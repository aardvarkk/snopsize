set :user, 				'sysadmin'
set :application, 'snopsize'
set :repository,  'git@github.com:aardvarkk/snopsize.git'
set :deploy_to,   '/home/sysadmin/snopsize'

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# Seems to fix error about 'no tty present and no askpass program specified'
default_run_options[:pty] = true

# Your HTTP server, Apache/etc
server '184.106.240.177:8285', :app, :web, :db

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
