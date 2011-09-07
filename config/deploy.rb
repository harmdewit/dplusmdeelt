require "bundler/capistrano"
set :application, "dplusm"
set :host,        "perry.bluerail.nl"
set :user,        "dplusmdeelt"
set :use_sudo,    false
set :deploy_to,   "~/rails"
set :rake,        "/opt/ruby/bin/rake"
set :keep_releases, 3
set :bundle_without,  [:development, :test]
set :bundle_dir, File.join(fetch(:shared_path), 'vendor_bundle')

set :scm,         :git
set :repository,  "git@github.com:harmdewit/dplusmdeelt.git" 

role :app, host
role :web, host
role :db,  host, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  after "deploy:update_code", :link_production_db
  after "deploy:update_code", :share_images
end

desc "Link database.yml to production"
task :link_production_db do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

desc "Share the images between versions"
task :share_images do
  run "rmdir #{deploy_to}/shared/images"
  run "cp -r #{release_path}/public/images #{deploy_to}/shared/images/"
  run "ln -nfs #{deploy_to}/shared/images #{release_path}/public/images/"
end

