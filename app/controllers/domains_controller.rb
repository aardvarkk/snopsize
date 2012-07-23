class DomainsController < ApplicationController
  def show
  	@domain = Domain.find(params[:domain_id]);
  	@resources = @domain.resources;
  end
end
