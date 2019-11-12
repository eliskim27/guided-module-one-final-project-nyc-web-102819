require 'pry'
require_relative '../config/environment'

require "tty-prompt"



class Search
    def run
        welcome
        binding.pry
        city_name = get_user_input
        response = call_api(city_name)
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
        username = prompt.ask('Please enter your Username:')
        if !User.all.find_by username: "#{username}"
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
            password = prompt.mask('What is your Password?')

        end
        # User.create(username: username, password: password)
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
    end

    # def validate_username(username)
    #     if User.all.find_by username: "#{username}"
    #         puts "This Username already exists."
    #         username = prompt.ask('Please enter a new Username:')
    #     end

    # end

    def get_user_input
        puts "Please enter a (US) city:"
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
end



search = Search.new
search.run