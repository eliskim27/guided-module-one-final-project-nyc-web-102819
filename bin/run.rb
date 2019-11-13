require 'pry'
require_relative '../config/environment'

require "tty-prompt"
require 'date'


my_app = Cli.new
my_app.run