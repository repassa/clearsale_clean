# frozen_string_literal: true

require 'active_support/all'

module ClearsaleClean
  # config class
  class Config
    mattr_accessor :logger, :log

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.log
      @@log.nil? ? true : @@log
    end
  end
end
