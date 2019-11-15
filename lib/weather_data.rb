# def get_user_input
#     puts "Please enter a location (city, state/country):".light_blue
#     gets.chomp
# end

# def call_api(city_name)
#     url = "http://api.openweathermap.org/data/2.5/weather?q=#{city_name}&APPID=827a998e41cda6984e61e05673fb503b"
#     begin
#         response=RestClient.get(url)
#         rescue 
#         puts "Couldn't find find that location".bold.red
#         puts ""
#         puts "*  *  *  *  *  *  *  *  *"
        
#         return call_api(get_user_input)
#     end
#         parse_response(response)     
# end

# def parse_response(response)
#     JSON.parse(response)
# end

# def convert_data(response)
#     name = response["name"]
#     country = response["sys"]["country"]
#     namecountry = "#{name}, #{country}"
#         puts "_"*namecountry.length
#         puts "#{namecountry}".bold
#     timezone = response["timezone"]
#     time = Time.new
#         time_format = time.getlocal(timezone)
#         puts "Local time is: #{time_format.strftime("%I:%M %p")}"
#         puts ""
#     temp = ((response["main"]["temp"] -273.15) * 9/5 + 32).round(1) 
#         puts "Temperature: #{temp}°F".yellow
#     temp_min = ((response["main"]["temp_min"] -273.15) * 9/5 + 32).round(1) 
#         puts "Today's low 📉: #{temp_min}°F".yellow
#     temp_max = ((response["main"]["temp_max"] -273.15) * 9/5 + 32).round(1) 
#         puts "Today's high 📈: #{temp_max}°F".yellow
#         puts ""
#     description = response["weather"][0]["description"]
#         if description.include?("cloud")
#         puts "Description: #{description.titleize} ☁️"
#         elsif description.include?("sun") || description.include?("clear")
#             puts "Description: #{description.titleize} ☀️"
#         elsif description.include?("partly cloud") || description.include?("scattered cloud")
#             puts "Description: #{description.titleize} 🌤"
#         elsif description.include?("rain") 
#             puts "Description: #{description.titleize} 🌧"
#         elsif description.include?("snow") 
#             puts "Description: #{description.titleize} ❄️"
#         elsif description.include?("wind")
#             puts "Description: #{description.titleize} 💨"
#         else 
#             puts "Description: #{description.titleize}"
#         end
#     # sky = response["weather"][0]["main"]
#     #     puts "Sky: #{sky}"
#     humidity = response["main"]["humidity"]
#         puts "Humidity: #{humidity}%"
#     rain = response["rain"]
#         if !rain == nil
#             puts "Rain: #{rain}"
#         end
#     snow = response["snow"]
#         if !snow == nil
#             puts "Snow: #{snow}"
#         end
#         puts ""
#     wind_speed = (response["wind"]["speed"] * 2.236936).round(2)
#         puts "Wind Speed: #{wind_speed} mph"
#     wind_direction = (response["wind"]["deg"])
#         case wind_direction
#             when 22.6..67.5
#                 cardinal = "NE"
#             when 67.6..112.5
#                 cardinal = "E"
#             when 112.6..157.5
#                 cardinal = "SE"
#             when 157.6..202.5
#                 cardinal = "S"
#             when 202.6..247.5
#                 cardinal = "SW"
#             when 247.6..292.5
#                 cardinal = "W"
#             when 292.6..337.5
#                 cardinal = "NW"
#             when 337.6..361
#                 cardinal = "N"
#             when 0..22.5
#                 cardinal = "N"
#             else
#                 cardinal = nil
#         end
#         if cardinal != nil
#             puts "Wind Direction: #{cardinal}"
#         end
#         puts ""
#     sunrise = response["sys"]["sunrise"]
#         sunrise_format = Time.at(sunrise).getlocal(timezone)
#         puts "Sun will rise at: #{sunrise_format.strftime("%I:%M %p %Z")} 🌇"
#     sunset = response["sys"]["sunset"]
#         sunset_format = Time.at(sunset).getlocal(timezone)
#         puts "Sun will set at: #{sunset_format.strftime("%I:%M %p %Z")} 🌃"
#         # binding.pry
#         save_and_favorite(namecountry)
# end

