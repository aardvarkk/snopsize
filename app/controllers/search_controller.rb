require 'addressable/uri'

class SearchController < ApplicationController
  include DatatableHelpers

  # GET /search
  def search
  	
    @results = nil

  	# We're done if they didn't pass a search query
  	return if params[:q].blank?

    # By default, perform a keyword search
    case params[:type]
    when 'url'

      # Perform a URL-based search
      # First, we'll have to try to parse and normalize the URL
      # After that, we'll look for an EXACT match on resource, and if found, redirect there
      # Otherwise, we'll look for an EXACT match on domain, and if found, redirect there
      # Otherwise, do nothing and the search page will take care of saying it didn't find anything
      @uri = Addressable::URI.heuristic_parse(params[:q]) rescue nil

      # Can't do anything with a bad uri
      return if @uri.nil? || @uri.host.nil?

      # Assume an http scheme if none is given
      @uri.scheme = 'http' if @uri.scheme.nil?

      # Resource match -- redirect if we find anything
      r = Snop.where('uri = ?', @uri.normalize.to_s).limit(1)
      if r[0]
        redirect_to resource_path(domain_id: r[0].domain_id, resource_id: r[0].resource.id) 
        return
      end

      # Domain match -- redirect if we find anything
      d = Domain.where('uri = ?', @uri.scheme + '://' + @uri.host).limit(1)
      if d[0]
        redirect_to domain_path(d[0]) 
        return
      end

      # We couldn't find anything, return empty results
      @results = Array.new

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

      # Get the relation 
      @snops = Snop.where("snops.id IN (?)", @results)

      # Lets see if they passed in an ordering
      if params.has_key?(:iSortCol_0) && params.has_key?(:sSortDir_0)
        # Sort by domains
        if (sort_column == "domain")
          @snops = @snops.joins(:domain).order("domain_id IS NULL, domains.uri #{sort_direction}")
        # order by username
        elsif (sort_column == "user")
          @snops = @snops.joins(:user).order("users.username #{sort_direction}")
        # order by category
        else 
          @snops = @snops.order("#{sort_column} #{sort_direction}") 
        end
      end

      # Handle pagination next
      @snops = @snops.page(page).per_page(per_page) if params.has_key?(:iDisplayStart) && params.has_key?(:iDisplayLength)

      # Check if we are in browse view
      @browse_view = params[:browse_view] == "true" if params.has_key?(:browse_view)
      # Check if a single snop has been passed in to display in browse view
      @snop = Snop.find(params[:snop]) if (params.has_key?(:snop)) && @browse_view

      # Convert snops to an array
      @snops = @snops.to_a

      respond_to do |format|
        format.html
        format.json { render json: SearchTable.new(view_context, @snops) }
        format.js 
      end
    end
  end
end
