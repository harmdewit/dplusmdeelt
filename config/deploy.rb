set :application, "dplusm"
set :host,        "perry.bluerail.nl"
set :user,        "dplusmdeelt"
set :use_sudo,    false
set :deploy_to,   "~/rails"
set :rake,        "/opt/ruby/bin/rake"
set :keep_releases,3

set :scm,         :git
# set :repository,  "ssh://dplusmdeelt@perry.bluerail.nl/~/rails/git/dplusm.git"

set :repository, "git@github.com:harmdewit/DplusM-Deelt.git"
set :scm_passphrase, ""
set :branch,      'master' 
set :scm_verbose, true
set :deploy_via,  :remote_cache 




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
end

desc "Link database.yml to production"
task :link_production_db do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

