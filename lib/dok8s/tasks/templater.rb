# frozen_string_literal: true

class Templater
  def initialize(source, destination, substitutions = {})
    @source = source
    @destination = destination
    @substitutions = substitutions
  end

  def copy
    unless Dir.exist?(destination_dir)
      FileUtils.mkdir_p(File.join(root_dir, destination_dir))
      puts "Directory #{destination_dir} created"
    end

    source_file = File.join(Dok8s.root, @source)
    return puts "Cannot find file at #{source_file}" unless File.exist?(source_file)

    dest_file = File.join(root_dir, @destination)

    unless File.exist?(dest_file)
      system "#{subst_with_values} envsubst '#{subst_list}' < #{source_file} > #{dest_file}"
      puts "File #{dest_file} created"
    end
  end

  private

  def root_dir
    Rails.root
  rescue NameError
    "./"
  end

  def destination_dir
    File.dirname(@destination)
  end

  def subst_with_values
    @substitutions.map do |key, value|
      "#{key}=#{value}"
    end.join(" ")
  end

  def subst_list
    @substitutions.keys.map {|key| "$#{key}" }.join(" ")
  end
end
