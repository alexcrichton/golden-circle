require 'erb'
# http://github.com/jnewland/san_juan/tree/master For god integration
require 'san_juan'

set :application, "goldencircle.academycommunity.com"

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
  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

end

set :web_server, "academycommunity.com"

role :app, web_server
role :web, web_server
role :db,  web_server, :primary => true

thin_app = "thin-#{application}"

san_juan.role :app, [thin_app]

set :god_config_path, "/etc/god.conf"

namespace :deploy do
  desc "Use god to restart the app" 
  task :restart do
    god.app.send(thin_app).restart
  end

  desc "Use god to start the app" 
  task :start do
    god.app.send(thin_app).start
  end

  desc "Use god to stop the app" 
  task :stop do
    god.app.send(thin_app).stop
  end
end
