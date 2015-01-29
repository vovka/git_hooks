#!/usr/bin/env ruby

require 'erb'
require 'pry'
require 'active_support/core_ext'
require 'ostruct'

module DatabaseConfig
  class YamlTemplate
    attr_reader :config_template_content, :new_config_content, :context
    private :config_template_content, :new_config_content, :context

    FILE_PATH = './config/database.yml.template'

    def initialize
      @config_template_content = File.read(FILE_PATH)
    end

    def process_and_save
      process
      save
    end

  private

    def process
      erb_template = ERB.new(config_template_content)
      @new_config_content = erb_template.result(binding)
    end

    def save
      new_config_file.save
    end

    def new_config_file
      ConfigFile.new(new_config_content)
    end

    # Do not remove this method. It is used during ERB evaluation. 
    def top_branch
      # TODO: Your conditions go here
    end
  end

  class ConfigFile
    attr_reader :content
    private :content

    FILE_PATH = './config/database.yml'

    def initialize(content)
      @content = content
    end

    def save
      File.write(FILE_PATH, content)
    end
  end
end

DatabaseConfig::YamlTemplate.new.process_and_save
