#!/usr/bin/env ruby
require_relative 'dictionary'
class Spellchecker
  def initialize file: '/usr/share/dict/words'
    @dictionary = Dictionary.build_from(file)
    @d_ctionary = Dictionary.build_from(file) { |word| sub_vowels(word).to_sym }
  end

  def correct word
    @word = word.downcase
    search_exact || search_no_vowels || remove_duplicates_and_search || "NO SUGGESTIONS"
  end

  private
  def search_exact word = @word
    @dictionary.fetch word.to_sym, false
  end

  def search_no_vowels word = @word
    w_rd = sub_vowels word
    @d_ctionary.fetch w_rd.to_sym, false
  end

  def remove_duplicates_and_search word = @word
    collect_deviations(word)
      .each { |word| result = search_exact(word);     return result if result }
      .each { |word| result = search_no_vowels(word); return result if result }
    collect_deviations(sub_vowels word)
      .each { |word| result = search_no_vowels(word); return result if result }
    return false
  end

  def collect_deviations word
    all_deviations = []
    new_deviations = [word]

    begin
      all_deviations += new_deviations = new_deviations
        .map { |word| remove_one_of_each_duplication word }
        .flatten.uniq
    end while double_letters_in new_deviations

    all_deviations.flatten.uniq.sort { |a,b| b <=> a }
  end

  def double_letters_in words
    words.grep(/([a-z])\1/).any?
  end

  def remove_one_of_each_duplication word
    (0..word.length - 2).collect do |i| 
      remove_at_index(word.dup, i) if word[i] == word[i + 1]
    end.uniq.compact
  end

  def remove_at_index word, index
    word.slice!(index) and word
  end

  def sub_vowels word
    word.gsub(/[aeiou]/, "_")
  end
end


if __FILE__ == $0 && STDIN.tty?
  print   "enter filepath to dictionary [press enter to use /usr/share/dict/words]\n> "
  params  = gets.chomp.empty? ? {} : {file: gets.chomp}
  puts    "reticulating splines..."
  checker = Spellchecker.new params
  puts    "enter a word to correct, ^c to exit"
  begin
    print "> "
    puts checker.correct STDIN.gets.chomp
  end while checker
end

if !STDIN.tty?
  stdin = STDIN.gets.chomp
  STDERR.write "checking #{stdin}\n"
  checker = Spellchecker.new 
  STDOUT.write checker.correct(stdin) + "\n"
end

