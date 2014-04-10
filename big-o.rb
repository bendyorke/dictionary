require_relative 'spellchecker.rb'
require 'benchmark'

$dict      = './words'
$length    = 16
$interval  = 500000
$steps     = 20
$checker   = nil

def random length
  (0...$length).map { (65 + rand(26)).chr }.join
end

def increase_dict 
  print "+"
  ($interval/1000).times do |i|
    print "-" if i % ($interval/50000) == 0
    addition = (0..1000).map { random $length }.join('\n')
    %x{echo #{addition} >> #{$dict}}
  end
  print "+\n"
end

%x{rm #{$dict}}
Benchmark.bm do |x|
  $steps.times do |i|
    increase_dict
    puts "@#{(i+1)*$interval} words in dict"
    x.report("build") { $checker = Spellchecker.new file: $dict }
    x.report("search") { $checker.correct("OwnLocal") }
  end
end

