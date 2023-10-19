class ForecastsController < ApplicationController
  def create
    require_address_params
    redirect_to root_url and return unless @address_params

    get_geocode
    redirect_to root_url and return unless @geocode

    cached_forecast
    render 'application/index' and return if @forecast # Render from cache if found

    get_weather
    redirect_to root_url and return unless @weather

    create_forecast
    redirect_to root_path and return unless @forecast

    render 'application/index' # Render after create if cache not found
  end

  private

  def require_address_params
    @address_params = params.require('address')
  rescue
    flash['error'] = 'Please enter a valid address.'
  end

  def get_geocode
    geocode = GeocodeApi::get(address: @address_params)

    if geocode.valid?
      @geocode = geocode
    else
      flash['error'] = 'There was a problem finding a forecast for that address. Please try again.'
    end
  end

  def cached_forecast
    @forecast = Forecast.cached.where(zipcode: @geocode.zipcode).first
    @retrieved_from_cache = !!@forecast
  end

  def get_weather
    weather = WeatherApi::get(latitude: @geocode.latitude, longitude: @geocode.longitude)

    if weather.valid?
      @weather = weather
    else
      flash['error'] = 'There was a problem retrieving weather at that address. Please try again.'
    end
  end

  def create_forecast
    @forecast = Forecast.new(zipcode: @geocode.zipcode)
    @forecast.intervals.build(@weather.intervals)
    @forecast.save!
  rescue
    flash['error'] = 'There was a problem creating a forecast for that address. Please try again.'
  end
end
