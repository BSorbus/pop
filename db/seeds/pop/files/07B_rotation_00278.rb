require 'csv'

def rotation_created_at_first_rec(seek_id)
  RotationHistory.where(rotation_id: seek_id).order(:created_at).first.created_at
end


puts ""
puts "#####  07B_rotation_00278.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/polisa_rotacja_00278.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'polisa_rotacja_00278.log'), 'a+') do |f|
  f.puts "#####  07B_rotation_00278.rb  #####"
  f.puts "... load from db/seeds/pop/files/polisa_rotacja_00278.csv... start..."
end 

CSV.foreach("db/seeds/pop/files/polisa_rotacja_00278.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #rotation.create(row.to_hash)

  @rotation = Rotation.create(    id:                   id_with_offset( row[:id_polisa_rotacja], DB00278_OFFSET_POLISA_ROTACJA ), 
                                  rotation_date:        row[:data_rotacji],
                                  rotation_lock:        row[:blokada],
                                  date_file_send:       nil,
                                  note:                 row[:uwagi],
                                  insurance_id:         id_with_offset( row[:polisa], DB00278_OFFSET_POLISA ),
                                  created_at:           rotation_created_at_first_rec( id_with_offset( row[:id_polisa_rotacja], DB00278_OFFSET_POLISA_ROTACJA ) ),
                                  updated_at:           row[:change_date] )

  if @rotation.valid?
    puts row[:id_polisa_rotacja]
  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "    id_polisa_rotacja: #{row[:id_polisa_rotacja]}"
    puts "               polisa: #{row[:polisa]}"
    @rotation.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'polisa_rotacja_00278.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "    id_polisa_rotacja: #{row[:id_polisa_rotacja]}"
      f.puts "               polisa: #{row[:polisa]}"
      @rotation.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "rotations all: #{Rotation.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'polisa_rotacja_00278.log'), 'a+') do |f|
  f.puts "Rotations all: #{Rotation.all.size}"
  f.puts "#####  END ...load from 07B_rotation_00278.rb  #####"
end 
############################################################################################






#    ############################################################################################
#    #pobierz najwiekszy ID i zwiększ go o 1
#    next_id = Rotation.all.order(:id).last.id + 1
#    puts "Rotations NEXT_ID: #{next_id}"
#    #ustaw generator sekwencji na odpowiednia wartosc
#    connection = ActiveRecord::Base.connection()
#    connection.execute( "ALTER SEQUENCE rotations_id_seq RESTART WITH #{next_id} ;" )
#    #wstaw do bazy testowy rekord
#    @last_rotation = Rotation.create( rotation_date:        Time.now, 
#                                      rotation_lock:        false,
#                                      date_file_send:       nil,
#                                      note:                 'AAA-Uwagi',
#                                      insurance_id:         Insurance.all.order(:id).last.id)
#
#    @last_rotation.destroy

    puts "#####  END OF 07B_rotation_00278.rb  #####"
    puts ""

