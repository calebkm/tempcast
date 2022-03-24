module WeatherHelper
  def weather_code_to_icon_path(weather_code)
    # Return weather icon from weather code.
    # NOTE: Currently tied to the Tomorrow.io weather API specific codes/icons.
    # NOTE: The "0" in the below image path represents the DAYTIME icons.
    #       Replacing the "0" with a "1" will return the NIGHTTIME icons.
    #       Current code implementation does not take day/night into account,
    #       and we always return the daytime icons.
    image_path("icons/#{weather_code}0.png")
  rescue
    # If asset can't be found return empty PNG placeholder.
    image_path('icons/0.png')
  end

  def weather_code_to_description(weather_code)
    # Return text description from weather code.
    # NOTE: Currently tied to the Tomorrow.io weather API specific codes.
    WeatherApi::DESCRIPTION[weather_code.to_s]
  end
end
