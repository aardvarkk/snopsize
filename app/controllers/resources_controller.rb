class ResourcesController < ApplicationController
  # GET /domains/:domain_id/resources/:resource_id
  def show
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops.where(deleted: false).order("created_at DESC")
    @url = @resource.domain.uri + @resource.uri

    # Set the snop to show just to the first
    @snop = @snops.first unless @snops.nil?

    # If a snop has been provided... let's set that one 
    # as the one to show
    @snop = snops.find(params[:snop]) if @snops.exists?(params[:snop])

    # Now we'll set the next and previous
    snop_index = @snops.all.index(@snop)

    # Set the previous
    @prev = @snops.all[snop_index - 1] if snop_index > 0

    # Set the next
    @next = @snops.all[snop_index + 1] if snop_index < @snops.size - 1
  end

  # POST /domains/:domain_id/resource/:resource_id?snop=
  def show_snop
    # Get the resrouce and all the snops for it
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops.where(deleted: false).order("created_at DESC")
    @direction = params[:direction].to_s

    # Make sure the snop requested is part of the snops!
    unless @snops.exists?(params[:snop])
      redirect_to resource_path(domain_id: params[:domain_id], resource_id: params[:resource_id])
      return
    end

    # Get the snop that's passed in
    @snop = @snops.find(params[:snop])

    # Now we'll set the next and previous
    snop_index = @snops.all.index(@snop)

    # Set the previous
    @prev = @snops.all[snop_index - 1] if snop_index > 0

    # Set the next
    @next = @snops.all[snop_index + 1] if snop_index < @snops.size - 1

    # Respond with the javascript call
    respond_to do |format|
      format.js
    end
  end
end
