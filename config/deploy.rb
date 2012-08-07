# This should automatically run bundle install on the server side
require "bundler/capistrano"

set :user, 				'sysadmin'
set :application, 'snopsize'
set :repository,  'git@github.com:aardvarkk/snopsize.git'
set :deploy_to,   '/home/sysadmin/snopsize'
set :port, 8285
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# Seems to fix error about 'no tty present and no askpass program specified'
default_run_options[:pty] = true

# adjust if you are using RVM, remove if you are not
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_type, :user

# This lets us NOT have a Gemfile.lock
set :bundle_flags, "--quiet"

# Your HTTP server, Apache/etc
server '184.106.240.177', :app, :web, :db

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
