require 'addressable/uri'

class SearchController < ApplicationController
  
  # GET /search
  def search
  	
    # Assume results are nil to start with
  	@results = nil

  	# We're done if they didn't pass a search query
  	return unless params[:q]

    # By default, perform a keyword search
    case params[:type]
    when 'url'

      # Perform a URL-based search
      # First, we'll have to try to parse and normalize the URL
      # After that, we'll look for an EXACT match on resource, and if found, redirect there
      # Otherwise, we'll look for an EXACT match on domain, and if found, redirect there
      # Otherwise, do nothing and the search page will take care of saying it didn't find anything
      uri = Addressable::URI.heuristic_parse(params[:q]) rescue nil

      # Can't do anything with a bad uri
      return if uri.nil?

      # Resource match -- redirect if we find anything
      r = Snop.where('uri = ?', uri.normalize.to_s).limit(1)
      if r[0]
        redirect_to resource_path(domain_id: r[0].domain_id, resource_id: r[0].resource.id) 
        return
      end

      # Domain match -- redirect if we find anything
      d = Domain.where('uri = ?', uri.scheme + '://' + uri.host).limit(1)
      if d[0]
        redirect_to domain_path(d[0]) 
        return
      end

      # We couldn't find anything, so @results will be nil

    when 'user'

      # Perform user search using the full text
      @results = User.search do
        fulltext params[:q]
      end.results

    else 

      # Perform keyword search using the full text
      @results = Snop.search do
        fulltext params[:q]
      end.results

    end

  end
end
