class ResourcesController < ApplicationController
  # GET /domains/:domain_id/resources/:resource_id
  def show
    # Get the resrouce and all the snops for it
    @resource = Resource.find(params[:resource_id])
    @snops = @resource.snops.where(deleted: false).order("created_at DESC")
    @url = @resource.domain.uri + @resource.uri
    
    # Check if a direction is passed in (For JS animation)
    @direction = params[:direction].to_s if params[:direction]

    # Set the snop to show just to the first
    @snop = @snops.first unless @snops.nil?

    # If a snop has been provided... let's set that one 
    # as the one to show
    @snop = @snops.find(params[:snop]) if @snops.exists?(params[:snop])

    # Now we'll set the next and previous
    snop_index = @snops.all.index(@snop)

    # Set the previous
    @prev = @snops.all[snop_index - 1] if snop_index > 0

    # Set the next
    @next = @snops.all[snop_index + 1] if snop_index < @snops.size - 1

    # Respond with the appropriate data
    respond_to do |format|
      format.html #show.html.erb
      format.js   #show.js.erb
    end
  end
end
