require_relative 'assert.rb'
require_relative 'spellchecker.rb'

checker = Spellchecker.new

assert "returns NO SUGGESTIONS when word is not found" do
  checker.correct("#SELFIE") == "NO SUGGESTIONS"
end

assert "ignores case" do
  checker.correct("ARTisAN") == "artisan"
end

assert "ignores duplicates" do
  checker.correct("arrrttttisan") == "artisan"
end

assert "ignores infinite duplicates" do
  print "(this on may take a while)"
  checker.correct("aaaaaarrrrrrttttttiiiiiissssssaaaaaannnnnn") == "artisan"
end

assert "ignores vowel transposition" do
  checker.correct("ortoson") == "artisan"
end

assert "can handle all three" do
  checker.correct("ORTissssannn") == "artisan"
end

assert "can handle duplicatations of vowel transposition" do
  checker.correct("Artiosan") == "artisan"
end

