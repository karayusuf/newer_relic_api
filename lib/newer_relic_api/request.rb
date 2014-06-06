require 'net/https'
require 'uri'
require 'json'

module NewerRelicApi
  class Response
    def initialize(http_response)
      @http_response = http_response
    end

    def body
      @body ||= JSON(@http_response.body)
    end
  end

  class Request
    API = URI.parse('https://api.newrelic.com')

    def initialize(api_key)
      @api_key = api_key
    end

    def get(request_uri)
      request = Net::HTTP::Get.new(request_uri)
      request['X-Api-Key'] = @api_key

      response = http.request(request)
      Response.new(response)
    end

    def http
      @http ||= begin
        http = Net::HTTP.new(API.host, API.port)
        http.use_ssl = true
        http
      end
    end
  end
end

