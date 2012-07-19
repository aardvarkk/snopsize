class HomeController < ApplicationController
  def index
    @snops = Snop.all
  end
end
