# frozen_string_literal: true

require_relative "templater"

def logged_system(cmd)
  puts cmd
  success = system cmd
  raise "System Command: #{cmd} failed" unless success
end

class CredentialsError < RuntimeError; end

namespace :k8s do
  desc "Rolls out a new version of the application"
  task deploy: [:build, :push, :rollout]

  desc "Generating the yml templates for deployment"
  task :setup do
    return unless registry && service

    # Create files
    ["deploy.yml", "ingress.yml"].each do |file|
      Templater.new("lib/dok8s/templates/k8s/#{file}", "lib/k8s/#{file}", { "SERVICE" => service, "REGISTRY" => registry }).copy
    end
  rescue CredentialsError => e
    puts "Not all required credentials are present"
    puts e
  end

  desc "Initial deploy"
  task :init do
    # Set RAILS_MASTER_KEY secret in the cluster
    logged_system "kubectl create secret generic #{service} --from-file=RAILS_MASTER_KEY=./config/master.key"

    # Initialize the deployment files
    create("deploy")
    create("ingress")
  end

  task :build do
    master_key = ENV["RAILS_MASTER_KEY"]
    master_key ||= `cat config/master.key`.strip
    logged_system "docker build --tag #{service} --build-arg RAILS_MASTER_KEY=#{master_key} --build-arg BUNDLE_WITHOUT='development test' ."
  end

  task :push do
    logged_system "docker tag #{service}:latest #{registry}/#{service}:#{commit}"
    logged_system "docker push #{registry}/#{service}:#{commit}"
  end

  task :rollout do
    # In case the deployment or ingress files have changed
    apply("deploy")
    apply("ingress")

    # To trigger a deployment
    logged_system "kubectl rollout restart deployment/#{service}"
  end

  desc "Rollback to the previous deployment"
  task :rollback do
    logged_system "kubectl rollout undo deployment/#{service}"
  end

  task :bash do
    logged_system "kubectl exec -it #{first_container} -- /bin/bash"
  end

  task :console do
    logged_system "kubectl exec -it #{first_container} -- /bin/bash -c 'rails c'"
  end

  task :migrate do
    logged_system "kubectl exec -it #{first_container} -- bundle exec rails db:migrate"
  end

  task :logs do
    logged_system "kubectl logs #{first_container}"
  end

  task :shared do
    "kubectl apply -f #{shared_yml('imagor')}"
  end

  def shared_yml(name)
    File.join(Dok8s.root, "lib", "dok8s", "k8s", "#{name}.yml")
  end

  def commit
    @commit ||= `git rev-parse --short HEAD`.strip
  end

  def first_container
    containers = `kubectl get pods | grep #{service}- | grep Running`
    raise "No container of type #{service} is running" if containers.lines.empty?

    containers.lines.first.split.first
  end

  def yml(name)
    "./lib/k8s/#{name}.yml"
  end

  def create(name)
    logged_system "kubectl create -f" + yml(name)
  end

  def apply(name)
    return unless File.exist?(yml(name))

    logged_system "GIT_SHORT=#{commit} envsubst < #{yml(name)} | kubectl apply -f -"
  end

  def credentials
    @credentials ||= Rails.application.credentials.k8s.tap do |k8s|
      raise CredentialsError, "Please create credentials for k8s.registry and k8s.service" unless k8s
    end
  end

  def registry
    return ENV["K8S_REGISTRY"] if ENV["K8S_REGISTRY"]

    credentials.fetch(:registry).tap do |value|
      raise CredentialsError, "Please create k8s.registry like registry.digitalocean.com/name" unless value
    end
  end

  def service
    return ENV["K8S_SERVICE"] if ENV["K8S_REGISTRY"]

    credentials.fetch(:service).tap do |value|
      raise CredentialsError, "Please create k8s.service like app_name" unless value
    end
  end
end
