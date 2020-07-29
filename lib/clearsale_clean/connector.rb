# frozen_string_literal: true

require 'savon'
require 'singleton'

module ClearsaleClean
  # Create Connector to ClearSale
  class Connector
    include Singleton

    attr_reader :token, :client

    PROXY = ENV['CLEARSALE_PROXY']
    URL_S = {
      homolog: 'https://homologacao.clearsale.com.br/integracaov2/Service.asmx',
      production: 'https://integracao.clearsale.com.br/service.asmx'
    }.freeze
    NAMESPACES = {
      'xmlns:soap' => 'http://www.w3.org/2003/05/soap-envelope',
      'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'xmlns:int' => 'http://www.clearsale.com.br/integration'
    }.freeze

    def initialize
      @token = ENV['CLEARSALE_ENTITYCODE']
      @client ||= Savon.client(savon_options)
    end

    def do_request(method, request)
      namespaced_request = append_namespace('int', request)
      arguments = namespaced_request.merge({ 'int:entityCode' => @token })

      response = @client.call(
        method,
        message: arguments,
        soap_action: "#{NAMESPACES['xmlns:int']}/#{method}"
      )

      extract_response_xml(method, response.to_hash)
    end

    private

    def savon_options
      options = { endpoint: URL_S[endpoint_url],
                  namespace: NAMESPACES['xmlns:int'],
                  namespaces: NAMESPACES,
                  convert_request_keys_to: :snakecase }

      options.tap do |opt|
        opt[:proxy] = PROXY if PROXY
        opt[:log] = Config.log
        opt[:logger] = Config.logger
      end
    end

    def endpoint_url_valid?(env)
      env.eql?('homolog') || env.eql?('production')
    end

    def endpoint_url
      return :homolog unless endpoint_url_valid?(ENV.fetch('CLEARSALE_ENV'))

      ENV.fetch('CLEARSALE_ENV').to_sym
    end

    def extract_response_xml(method, response)
      results = response.fetch(:"#{method.snakecase}_response", {})
      response_xml = results.fetch(:"#{method.snakecase}_result", {}).to_s
      Nori.new(
        parser: :nokogiri,
        convert_tags_to: ->(tag) { tag.snakecase.to_sym }
      ).parse(response_xml.gsub(/^<\?xml.*\?>/, ''))
    end

    def append_namespace(namespace, hash)
      Hash[hash.map { |key, value| ["#{namespace}:#{key}", value] }]
    end
  end
end
