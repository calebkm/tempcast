require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GeocodeApi, type: :model do
  let(:base_uri)  { GeocodeApi::BASE_URI }
  let(:address)   { "5905 Wilshire Blvd, Los Angeles, CA 90036" }
  let(:latitude)  { "34.064468" }
  let(:longitude) { "-118.359922" }
  let(:zipcode)   { "90036" }

  # Stubbed API response
  let(:response) do
    %Q({"data":[
        {
          "type": "address",
          "latitude": "#{latitude}",
          "longitude": "#{longitude}",
          "postal_code": "#{zipcode}"
        }
      ]})
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
      it 'should return a GeocodeApi instance' do
        geocode = GeocodeApi.get(address: address)

        expect(geocode).to be_a(GeocodeApi)
      end
    end
  end

  context 'instance method tests' do
    context 'get' do
      it 'should set the latitude, longitude and zipcode from an input address' do
        geocode = GeocodeApi.new(address: address).get

        expect(geocode.latitude).to eq(latitude)
        expect(geocode.longitude).to eq(longitude)
        expect(geocode.zipcode).to eq(zipcode)
      end
    end

    context 'valid?' do
      it 'should be true' do
        geocode = GeocodeApi.new(address: address).get

        expect(geocode.valid?).to be_truthy
      end
    end
  end
end
