set :application, "dplusm"
set :host,        "perry.bluerail.nl"
set :user,        "dplusmdeelt"
set :use_sudo,    false
set :deploy_to,   "~/rails"
set :rake,        "/opt/ruby/bin/rake"
set :keep_releases,3

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
  after 'deploy:update_code', 'bundler:bundle_new_release'
end

desc "Link database.yml to production"
task :link_production_db do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'vendor_bundle')
    release_dir = File.join(release_path, 'vendor/bundle')
    run("mkdir -p #{shared_dir}")
    run("ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    # run "cd #{release_path}"
    # run "bundle install --deployment"
  end
end

