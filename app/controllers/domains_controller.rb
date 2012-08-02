class DomainsController < ApplicationController
  def show
  	@domain = Domain.find(params[:id])
  	@resources = @domain.resources
  end
end
