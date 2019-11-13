require 'pry'
require_relative '../config/environment'

require "tty-prompt"
require 'date'



class Search
    def run
        welcome
        welcome_options
        # new search or view favorite ?
        #       > favortie = list all user favorites ==> selects location ==> 
        #       > run taht search or delete from favorites
        #       > if deleted => * new search or view favorite *
        city_name = get_user_input
        response = call_api(city_name)
        convert_data(response)
        #save_and_favorite
        # binding.pry
        
    end

    # def throw_error
    #     puts "That didn't return a result"
    #     run
    # end


end


search = Search.new
search.run