require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').sort_by {rand}[0,10]
  end

  def score
    shuffled_letters = params[:shuffled_letters]
    letters_array = shuffled_letters.split(" ")
    @score = ""
    @word = params[:answer]
    if include(word, letters_array) == false
      @score = "Sorry but #{@word} can't be built out of #{shuffled_letters}"
    elsif exist(word) == false
      @score = "Sorry but #{@word} does not seem to be a valid English word"
    else
      @score = "Congrats #{@word} is a valid English word"
    end
  end

  def include(word, letters)
    check = []
    word.split(//).map do |letter|
      response = letters.include?(letter)
      check << response
    end
    check.include?(false) ? false : true
  end

  def exist(word)
    url= "https://dictionary.lewagon.com/#{word}"
    response_serialized= URI.open(url).read
    response= JSON.parse(response_serialized)
    response[:found] == true ? true : false
  end
end
