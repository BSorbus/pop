require 'csv'


puts ""
puts "#####  06_discount_00718.rb  #####"

############################################################################################
puts "... load from db/seeds/polisa_zz_00718.csv... start..."

File.open(File.join("db/seeds/log", 'polisa_zz_00718.log'), 'a+') do |f|
  f.puts "#####  06_discount_00718.rb  #####"
  f.puts "... load from db/seeds/polisa_zz_00718.csv... start..."
  f.puts "Discounts all: #{Discount.all.size}"
end 

CSV.foreach("db/seeds/polisa_zz_00718.csv", {  encoding: "WINDOWS-1250:UTF-8", 
                                            headers: true, 
                                            header_converters: :symbol, 
                                            col_sep: ';'}
                    ) do |row|

  ## jezeli plik csv ma strukture zgodna, to wystarczy wywolac wiersz ponizej
  #discount.create(row.to_hash)

  @discount = Discount.create(    id:                   id_with_offset( row[:id_polisa_zz], DB00718_OFFSET_POLISA_ZZ ), 
                                  category:             row[:typ_zz],
                                  description:          row[:opis_zz],
                                  discount_increase:    correct_decimal_separator(row[:zz_procent]),
                                  group_id:             id_with_offset( row[:polisa_grupa], DB00718_OFFSET_POLISA_GRUPA ))

  if @discount.valid?
    puts row[:id_polisa_zz]
  else
    # jeżeli jednak był błąd
    # wyswietl błąd na ekranie
    puts "ERROR(s)"
    puts "      id_polisa_zz: #{row[:id_polisa_zz]}"
    puts "             grupa: #{row[:polisa_grupa]}"
    @discount.errors.full_messages.each do |msg|
      puts " - #{msg}"
    end     
    puts ""

    #zapisz błąd do pliku
    File.open(File.join("db/seeds/log", 'polisa_zz_00718.error'), 'a+') do |f|
      f.puts "ERROR(s)"
      f.puts "      id_polisa_zz: #{row[:id_polisa_zz]}"
      f.puts "             grupa: #{row[:polisa_grupa]}"
      @discount.errors.full_messages.each do |msg|
        f.puts " - #{msg}"
      end     
      f.puts ""
    end 

  end
end

puts "discounts all: #{Discount.all.size}"

File.open(File.join("db/seeds/log", 'polisa_zz_00718.log'), 'a+') do |f|
  f.puts "Discounts all: #{Discount.all.size}"
  f.puts "#####  END ...load from 06_discount_00718.rb  #####"
end 
############################################################################################






############################################################################################
#pobierz najwiekszy ID i zwiększ go o 1
next_id = Discount.all.order(:id).last.id + 1
puts "Discounts NEXT_ID: #{next_id}"
#ustaw generator sekwencji na odpowiednia wartosc
connection = ActiveRecord::Base.connection()
connection.execute( "ALTER SEQUENCE discounts_id_seq RESTART WITH #{next_id} ;" )
#wstaw do bazy testowy rekord
@last_discount = Discount.create(
                                  category:             'IL',
                                  description:          'Test',
                                  discount_increase:    -10.0,
                                  group_id:             Group.all.order(:id).last.id
                                  )

@last_discount.destroy

puts "#####  END OF 07_discount_00718.rb  #####"
puts ""

