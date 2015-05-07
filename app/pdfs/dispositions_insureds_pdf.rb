class DispositionsInsuredsPdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(coverages, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @coverages = coverages
    @rotation = @coverages.first.rotation
    @insurance = @rotation.insurance
    @company = @rotation.insurance.company
    @user = @rotation.insurance.user
    @view = view

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10

    count_coverages = @coverages.size

    @coverages.each_with_index do |coverage, i|
      logo
      header_left_corner(coverage)
      header_right_corner(coverage)
      title
      data(coverage)
      footer
      start_new_page if ((i+1) < count_coverages)
    end

  end


  def logo
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner(coverage)
    move_down 0
    text "#{coverage.insured.last_first_name}", :style => :bold
    text "#{coverage.insured.street_house_number}", :style => :bold
    text "#{coverage.insured.postal_code_city}", :style => :bold
    text "ur. #{coverage.insured.birth_date.strftime("%d.%m.%Y")}", :style => :bold
  end

  def header_right_corner(coverage)
    text_box "TUiR Allianz Polska S.A." + "\n" +
             "ul. Rodziny Hiszpańskich 1" + "\n" +
             "02-685 Warszawa", size: 9, :style => :bold, 
      :at => [390, 730], 
      :width => 170, 
      :height => 70
  end

  def title   
    move_down 50
    text "Dyspozycja ubezpieczonego odnośnie wyznaczania uposażonych", size: 14, :align => :center
    move_down 5
    text "Nr polisy:  #{@rotation.insurance.number}", size: 14, :align => :center  
  end

  def data(coverage)
    move_down 10
    text "Suma ubezpieczenia z tytułu śmierci w wypadku:  #{with_delimiter_and_separator(coverage.group.insurance_death_val)} zł"
    move_down 5
    text "Wskazuję następujące osoby, którym należy wypłacić odszkodowanie " +
         "z tytułu umowy ubezpieczenia w razie mojej śmierci w następstwie wypadku"
    move_down 10
    text "UPOSAŻENI:", size: 11


    draw_text "Lp.",                      :at => [  4, 537], size: 9
    draw_text "Imię (imiona) i nazwisko", :at => [ 24, 537], size: 9
    draw_text "Adres",                    :at => [200, 537], size: 9
    draw_text "PESEL / data ur.",         :at => [350, 537], size: 9
    draw_text "Udział w środkach",        :at => [440, 537], size: 9
    draw_text "(% świadczenia)",          :at => [440, 526], size: 9

    current_row = 550
    stroke_line [  0, current_row], [525,current_row], self.line_width = 0.5

    stroke_line [  0, current_row], [  0, current_row-230], self.line_width = 0.5
    stroke_line [ 20, current_row], [ 20, current_row-230], self.line_width = 0.5
    stroke_line [196, current_row], [196, current_row-230], self.line_width = 0.5
    stroke_line [346, current_row], [346, current_row-230], self.line_width = 0.5
    stroke_line [436, current_row], [436, current_row-230], self.line_width = 0.5
    stroke_line [525, current_row], [525, current_row-230], self.line_width = 0.5

    current_row -= 30
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 50
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 50
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 50
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 50
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    move_down 250
    text "1. Niniejszym wyrażam zgodę na przetwarzanie moich danych osobowych podanych " +
         "dobrowolnie przeze mnie lub osoby trzecie, w tym danych dotyczących mojego " +
         "stanu zdrowia i nałogów przez TU Allianz Polska S.A. dla celów związanych z " +
         "wykonywaniem umowy ubezpieczenia oraz działalnością statutową TU Allianz Polska SA " +
         "Ponadto oświadczam, że wyrażam zgodę na przekazywanie ww. danych podmiotom " +
         "związanym z TU Allianz S.A. w celach związanych z działalnością ubezpieczniową. " +
         "Zgody powyższe obejmują również przetwarzanie ww. danych osobowych w przyszłości, " +
         "o ile nie zmieni się cel ich przetwarzania.", size: 7

    #draw_text "#{@company.address_city},", :at => [ 5,current_row+5]

    draw_text "." * 110, :at => [ 30,220], size: 6
    draw_text "Miejscowość i data", :at => [ 60,211], size: 7

    draw_text "." * 110, :at => [300,220], size: 6
    draw_text "Czytelny podpis ubezpieczonego", :at => [330,211], size: 7

    move_down 90
    text "1) Prawo do odebrania świadczenia w razie śmierci ubezpieczonego przysługuje " +
         "osobie Uposażonej. Wyznaczenie osób uposażonych jest skuteczne pod warunkiem " +
         "dostarczenia dyspozycji do TU Allianz Polska" + "\n" +
         "2) W przypadku niewyznaczenia osoby Uposażonej, albo gdy Uposażony nie żyje w dniu " +
         "śmierci Ubezpieczonego, albo gdy Uposażony utracił prawo do świadczenia - " +
         "świadczenie przysługuje członkom rodziny Ubezpieczonego wg następującej kolejności: " +
         "a) współmałżonkowi, b) w równych częściach dzieciom Ubezpieczonego, jeśli nie ma współmałżonka, " +
         "c) w równych częściach rodzicom Ubezpieczonego, jeśli nie ma dzieci Ubezpieczonego " +
         "d) dalszym spadkobiercom ustawowym jeśli nie ma w/w osób." + "\n" +
         "Zapis zgodny z OWU § 10.2.2-4" + "\n" +
         "3) Świadczenie nie przysługuje osobie, która umyślnym czynem karalnym spowodowała śmierć Ubezpieczonego" + "\n" +
         "4) Dyspozycję należy przesłać na adres TU Allianz Polska, ul. Rodziny Hiszpańskich 1 " +
         "02-685 Warszawa, Depertament NNW", size: 7
  end

  def footer
    draw_text "Ubezpieczenie obsługuje: #{@rotation.insurance.user.name} - #{@rotation.insurance.user.agent_number}", :at => [0, 15], size: 9    
    stroke_line [0, 10], [525,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
