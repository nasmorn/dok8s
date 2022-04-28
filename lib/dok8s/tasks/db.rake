# frozen_string_literal: true

namespace :db do
  desc "Allows you to download your production DB and load into dev"
  task :sync do
    puts "Downloading your DB from prod"
    system "PGPASSWORD=\"#{production.fetch("password")}\" pg_dump #{production.fetch("database")} --host #{host} --port #{production.fetch("port")} --username #{production.fetch("username")} --clean > tmp/dump.sql"
    system "cat tmp/dump.sql | psql #{development.fetch("database")} --username #{development.fetch("username")}"

    puts "If you cannot connect check if the current IP is allowed on the DB server."
  end
end

def production
  Rails.configuration.database_configuration["production"]
end

def development
  Rails.configuration.database_configuration["development"]
end

def host
  production.fetch("host").gsub("private-", "")
end
