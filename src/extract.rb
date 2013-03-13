#!/bin/env ruby

require 'rubygems'
require 'mechanize'
 
martine_ids = []
 
class Pokemon
end

class PokemonDescription
  BASE_URL = "http://www.pokepedia.fr/index.php/Pok%C3%A9mon_n%C2%B0"

  attr_reader :pokemon_number

  def initialize(pokemon_number)
    @pokemon_number = pokemon_number
  end

  def text_description
    @text_description ||= begin
      agent = Mechanize.new
      page = agent.get(BASE_URL + pokemon_number.to_s)
      page = page.link_with(text: "Modifier").click
      page.parser.css("textarea").text
    rescue Mechanize::ResponseCodeError
      "Not found..."
    end

  end
end

(1..151).each do |pokemon_number|
  file_name = "data/txt/pokemon_#{pokemon_number}.txt"
  next if File.exists?(file_name)

  puts "Pokemon #{pokemon_number} - Fetch"
  description = PokemonDescription.new(pokemon_number).text_description
  puts "Pokemon #{pokemon_number} - Write"

  File.open(file_name, 'w') do |f|
    f.write description
  end
end
