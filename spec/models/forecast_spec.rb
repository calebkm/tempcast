require 'rails_helper'

RSpec.describe Forecast, type: :model do
  context 'validation tests' do
    it 'requires zipcode presence' do
      is_valid = Forecast.new.save
      expect(is_valid).to eq(false)
    end
  end

  context 'associations tests' do
    it 'should has_many intervals' do
      # https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html
      forecast = Forecast.reflect_on_association(:intervals)
      expect(forecast.macro).to eq(:has_many)
    end
  end

  context 'scope tests' do
    before(:each) do
      Forecast.create(zipcode: '12345', created_at: DateTime.now)
      Forecast.create(zipcode: '12345', created_at: DateTime.now - 20.minutes)
      Forecast.create(zipcode: '12345', created_at: DateTime.now - 60.minutes)
    end

    it "'cached' should not return forecasts older than 30 minutes." do
      expect(Forecast.cached.size).to eq(2)
    end
  end

  context 'instance method tests' do
    let(:timestamps) do
      [
        {timestamp: DateTime.parse('2022/3/14')},
        {timestamp: DateTime.parse('2022/3/15')},
        {timestamp: DateTime.parse('2022/3/16')}
      ]
    end

    let(:forecast) do
      forecast = Forecast.new(zipcode: '12345')
      forecast.intervals.build(timestamps)
      forecast.save
      forecast
    end

    context '#current' do
      it 'should return a single interval' do
        expect(forecast.current).to be_an_instance_of(Interval)
      end

      it 'should return the most recent interval by timestamp' do
        expect(forecast.current.timestamp).to eq(timestamps.first[:timestamp])
      end
    end

    context '#extended' do
      it 'should return all intervals except the current' do
        expect(forecast.extended.pluck(:timestamp)).to include(timestamps[1][:timestamp])
        expect(forecast.extended.pluck(:timestamp)).to include(timestamps[2][:timestamp])

        expect(forecast.extended.pluck(:timestamp)).not_to include(timestamps.first[:timestamp])
      end

      it 'should return one less than the length of all intervals' do
        expect(forecast.extended.size).to eq(forecast.intervals.size - 1)
      end
    end
  end
end
