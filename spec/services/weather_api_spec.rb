require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherApi, type: :model do
  let(:base_uri)  { WeatherApi::BASE_URI }
  let(:latitude)  { "34.064468" }
  let(:longitude) { "-118.359922" }

  # Stubbed API response with TWO intervals
  let(:response) do
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

  # WeatherAPI#intervals after being set by the API call
  let(:intervals) do
    [{
        timestamp: "2022-03-23T13:00:00Z",
        code: 1000,
        temperature: 88.03,
        max: 88.03,
        min: 59.98
     },
     {
       timestamp: "2022-03-24T13:00:00Z",
       code: 1000,
       temperature: 84.4,
       max: 84.4,
       min: 59.52
     }]
  end

  # Generate webmock to catch API call and return predefined response
  before(:each) do
    stub_request(:get, /#{base_uri}/).
      to_return(
        headers: {content_type: 'application/json'},
        body: response
      )
  end

  context 'class method tests' do
    context 'get' do
      it 'valid query should return a WeatherApi instance' do
        weather = WeatherApi.get(latitude: latitude, longitude: longitude)

        expect(weather).to be_a(WeatherApi)
      end
    end
  end

  context 'instance method tests' do
    context 'get' do
      it 'valid query should set the intervals' do
        weather = WeatherApi.get(latitude: latitude, longitude: longitude)

        expect(weather.intervals).to eq(intervals)
      end
    end

    context 'valid?' do
      it 'valid query should be true' do
        weather = WeatherApi.get(latitude: latitude, longitude: longitude)

        expect(weather.valid?).to be_truthy
      end
    end
  end
end
