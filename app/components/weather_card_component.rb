# frozen_string_literal: true

class WeatherCardComponent < ViewComponent::Base
  with_collection_parameter :weather
  attr_reader :cached

  def initialize(weather:, address:, title: 'Current Weather', cached: false)
    @weather = weather
    @address = address
    @title = title
    @cached = cached
  end

  def date
    date = @weather.dig("dt") || Time.now
    Time.at(date).to_datetime.strftime("%a, %d %B at %l:%M")
  end

  def current_temp
    @weather.dig("main", "temp")
  end

  def temp_high
    @weather.dig("main", "temp_max")
  end

  def temp_low
    @weather.dig("main", "temp_min")
  end

  def address_string
    "#{@address[:city]}, #{@address[:state]}"
  end

end
