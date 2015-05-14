class CertificationsInsuredsPdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(coverages, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @coverages = coverages
    if !@coverages.empty?
      @rotation = @coverages.first.rotation
      @insurance = @rotation.insurance
      @company = @rotation.insurance.company
      @user = @rotation.insurance.user
    end
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
      header_left_corner
      header(coverage)
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

  def header_left_corner
    move_down 5
    text "CERTYFIKAT", size: 14, :style => :bold
    move_down 10    
    text "do polisy grupowego ubezpieczenia NNW nr #{@insurance.number}", size: 11
  end

  def header(coverage)
    draw_text "Ubezpieczyciel:",          :at => [0,   705], size: 8, :style => :italic
    draw_text "Oddział:",                 :at => [190, 705], size: 8, :style => :italic
    draw_text "Ubezpieczenie obsługuje:", :at => [380, 705], size: 8, :style => :italic

    text_box "TUiR Allianz Polska S.A." + "\n" +
             "ul. Rodziny Hiszpańskich 1" + "\n" +
             "02-685 Warszawa", size: 9, :style => :bold, 
      :at => [0, 697], 
      :width => 170, 
      :height => 70

    text_box "#{@user.address}", size: 9, :style => :bold, 
      :at => [190, 697], 
      :width => 170, 
      :height => 70

    text_box "#{@user.name}" + "\n" +
             "- #{@user.agent_number}" , size: 9, :style => :bold, 
      :at => [380, 697], 
      :width => 170, 
      :height => 70

    draw_text "Ubezpieczony:",            :at => [0,   620], size: 8, :style => :italic
    draw_text "Ubezpieczający:",          :at => [210, 620], size: 8, :style => :italic

    text_box "#{coverage.insured.last_first_name}" + "\n" +
             "ur. #{coverage.insured.birth_date.strftime("%d.%m.%Y")}" + "\n" +
             "#{coverage.insured.street_house_number}" + "\n" +
             "#{coverage.insured.postal_code_city}", size: 9, :style => :bold, 
      :at => [0, 612], 
      :width => 170, 
      :height => 70

    text_box "#{@company.name}" + "\n" +
             "#{@company.street_house_number}" + "\n" +
             "#{@company.postal_code_city}", size: 9, :style => :bold, 
      :at => [210, 612], 
      :width => 330, 
      :height => 70

    draw_text "Charakter wykonywanej pracy: ",  :at => [0,   535], size: 9
    draw_text "#{coverage.insured.profession}", :at => [150, 535], size: 9, :style => :bold
  end

  def title   
    move_down 210
    text "GRUPOWE UBEZPIECZENIE NASTĘPSTW NIESZCZĘŚLIWYCH WYPADKÓW", size: 12, :style => :bold, :align => :center    
    text "Niniejszy dokument stanowi potwierdzenie objęcia ochroną ubezpieczeniową " +
         "w ramach grupowego ubezpieczenia następstw nieszczęśliwych wypadków", size: 6, :align => :center    
  end

  def data(coverage)
    move_down 20
    text "Data przystąpienia do umowy grupowego ubezpieczenia NNW:  #{@rotation.rotation_date.strftime("%d.%m.%Y")}"
    text "Grupa osób ubezpieczonych nr:  #{coverage.group.number}  zgodnie z polisą"
    text "Grupa ryzyka:  #{coverage.group.risk_group}"
    text "Składka:  #{coverage.group.contribution}"
    move_down 20

    text "Sumy ubezpieczenia/kwoty", size: 12, :style => :bold    

    current_row = 370
    draw_text "Świadczenie na wypadek trwałego uszczerbku na zdrowiu " + '.'*24,          :at => [0,   current_row] 
      draw_text "#{with_delimiter_and_separator(coverage.group.assurance)} zł",           :at => [375, current_row], :style => :bold

    current_row -= 20
    draw_text "Podwójne świadczenie na wypadek trwałego uszczerbku na zdrowiu ........",  :at => [0,   current_row] 
      draw_text "#{with_delimiter_and_separator(coverage.group.double_assurance)} zł",    :at => [375, current_row], :style => :bold

    current_row -= 20
    draw_text "Świadczenie na wypadek śmierci " + '.'*63,                                 :at => [0,   current_row] 
      draw_text "#{with_delimiter_and_separator(coverage.group.insurance_death_val)} zł", :at => [375, current_row], :style => :bold

    current_row -= 20
    draw_text "Przeszkolenie zawodowe inwalidów " + '.'*59,                               :at => [0,   current_row] 
      draw_text "#{with_delimiter_and_separator(coverage.group.insurance_training_val)} zł", :at => [375, current_row], :style => :bold

    current_row -= 20
    draw_text "Zawał serca albo udar mózgu dla osób poniżej 30 roku życia " + '.'*19,     :at => [0,   current_row] 
      draw_text "#{with_delimiter_and_separator(coverage.group.insurance_infarct30_val)} zł", :at => [375, current_row], :style => :bold

    current_row -= 20
    draw_text "Świadczenie opiekuńcze na terenie Rzeczpospolitej Polskiej " + '.'*21,     :at => [0,   current_row] 
      draw_text "wg OWU",                                                                 :at => [375, current_row], :style => :bold



    if coverage.group.treatment > 0
      current_row -= 20
      draw_text "Koszty leczenia na terenie Rzeczpospolitej Polskiej " + '.'*35,            :at => [0,   current_row] 
        draw_text "#{with_delimiter_and_separator(coverage.group.treatment)} zł",           :at => [375, current_row], :style => :bold
    end

    if coverage.group.ambulatory > 0
      current_row -= 20
      draw_text "Zasiłek amulatoryjny " + '.'*81,                                           :at => [0,   current_row] 
        draw_text "#{with_delimiter_and_separator(coverage.group.ambulatory)} zł",          :at => [375, current_row], :style => :bold
    end

    if coverage.group.hospital > 0
      current_row -= 20
      draw_text "Zasiłek szpitalny " + '.'*88,                                              :at => [0,   current_row] 
        draw_text "#{with_delimiter_and_separator(coverage.group.hospital)} zł",            :at => [375, current_row], :style => :bold
    end

    if coverage.group.infarct > 0
      current_row -= 20
      draw_text "Zawał serca albo udar mózgu " + '.'*68,                                    :at => [0,   current_row] 
        draw_text "#{with_delimiter_and_separator(coverage.group.infarct)} zł",             :at => [375, current_row], :style => :bold
    end

    if coverage.group.inability > 0
      current_row -= 20
      draw_text "Trwała niezdolność do pracy " + '.'*70,                                    :at => [0,   current_row] 
        draw_text "#{with_delimiter_and_separator(coverage.group.inability)} zł",           :at => [375, current_row], :style => :bold
    end


    text_box "Niniejszy certyfikat służy wyłącznie celom informacyjnym. Warunki ubezpieczenia reguluje polisa nr #{@insurance.number} " +
         "oraz ogólne warunki grupowego ubezpieczenia następstw nieszczęśliwych wypadków.", size: 8,
      :at => [0, 115], 
      :width => 525, 
      :height => 19

    draw_text "." * 80, :at => [300, 50], size: 6
    draw_text "Przedstawiciel TUiR Allianz Polska S.A.", :at => [310, 41], size: 7
  end

  def footer
    stroke_line [0, 36], [525,36], self.line_width = 0.1
    text_box "Towarzystwo Ubezpieczeń i Reasekuracji Allianz Polska Spółka Akcyjna z siedzibą w Warszawie, " + 
             "ul Rodziny Hiszpańskich 1, 02-685 Warszawa, wpisana do rejestru przedsiębiorców prowadzonego przez Sąd Rejonowy " +
             "dla m. st. Warszawy w Warszawie, XIII Wydział Gospodarczy Krajowego Rejestru Sądowego, pod numerem KRS 0000028261, " + 
             "NIP 525-15-65-015, REGON 012267870, wysokość kapitału zakładowego: 377 240 000 złotych (wpłacony w całości)", size: 6, :align => :justify, 
      :at => [0, 33], 
      :width => 525, 
      :height => 22
    stroke_line [0, 10], [525,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
