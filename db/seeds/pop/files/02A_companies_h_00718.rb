require 'csv'


puts ""
puts "#####  02A_companies_h_00718.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/firma_h_00718.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'firma_h_00718.log'), 'a+') do |f|
  f.puts "#####  02A_companies_h_00718.rb  #####"
  f.puts "... load from db/seeds/pop/files/firma_h_00718.csv... start..."
end 

CSV.foreach("db/seeds/pop/files/firma_h_00718.csv", { encoding: "WINDOWS-1250:UTF-8", 
                                    headers: true, 
                                    header_converters: :symbol, 
                                    col_sep: ';'}
            ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #Company.create(row.to_hash)

  if CompanyHistory.where(company_id: id_with_offset(row[:id_firma], DB00718_OFFSET_FIRMA),
                          short:                row[:skrot],
                          name:                 row[:nazwa],
                          address_city:         row[:miejscowosc],
                          address_street:       row[:ulica],
                          address_house:        row[:nr_domu],
                          address_number:       row[:nr_lokalu],
                          address_postal_code:  row[:kod_pocztowy],
                          phone:                row[:telefon_fax],
                          email:                row[:e_mail],
                          nip:                  row[:nip],
                          regon:                row[:regon],
                          pesel:                row[:pesel],
                          informal_group:       row[:gr_nieformalna],
                          note:                 row[:uwagi],
                          user_id:              DB00718_USER_ID ).any?  
    puts "Taki wpis już jest"
    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'firma_h_00718.error'), 'a+') do |f|
      f.puts "DUPLIKAT - odrzucenie"
      f.puts "         id_firma: #{row[:id_firma]}"
      f.puts "            skrot: #{row[:skrot]}"
      f.puts "            nazwa: #{row[:nazwa]}"
      f.puts "      miejscowosc: #{row[:miejscowosc]}"
      f.puts "            ulica: #{row[:ulica]}"
      f.puts "          nr_domu: #{row[:nr_domu]}"
      f.puts "        nr_lokalu: #{row[:nr_lokalu]}"
      f.puts "     kod_pocztowy: #{row[:kod_pocztowy]}"
      f.puts "      telefon_fax: #{row[:telefon_fax]}"
      f.puts "           e_mail: #{row[:e_mail]}"
      f.puts "              nip: #{row[:nip]}"
      f.puts "            regon: #{row[:regon]}"
      f.puts "            pesel: #{row[:pesel]}"
      f.puts "   gr_nieformalna: #{row[:gr_nieformalna]}"
      f.puts "            uwagi: #{row[:uwagi]}"
      f.puts "      change_date: #{row[:change_date]}"
      f.puts ""
    end 
  else 
    @company_h = CompanyHistory.create( company_id:           id_with_offset( row[:id_firma], DB00718_OFFSET_FIRMA ), 
                                        short:                row[:skrot], 
                                        name:                 row[:nazwa],
                                        address_city:         row[:miejscowosc],
                                        address_street:       row[:ulica],
                                        address_house:        row[:nr_domu],
                                        address_number:       row[:nr_lokalu],
                                        address_postal_code:  row[:kod_pocztowy],
                                        phone:                row[:telefon_fax],
                                        email:                row[:e_mail],
                                        nip:                  row[:nip],
                                        regon:                row[:regon],
                                        pesel:                row[:pesel],
                                        informal_group:       row[:gr_nieformalna],
                                        note:                 row[:uwagi],
                                        user_id:              DB00718_USER_ID,
                                        created_at:           row[:change_date],
                                        updated_at:           row[:change_date] )

    if @company_h.valid?
      # Jezeli OK, to wyświetl ID na ekranie
      puts row[:id_firma]
    else
      # jeżeli jednak był błąd
      # wyswietl błąd na ekranie
      puts "ERROR(s)"
      puts "         id_firma: #{row[:id_firma]}"
      puts "            skrot: #{row[:skrot]}"
      puts "            nazwa: #{row[:nazwa]}"
      puts "      miejscowosc: #{row[:miejscowosc]}"
      puts "              nip: #{row[:nip]}"
      puts "            regon: #{row[:regon]}"
      puts "            pesel: #{row[:pesel]}"
      @company_h.errors.full_messages.each do |msg|
        puts " - #{msg}"
      end     
      puts ""

      #zapisz błąd do pliku
      File.open(File.join("db/seeds/pop/files/log", 'firma_h_00718.error'), 'a+') do |f|
        f.puts "ERROR(s)"
        f.puts "         id_firma: #{row[:id_firma]}"
        f.puts "            skrot: #{row[:skrot]}"
        f.puts "            nazwa: #{row[:nazwa]}"
        f.puts "      miejscowosc: #{row[:miejscowosc]}"
        f.puts "              nip: #{row[:nip]}"
        f.puts "            regon: #{row[:regon]}"
        f.puts "            pesel: #{row[:pesel]}"
        @company_h.errors.full_messages.each do |msg|
          f.puts " - #{msg}"
        end     
        f.puts ""
      end 

    end # /@company_h.valid?
  end # /CompanyHistory.where(....).eny?

end

puts "CompanyHistory all: #{CompanyHistory.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'firma_h_00718.log'), 'a+') do |f|
  f.puts "CompanyHistory all: #{CompanyHistory.all.size}"
  f.puts "CompanyHistory all where user=DB00718_USER_ID: #{CompanyHistory.all.where(user_id: DB00718_USER_ID).size}"
  f.puts "#####  END ...load from 02A_companies_00718.rb  #####"
end 
############################################################################################





############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = CompanyHistory.all.order(:id).last.id + 1
puts "CompanyHistory NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE company_histories_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_company_h = CompanyHistory.create(  company_id:           nil,    
                                          short:                'AAA-TEST', 
                                          name:                 'AAA-Test nazwa',
                                          address_city:         'AAA-Miejscowosc',
                                          address_street:       'AAA-Ulica',
                                          address_house:        'AAA-Dom',
                                          address_number:       'AAA-Numer',
                                          address_postal_code:  '00-000',
                                          phone:                'AAA-601-602-603',
                                          email:                'artex.soft@gmail.com',
                                          nip:                  nil,
                                          regon:                nil,
                                          pesel:                nil,
                                          informal_group:       false,
                                          note:                 'AAA-Uwagi',
                                          user_id:              1 )

@last_company_h.destroy

puts "#####  END OF 02A_companies_h_00718.rb  #####"
puts ""
