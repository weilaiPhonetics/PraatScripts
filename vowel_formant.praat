#This praat script is modifed based on an old script written by Professor Joey Stanley.
#This praat script extracts the info of vowel formants for all the audios in the current folder that has a TextGrid sharing its name.
#The TextGrid should have two layers, with the first layer annotating word and the second layer annotating vowel. You may adjust your TextGrid accordingly before running the script if your textgrids do not conform to this format. 
#Feel free to reach out to the author of this praat script: weilai.phonetics@gmail.com.

Create Strings as file list: "gridlist", "./*.TextGrid"

select Strings gridlist
n = Get number of strings

for i from 1 to n
  select Strings gridlist
  grid$ = Get string: i
  name$ = grid$- ".TextGrid" 
  wav$ =  name$ + ".wav"
  Read from file: "./'grid$'"
  Read from file: "./'wav$'"

  selectObject: "TextGrid 'name$'"
  numberOfPhonemes = Get number of intervals: 2
  appendInfoLine: "for 'name$':"
  appendInfoLine: "There are ", numberOfPhonemes, " vowels."
  numberOfWords = Get number of intervals: 1  
  appendInfoLine: "There are ", numberOfWords, " words."

  selectObject: "Sound 'name$'"
  To Formant (burg)... 0 5 5000 0.025 50 

  # Create the output file and write the first line.
  outputPath$ = "formants_'name$'.csv"
  writeFileLine: "'outputPath$'", "file,time,word,vowel,duration,F1,F2,F3"

  # Loop through each interval on the phoneme tier.
    for thisInterval from 1 to numberOfPhonemes
      #appendInfoLine: thisInterval

      # Get the label of the interval
      select TextGrid 'name$'
      thisPhoneme$ = Get label of interval: 2, thisInterval
      #appendInfoLine: thisPhoneme$
      
      # Find the midpoint.
      thisPhonemeStartTime = Get start point: 2, thisInterval
      thisPhonemeEndTime   = Get end point:   2, thisInterval
      duration = thisPhonemeEndTime - thisPhonemeStartTime
      midpoint = thisPhonemeStartTime + duration/2
    
      # Get the word interval and then the label
      thisWordInterval = Get interval at time: 1, midpoint
      thisWord$ = Get label of interval: 1, thisWordInterval
      
      # Extract formant measurements
      select Formant 'name$'
      f1 = Get value at time... 1 midpoint Hertz Linear
      f2 = Get value at time... 2 midpoint Hertz Linear
      f3 = Get value at time... 3 midpoint Hertz Linear

    # Save to a spreadsheet
    appendFileLine: "'outputPath$'", 
                      ...name$, ",",
                      ...midpoint, ",",
                      ...thisWord$, ",",
                      ...thisPhoneme$, ",",
                      ...duration, ",",
                      ...f1, ",", 
                      ...f2, ",", 
                      ...f3

	endfor
endfor

appendInfoLine: "Completed! You may close this window now."