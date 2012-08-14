class HomeController < ApplicationController
  def index
    # Get a list of the latest snops
    @latest_snops = Snop.where(:deleted => false).order("created_at DESC").limit(5)

    # Get a list of the most popular snops
    @popular_snops = Snop.where(:deleted => false).includes(:fave_snops).order("count(fave_snops.snop_id) DESC").group("fave_snops.snop_id").having("fave_snops.snop_id > ?", 0).limit(5)
  end
end
