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


    # Respond with the javascript call
    respond_to do |format|
      format.js
    end
  end
end
