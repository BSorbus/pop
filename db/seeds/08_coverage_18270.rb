require 'csv'


puts ""
puts "#####  08_coverage_18270.rb  #####"

############################################################################################
puts "... load from db/seeds/polisa_rotacja_osoba_18270.csv... start..."

File.open(File.join("db/seeds/log", 'polisa_rotacja_osoba_18270.log'), 'a+') do |f|
  f.puts "#####  08_coverage_18270.rb  #####"
  f.puts "... load from db/seeds/polisa_rotacja_osoba_18270.csv... start..."
  f.puts "Coverages all: #{Coverage.all.size}"
end 

CSV.foreach("db/seeds/polisa_rotacja_osoba_18270.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #coverage.create(row.to_hash)

  @coverage = Coverage.create(    id:           id_with_offset( row[:id_pro], DB18270_OFFSET_POLISA_ROTACJA_OSOBA ), 
                                  group_id:     id_with_offset( row[:polisa_grupa], DB18270_OFFSET_POLISA_GRUPA ),
                                  rotation_id:  id_with_offset( row[:polisa_rotacja], DB18270_OFFSET_POLISA_ROTACJA ),
                                  insured_id:   id_with_offset( row[:ubezpieczony], DB18270_OFFSET_OSOBA ),
                                  payer_id:     id_with_offset( row[:platnik], DB18270_OFFSET_OSOBA ),
                                  note:         row[:uwagi],
                                  created_at:   row[:change_date],
                                  updated_at:   row[:change_date]
                                  )

  if @coverage.valid?
    puts row[:id_pro]
  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "      id_polisa_rotacja_osoba: #{row[:id_pro]}"
    @coverage.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/log", 'polisa_rotacja_osoba_18270.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "      id_polisa_rotacja_osoba: #{row[:id_pro]}"
      @coverage.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "coverages all: #{Coverage.all.size}"

File.open(File.join("db/seeds/log", 'polisa_rotacja_osoba_18270.log'), 'a+') do |f|
  f.puts "Coverages all: #{Coverage.all.size}"
  f.puts "#####  END ...load from 08_coverage_18270.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = Coverage.all.order(:id).last.id + 1
puts "Coverages NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE coverages_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_coverage = Coverage.create(
                                  group_id:     Group.all.order(:id).last.id,
                                  rotation_id:  Rotation.all.order(:id).last.id,
                                  insured_id:   Individual.all.order(:id).last.id,
                                  payer_id:     Individual.all.order(:id).last.id
                                  )

@last_coverage.destroy


############################################################################################
#uporządkuj daty wpisania grupy

@groups = Group.all

@groups.each do |group|
  first_used = Coverage.where(group: group).order(:rotation_id).first #rotation.rotation_date

  group.created_at = first_used.created_at if first_used.present?
  group.updated_at = first_used.created_at if first_used.present?
  group.save

end # ./ @groups.each


puts "#####  END OF 08_coverage_18270.rb  #####"
puts ""

