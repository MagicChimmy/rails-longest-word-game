require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @letters = []
    9.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @user_input = params[:user_input].upcase
    @letters = params[:letters].split(' ')
    if included?(@user_input, @letters)
      if english_word?(@user_input)
        @answer = "Congratulations, #{@user_input} is a valid word!"
      else
        @answer = "Sorry but #{@user_input} does not seem to be a valid English word"
      end
    else
      @answer = "Sorry but #{@user_input} can't be built out of #{@letters}"
    end
  end

  def included?(user_input, _letters)
    user_input.chars.all? do |letter|
      user_input.count(letter) <= @letters.count(letter)
    end
  end

  def english_word?(_user_input)
    response = open("https://wagon-dictionary.herokuapp.com/#{@user_input}")
    json = JSON.parse(response.read)
    json['found']
  end
end
