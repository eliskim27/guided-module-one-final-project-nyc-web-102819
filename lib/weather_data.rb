def get_user_input
    puts "Please enter a location (city, state/country):"
    gets.chomp
end

def call_api(city_name,country_code="US")
    url = "http://api.openweathermap.org/data/2.5/weather?q=#{city_name},#{country_code}&APPID=827a998e41cda6984e61e05673fb503b"
    response = RestClient.get(url)
    parse_response(response)
end

def parse_response(response)
    JSON.parse(response)
end

def convert_data(response)
    name = response["name"]
    country = response["sys"]["country"]
    puts "#{name}, #{country}"
    puts timezone = response["timezone"]
    time = response["dt"]
    puts Time.at(time).to_datetime
    puts description = response["weather"][0]["description"]
    puts sky = response["weather"][0]["main"]
     temp = ((response["main"]["temp"] -273.15) * 9/5 + 32).round(1) 
    puts "Temperature: #{temp}°F"
    temp_min = ((response["main"]["temp_min"] -273.15) * 9/5 + 32).round(1) 
    puts "Today's low 📉: #{temp_min}°F"
    temp_max = ((response["main"]["temp_max"] -273.15) * 9/5 + 32).round(1) 
    puts "Today's high 📈: #{temp_max}°F"
    puts humidity = response["main"]["humidity"]
    puts wind_speed = response["wind"]["speed"]
    wind_direction = (response["wind"]["deg"])
    sunrise = response["sys"]["sunrise"]
    puts "Sun will rise at: #{Time.at(sunrise).to_datetime}"
    sunset = response["sys"]["sunset"]
    puts "Sun will set at: #{Time.at(sunset).to_datetime}"
    rain = response["rain"]
    #!response["rain"].empty? ? puts rain : nil
    #puts snow if !response["snow"].empty?

    binding.pry
end

