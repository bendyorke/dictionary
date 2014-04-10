#!/usr/bin/env ruby
module Dictionary
  def self.build_from filepath, &modifier
    File.open(filepath).each_line.inject({}) do |h,line|
      val = line[0..-2].downcase
      key = block_given? ? modifier.call(val) : val.to_sym
      h[key] = val and h
    end
  end

  def self.pluck_from filepath
    filesize = %x{wc -l '#{filepath}'}.to_i
    File.open(filepath) do |f| 
      rand(filesize).times {f.gets}
    end
    $_
  end

  def self.pluck
    Dictionary.pluck_from '/usr/share/dict/words'
  end
end

if ARGV.include? '--pluck'
  STDOUT.write Dictionary.pluck + "\n"
end

if ARGV.include? '--benchmark'
  require 'benchmark'
  n = 100
  f = '/usr/share/dict/words'

  puts "loading file"
  Benchmark.bm do |x|
    x.report('readlines') { (n/10).times { File.open(f).each_line.inject({}) { |m,l| m[l[0..-2]]=l and m } } }
    x.report('each_line') { (n/10).times { File.readlines(f).inject({}) { |m,l| m[l[0..-2]]=l and m } } }
  end

  puts "reading filesize"
  Benchmark.bm do |x|
    x.report("open") { n.times { File.open(f).readlines.size } }
    x.report("read") { n.times { File.open(f) { |f| f.read.count("\n") }; $_ } }
    x.report("scan") { n.times { File.read(f).scan(/\n/).count } }
    x.report("memo") { n.times { File.foreach(f).inject(0) {|m,l| m+1} } }
    x.report("perl") { n.times { File.foreach(f) {}; $. } }
    x.report("wc-l") { n.times { %x{wc -l '#{f}'}.to_i } }
  end

  puts "sampling files"
  Benchmark.bm do |x|
    x.report("gets")  { n.times { File.open(f) {|f| rand(100).times {f.gets}}; $_  } }
    x.report("splat") { n.times { [*File.open(f)][rand(100)] } }
  end

  puts "combination"
  Benchmark.bm do |x|
    x.report("open") { n.times do
      File.open(f) { |_f| rand(_f.read.count("\n")).times {_f.gets} }
    end }
    x.report("unix") { n.times do
      File.open(f) { |_f| rand(%x{wc -l '#{f}'}.to_i).times {_f.gets} }
    end }
  end
end
