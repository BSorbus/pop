require 'csv'


puts ""
puts "#####  17A_family_rotation_h_00278.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/polisa_rod_rotacja_h_00278.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_rotacja_h_00278.log'), 'a+') do |f|
  f.puts "#####  17A_family_rotation_h_00278.rb  #####"
  f.puts "... load from db/seeds/pop/files/polisa_rod_rotacja_h_00278.csv... start..."
  f.puts "FamilyRotationHistory all: #{FamilyRotationHistory.all.size}"
end 

CSV.foreach("db/seeds/pop/files/polisa_rod_rotacja_h_00278.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #rotation.create(row.to_hash)

  if false
  #   FamilyRotationHistory.where( family_rotation_id:  id_with_offset( row[:id_polisa_rod_rotacja], DB00278_OFFSET_POLISA_ROD_ROTACJA ), 
  #                          rotation_date:        row[:data_rotacji],
  #                          rotation_lock:        row[:blokada],
  #                          date_file_send:       nil,
  #                          note:                 row[:uwagi],
  #                          insurance_id:         id_with_offset( row[:polisa], DB00278_OFFSET_POLISA_ROD ) ).any?
  #  puts "Taki wpis już jest"
  #  #zapisz błąd do pliku
  #  File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_rotacja_h_00278.error'), 'a+') do |f|
  #    f.puts "DUPLIKAT - odrzucenie"
  #    f.puts "id_polisa_rod_rotacja: #{row[:id_polisa_rod_rotacja]}"
  #    f.puts "     data_rotacji: #{row[:data_rotacji]}"
  #    f.puts "          blokada: #{row[:blokada]}"
  #    f.puts "           polisa: #{row[:polisa]}"
  #    f.puts "            uwagi: #{row[:uwagi]}"
  #    f.puts "      change_date: #{row[:change_date]}"
  #    f.puts ""
  #  end 
  else 
    @family_rotation_h = FamilyRotationHistory.create( family_rotation_id:  id_with_offset( row[:id_polisa_rod_rotacja], DB00278_OFFSET_POLISA_ROD_ROTACJA ), 
                                          rotation_date:        row[:data_rotacji],
                                          rotation_lock:        row[:blokada],
                                          date_file_send:       nil,
                                          note:                 row[:uwagi],
                                          family_id:            id_with_offset( row[:polisa_rod], DB00278_OFFSET_POLISA_ROD ),
                                          created_at:           row[:change_date],
                                          updated_at:           row[:change_date] )

    if @family_rotation_h.valid?
      puts row[:id_polisa_rod_rotacja]
    else
      # jeżeli jednak był błąd
      # wyswietl błąd na ekranie
      puts "ERROR(s)"
      puts "    id_polisa_rod_rotacja: #{row[:id_polisa_rod_rotacja]}"
      puts "               polisa_rod: #{row[:polisa_rod]}"
      @family_rotation_h.errors.full_messages.each do |msg|
        puts " - #{msg}"
      end     
      puts ""

      #zapisz błąd do pliku
      File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_rotacja_h_00278.error'), 'a+') do |f|
        f.puts "ERROR(s)"
        f.puts "    id_polisa_rod_rotacja: #{row[:id_polisa_rod_rotacja]}"
        f.puts "               polisa_rod: #{row[:polisa_rod]}"
        @family_rotation_h.errors.full_messages.each do |msg|
          f.puts " - #{msg}"
        end     
        f.puts ""
      end 

    end # /rotation_h.valid?
  end # /FamilyRotationHistory.where(....).eny?

end

puts "FamilyRotationHistory all: #{FamilyRotationHistory.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_rotacja_h_00278.log'), 'a+') do |f|
  f.puts "FamilyRotationHistory all: #{FamilyRotationHistory.all.size}"
  f.puts "#####  END ...load from 17A_family_rotation_h_00278.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = FamilyRotationHistory.all.order(:id).last.id + 1
puts "FamilyRotationHistory NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE family_rotation_histories_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_rotation = FamilyRotationHistory.create(  family_rotation_id:         nil, 
                                          rotation_date:        Time.now, 
                                          rotation_lock:        false,
                                          date_file_send:       nil,
                                          note:                 'AAA-Uwagi',
                                          family_id:            nil)

@last_rotation.destroy

puts "#####  END OF 17A_family_rotation_h_00278.rb  #####"
puts ""

