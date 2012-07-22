class HomeController < ApplicationController
  def index
    @snops = Snop.order("created_at DESC")
  end
end
