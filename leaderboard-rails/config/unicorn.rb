shared_path = "/home/deploy/sites/apis-bench/shared"

worker_processes 4
working_directory "/home/deploy/sites/apis-bench/current/leaderboard-rails"
listen "/tmp/leaderboard-rails.unicorn.sock", :backlog => 64
listen 8080, :tcp_nopush => true
timeout 30
pid shared_path + "/pids/leaderboard-rails.unicorn.pid"
stderr_path shared_path + "/log/leaderboard-rails.unicorn.stderr.log"
stdout_path shared_path + "/log/leaderboard-rails.unicorn.stdout.log"
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
#check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end