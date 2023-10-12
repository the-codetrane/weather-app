require 'weather_app_client'

class WeatherController < ApplicationController

  def weather; end

  def current_weather
    case params[:commit]
    when 'Current Weather'
      is_cached = Rails.cache.exist?("#{address.zip}-current_weather")
      @weather = fetch_data(:current_weather)
      render turbo_stream: turbo_stream.update('current_weather', WeatherCardComponent.new(weather: @weather, address: address, cached: is_cached))
    when 'Forecast'
      is_cached = Rails.cache.exist?("#{address.zip}-forecast")
      @weathers = fetch_data(:forecast).dig('list')
      render turbo_stream: turbo_stream.update('forecast_weather', WeatherCardComponent.with_collection(@weathers, address: address, title: 'Forecast', cached: is_cached))
    else
      @weather = weather_app_client.send(:current_weather)
    end
  end

  private

  def fetch_data(method)
    if Rails.cache.exist?("#{address.zip}-#{method}}")
      Rails.cache.read("#{address.zip}-#{method}}")
    else
      response = weather_app_client.send(method)
      Rails.cache.write("#{address.zip}-#{method}", response, expires_in: 30.minutes)
      response
    end
  end

  def address
    @address = OpenStruct.new(city: address_params[:city],
                              state: address_params[:state],
                              zip: address_params[:zip],
                              country: address_params[:country])
  end

  def address_params
    params.permit(:authenticity_token, :city, :state, :zip, :country_code, :commit)
  end

  def weather_app_client
    @weather_app_client ||= ::WeatherAppClient.new(city: address.city,
                                                   state: address.state,
                                                   zip: address.zip,
                                                   country: address.country)
  end
end
