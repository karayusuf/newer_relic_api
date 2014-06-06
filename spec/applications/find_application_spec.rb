require 'spec_helper'
require 'webmock/rspec'

module NewerRelicApi
  describe Client do
    describe "finding an application" do
      let(:client) { NewerRelicApi::Client.new('api-key') }

      context "when the application exists" do
        let(:application_schema) do
          { "application" => {
              "id" => 1,
              "name" => "Example Application",
              "language" => "ruby",
              "health_status" => "green",
              "reporting" => true,
              "last_reported_at" => "2014-06-06T05:01:45+00:00",
              "application_summary" => {
                "response_time" => 6.43,
                "throughput" => 15400,
                "error_rate" => 0,
                "apdex_target" => 18,
                "apdex_score" => 1
              },
              "settings" => {
                "app_apdex_threshold" => 0.05,
                "end_user_apdex_threshold" => 7,
                "enable_real_user_monitoring" => false,
                "use_server_side_config" => true
              },
              "links" => {
                "application_instances" => [ 1, 2 ],
                "servers" => [ 1, 2, 3 ],
                "application_hosts" => [ 1, 2 ]
              }
            }
          }
        end

        def respond_with_application_data(data)
          schema = application_schema.dup
          schema['application'] = application_schema['application'].merge(data)

          stub_request(:get, "https://api.newrelic.com/v2/application/#{data['id']}.json").
            to_return(status: 200, headers: {}, body: schema.to_json)
        end

        it "fetches the requested application" do
          respond_with_application_data({ 'id' => 2 })

          client = NewerRelicApi::Client.new('api-key')
          application = client.application(2)

          expect(application.id).to eql 2
        end

        it "returns an application resource" do
          respond_with_application_data({ 'id' => 2 })

          client = NewerRelicApi::Client.new('api-key')
          application = client.application(2)

          expect(application).to be_a Resources::Application
        end
      end
    end
  end
end
