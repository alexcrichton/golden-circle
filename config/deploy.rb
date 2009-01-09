require 'erb'
# http://github.com/jnewland/san_juan/tree/master For god integration
require 'san_juan'

set :application, "gcircle.ac.com"

set :scm, :git
set :repository,  "git@academycommunity.com:golden_circle.git"
set :branch, "master"
set :deploy_via, :remote_cache


set :user, "capistrano"
set :use_sudo, false

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/srv/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

before "deploy:setup", :db
after "deploy:update_code", "db:symlink" 

namespace :db do
  desc "Create database yaml in shared path" 
  task :default do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      socket: /tmp/mysql.sock
      username: academy
      password: xxx~K)Xnlc

    development:
      database: gc_development
      <<: *base

    test:
      database: gc_test
      <<: *base

    production:
      database: gc_production
      <<: *base
      
    profile:
      database: gc_production
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config" 
    put db_config.result, "#{shared_path}/config/database.yml" 
  end

  desc "Make symlink for database yaml, attachment-fu" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :slicehost do
desc "install required gems"
  task :install_required_gems do
    run "cd #{deploy_to}/current; rake gems:install"
  end
end

role :app, application
role :web, application
role :db,  application, :primary => true

thin_app = "thin-gcircle.ac.com"

san_juan.role :app, [thin_app]
san_juan.role :web, %w(nginx)

set :god_config_path, "/etc/god.conf"

namespace :deploy do
  desc "Use god to restart the app" 
    task :restart do
      god.all.reload #ensures any changes to the god config are applied at deploy
      god.app.send(thin_app).restart
      god.web.nginx.restart
    end

    desc "Use god to start the app" 
    task :start do
      god.all.start
    end

    desc "Use god to stop the app" 
    task :stop do
      god.all.terminate
    end
end