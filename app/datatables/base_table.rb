# Very basic table class
class BaseTable
  include Rails.application.routes.url_helpers

  # View Helpers
  delegate :params, :link_to, :time_ago_in_words, :button_to, :collection_select, :current_user, :user_signed_in?, to: :@view

  # Creates a new BaseTable instance
  def initialize(view, all_snops, pre_filter_count, post_filter_count)
    @view = view
    @all_snops = all_snops
    @pre_filter_count = pre_filter_count
    @post_filter_count = post_filter_count
  end

  # Returns the JSON data for the base table.
  # Note that data needs to be implemented by the base class for this to 
  # work properly
  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @pre_filter_count,
      iTotalDisplayRecords: @post_filter_count,
      aaData: get_data()
    }
  end

  protected

  # Basically the equivalent of an abstract method in Ruby. Since Ruby is a dynamically typed
  # language, we can't create Abstract classes.
  # http://stackoverflow.com/questions/512466/how-to-implement-an-abstract-class-in-ruby
  def get_data
    raise "This method should be overriden to return the JSON data for a concrete table"
  end

end