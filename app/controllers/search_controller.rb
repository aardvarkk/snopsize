class SearchController < ApplicationController
  
  # GET /search
  def search
  	
    # assume results are nil to start with
  	@results = nil

  	# we're done if they didn't pass a search query
  	return unless params[:q]

    # by default, perform a keyword search
    case params[:type]
    when 'url'
    when 'user'

      # perform user search using the full text
      @results = User.search do
        fulltext params[:q]
      end.results

    else 

      # perform keyword search using the full text
      @results = Snop.search do
        fulltext params[:q]
      end.results

    end

  end
end
