require 'csv'


puts ""
puts "#####  18_family_coverage_00278.rb  #####"

############################################################################################
puts "... load from db/seeds/pop/files/polisa_rod_rotacja_osoba_00278.csv... start..."

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_rotacja_osoba_00278.log'), 'a+') do |f|
  f.puts "#####  18_family_coverage_00278.rb  #####"
  f.puts "... load from db/seeds/pop/files/polisa_rod_rotacja_osoba_00278.csv... start..."
  f.puts "FamilyCoverages all: #{FamilyCoverage.all.size}"
end 

CSV.foreach("db/seeds/pop/files/polisa_rod_rotacja_osoba_00278.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #coverage.create(row.to_hash)

  @family_coverage = FamilyCoverage.create( id:                 id_with_offset( row[:id_polisa_rod_rot_oso], DB00278_OFFSET_POLISA_ROD_ROTACJA_OSOBA ), 
                                            family_rotation_id: id_with_offset( row[:polisa_rod_rotacja], DB00278_OFFSET_POLISA_ROD_ROTACJA ),
                                            insured_id:         id_with_offset( row[:ubezpieczony], DB00278_OFFSET_OSOBA ),
                                            payer_id:           id_with_offset( row[:platnik], DB00278_OFFSET_OSOBA ),
                                            note:               row[:uwagi],
                                            created_at:         row[:change_date],
                                            updated_at:         row[:change_date]
                                            )

  if @family_coverage.valid?
    puts row[:id_polisa_rod_rot_oso]
  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "      id_polisa_rod_rot_oso: #{row[:id_polisa_rod_rot_oso]}"
    @family_coverage.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_rotacja_osoba_00278.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "      id_polisa_rod_rot_oso: #{row[:id_polisa_rod_rot_oso]}"
      @family_coverage.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "coverages all: #{FamilyCoverage.all.size}"

File.open(File.join("db/seeds/pop/files/log", 'polisa_rod_rotacja_osoba_00278.log'), 'a+') do |f|
  f.puts "FamilyCoverages all: #{FamilyCoverage.all.size}"
  f.puts "#####  END ...load from 18_family_coverage_00278.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = FamilyCoverage.all.order(:id).last.id + 1
puts "FamilyCoverages NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE family_coverages_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_coverage = FamilyCoverage.create(
                                  family_rotation_id:  FamilyRotation.all.order(:id).last.id,
                                  insured_id:          Individual.all.order(:id).last.id,
                                  payer_id:            Individual.all.order(:id).last.id
                                  )

@last_coverage.destroy


############################################################################################
#uporządkuj daty wpisania grupy

#@groups = Group.all
#
#@groups.each do |group|
#  first_used = FamilyCoverage.where(group: group).order(:rotation_id).first #rotation.rotation_date
#
#  group.created_at = first_used.created_at if first_used.present?
#  group.updated_at = first_used.created_at if first_used.present?
#  group.save
#
#end # ./ @groups.each



puts "#####  END OF 18_family_coverage_00278.rb  #####"
puts ""

