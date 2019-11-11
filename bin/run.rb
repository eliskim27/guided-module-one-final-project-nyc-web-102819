require 'pry'
require_relative '../config/environment'

# api.openweathermap.org/data/2.5/weather?q={city name}

# unsure of commas in has_many realtionships classes
class Search
def run
    welcome
    city_name = get_user_input
    response = call_api(city_name)
    binding.pry
end

def welcome
    puts "welcome"
end

def get_user_input
    puts "Please enter a city:"
    gets.chomp
end

def call_api(city_name)
    url = "http://api.openweathermap.org/data/2.5/weather?q=#{city_name}&APPID=827a998e41cda6984e61e05673fb503b"
    response = RestClient.get(url)
    parse_response(response)
end

def parse_response(response)
    JSON.parse(response)
end


#kthx
end

search = Search.new
search.run
# binding.pry