server "eve.alexcrichton.com", :app, :web, :db, :primary => true

set :scm, :git
set :repository, "git://github.com/alexcrichton/golden-circle.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :rake, "/opt/ruby1.8/bin/rake"

set :user, "capistrano"
set :use_sudo, false

set :deploy_to, "/srv/http/goldencircle"

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
    run "ln -nfs #{shared_path}/files #{latest_release}/public/files"
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
