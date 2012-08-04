class SearchController < ApplicationController
  
  # GET /search
  def search
  	# assume results are nil to start with
  	@results = nil

  	# we're done if they didn't pass a search query
  	return unless (params[:q])

  	# perform the search using the full text
  	@results = Snop.search do
  		fulltext params[:q]
  	end.results
  end
end
