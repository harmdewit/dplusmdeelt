$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require 'bundler/capistrano'

# Indien u geen RVM gebruikt op uw system kunt u het onderstaande bestand
# downloaden op: https://github.com/wayneeseguin/rvm/blob/master/lib/rvm/capistrano.rb
# Plaats dit in uw applicatie en pas de onderstaande require regel aan.
require 'rvm/capistrano'

# De te gebruiken RVM versie, default is 1.8.7. Indien u een Thin installatie
# met Ruby 1.9.2 heeft dan kunt u '1.9.2' als versie opgeven.
set :rvm_ruby_string, 'default'
set :rvm_type, :system
set :rvm_bin_path, '/usr/local/bin'


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

# Add RVM's lib directory to the load path.


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
  run "rm -dr #{deploy_to}/shared/images"
  run "mv -u #{release_path}/public/images #{deploy_to}/shared/images" # Using the same source and target directory name gives a "cannot move into subdirectory" conflict.
  run "ln -nfs #{deploy_to}/shared/images #{release_path}/public/images"
end

