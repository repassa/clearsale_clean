# frozen_string_literal: true

require 'bundler/setup'
require 'clearsale_clean'
require 'rubygems'
require 'bundler'
require 'vcr'
require 'savon'
require 'logger'
require 'active_support/all'
require 'simplecov'

SimpleCov.start

ClearsaleClean::Config.log = false

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/support/cassettes'
  c.ignore_hosts '127.0.0.1', 'localhost'
  # To record new external requests, record: :all OR :new_episodes
  c.default_cassette_options = {
    record: :new_episodes, match_requests_on: %i[method uri query headers body]
  }

  c.before_record { |i| i.response.body.force_encoding('UTF-8') }
  c.configure_rspec_metadata!
end
