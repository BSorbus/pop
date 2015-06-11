require 'csv'

def family_created_at_first_rec(seek_id)
  FamilyHistory.where(family_id: seek_id).order(:created_at).first.created_at
end


puts ""
puts "#####  14B_families_00278.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/polisa_rod_00278.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_00278.log'), 'a+') do |f|
  f.puts "#####  14B_families_00278.rb  #####"
  f.puts "... load from db/seeds/pop/files/polisa_rod_00278.csv... start..."
end 

CSV.foreach("db/seeds/pop/files/polisa_rod_00278.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #family.create(row.to_hash)

  @family = Family.create(        id:                   id_with_offset( row[:id_polisa_rod], DB00278_OFFSET_POLISA_ROD ),
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
                                  created_at:           family_created_at_first_rec(id_with_offset(row[:id_polisa_rod], DB00278_OFFSET_POLISA_ROD)),
                                  updated_at:           row[:change_date] )

  if @family.valid?
    puts row[:id_polisa_rod]
  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "        id_polisa_rod: #{row[:id_polisa_rod]}"
    puts "            numer: #{row[:numer]}"
    @family.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_00278.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "        id_polisa_rod: #{row[:id_polisa_rod]}"
      f.puts "            numer: #{row[:numer]}"
      @family.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "families all: #{Family.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_00278.log'), 'a+') do |f|
  f.puts "Familys all: #{Family.all.size}"
  f.puts "Familys all where user=DB00278_USER_ID: #{Family.all.where(user: DB00278_USER_ID).size}"
  f.puts "#####  END ...load from 14B_families_00278.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = Family.all.order(:id).last.id + 1
puts "Family NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE families_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_family = Family.create(       number:               '000-000-000', 
                                    concluded:            '2001-01-01',
                                    valid_from:           '2001-01-01',
                                    applies_to:           '2001-12-31',
                                    pay:                  'R',
                                    protection_variant:   'A11',
                                    assurance:            10.0,
                                    assurance_component:  1.0,
                                    family_lock:          false,
                                    note:                 'AAA-Uwagi',
                                    company_id:           Company.all.order(:id).last.id,
                                    user_id:              1 )

@last_family.destroy

puts "#####  END OF 14B_families_00278.rb  #####"
puts ""

