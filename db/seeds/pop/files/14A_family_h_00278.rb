require 'csv'


puts ""
puts "#####  14A_families_h_00278.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/polisa_rod_h_00278.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_h_00278.log'), 'a+') do |f|
  f.puts "#####  14A_families_h_00278.rb  #####"
  f.puts "... load from db/seeds/pop/files/polisa_rod_h_00278.csv... start..."
end 

CSV.foreach("db/seeds/pop/files/polisa_rod_h_00278.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #family.create(row.to_hash)

  if FamilyHistory.where(     family_id:            id_with_offset( row[:id_polisa_rod], DB00278_OFFSET_POLISA_ROD ),
                              number:               row[:numer], 
                              proposal_number:      row[:numer_wniosku], 
                              concluded:            row[:data_zawarcia],
                              valid_from:           row[:data_ochrony_od],
                              applies_to:           row[:data_ochrony_do],
                              pay:                  row[:skladka],
                              protection_variant:   row[:wariant_ochrony],
                              assurance:            correct_decimal_separator(row[:ubezpieczenie]),
                              assurance_component:  correct_decimal_separator(row[:ubez_skl]),
                              family_lock:          false,
                              note:                 row[:uwagi],
                              company_id:           id_with_offset( row[:id_firma], DB00278_OFFSET_FIRMA ),
                              user_id:              DB00278_USER_ID ).any?  
    puts "Taki wpis już jest"
    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_h_00278.error'), 'a+') do |f|
      f.puts "DUPLIKAT - odrzucenie"
      f.puts "    id_polisa_rod: #{row[:id_polisa_rod]}"
      f.puts "            numer: #{row[:numer]}"
      f.puts "    numer_wniosku: #{row[:numer_wniosku]}"
      f.puts "    data_zawarcia: #{row[:data_zawarcia]}"
      f.puts "  data_ochrony_od: #{row[:data_ochrony_od]}"
      f.puts "  data_ochrony_do: #{row[:data_ochrony_do]}"
      f.puts "          skladka: #{row[:skladka]}"
      f.puts "  wariant_ochrony: #{row[:wariant_ochrony]}"
      f.puts "    ubezpieczenie: #{row[:ubezpieczenie]}"
      f.puts "         ubez_skl: #{row[:ubez_skl]}"
      f.puts "         id_firma: #{row[:id_firma]}"
      f.puts "            uwagi: #{row[:uwagi]}"
      f.puts "      change_date: #{row[:change_date]}"
      f.puts ""
    end 
  else 
    @family_h = FamilyHistory.create(   family_id:            id_with_offset( row[:id_polisa_rod], DB00278_OFFSET_POLISA_ROD ),
                                        number:               row[:numer], 
                                        proposal_number:      row[:numer_wniosku], 
                                        concluded:            row[:data_zawarcia],
                                        valid_from:           row[:data_ochrony_od],
                                        applies_to:           row[:data_ochrony_do],
                                        pay:                  row[:skladka],
                                        protection_variant:   row[:wariant_ochrony],
                                        assurance:            correct_decimal_separator(row[:ubezpieczenie]),
                                        assurance_component:  correct_decimal_separator(row[:ubez_skl]),
                                        family_lock:          false,
                                        note:                 row[:uwagi],
                                        company_id:           id_with_offset( row[:id_firma], DB00278_OFFSET_FIRMA ),
                                        user_id:              DB00278_USER_ID,
                                        created_at:           row[:change_date],
                                        updated_at:           row[:change_date] )

    if @family_h.valid?
      puts row[:id_polisa_rod]
    else
      # jeżeli jednak był błąd
      # wyswietl błąd na ekranie
      puts "ERROR(s)"
      puts "    id_polisa_rod: #{row[:id_polisa_rod]}"
      puts "            numer: #{row[:numer]}"
      @family_h.errors.full_messages.each do |msg|
        puts " - #{msg}"
      end     
      puts ""

      #zapisz błąd do pliku
      File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_h_00278.error'), 'a+') do |f|
        f.puts "ERROR(s)"
        f.puts "    id_polisa_rod: #{row[:id_polisa_rod]}"
        f.puts "            numer: #{row[:numer]}"
        @family_h.errors.full_messages.each do |msg|
          f.puts " - #{msg}"
        end     
        f.puts ""
      end 

    end # /family_h.valid?
  end # /FamilyHistory.where(....).eny?

end

puts "FamilyHistory all: #{FamilyHistory.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_h_00278.log'), 'a+') do |f|
  f.puts "FamilyHistory all: #{FamilyHistory.all.size}"
  f.puts "FamilyHistory all where user=DB00278_USER_ID: #{FamilyHistory.all.where(user_id: DB00278_USER_ID).size}"
  f.puts "#####  END ...load from 14A_families_h_00278.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = FamilyHistory.all.order(:id).last.id + 1
puts "FamilyHistory NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE family_histories_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_family = FamilyHistory.create(  family_id:                  nil, 
                                            number:               '000-000-000', 
                                            concluded:            '2001-01-01',
                                            valid_from:           '2001-01-01',
                                            applies_to:           '2001-12-31',
                                            pay:                  'R',
                                            family_lock:          true,
                                            note:                 'AAA-Uwagi',
                                            company_id:           nil,
                                            user_id:              1 )

@last_family.destroy

puts "#####  END OF 14A_families_h_00278.rb  #####"
puts ""

