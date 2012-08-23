class HomeController < ApplicationController
  def index
    # Get a list of the "trending" snops to show (for now just the last 5)
    @snops = Snop.where(deleted: false).order("title DESC").limit(5)
    @snops = @snops.to_a
  end
end
