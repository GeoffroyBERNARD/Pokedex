#!/usr/bin/env ruby

require 'pp'

file = ARGV[0]

text_content = File.read(file)

data = {}

text_content.each_line do |line|
  next unless line[/^\| .+=/]
  next if line[/="/] # style="blabla"

  key, value = line.delete('| ').split('=')
  data[key.strip] = value.strip
end

pp data
