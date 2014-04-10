#!/usr/bin/env ruby
require_relative 'dictionary.rb'
class Misspeler
  attr_reader :word
  def initialize word
    @word = word
    @length = @word.length
  end
    
  def misspel strength = 3
    rand(strength).times { swap_vowels }
    rand(strength).times { duplicate_letters }
    rand(strength).times { change_chase }
    @word
  end

  # private
  def swap_vowels
    i = (0..@length).collect { |i| i if @word[i] =~ /[aeiou]/ }.compact.sample
    @word[i] = ("aeiou".split('') - [@word[i]]).sample
  end

  def duplicate_letters
    i = rand(@length)
    @word = @word[0..i] + @word[i..-1]
  end

  def change_chase
    i = rand(@length)
    @word[i] = @word[i].upcase
  end
end

if __FILE__ == $0 && STDIN.tty?
  word = Dictionary.pluck
  puts Misspeler.new(word).misspel
end

if !STDIN.tty?
  stdin = STDIN.gets.chomp
  STDERR.write "misspeling #{stdin}\n"
  STDOUT.write Misspeler.new(stdin).misspel + "\n"
end
