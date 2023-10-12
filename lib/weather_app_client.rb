class WeatherAppClient
  WEATHER_URL = "https://api.openweathermap.org/data/2.5"
  GEOCODE_URL = "https://api.openweathermap.org/geo/1.0"

  attr_reader :city, :state, :zip, :country, :api_key

  def initialize(city:, state:, zip:, country:)
    @city = city
    @state = state
    @zip = zip
    @country = country
    @api_key = Rails.application.credentials.open_weather_map_api_key
  end

  def current_weather
    lat, lon = geocoded_address
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{api_key}&units=imperial")
    response.parsed_response
  end

  def forecast
    lat, lon = geocoded_address
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/forecast?lat=#{lat}&lon=#{lon}&appid=#{api_key}&units=imperial")
    response.parsed_response
  end

  private

  def geocoded_address
    return @geocoded_address if @geocoded_address
    response = HTTParty.get("#{GEOCODE_URL}/direct?q=#{city},#{state},#{country}&limit=10&appid=#{api_key}")
    lat = response.parsed_response.first["lat"]
    lon = response.parsed_response.first["lon"]
    @geocoded_address ||= [lat, lon]
  end

  def geocoded_zip
    return @geocoded_zip if @geocoded_zip
    response = HTTParty.get("#{GEOCODE_URL}/zip?zip=#{zip},#{country}&appid=#{api_key}")
    lat = response.parsed_response["lat"]
    lon = response.parsed_response["lon"]
    @geocoded_zip ||= [lat, lon]
  end
end
