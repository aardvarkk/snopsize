class SnopsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  # GET /snops/1
  # GET /snops/1.json
  def show
    @snop = Snop.find(params[:id])

    # Create a tweetable string by combining title, all points, and summary
    # For now, we'll just put a space in between them all.
    @snopcontent = @snop.title
    if @snop.point1
      @snopcontent += ' ' + @snop.point1
    end
    if @snop.point2
      @snopcontent += ' ' + @snop.point2
    end
    if @snop.point3
      @snopcontent += ' ' + @snop.point3
    end
    if @snop.summary
      @snopcontent += ' ' + @snop.summary
    end
    @snopcontent.truncate(140)

    # has the logged in user already faved this snop?
    if (user_signed_in?)
      @fave_snop = current_user.favourites.find_by_id(@snop.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @snop }
    end
  end

  # GET /snops/new
  # GET /snops/new.json
  def new
    @snop = Snop.new

    # Check if we should pre-fill with URI value
    if (params.has_key? :uri)
      @default_uri = params[:uri]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @snop }
    end
  end

  # POST /snops
  # POST /snops.json
  def create
    @snop = Snop.new(params[:snop])

    # Set the user_id to the logged in user, since
    # only logged in users can create snops
    @snop.user = current_user

    respond_to do |format|
      if @snop.save
        format.html { redirect_to @snop, notice: 'Snop was successfully created.' }
        format.json { render json: @snop, status: :created, location: @snop }
      else
        format.html { render action: "new" }
        format.json { render json: @snop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snops/1
  # DELETE /snops/1.json
  def destroy

    @snop = Snop.find(params[:id])

    # Don't actually destroy it, just mark it as deleted!
    @snop.update_attribute(:deleted, 1)

    respond_to do |format|
      format.html { redirect_to @snop.user }
      format.json { head :no_content }
    end

  end
end
