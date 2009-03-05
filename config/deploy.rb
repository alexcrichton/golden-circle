require 'erb'
# http://github.com/jnewland/san_juan/tree/master For god integration
require 'san_juan'

set :application, "goldencircle.academycommunity.com"

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
after "deploy:update_code", "db:symlink", "db:rake_db" 

namespace :db do
  desc "Create database yaml in shared path" 
  task :default do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      socket: /tmp/mysql.sock
      username: golden
      password: N)+;3^Df

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

  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Rake the databases"
  task :rake_db do
    run "rake -f #{release_path}/Rakefile db:migrate RAILS_ENV=production"
  end
end

namespace :slicehost do
desc "install required gems"
  task :install_required_gems do
    run "cd #{deploy_to}/current; rake gems:install"
  end
end

set :web_server, "academycommunity.com"

role :app, web_server
role :web, web_server
role :db,  web_server, :primary => true

thin_app = "thin-goldencircle.academycommunity.com"

san_juan.role :app, [thin_app]
#san_juan.role :web, %w(nginx)

set :god_config_path, "/etc/god.conf"

namespace :deploy do
  desc "Use god to restart the app" 
    task :restart do
#      god.all.reload #ensures any changes to the god config are applied at deploy
      god.app.send(thin_app).restart
#      god.web.nginx.reload
    end

    desc "Use god to start the app" 
    task :start do
#      god.all.start
      god.app.send(thin_app).start
    end

    desc "Use god to stop the app" 
    task :stop do
      #god.all.terminate
      god.app.send(thin_app).stop
    end
end
