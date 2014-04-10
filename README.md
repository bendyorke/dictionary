##Spellchecker CLI
To use the spellchecker cli, run `$ ruby spellchecker.rb`

##Spellchecker executable
To use the spellchecker executable, pipe in any input.  i.e. `$ echo husky | ruby spellchecker.rb`

##Misspeler executable
To generate a random misspelled word, run `$ ruby misspeler.rb`

To misspell a specific word,  run `$ echo husky | ruby misspeler.rb`

##Dictionary executable
The dictionary has two methods to run:

`$ ruby dictionary.rb --pluck` will pluck a random word from /usr/share/dict/words

`$ ruby dictionary.rb --benchmark` will run a series of benchmarks used to benchmark dictionary

##True executables
Give each file executable permissions and you can run them like executables. i.e. `$ ./misspeler.rb | ./spellchecker.rb`

##All together
`$ ./dictionary.rb --pluck | ./misspeler.rb | ./spellchecker.rb`
