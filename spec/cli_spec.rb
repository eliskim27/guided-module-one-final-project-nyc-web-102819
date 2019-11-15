require_relative '../lib/cli.rb'
require 'colorize'

RSpec.describe Cli do
    xdescribe '#call_api' do
        let(:test) {Cli.new}
        it 'it expects a string ' do
            string = "New York"
            result = test.call_api(string)
            expect(result).to be true
        end
    end

    xdescribe '#convert_data' do
        let(:test) {Cli.new}
        hash = {"coord"=>
        {"lon"=>-73.99,
         "lat"=>40.73},
       "weather"=>
        [{"id"=>800,
          "main"=>"Clear",
          "description"=>
           "clear sky",
          "icon"=>"01d"}],
       "base"=>"stations",
       "main"=>
        {"temp"=>281.62,
         "pressure"=>1023,
         "humidity"=>39,
         "temp_min"=>279.82,
         "temp_max"=>283.15},
       "visibility"=>16093,
       "wind"=>
        {"speed"=>3.6,
         "deg"=>300},
       "clouds"=>{"all"=>1},
       "dt"=>1573835897,
       "sys"=>
        {"type"=>1,
         "id"=>4686,
         "country"=>"US",
         "sunrise"=>
          1573818159,
         "sunset"=>
          1573853918},
       "timezone"=>-18000,
       "id"=>5128581,
       "name"=>"New York",
       "cod"=>200}

        it 'takes 1 argument' do
            expect{convert_data(hash)}


        end

    end

    xdescribe '#convert_data' do
            it 'it should output temperature as a string' do
                hash = {"coord"=>
                {"lon"=>-73.99,
                 "lat"=>40.73},
               "weather"=>
                [{"id"=>800,
                  "main"=>"Clear",
                  "description"=>
                   "clear sky",
                  "icon"=>"01d"}],
               "base"=>"stations",
               "main"=>
                {"temp"=>281.62,
                 "pressure"=>1023,
                 "humidity"=>39,
                 "temp_min"=>279.82,
                 "temp_max"=>283.15},
               "visibility"=>16093,
               "wind"=>
                {"speed"=>3.6,
                 "deg"=>300},
               "clouds"=>{"all"=>1},
               "dt"=>1573835897,
               "sys"=>
                {"type"=>1,
                 "id"=>4686,
                 "country"=>"US",
                 "sunrise"=>
                  1573818159,
                 "sunset"=>
                  1573853918},
               "timezone"=>-18000,
               "id"=>5128581,
               "name"=>"New York",
               "cod"=>200}
         

                expect{convert_data(hash)}.to output("Temperature: 47.2 °F").to_stdout
            end
        end








end


