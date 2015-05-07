require 'csv'


puts ""
puts "#####  05_group_00718.rb  #####"

############################################################################################
puts "... load from db/seeds/polisa_grupa_00718.csv... start..."

File.open(File.join("db/seeds/log", 'polisa_grupa_00718.log'), 'a+') do |f|
  f.puts "#####  05_group_00718.rb  #####"
  f.puts "... load from db/seeds/polisa_grupa_00718.csv... start..."
  f.puts "Groups all: #{Group.all.size}"
end 

CSV.foreach("db/seeds/polisa_grupa_00718.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #group.create(row.to_hash)

  @group = Group.create(          id:                   id_with_offset( row[:id_polisa_grupa], DB00718_OFFSET_POLISA_GRUPA ), 
                                  number:               row[:nr_grupy],
                                  quotation:            row[:kwotacja],
                                  tariff_fixed:         row[:taryfikacja_stala],
                                  full_range:           row[:zakres_pelny],
                                  risk_group:           row[:grupa_ryzyka],
                                  assurance:            correct_decimal_separator(row[:ubezpieczenie]),
                                  assurance_component:  correct_decimal_separator(row[:ubez_skl]),
                                  treatment:            correct_decimal_separator(row[:leczenie]),
                                  treatment_component:  correct_decimal_separator(row[:lecz_skl]),
                                  ambulatory:           correct_decimal_separator(row[:ambulatorium]),
                                  ambulatory_component: correct_decimal_separator(row[:ambu_skl]),
                                  hospital:             correct_decimal_separator(row[:szpital]),
                                  hospital_component:   correct_decimal_separator(row[:szpi_skl]),
                                  infarct:              correct_decimal_separator(row[:zawal]),
                                  infarct_component:    correct_decimal_separator(row[:zawa_skl]),
                                  inability:            correct_decimal_separator(row[:niezdolnosc]),
                                  inability_component:  correct_decimal_separator(row[:niez_skl]),
                                  death_100_percent:    row[:smierc_100],
                                  sum_component:        correct_decimal_separator(row[:suma_skl]),
                                  sum_after_discounts:  correct_decimal_separator(row[:suma_after_znizki]),
                                  sum_after_increases:  correct_decimal_separator(row[:suma_after_zwyzki]),
                                  sum_after_monthly:    correct_decimal_separator(row[:suma_after_zwyzki_m]),
                                  insurance_id:         id_with_offset( row[:polisa], DB00718_OFFSET_POLISA ))

  if @group.valid?
    puts row[:id_polisa_grupa]
  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "      id_polisa_grupa: #{row[:id_polisa_grupa]}"
    puts "               polisa: #{row[:polisa]}"
    @group.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/log", 'polisa_grupa_00718.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "      id_polisa_grupa: #{row[:id_polisa_grupa]}"
      f.puts "               polisa: #{row[:polisa]}"
      @group.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "groups all: #{Group.all.size}"

File.open(File.join("db/seeds/log", 'polisa_grupa_00718.log'), 'a+') do |f|
  f.puts "Groups all: #{Group.all.size}"
  f.puts "#####  END ...load from 05_group_00718.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = Group.all.order(:id).last.id + 1
puts "Groups NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE groups_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_group = Group.create(
                                  number:               1111,
                                  quotation:            'A',
                                  tariff_fixed:         false,
                                  full_range:           true,
                                  risk_group:           'A',
                                  assurance:            0.0,
                                  assurance_component:  0.0,
                                  treatment:            0.0,
                                  treatment_component:  0.0,
                                  ambulatory:           0.0,
                                  ambulatory_component: 0.0,
                                  hospital:             0.0,
                                  hospital_component:   0.0,
                                  infarct:              0.0,
                                  infarct_component:    0.0,
                                  inability:            0.0,
                                  inability_component:  0.0,
                                  death_100_percent:    false,
                                  sum_component:        0.0,
                                  sum_after_discounts:  0.0,
                                  sum_after_increases:  0.0,
                                  sum_after_monthly:    0.0,
                                  insurance_id:         Insurance.all.order(:id).last.id)

@last_group.destroy

puts "#####  END OF 05_group_00718.rb  #####"
puts ""

