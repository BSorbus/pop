require 'csv'


puts ""
puts "#####  03A_individuals_h_00718.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/osoba_h_00718.csv... start..." 

File.open(File.join("db/seeds/pop/files/log", 'osoba_h_00718.log'), 'a+') do |f|
  f.puts "#####  03A_individuals_h_00718.rb  #####"
  f.puts "... load from db/seeds/pop/files/osoba_h_00718.csv... start..."
end 

CSV.foreach("db/seeds/pop/files/osoba_h_00718.csv", { encoding: "WINDOWS-1250:UTF-8", 
                                    headers: true, 
                                    header_converters: :symbol, 
                                    col_sep: ';'}
            ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #individual.create(row.to_hash)

  if IndividualHistory.where( individual_id: id_with_offset( row[:id_osoba], DB00718_OFFSET_OSOBA ),
                              first_name:           row[:imie], 
                              last_name:            row[:nazwisko],
                              address_city:         row[:miejscowosc],
                              address_street:       row[:ulica],
                              address_house:        row[:nr_domu],
                              address_number:       row[:nr_lokalu],
                              address_postal_code:  row[:kod_pocztowy],
                              pesel:                row[:pesel],
                              birth_date:           row[:data_ur],
                              profession:           row[:zawod],
                              note:                 row[:uwagi],
                              user_id:              DB00718_USER_ID).any?

    puts "Taki wpis już jest"
    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'osoba_h_00718.error'), 'a+') do |f|
      f.puts "DUPLIKAT - odrzucenie"
      f.puts "         id_osoba: #{row[:id_osoba]}"
      f.puts "         nazwisko: #{row[:nazwisko]}"
      f.puts "             imie: #{row[:imie]}"
      f.puts "      miejscowosc: #{row[:miejscowosc]}"
      f.puts "            ulica: #{row[:ulica]}"
      f.puts "          nr_domu: #{row[:nr_domu]}"
      f.puts "        nr_lokalu: #{row[:nr_lokalu]}"
      f.puts "     kod_pocztowy: #{row[:kod_pocztowy]}"
      f.puts "            pesel: #{row[:pesel]}"
      f.puts "          data_ur: #{row[:data_ur]}"
      f.puts "            zawod: #{row[:zawod]}"
      f.puts "            uwagi: #{row[:uwagi]}"
      f.puts "      change_date: #{row[:change_date]}"
      f.puts ""
    end  
  else
    @individual_h = IndividualHistory.create( individual_id:        id_with_offset( row[:id_osoba], DB00718_OFFSET_OSOBA ),
                                              first_name:           row[:imie], 
                                              last_name:            row[:nazwisko],
                                              address_city:         row[:miejscowosc],
                                              address_street:       row[:ulica],
                                              address_house:        row[:nr_domu],
                                              address_number:       row[:nr_lokalu],
                                              address_postal_code:  row[:kod_pocztowy],
                                              pesel:                row[:pesel],
                                              birth_date:           row[:data_ur],
                                              profession:           row[:zawod],
                                              note:                 row[:uwagi],
                                              user_id:              DB00718_USER_ID,
                                              created_at:           row[:change_date],
                                              updated_at:           row[:change_date] )

    if @individual_h.valid?
      puts row[:id_osoba]
    else
      # jeżeli jednak był błąd
      # wyswietl błąd na ekranie
      puts "ERROR(s)"
      puts "         id_osoba: #{row[:id_osoba]}"
      puts "         nazwisko: #{row[:nazwisko]}"
      puts "             imie: #{row[:imie]}"
      puts "      miejscowosc: #{row[:miejscowosc]}"
      puts "            pesel: #{row[:pesel]}"
      @individual_h.errors.full_messages.each do |msg|
        puts " - #{msg}"
      end     
      puts ""

      #zapisz błąd do pliku
      File.open(File.join("db/seeds/pop/files/log", 'osoba_h_00718.error'), 'a+') do |f|
        f.puts "ERROR(s)"
        f.puts "         id_osoba: #{row[:id_osoba]}"
        f.puts "         nazwisko: #{row[:nazwisko]}"
        f.puts "             imie: #{row[:imie]}"
        f.puts "      miejscowosc: #{row[:miejscowosc]}"
        f.puts "            pesel: #{row[:pesel]}"
        @individual_h.errors.full_messages.each do |msg|
          f.puts " - #{msg}"
        end     
        f.puts ""
      end 

    end # /@individual_h.valid?
  end # /IndividualHistory.where(....).eny?

end

puts "IndividualHistory all: #{IndividualHistory.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'osoba_h_00718.log'), 'a+') do |f|
  f.puts "IndividualHistory all: #{IndividualHistory.all.size}"
  f.puts "IndividualHistory all where user=DB00718_USER_ID: #{IndividualHistory.all.where(user_id: DB00718_USER_ID).size}"
  f.puts "#####  END ...load from 03A_individuals_h_00718.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = IndividualHistory.all.order(:id).last.id + 1
puts "Individual NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE individual_histories_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_individual_h = IndividualHistory.create(  individual_id:        nil, 
                                                first_name:           'AAA-Imie', 
                                                last_name:            'AAA-Nazwisko',
                                                address_city:         'AAA-Miejscowosc',
                                                address_street:       'AAA-Ulica',
                                                address_house:        'AAA-Dom',
                                                address_number:       'AAA-Numer',
                                                address_postal_code:  '00-000',
                                                pesel:                nil,
                                                birth_date:           nil,
                                                profession:           'AAA-Tester',
                                                note:                 'AAA-Uwagi',
                                                user_id:              1 )

@last_individual_h.destroy

puts "#####  END OF 03A_individuals_h_00718.rb  #####"
puts ""
