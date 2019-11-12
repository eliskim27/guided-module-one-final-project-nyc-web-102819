require 'pry'
require_relative '../config/environment'

require "tty-prompt"
require 'date'



class Search
    def run
        welcome
        city_name = get_user_input
        response = call_api(city_name)
        convert_data(response)
        #binding.pry
    end
######## INITIAL LOGIN
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
    end
end


search = Search.new
search.run