class Cli
    def run
        welcome
        welcome_options
        # new search or view favorite ?
        #       > favortie = list all user favorites ==> selects location ==> 
        #       > run taht search or delete from favorites
        #       > if deleted => * new search or view favorite *
        # city_name = get_user_input
        # response = call_api(city_name)
        # convert_data(response)
        #save_and_favorite
        # binding.pry
        
    end
    
    def welcome
        puts "Welcome! Let's look at some weather!"
        prompt = TTY::Prompt.new
        puts ""
        choice = prompt.select("Login or Create an Account:") do |menu|
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
        prompt = TTY::Prompt.new
        @username = prompt.ask('Please enter your Username:')
        if !User.all.find_by username: "#{@username}"
            puts "This Username does not exist"
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
            # binding.pry
        end
    end

    def validate_password
        prompt = TTY::Prompt.new
        password = prompt.mask('What is your Password?')
        if (User.all.find_by username: "#{@username}").password == password
            @current_user_id =(User.all.find_by username: "#{@username}").id
        else
            puts "Wrong password, try again."
            validate_password
        end
    end

    def create_account
        prompt = TTY::Prompt.new
        puts ""
        puts "New account:"
        puts ""
        username = prompt.ask('Please enter a new username:')
        if User.all.find_by username: "#{username}"
            puts "This Username already exists."
            username = prompt.ask('Please enter a new Username:')
        end
        password = prompt.mask('What is your Password?')
        User.create(username: username, password: password)
        @current_user_id = User.last.id
    end

    def save_and_favorite(name)
        prompt = TTY::Prompt.new
        choice = prompt.select("Would you like to save this location to your favorites?") do |menu|
            menu.choice 'Yes'
            menu.choice 'No'
        end
        if choice == 'Yes'
            Location.create(name: name)
            Favorite.create(user_id:@current_user_id,location_id:Location.find_by(name:name).id)
            
        # elsif choice == 'No'
            
        end
    end

    def welcome_options
    # new search or view favorite ?
            #       > favortie = list all user favorites ==> selects location ==> 
            #       > run taht search or delete from favorites
            #       > if deleted => * new search or view favorite *
        prompt = TTY::Prompt.new
        choice = prompt.select("Would you like to do?") do |menu|
            menu.choice 'Make a new search'
            menu.choice "View my favorites"
        end
        if choice == 'View my favorites'
            city = prompt.select("Please select....", my_favorites)
            search_or_delete(city)
        elsif choice == 'Make a new search'
            city_name = get_user_input
            response = call_api(city_name)
            convert_data(response)
        end
        # search_or_delete
    end

    def search_or_delete(city)
        prompt = TTY::Prompt.new
        choice = prompt.select("Would you like to search this location's current weather, or delete from favorites?") do |menu|
            menu.choice "Search location's weather"
            menu.choice "Delete from favorites"
        end
        if choice == "Search location's weather"


            # binding.pry
            response = call_api(city)
            convert_data(response)

        elsif choice == "Delete from favorites"
        Favorite.where(user_id: @current_user_id).where()
        end
        binding.pry
    end

    def my_favorites
        User.find_by(id:@current_user_id).favorites.map do |favorite|
            x = favorite.location_id
            Location.all.find_by(id: x).name
        end
    end

end

