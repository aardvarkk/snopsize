class SearchController < ApplicationController
  def search

  	# assume results are nil to start with
  	@results = nil

  	# we're done if they didn't pass a search query
  	return unless (params[:q])

  	# perform the search using the full text
  	Snop.search do
  		fulltext params[:q]
  	end

  end
end
