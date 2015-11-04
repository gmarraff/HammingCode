load 'HammingCode.rb'

hc = HammingCode.new('not_valid')
while hc.check != HammingCode::WORD_VALID do
  print 'Inserisci la parola: '
  hc = HammingCode.new(gets.chomp.reverse)
  puts 'Parola non valida' if hc.check == HammingCode::WORD_NOT_VALID
  puts 'La lunghezza della parola deve essere un multiplo di due' if hc.check == HammingCode::WORD_NOT_MULTIPLE
end
hc.work!
puts 'Codice SEC: ' + hc.get_sec
puts 'Parola completa: ' + hc.get_full_word