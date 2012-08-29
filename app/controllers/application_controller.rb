class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :remove_cache_for_ajax

  def remove_cache_for_ajax
    # Please see below link for why this has to be done.
    # http://stackoverflow.com/questions/711418/how-to-prevent-browser-page-caching-in-rails

    # If the request is an AJAX request, we will tell the browser not to cache, the results.
    # This means that any AJAX GET responses will not be cached in the browse and then shown
    # via the back and forward buttons.
    if request.xhr?
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end
end
