class GeocodeApi
  # Class for converting street address into latitude and longitude coordinates.
  # This class is a wrapper for the Positionstack geocode API: https://positionstack.com/documentation

  BASE_URI = 'http://api.positionstack.com/v1/forward'

  attr_reader :results, :latitude, :longitude, :zipcode

  # Convenience method allowing class level calls to `get`,
  # while still providing all the niceties of instance instantiation.
  #
  # For example:
  #     GeocodeApi::get(address: '6060 Wilshire Blvd, Los Angeles, CA 90036')
  #       => #<GeocodeApi @latitude=34.06273, @longitude=-118.361035, @zipcode="90036", ...>
  def self.get(address:)
    self.new(address: address).get
  end

  # Initialize a GeocodeApi instance.
  # Requires the string query address as an input.
  # Sets default instance var values.
  def initialize(address:)
    @address = address
    @error = false
    @response = nil
    @zipcode = nil
    @latitude = nil
    @longitude = nil
  end

  # Queries the geocode api and parses the response.
  # Flips error flag if any exceptions are thrown.
  # Returns itself.
  def get
    begin
      query_api
      parse_response
    rescue
      @error = true
    ensure
      return self # Must explicitly return on ensure
    end
  end

  # Returns true if the geocode instance is valid.
  def valid?
    !@error && valid_results?
  end

  private

  # Returns true if the geocode instance has valid results.
  # If the zipcode, latitude or longitude have not been set,
  # then the instance is considered invalid.
  def valid_results?
    !!@zipcode && !!@latitude && !!@longitude
  end

  # Query the Positionstack API and set the response.
  def query_api
    @response = HTTParty.get(api_url).parsed_response
  end

  # Parse the Positionstack API response and set instance vars.
  # Parses and sets the zipcode, latitude and longitude from the response data.
  # NOTE: Currently only return results for "type" address or postalcode.
  #       This restricts input addresses to US only.
  def parse_response
    if @response['data']
      @response['data'].each do |data|
        if data['type'] == 'address' or data['type'] == 'postalcode'
          @latitude = data['latitude']
          @longitude = data['longitude']
          @zipcode = data['postal_code']
          break
        end
      end
    end
  end

  # Builds the Positionstack API query url.
  # Requires a valid API access key and query address.
  def api_url
    url = BASE_URI
    url += "?access_key=#{access_key}"
    url += "&query=#{@address}"
  end

  # Returns the Positionstack API key.
  # In development this is stored in the '.env' file.
  # In production this is stored as an ENV variable on the server.
  def access_key
    ENV['POSITIONSTACK_ACCESS_KEY']
  end
end
