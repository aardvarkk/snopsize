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
    
    # Create a tweetable string by combining title, all points, and summary
    # For now, we'll just put a space in between them all.
    @snopcontent = @snop.title
    @snopcontent += ' ' + @snop.point1 if @snop.point1
    @snopcontent += ' ' + @snop.point2 if @snop.point2
    @snopcontent += ' ' + @snop.point3 if @snop.point3
    @snopcontent += ' ' + @snop.summary if @snop.summary
    @snopcontent.truncate(140)

    # has the logged in user already faved this snop?
    @fave_snop = current_user.favourites.find_by_id(@snop.id) if user_signed_in?

    # Respond with the appropriate data
    respond_to do |format|
      format.html #show.html.erb
      format.js   #show.js.erb
    end
  end
end
