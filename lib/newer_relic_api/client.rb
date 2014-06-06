module NewerRelicApi
  class Client

    def initialize(api_key)
      @request = Request.new(api_key)
    end

    def application(id)
      response = @request.get("/v2/application/#{id}.json")
      Resources::Application.new(response.body['application'])
    end
  end

end
