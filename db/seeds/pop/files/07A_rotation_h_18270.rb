require 'csv'


puts ""
puts "#####  07A_rotation_h_18270.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/polisa_rotacja_h_18270.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'polisa_rotacja_h_18270.log'), 'a+') do |f|
  f.puts "#####  07A_rotation_h_18270.rb  #####"
  f.puts "... load from db/seeds/pop/files/polisa_rotacja_h_18270.csv... start..."
  f.puts "RotationHistory all: #{RotationHistory.all.size}"
end 

CSV.foreach("db/seeds/pop/files/polisa_rotacja_h_18270.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #rotation.create(row.to_hash)

  if false
  #   RotationHistory.where( rotation_id:  id_with_offset( row[:id_polisa_rotacja], DB18270_OFFSET_POLISA_ROTACJA ), 
  #                          rotation_date:        row[:data_rotacji],
  #                          rotation_lock:        row[:blokada],
  #                          date_file_send:       nil,
  #                          note:                 row[:uwagi],
  #                          insurance_id:         id_with_offset( row[:polisa], DB18270_OFFSET_POLISA ) ).any?
  #  puts "Taki wpis już jest"
  #  #zapisz błąd do pliku
  #  File.open(File.join("db/seeds/pop/files/log", 'polisa_rotacja_h_18270.error'), 'a+') do |f|
  #    f.puts "DUPLIKAT - odrzucenie"
  #    f.puts "id_polisa_rotacja: #{row[:id_polisa_rotacja]}"
  #    f.puts "     data_rotacji: #{row[:data_rotacji]}"
  #    f.puts "          blokada: #{row[:blokada]}"
  #    f.puts "           polisa: #{row[:polisa]}"
  #    f.puts "            uwagi: #{row[:uwagi]}"
  #    f.puts "      change_date: #{row[:change_date]}"
  #    f.puts ""
  #  end 
  else 
    @rotation_h = RotationHistory.create( rotation_id:  id_with_offset( row[:id_polisa_rotacja], DB18270_OFFSET_POLISA_ROTACJA ), 
                                          rotation_date:        row[:data_rotacji],
                                          rotation_lock:        row[:blokada],
                                          date_file_send:       nil,
                                          note:                 row[:uwagi],
                                          insurance_id:         id_with_offset( row[:polisa], DB18270_OFFSET_POLISA ),
                                          created_at:           row[:change_date],
                                          updated_at:           row[:change_date] )

    if @rotation_h.valid?
      puts row[:id_polisa_rotacja]
    else
      # jeżeli jednak był błąd
      # wyswietl błąd na ekranie
      puts "ERROR(s)"
      puts "    id_polisa_rotacja: #{row[:id_polisa_rotacja]}"
      puts "               polisa: #{row[:polisa]}"
      @rotation_h.errors.full_messages.each do |msg|
        puts " - #{msg}"
      end     
      puts ""

      #zapisz błąd do pliku
      File.open(File.join("db/seeds/pop/files/log", 'polisa_rotacja_h_18270.error'), 'a+') do |f|
        f.puts "ERROR(s)"
        f.puts "    id_polisa_rotacja: #{row[:id_polisa_rotacja]}"
        f.puts "               polisa: #{row[:polisa]}"
        @rotation_h.errors.full_messages.each do |msg|
          f.puts " - #{msg}"
        end     
        f.puts ""
      end 

    end # /rotation_h.valid?
  end # /RotationHistory.where(....).eny?

end

puts "RotationHistory all: #{RotationHistory.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'polisa_rotacja_h_18270.log'), 'a+') do |f|
  f.puts "RotationHistory all: #{RotationHistory.all.size}"
  f.puts "#####  END ...load from 07A_rotation_h_18270.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = RotationHistory.all.order(:id).last.id + 1
puts "RotationHistory NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE rotation_histories_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_rotation = RotationHistory.create(  rotation_id:         nil, 
                                          rotation_date:        Time.now, 
                                          rotation_lock:        false,
                                          date_file_send:       nil,
                                          note:                 'AAA-Uwagi',
                                          insurance_id:         nil)

@last_rotation.destroy

puts "#####  END OF 07A_rotation_h_18270.rb  #####"
puts ""

