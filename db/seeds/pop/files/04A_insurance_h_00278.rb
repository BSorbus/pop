require 'csv'


puts ""
puts "#####  04A_insurances_h_00278.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/polisa_h_00278.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'polisa_h_00278.log'), 'a+') do |f|
  f.puts "#####  04A_insurances_h_00278.rb  #####"
  f.puts "... load from db/seeds/pop/files/polisa_h_00278.csv... start..."
end 

CSV.foreach("db/seeds/pop/files/polisa_h_00278.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #insurance.create(row.to_hash)

  if InsuranceHistory.where(  insurance_id: id_with_offset( row[:id_polisa], DB00278_OFFSET_POLISA ),
                              number:               row[:numer], 
                              concluded:            row[:data_zawarcia],
                              valid_from:           row[:data_zawarcia_od],
                              applies_to:           row[:data_zawarcia_do],
                              pay:                  row[:skladka],
                              insurance_lock:       row[:blokada_zwyz_zniz],
                              note:                 row[:uwagi],
                              company_id:           id_with_offset( row[:id_firma], DB00278_OFFSET_FIRMA ),
                              user_id:              DB00278_USER_ID ).any?  
    puts "Taki wpis już jest"
    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'polisa_h_00278.error'), 'a+') do |f|
      f.puts "DUPLIKAT - odrzucenie"
      f.puts "        id_polisa: #{row[:id_polisa]}"
      f.puts "            numer: #{row[:numer]}"
      f.puts "    data_zawarcia: #{row[:data_zawarcia]}"
      f.puts " data_zawarcia_od: #{row[:data_zawarcia_od]}"
      f.puts " data_zawarcia_do: #{row[:data_zawarcia_do]}"
      f.puts "          skladka: #{row[:skladka]}"
      f.puts "blokada_zwyz_zniz: #{row[:blokada_zwyz_zniz]}"
      f.puts "         id_firma: #{row[:id_firma]}"
      f.puts "            uwagi: #{row[:uwagi]}"
      f.puts "      change_date: #{row[:change_date]}"
      f.puts ""
    end 
  else 
    @insurance_h = InsuranceHistory.create( insurance_id:         id_with_offset( row[:id_polisa], DB00278_OFFSET_POLISA ),
                                            number:               row[:numer], 
                                            concluded:            row[:data_zawarcia],
                                            valid_from:           row[:data_zawarcia_od],
                                            applies_to:           row[:data_zawarcia_do],
                                            pay:                  row[:skladka],
                                            insurance_lock:       row[:blokada_zwyz_zniz],
                                            note:                 row[:uwagi],
                                            company_id:           id_with_offset( row[:id_firma], DB00278_OFFSET_FIRMA ),
                                            user_id:              DB00278_USER_ID,
                                            created_at:           row[:change_date],
                                            updated_at:           row[:change_date] )

    if @insurance_h.valid?
      puts row[:id_polisa]
    else
      # jeżeli jednak był błąd
      # wyswietl błąd na ekranie
      puts "ERROR(s)"
      puts "        id_polisa: #{row[:id_polisa]}"
      puts "            numer: #{row[:numer]}"
      @insurance_h.errors.full_messages.each do |msg|
        puts " - #{msg}"
      end     
      puts ""

      #zapisz błąd do pliku
      File.open(File.join("db/seeds/pop/files/log", 'polisa_h_00278.error'), 'a+') do |f|
        f.puts "ERROR(s)"
        f.puts "        id_polisa: #{row[:id_polisa]}"
        f.puts "            numer: #{row[:numer]}"
        @insurance_h.errors.full_messages.each do |msg|
          f.puts " - #{msg}"
        end     
        f.puts ""
      end 

    end # /insurance_h.valid?
  end # /InsuranceHistory.where(....).eny?

end

puts "InsuranceHistory all: #{InsuranceHistory.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'polisa_h_00278.log'), 'a+') do |f|
  f.puts "InsuranceHistory all: #{InsuranceHistory.all.size}"
  f.puts "InsuranceHistory all where user=DB00278_USER_ID: #{InsuranceHistory.all.where(user_id: DB00278_USER_ID).size}"
  f.puts "#####  END ...load from 04A_insurances_h_00278.rb  #####"
end 
############################################################################################






#    ############################################################################################
#    #pobierz najwiekszy ID i zwiększ go o 1
#    next_id = InsuranceHistory.all.order(:id).last.id + 1
#    puts "InsuranceHistory NEXT_ID: #{next_id}"
#    #ustaw generator sekwencji na odpowiednia wartosc
#    connection = ActiveRecord::Base.connection()
#    connection.execute( "ALTER SEQUENCE insurance_histories_id_seq RESTART WITH #{next_id} ;" )
#    #wstaw do bazy testowy rekord
#    @last_insurance = InsuranceHistory.create(  insurance_id:         nil, 
#                                                number:               '000-000-000', 
#                                                concluded:            '2001-01-01',
#                                                valid_from:           '2001-01-01',
#                                                applies_to:           '2001-12-31',
#                                                pay:                  'R',
#                                                insurance_lock:       true,
#                                                note:                 'AAA-Uwagi',
#                                                company_id:           nil,
#                                                user_id:              1 )
#
#    @last_insurance.destroy

    puts "#####  END OF 04A_insurances_h_00278.rb  #####"
    puts ""

