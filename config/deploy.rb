set :application, "dplusm"
set :host,        "perry.bluerail.nl"
set :user,        "dplusmdeelt"
set :use_sudo,    false
set :rake,        "/opt/ruby/bin/rake"
set :keep_releases,3

role :app, host
role :web, host
role :db,  host, :primary => true

# file paths
set :repository, "#{user}@#{host}:rails/git/#{application}.git" 
set :deploy_to, "~/rails"

# you might need to set this if you aren't seeing password prompts # default_run_options[:pty] = true
# As Capistrano executes in a non-interactive mode and therefore doesn't cause # any of your shell profile scripts to be run, the following might be needed # if (for example) you have locally installed gems or applications. Note: # this needs to contain the full values for the variables set, not simply
# the deltas. # default_environment['PATH']='<your paths>:/usr/local/bin:/usr/bin:/bin' # default_environment['GEM_PATH']='<your paths>:/usr/lib/ruby/gems/1.8'

# miscellaneous options
set :deploy_via, :remote_cache 
set :scm, 'git' 
set :branch, 'master' 
set :scm_verbose, true
set :use_sudo, false

# task which causes Passenger to initiate a restart
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