# frozen_string_literal: true

require_relative "templater"

namespace :ci do
  desc "Creates necessary files for Github Actions CI"
  task :setup do
    Templater.new("lib/dok8s/templates/github.yml", ".github/workflows/ruby.yml", { "APP_TEST_DB" => test_db_name }).copy
    Templater.new("lib/dok8s/templates/Dockerfile", "Dockerfile").copy
    Templater.new("lib/dok8s/templates/docker-entrypoint.sh", "lib/docker-entrypoint.sh").copy

    puts "---"
    puts "WARNING - Github CI will need a DIGITALOCEAN_ACCESS_TOKEN and the RAILS_MASTER_KEY as secrets"
    puts "---"
  end
end

def test_db_name
  Rails.configuration.database_configuration["test"]["database"]
rescue NameError
  puts "This is not a rails application"
  "REMOVE-DB-SETUP"
end
