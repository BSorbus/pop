require 'csv'

def individual_created_at_first_rec(seek_id)
  IndividualHistory.where(individual_id: seek_id).order(:created_at).first.created_at
end


puts ""
puts "#####  03B_individuals_00278.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/osoba_00278.csv... start..." 

File.open(File.join("db/seeds/pop/files/log", 'osoba_00278.log'), 'a+') do |f|
  f.puts "#####  03B_individuals_00278.rb  #####"
  f.puts "... load from db/seeds/pop/files/osoba_00278.csv... start..."
end 

CSV.foreach("db/seeds/pop/files/osoba_00278.csv", { encoding: "WINDOWS-1250:UTF-8", 
                                    headers: true, 
                                    header_converters: :symbol, 
                                    col_sep: ';'}
            ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #individual.create(row.to_hash)

  @individual = Individual.create(id:                   id_with_offset( row[:id_osoba], DB00278_OFFSET_OSOBA ),
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
                                  user_id:              DB00278_USER_ID,
                                  created_at:           individual_created_at_first_rec( id_with_offset( row[:id_osoba], DB00278_OFFSET_OSOBA ) ),
                                  updated_at:           row[:change_date] )

  if @individual.valid?
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
    @individual.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'osoba_00278.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "         id_osoba: #{row[:id_osoba]}"
      f.puts "         nazwisko: #{row[:nazwisko]}"
      f.puts "             imie: #{row[:imie]}"
      f.puts "      miejscowosc: #{row[:miejscowosc]}"
      f.puts "            pesel: #{row[:pesel]}"
      @individual.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "Individuals all: #{Individual.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'osoba_00278.log'), 'a+') do |f|
  f.puts "Individuals all: #{Individual.all.size}"
  f.puts "Individuals all where user=DB00278_USER_ID: #{Individual.all.where(user: DB00278_USER_ID).size}"
  f.puts "#####  END ...load from 03B_individuals_00278.rb  #####"
end 
############################################################################################






#    ############################################################################################
#    #pobierz najwiekszy ID i zwiększ go o 1
#    next_id = Individual.all.order(:id).last.id + 1
#    puts "Individual NEXT_ID: #{next_id}"
#    #ustaw generator sekwencji na odpowiednia wartosc
#    connection = ActiveRecord::Base.connection()
#    connection.execute( "ALTER SEQUENCE individuals_id_seq RESTART WITH #{next_id} ;" )
#    #wstaw do bazy testowy rekord
#    @last_individual = Individual.create( first_name:           'AAA-Imie', 
#                                          last_name:            'AAA-Nazwisko',
#                                          address_city:         'AAA-Miejscowosc',
#                                          address_street:       'AAA-Ulica',
#                                          address_house:        'AAA-Dom',
#                                          address_number:       'AAA-Numer',
#                                          address_postal_code:  '00-000',
#                                          pesel:                nil,
#                                          birth_date:           nil,
#                                          profession:           'AAA-Tester',
#                                          note:                 'AAA-Uwagi',
#                                          user_id:              1 )
#
#    @last_individual.destroy

    puts "#####  END OF 03B_individuals_00278.rb  #####"
    puts ""
