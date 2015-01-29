#!/usr/bin/env ruby

require 'fileutils'

module Rvmrc
  class VersionedFile
    attr_reader :file, :version_name
    private :file, :version_name

    def initialize(version_name)
      @file = ".rvmrc.#{version_name}"
    end

    def copy_self
      FileUtils.cp file, '.rvmrc'
      notify
    end

  private

    def notify
      puts <<-EON
********************************
*
* Don't forget to do
*
*  cd .
*
* to aply the new .rvmrc file. 
*
********************************
      EON
    end
  end

  class RubyVersion
    VERSION_2_1_2 = '2.1.2'
    VERSION_1_9_3 = '1.9.3'
    
    def self.required_version
      if requies_ruby_2_1_2?
        VERSION_2_1_2
      else
        VERSION_1_9_3
      end
    end

    def self.requies_ruby_2_1_2?
      ENV['GIT_COUPA_BRANCH'].match(/master/)
    end
  end
end

Rvmrc::VersionedFile.new( Rvmrc::RubyVersion.required_version ).copy_self
