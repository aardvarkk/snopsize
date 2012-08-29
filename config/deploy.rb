require "bundler/capistrano" # runs bundler install on the server
require "rvm/capistrano"

set :user, 				'sysadmin'
set :application, 'snopsize'
set :repository,  'git@github.com:aardvarkk/snopsize.git'
set :deploy_to,   '/home/sysadmin/snopsize'
set :port, 8285
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# Seems to fix error about 'no tty present and no askpass program specified'
default_run_options[:pty] = true

# Your HTTP server, Apache/etc
role :app, 'snopsize.com'
role :web, 'snopsize.com'
role :db,  'snopsize.com', :primary => true

# This lets us NOT have a Gemfile.lock
# I think it fixes an error saying deployment can't find Gemfile.lock
set :bundle_flags, "--quiet"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
