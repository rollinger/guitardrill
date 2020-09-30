Guitar Drill Instructor 
Version 0.1
Copyright 2020 by Philipp Rollinger

Mail: philipp.rollinger [at] gmail.com

This program requires ruby 2.7.1 to run. To get the correct ruby interpreter go to https://www.ruby-lang.org/en/downloads/

This Program is very alpha... so bugs and ideas are welcome here: https://bitbucket.org/rollinger/guitardrill/issues?status=new&status=open

Currently two standalone scripts (in the standalone folder) assist you to train and improve your guitar skill:

1) solo_training.rb KEY MODE TYPE [ruby.exe solo_training.rb C major diatonic]
=> Assists you in training patterns in a scale at different tempi and voicings 
Commands:
"n" next_shape
"m" more_notes
"f" fewer_notes
"+" faster
"-" slower
"d" delete_shape
"s" saving_shape
"l" loading_shape
"i" drill_instructor
"1" shape_permutation
"2" shape_location
"q" exit program

2) chord_training.rb ROOT EXT [ruby.exe chord_training.rb E sus2]
=> Assists you in learning a particular chord and its variations in different tempi and voicings.
Commands:
"r" next_root
"n" next_variation
"e" enter_chord
"f" faster
"s" slower
"q" exit


Happy Playing
