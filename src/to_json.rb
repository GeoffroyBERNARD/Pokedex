#!/usr/bin/env ruby
#encoding: utf-8

require 'json'

files = ARGV

class Pokemon
  def initialize(text_description)
    @text_description = text_description
  end

  attr_reader :text_description

  def properties
    @properties ||= begin
      data = {}

      text_description.each_line do |line|
        next unless line[/^\| .+=/]
        next if line[/="/] # style="blabla"

        key, value = line.delete('| ').split('=')
        data[key.strip] = value.strip
      end

      reading_attacks = false
      attacks = []
      text_description.each_line do |line|
        line.strip!

        if line == "{{Attaques apprises|gen=I}}"
          reading_attacks = true
          next
        end

        if line == "{{Attaques apprises-bas}}"
          reading_attacks = false
        end

        if reading_attacks
          line.delete!('{}')
          _, niveau, nom, puissance, precision, pp = line.strip.split('|')
          attacks << {
            niveau: niveau,
            nom: nom,
            puissance: puissance,
            precision: precision,
            pp: pp
          }
        end
      end

      data["attaques"] = attacks

      data.delete 'nomSuivant'
      data.delete 'nomPrécédent'

      data
    end
  end
end

pokemons = []

files.each do |file|
  pokemons << Pokemon.new(File.read(file)).properties
end

File.open('data/pokedex.json', 'w') do |f|
  f.write JSON.pretty_generate pokemons
end
