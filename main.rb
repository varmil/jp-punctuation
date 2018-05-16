require "./zch_sentence"

f = File.open("raw_text/002.txt")
s = f.read
f.close

# p s

puts ZchSentence.emend(s)
