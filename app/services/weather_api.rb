class WeatherApi
  # Class for returning the current and extended weather forecasts by latitude/longitude.
  # This class is a wrapper for the Tomorrow.IO weather API: https://www.tomorrow.io/weather-api

  BASE_URI = 'https://api.tomorrow.io/v4/timelines'

  # Tomorrow.io "weatherCode" mapping.
  # Converts the returned code to a textual description.
  DESCRIPTION = {
      '0'    => 'Unknown',
      '1000' => 'Clear',
      '1001' => 'Cloudy',
      '1100' => 'Mostly Clear',
      '1101' => 'Partly Cloudy',
      '1102' => 'Mostly Cloudy',
      '2000' => 'Fog',
      '2100' => 'Light Fog',
      '3000' => 'Light Wind',
      '3001' => 'Wind',
      '3002' => 'Strong Wind',
      '4000' => 'Drizzle',
      '4001' => 'Rain',
      '4200' => 'Light Rain',
      '4201' => 'Heavy Rain',
      '5000' => 'Snow',
      '5001' => 'Flurries',
      '5100' => 'Light Snow',
      '5101' => 'Heavy Snow',
      '6000' => 'Freezing Drizzle',
      '6001' => 'Freezing Rain',
      '6200' => 'Light Freezing Rain',
      '6201' => 'Heavy Freezing Rain',
      '7000' => 'Ice Pellets',
      '7101' => 'Heavy Ice Pellets',
      '7102' => 'Light Ice Pellets',
      '8000' => 'Thunderstorm'
    }

  attr_reader :intervals

  # Convenience method allowing class level calls to `get`,
  # while still providing all the niceties of instance instantiation.
  #
  # For example:
  #     WeatherApi::get(latitude: 47.620495, longitude: -122.3493)
  #       => #<WeatherApi  @intervals=> [{:timestamp=>"2022-03-15T07:22:00Z", ... >
  def self.get(latitude:, longitude:)
    self.new(latitude: latitude, longitude: longitude).get
  end

  # Initialize a WeatherApi instance.
  # Requires the latitude and longitude coordinates.
  # Sets default instance var values.
  def initialize(latitude:, longitude:)
    @error = false
    @latitude = latitude
    @longitude = longitude
    @response = nil
    @intervals = []
  end

  # Queries the weather api and parses the response.
  # Flips error flag if any exceptions are thrown.
  # Returns itself.
  def get
    query_api
    parse_results
  rescue
    @error = true
  ensure
    return self # Must explicitly return on ensure
  end

  # Returns true if the weather instance is valid.
  def valid?
    !@error && valid_results?
  end

  private

  # Returns true if the weather instance has valid results.
  # If the zipcode, latitude or longitude have not been set,
  # then the instance is considered invalid.
  def valid_results?
    @intervals.any?
  end

  # Query the Tomorrow.IO weather API and set the response.
  def query_api
    @response = HTTParty.get(api_url).parsed_response
  end

  # Parse the Tomorrow.io weather API response and construct forecast intervals.
  def parse_results
    if @response['data'] and @response['data']['timelines']
      @response['data']['timelines'].each do |timeline|
        timeline['intervals'].each do |interval|
          @intervals << {
            timestamp:   interval['startTime'],
            code:        interval['values']['weatherCode'],
            temperature: interval['values']['temperature'],
            max:         interval['values']['temperatureMax'],
            min:         interval['values']['temperatureMin']
          }
        end
      end
    end
  end

  # Builds the Tomorrow.io weather API query url.
  # Requires a valid API access key and latitude/longitude.
  def api_url
    url = BASE_URI
    url += "?location=#{@latitude},#{@longitude}"
    url += '&fields=temperature,temperatureMin,temperatureMax,weatherCode'
    url += '&timesteps=current,1d'
    url += '&units=imperial'
    url += "&apikey=#{api_key}"
  end

  # Returns the Tomorrow.io API key.
  # In development this is stored in the '.env' file.
  # In production this is stored as an ENV variable on the server.
  def api_key
    ENV['TEMPERATURE_IO_SECRET_KEY']
  end
end
