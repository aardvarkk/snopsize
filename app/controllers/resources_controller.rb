class ResourcesController < ApplicationController
  # GET /domains/:domain_id/resources/:resource_id
  def show
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops.order("created_at DESC")
    @url = @resource.domain.uri + @resource.uri

    # Set the snop to show just to the first
    @snop = @snops.first unless @snops.nil?

    # If a snop has been provided... let's set that one 
    # as the one to show
    @snop = snops.find(params[:snop]) if @snops.exists?(params[:snop])

    logger.debug "Snop: " + @snop.to_s if @snop

    # Now we'll set the next and previous
    snop_index = @snops.all.index(@snop)

    # Set the previous
    @prev = @snops.all[snop_index - 1] if snop_index > 0

    logger.debug "Prev: " + @prev.to_s if @prev

    # Set the next
    @next = @snops.all[snop_index + 1] if snop_index < @snops.size - 1

    logger.debug "Next: " + @next.to_s if @next
  end

  # POST /domains/:domain_id/resource/:resource_id?snop=
  def show_snop
    # Get the resrouce and all the snops for it
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops.order("created_at DESC")

    # Get the snop that's passed in
    @snop = @snops.find(params[:snop])

    logger.debug "Snop: " + @snop.to_s if @snop

    # Now we'll set the next and previous
    snop_index = @snops.all.index(@snop)

    # Set the previous
    @prev = @snops.all[snop_index - 1] if snop_index > 0

    logger.debug "Prev: " + @prev.to_s if @prev

    # Set the next
    @next = @snops.all[snop_index + 1] if snop_index < @snops.size - 1

    logger.debug "Next: " + @next.to_s if @next

    # Respond with the javascript call
    respond_to do |format|
      format.js
    end
  end
end
