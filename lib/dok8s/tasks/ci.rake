# frozen_string_literal: true

require_relative "templater"

namespace :ci do
  task :setup do
    Templater.new("lib/dok8s/templates/github.yml", ".github/workflows/ruby.yml", { "APP_TEST_DB" => test_db_name }).copy
    Templater.new("lib/dok8s/templates/Dockerfile", "Dockerfile").copy
    Templater.new("lib/dok8s/templates/docker-entrypoint.sh", "lib/docker-entrypoint.sh").copy
  end
end

def test_db_name
  Rails.configuration.database_configuration["test"]["database"]
end
