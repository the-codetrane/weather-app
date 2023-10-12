Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/weather', to: 'weather#weather'
  post '/current_weather', to: 'weather#current_weather'

  # Defines the root path route ("/")
  root "weather#weather"

end
