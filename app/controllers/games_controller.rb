require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @grid = generate_grid(10)
    @start_time = Time.now
  end

  def score
    # start a new st viariable assign to the string in my params
    @start_time = params["start_time"]
    st = Time.parse(@start_time)
    @end_time = Time.now
    @time = (@end_time - st).round(2)
    # raise
    @attempt = params["guess"]
    @found = english_word?(@attempt)

    if @found == true
      @end_message = "You WIN!!!!"
    else
      @end_message = "you LOOSE !!!"
    end
    @score = compute_score(@attempt, @time)
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(attempt, time)
    time > 60.0 ? 0 : attempt.size * (1.0 - time / 60.0)
  end


end
