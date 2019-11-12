class User < ActiveRecord::Base
    has_many :favorites
    has_many :locations, through: :favorites


    def login_username
        prompt = TTY::Prompt.new
        username = prompt.ask('Please enter your Username:', default: ENV['USER'])
        password = prompt.mask('What is your Password?')
        User.create(username: username, password: password)
        binding.pry
    end



end