require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  let(:geocode_uri)  { GeocodeApi::BASE_URI }
  let(:weather_uri)  { WeatherApi::BASE_URI }
  let(:address)   { "5905 Wilshire Blvd, Los Angeles, CA 90036" }
  let(:latitude)  { "34.064468" }
  let(:longitude) { "-118.359922" }
  let(:zipcode)   { "90036" }

  # Stubbed GeocodeAPI response
  let(:geocode_response) do
    %Q({"data":[
        {
          "type": "address",
          "latitude": "#{latitude}",
          "longitude": "#{longitude}",
          "postal_code": "#{zipcode}"
        }
      ]})
  end

  # Stubbed WeatherAPI response
  let(:weather_response) do
    %Q({"data":
        {"timelines":[
          {"timestep": "1d", "endTime": "2022-04-07T13:00:00Z", "startTime":"2022-03-23T13:00:00Z",
            "intervals":[
            {"startTime": "2022-03-23T13:00:00Z",
              "values":{
              "temperature": 88.03,
              "temperatureMax": 88.03,
              "temperatureMin": 59.98,
              "weatherCode": 1000}},
            {"startTime": "2022-03-24T13:00:00Z",
              "values": {
              "temperature": 84.4,
              "temperatureMax": 84.4,
              "temperatureMin": 59.52,
              "weatherCode":1000}}
            ]
          }]
        }
      })
  end

  before(:each) do
    # Generate webmock to catch GeocodeAPI calls
    stub_request(:get, /#{geocode_uri}/).
      to_return(
        headers: {content_type: 'application/json'},
        body: geocode_response
      )

    # Generate webmock to catch WeatherAPI calls
    stub_request(:get, /#{weather_uri}/).
      to_return(
        headers: {content_type: 'application/json'},
        body: weather_response
      )
  end

  context "POST create" do
    it 'valid query should render the index' do
      post :create, params: {address: address}

      expect(response).to render_template(:index)
    end

    it 'invalid query should redirect to root' do
      post :create

      expect(response).to redirect_to(:root)
    end

    it 'should render results from DB if cached' do
      Forecast.create(zipcode: zipcode)

      post :create, params: {address: address}

      # Cheat a little and just check for our cache flash flag
      expect(flash['from_cache']).to be_truthy
    end

    it 'should not render from cache if new query' do
      post :create, params: {address: address}

      # Cheat a little and just check for our cache flash flag
      expect(flash['from_cache']).to be_falsy
    end
  end
end
