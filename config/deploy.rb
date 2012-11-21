require "bundler/capistrano" # runs bundler install on the server
require "rvm/capistrano"

# Fixes error no tty present and no askpass program specified
default_run_options[:pty] = true

#before 'deploy', 'rvm:install_rvm'
#local_ruby_ver = ENV['GEM_HOME'].gsub(/.*\//,"")
#set :rvm_ruby_string, local_ruby_ver
#before 'deploy', 'rvm:install_ruby'

set :user, 				'sysadmin'
set :application, 'snopsize'
set :repository,  'git@github.com:aardvarkk/snopsize.git'
set :deploy_to,   '/home/sysadmin/snopsize'
set :port, 8285
set :scm, :git

# Your HTTP server, Apache/etc
role :app, 'snopsize.com'
role :web, 'snopsize.com'
role :db,  'snopsize.com', :primary => true

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

# Set up the password protection
desc "Limiting site access"
task :htaccess do 
  run "cp ~/htaccess_backup ~/snopsize/current/.htaccess"
  run "cp ~/htpasswd_backup ~/snopsize/current/.htpasswd"
end

# Set up the sunspot search
desc "Stop sunspot server"
task :sunspot_stop do
  run "cd ~/snopsize/current && bundle exec rake sunspot:solr:stop RAILS_ENV=production"
end

desc "Start sunspot server"
task :sunspot_start do
  run "cd ~/snopsize/current && bundle exec rake sunspot:solr:start RAILS_ENV=production"
end
  
before "deploy", "sunspot_stop"
after "deploy", "htaccess"
after "deploy", "sunspot_start"
