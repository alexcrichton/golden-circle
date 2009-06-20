require 'erb'

set :web_server, "gc.alexcrichton.com"

role :app, web_server
role :web, web_server
role :db,  web_server, :primary => true

set :application, "goldencircle"

set :scm, :git
set :repository, "git://github.com/alexcrichton/golden-circle.git"
set :branch, "master"
set :deploy_via, :remote_cache


set :user, "capistrano"
set :use_sudo, false

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/srv/www/#{application}"

before "deploy:setup", :db
after "deploy:update_code", "db:symlink" 

namespace :db do
  task :default do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/files"
  end
  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/files #{latest_release}/public/files"
  end

end
namespace :deploy do 
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  task :stop, :roles => :app do
    # Do nothing, don't want to kill nginx
  end
end
