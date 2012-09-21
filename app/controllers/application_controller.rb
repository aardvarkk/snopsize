class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :remove_cache_for_ajax
  after_filter :store_location

  # Please see below link for why this has to be done.
  # http://stackoverflow.com/questions/711418/how-to-prevent-browser-page-caching-in-rails
  def remove_cache_for_ajax
    # If the request is an AJAX request, we will tell the browser not to cache, the results.
    # This means that any AJAX GET responses will not be cached in the browse and then shown
    # via the back and forward buttons.
    if request.xhr?
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end

  # Stores unique previous URLs (only the last two, so we always know where we came from)
  def store_location
    session[:previous_urls] ||= []
    # store unique urls only that are not AJAX (just page changes)
    unless request.xhr?
      session[:previous_urls].prepend request.fullpath if session[:previous_urls].first != request.fullpath
      session[:previous_urls].pop if session[:previous_urls].count > 2
    end
  end

  # Where to go after signing in. Well we just want to go to the last page they were on.
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in
  def after_sign_in_path_for(resource)
    # For some tests sessions aren't set, so we'll make sure the session isn't nil before using.
    # We also want to make sure we're not redirecting to the same URL, this could cause a loop.
    if session[:previous_urls].nil? || session[:previous_urls].last == request.fullpath
      return root_path
    end

    return session[:previous_urls].last 
  end
end
