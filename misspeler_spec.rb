require_relative 'assert.rb'
require_relative 'misspeler.rb'
require_relative 'spellchecker.rb'
require_relative 'dictionary.rb'

checker = Spellchecker.new

assert "it capitalizes a letter" do
  Misspeler.new(Dictionary.pluck.downcase).misspel(cases: 1, vowels: 0, dupes: 0) =~ /[A-Z]/
end

assert "it swaps a vowel" do
  input  = Dictionary.pluck.chomp
  output = Misspeler.new(input.dup).misspel(vowels: 1, cases: 0, dupes: 0)
  input != output && input.gsub(/[aeiou]/, '') == output.gsub(/[aeiou]/, '')
end

assert "it duplicates a letter" do
  input  = Dictionary.pluck.chomp
  output = Misspeler.new(input.dup).misspel(dupes: 1, cases: 0, vowels: 0)
  input.length == (output.length - 1) && output =~ /([A-Za-z])\1/
end

assert "it can be corrected by the spellchecker" do
  10.times.map { Misspeler.new(Dictionary.pluck).misspel }
          .map { |word| checker.correct(word) }
          .select { |word| word == "NO SUGGESTIONS" }
          .empty?
end

