require 'csv'

def insurance_created_at_first_rec(seek_id)
  InsuranceHistory.where(insurance_id: seek_id).order(:created_at).first.created_at
end


puts ""
puts "#####  04B_insurances_18270.rb  #####"

############################################################################################
puts "... load from db/seeds/polisa_18270.csv... start..."

File.open(File.join("db/seeds/log", 'polisa_18270.log'), 'a+') do |f|
  f.puts "#####  04B_insurances_18270.rb  #####"
  f.puts "... load from db/seeds/polisa_18270.csv... start..."
end 

CSV.foreach("db/seeds/polisa_18270.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #insurance.create(row.to_hash)

  @insurance = Insurance.create(  id:                   id_with_offset( row[:id_polisa], DB18270_OFFSET_POLISA ),
                                  number:               row[:numer], 
                                  concluded:            row[:data_zawarcia],
                                  valid_from:           row[:data_zawarcia_od],
                                  applies_to:           row[:data_zawarcia_do],
                                  pay:                  row[:skladka],
                                  discounts_lock:       row[:blokada_zwyz_zniz],
                                  note:                 row[:uwagi],
                                  company_id:           id_with_offset( row[:id_firma], DB18270_OFFSET_FIRMA ),
                                  user_id:              DB18270_USER_ID,
                                  created_at:           insurance_created_at_first_rec(id_with_offset(row[:id_polisa], DB18270_OFFSET_POLISA)),
                                  updated_at:           row[:change_date] )

  if @insurance.valid?
    puts row[:id_polisa]
  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "        id_polisa: #{row[:id_polisa]}"
    puts "            numer: #{row[:numer]}"
    @insurance.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/log", 'polisa_18270.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "        id_polisa: #{row[:id_polisa]}"
      f.puts "            numer: #{row[:numer]}"
      @insurance.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "insurances all: #{Insurance.all.size}"

File.open(File.join("db/seeds/log", 'polisa_18270.log'), 'a+') do |f|
  f.puts "Insurances all: #{Insurance.all.size}"
  f.puts "Insurances all where user=DB18270_USER_ID: #{Insurance.all.where(user: DB18270_USER_ID).size}"
  f.puts "#####  END ...load from 04B_insurances_18270.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = Insurance.all.order(:id).last.id + 1
puts "Insurance NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE insurances_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_insurance = Insurance.create( number:               '000-000-000', 
                                    concluded:            '2001-01-01',
                                    valid_from:           '2001-01-01',
                                    applies_to:           '2001-12-31',
                                    pay:                  'R',
                                    discounts_lock:       true,
                                    note:                 'AAA-Uwagi',
                                    company_id:           Company.all.order(:id).last.id,
                                    user_id:              1 )

@last_insurance.destroy

puts "#####  END OF 04B_insurances_18270.rb  #####"
puts ""

