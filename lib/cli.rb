class Cli
    def run
        welcome
        welcome_options
    end

    def welcome
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        puts "Welcome! Let's look at some weather!"
        prompt = TTY::Prompt.new
        puts ""
        choice = prompt.select("Login or Create an Account:".blue) do |menu|
            menu.choice 'Login'
            menu.choice 'Create an Account'
        end
        if choice == 'Login'
            user_login
        elsif choice == 'Create an Account'
            create_account
        end
    end

    def user_login
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        prompt = TTY::Prompt.new
        @username = prompt.ask('Please enter your Username:')
        if !User.all.find_by username: "#{@username}"
            puts ""
            puts "*  *  *  *  *  *  *  *  *" 
            puts "This Username does not exist".bold.red
            choice = prompt.select("Please select one of the following options:") do |menu|
                menu.choice 'Re-enter Username'
                menu.choice 'Create an Account'
            end
            if choice == 'Re-enter Username'
                user_login
            elsif choice == 'Create an Account'
                create_account
            end
        else 
            validate_password
        end
    end

    def validate_password
        prompt = TTY::Prompt.new
        password = prompt.mask('What is your Password?')
        if (User.all.find_by username: "#{@username}").password == password
            @current_user_id =(User.all.find_by username: "#{@username}").id
        else
            puts "Wrong password, try again.".bold.red
            validate_password
        end
    end

    def create_account
        prompt = TTY::Prompt.new
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        puts "New account:"
        puts ""
        username = prompt.ask('Please enter a new username:')
        if User.all.find_by username: "#{username}"
            puts ""
            puts "*  *  *  *  *  *  *  *  *"    
            puts "This Username already exists.".bold.red
            username = prompt.ask('Please enter a new Username:')
        end
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        password = prompt.mask('What is your Password?')
        User.create(username: username, password: password)
        @current_user_id = User.last.id
    end

    def save_and_favorite(namecountry)
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        if my_favorites_by_name.include?(namecountry)
        else
            prompt = TTY::Prompt.new
            choice = prompt.select("Would you like to save this location to your favorites?") do |menu|
                menu.choice 'Yes'
                menu.choice 'No'
            end
        end
        if choice == 'Yes'
            Location.create(name: namecountry)
            Favorite.create(user_id:@current_user_id,location_id:Location.find_by(name:namecountry).id)            
        end
    end

    def welcome_options
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        if my_favorites_by_name.empty?
            city_name = get_user_input
            response = call_api(city_name)
            convert_data(response)
        else
            prompt = TTY::Prompt.new
            choice = prompt.select("Would you like to do?") do |menu|
                menu.choice 'Make a new search'
                menu.choice "View my favorites"
            end
            puts ""
            puts "*  *  *  *  *  *  *  *  *"    
            if choice == 'View my favorites'
                city = prompt.select("Please select....", my_favorites_by_name)
                search_or_delete(city)
            elsif choice == 'Make a new search'
                city_name = get_user_input
                response = call_api(city_name)
                convert_data(response)
            end
        end
        end_options
    end

    def search_or_delete(city)
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        prompt = TTY::Prompt.new
        choice = prompt.select("Would you like to search this location's current weather, or delete from favorites?") do |menu|
            menu.choice "Search location's weather"
            menu.choice "Delete from favorites"
        end
        if choice == "Search location's weather"
            response = call_api(city)
            convert_data(response)

        elsif choice == "Delete from favorites"
            x = Location.all.find_by(name: city).id
            city_to_delete = my_favorites.where(location_id: x)
            my_favorites.delete(city_to_delete)
            puts ""
            puts "*  *  *  *  *  *  *  *  *"    
            puts "#{city} has been deleted from your favorites."
        end
    end

    def my_favorites
        User.find_by(id:@current_user_id).favorites
    end

    def my_favorites_by_name
        my_favorites.map do |favorite|
            x = favorite.location_id
            Location.all.find_by(id: x).name
        end
    end

    def end_options
        puts ""
        puts "*  *  *  *  *  *  *  *  *"
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to do now?") do |menu|
            menu.choice "Home"
            menu.choice "Quit"
        end
        if choice == "Home"
            puts `clear`
            welcome_options
        elsif choice == "Quit"
            puts ""
            puts "*  *  *  *  *  *  *  *  *"    
            puts "Thanks! Come back soon!".bold.yellow
        end
    end

    def get_user_input
        puts "Please enter a location (city, state/country):".light_blue
        gets.chomp
    end
    
    def call_api(city_name)
        url = "http://api.openweathermap.org/data/2.5/weather?q=#{city_name}&APPID=827a998e41cda6984e61e05673fb503b"
        begin
            response=RestClient.get(url)
            rescue 
            puts "Couldn't find find that location".bold.red
            puts ""
            puts "*  *  *  *  *  *  *  *  *"
            
            return call_api(get_user_input)
        end
            parse_response(response)     
    end
    
    def parse_response(response)
        JSON.parse(response)
    end
    
    def convert_data(response)
        name = response["name"]
        country = response["sys"]["country"]
        namecountry = "#{name}, #{country}"
            puts "_"*namecountry.length
            puts "#{namecountry}".bold
        timezone = response["timezone"]
        time = Time.new
            time_format = time.getlocal(timezone)
            puts "Local time is: #{time_format.strftime("%I:%M %p")}"
            puts ""
        temp = ((response["main"]["temp"] -273.15) * 9/5 + 32).round(1) 
            puts "Temperature: #{temp}°F".yellow
        temp_min = ((response["main"]["temp_min"] -273.15) * 9/5 + 32).round(1) 
            puts "Today's low 📉: #{temp_min}°F".yellow
        temp_max = ((response["main"]["temp_max"] -273.15) * 9/5 + 32).round(1) 
            puts "Today's high 📈: #{temp_max}°F".yellow
            puts ""
        description = response["weather"][0]["description"]
            if description.include?("cloud")
            puts "Description: #{description.titleize} ☁️"
            elsif description.include?("sun") || description.include?("clear")
                puts "Description: #{description.titleize} ☀️"
            elsif description.include?("partly cloud") || description.include?("scattered cloud")
                puts "Description: #{description.titleize} 🌤"
            elsif description.include?("rain") 
                puts "Description: #{description.titleize} 🌧"
            elsif description.include?("snow") 
                puts "Description: #{description.titleize} ❄️"
            elsif description.include?("wind")
                puts "Description: #{description.titleize} 💨"
            else 
                puts "Description: #{description.titleize}"
            end
        # sky = response["weather"][0]["main"]
        #     puts "Sky: #{sky}"
        humidity = response["main"]["humidity"]
            puts "Humidity: #{humidity}%"
        rain = response["rain"]
            if !rain == nil
                puts "Rain: #{rain}"
            end
        snow = response["snow"]
            if !snow == nil
                puts "Snow: #{snow}"
            end
            puts ""
        wind_speed = (response["wind"]["speed"] * 2.236936).round(2)
            puts "Wind Speed: #{wind_speed} mph"
        wind_direction = (response["wind"]["deg"])
            case wind_direction
                when 22.6..67.5
                    cardinal = "NE"
                when 67.6..112.5
                    cardinal = "E"
                when 112.6..157.5
                    cardinal = "SE"
                when 157.6..202.5
                    cardinal = "S"
                when 202.6..247.5
                    cardinal = "SW"
                when 247.6..292.5
                    cardinal = "W"
                when 292.6..337.5
                    cardinal = "NW"
                when 337.6..361
                    cardinal = "N"
                when 0..22.5
                    cardinal = "N"
                else
                    cardinal = nil
            end
            if cardinal != nil
                puts "Wind Direction: #{cardinal}"
            end
            puts ""
        sunrise = response["sys"]["sunrise"]
            sunrise_format = Time.at(sunrise).getlocal(timezone)
            puts "Sun will rise at: #{sunrise_format.strftime("%I:%M %p %Z")} 🌇"
        sunset = response["sys"]["sunset"]
            sunset_format = Time.at(sunset).getlocal(timezone)
            puts "Sun will set at: #{sunset_format.strftime("%I:%M %p %Z")} 🌃"
            # binding.pry
            save_and_favorite(namecountry)
    end
    
    

end
