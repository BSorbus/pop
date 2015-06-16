class DeclarationsFamilyAccessionPdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(family_coverages, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @family_coverages = family_coverages
    if !@family_coverages.empty?
      @family_rotation = @family_coverages.first.family_rotation
      @family = @family_rotation.family
      @company = @family_rotation.family.company
      @user = @family_rotation.family.user
    end
    @view = view

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10

    count_family_coverages = @family_coverages.size

    @family_coverages.each_with_index do |coverage, i|

      bounding_box([0,775], :width => 525, :height => 755) do
        logo
        header_left_corner
        data_page_1(coverage)
        data_page_2(coverage)
        data_page_3(coverage)
      end

      start_new_page if ((i+1) < count_family_coverages)
    end

    repeat(:all, :dynamic => true) do
      #header_left_corner(title1, title2)
      footer
      current_page_per_user = (page_number%3 == 0)? 3 : page_number%3
      all_rec = page_count/3
      current_rec = (page_number-1)/3 + 1
      text "Strona #{current_page_per_user}/3          dla pozycji #{current_rec} z #{all_rec}", size: 7, :align => :left, :valign => :bottom  
    end    

  end


  def logo
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [410, 770], :height => 30
  end

  def header_left_corner
    move_down 0
    text "Deklaracja przystąpienia", size: 11, :style => :bold
    text "do umów grupowego ubezpieczenia", size: 8

    text_box "#{@user.name}" +
             " - #{@user.agent_number}" , size: 9, :style => :bold, 
      :at => [230, 760], 
      :width => 250, 
      :height => 25

    current_row = 726
    current_col = 0
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5
    draw_text "na życie Allianz Rodzina zawartej z TU Allianz Życie Polska S.A.", :at => [  10, 720], size: 8

    current_row = 716
    current_col = 0
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5
    draw_text "na życie Allianz Rodzina Prestige zawartej z TU Allianz Życie Polska S.A.", :at => [  10, 710], size: 8


    current_row = 735
    current_col = 320
    # obrys zewnętrzny
      # pionowa lewa
      stroke_line [current_col, current_row], [current_col, current_row-55], self.line_width = 0.5
      # pozioma górna
      stroke_line [current_col, current_row], [current_col+212, current_row], self.line_width = 0.5
      # pionowa prawa
      stroke_line [current_col+212, current_row], [current_col+212, current_row-55], self.line_width = 0.5
      # pozioma dolna
      stroke_line [current_col, current_row-55], [current_col+212, current_row-55], self.line_width = 0.5

    draw_text "Index o.w.u                nr wniosku            Nr grupy albo", :at => [330, 727], size: 7
    draw_text "nazwa wariantu", :at => [465, 720], size: 7

    # pionowa środek-lewa
    stroke_line [current_col+70, current_row], [current_col+70, current_row-55], self.line_width = 0.5
    # pionowa środek-prawa
    stroke_line [current_col+140, current_row], [current_col+140, current_row-55], self.line_width = 0.5


    # pozioma środek-górna-lewa
    stroke_line [current_col, current_row-20], [current_col+212, current_row-20], self.line_width = 0.5

    # pozioma środek-górna-prawa
    stroke_line [current_col, current_row-38], [current_col+212, current_row-38], self.line_width = 0.5

    draw_text "Nr polisy Allianz Rodzina:",                 :at => [  0, 692], size: 10
    draw_text "#{@family.number}",                          :at => [160, 692], size: 11, :style => :bold

    draw_text "Proponowana data przystąpienia:",            :at => [  0, 679], size: 8
    draw_text "#{@family.valid_from.strftime("%d.%m.%Y")}", :at => [160, 679], size: 8, :style => :bold

    current_row = 675
    current_col = 320
    # pieczątka - obrys zewnętrzny
      # pionowa lewa
      stroke_line [current_col, current_row], [current_col, current_row-30], self.line_width = 0.5
      # pozioma górna
      stroke_line [current_col, current_row], [current_col+212, current_row], self.line_width = 0.5
      # pionowa prawa
      stroke_line [current_col+212, current_row], [current_col+212, current_row-30], self.line_width = 0.5
      # pozioma dolna
      stroke_line [current_col, current_row-30], [current_col+212, current_row-30], self.line_width = 0.5

    draw_text "Pieczątka", :at => [325, 668], size: 7

    draw_text "Dane Ubezpieczającego (Pracodawcy):", :at => [  0, 668], size: 8


    text_box "#{@company.name}", size: 9, :style => :bold,
      :at => [10, 661], 
      :width => 295, 
      :height => 40

    #text "#{coverage.insured.street_house_number}"
    #text "#{coverage.insured.postal_code_city}"
    #text "ur. #{coverage.insured.birth_date.strftime("%d.%m.%Y")}"
    #text "#{coverage.insured.profession}"
  end

  def data_page_1(coverage)
    move_down 103
    text "Dane Ubezpieczonego:", size: 9
      draw_text "Kobieta                                    Mężczyzna", :at => [143, 623], size: 8  
    current_row = 630
    current_col = 130
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    current_row = 630
    current_col = 250
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    draw_text "Imię (imiona)",                  :at => [ 10, 610], size: 8
    draw_text "#{coverage.insured.first_name}", :at => [130, 610], size: 8, :style => :bold
    draw_text "Nazwisko",                       :at => [ 10, 597], size: 8
    draw_text "#{coverage.insured.last_name}",  :at => [130, 597], size: 8, :style => :bold
    draw_text "PESEL",                          :at => [ 10, 584], size: 8
    draw_text "#{coverage.insured.pesel}",      :at => [130, 584], size: 8, :style => :bold
      draw_text "Data urodzenia",                                       :at => [250, 584], size: 8
      draw_text "#{coverage.insured.birth_date.strftime("%d.%m.%Y")}",  :at => [370, 584], size: 8, :style => :bold
    draw_text "Obywatelstwo",                   :at => [ 10, 571], size: 8
    draw_text "....................................................",      :at => [130, 571], size: 6

    draw_text "Typ dokumentu tożsamości",       :at => [ 10, 558], size: 8
    draw_text "....................................................",      :at => [130, 558], size: 6
      draw_text "Seria i numer dokumentu",      :at => [250, 558], size: 8
      draw_text "....................................................",    :at => [370, 558], size: 6
    draw_text "Stan cywilny                                panna/kawaler" + 
              "                   zamężna/żonaty                 rozwiedziona/(y)" +
              "                   wdowa/wdowiec", :at => [ 10, 545], size: 8

    current_row = 552
    current_col = 130
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    current_row = 552
    current_col = 237
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    current_row = 552
    current_col = 347
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    current_row = 552
    current_col = 460
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    move_down 83
    text "Adres zameldowania:", size: 9
    draw_text "Ulica",                                                :at => [ 10, 517], size: 8
    draw_text "#{coverage.insured.address_street}",                   :at => [130, 517], size: 8, :style => :bold
    draw_text "Nr domu",                                              :at => [ 10, 504], size: 8
    draw_text "#{coverage.insured.address_house}",                    :at => [130, 504], size: 8, :style => :bold
      draw_text "Nr lokalu",                                            :at => [200, 504], size: 8
      draw_text "#{coverage.insured.address_number}",                   :at => [240, 504], size: 8, :style => :bold
        draw_text "Miejscowość",                                          :at => [295, 504], size: 8
        draw_text "#{coverage.insured.address_city}",                     :at => [355, 504], size: 8, :style => :bold
    draw_text "Kod pocztowy",                                         :at => [ 10, 491], size: 8
    draw_text "#{coverage.insured.address_postal_code}",              :at => [130, 491], size: 8, :style => :bold
      draw_text "Poczta",                                               :at => [200, 491], size: 8
      draw_text "....................................................", :at => [240, 491], size: 6
        draw_text "Kraj",                                                 :at => [355, 491], size: 8
        draw_text "....................................................", :at => [385, 491], size: 6
    draw_text "Tel.stacjonarny",                                      :at => [ 10, 478], size: 8
    draw_text "....................................................", :at => [130, 478], size: 6
      draw_text "Tel.kom.",                                             :at => [240, 478], size: 8
      draw_text "....................................................", :at => [280, 478], size: 6
        draw_text "e-mail",                                               :at => [395, 478], size: 8
        draw_text "....................................................", :at => [430, 478], size: 6

    move_down 58
    text "Adres korespondencyjny (jeżeli inny niż zameldowania):", size: 9
    draw_text "Ulica",                                                :at => [ 10, 448], size: 8
    draw_text "....................................................", :at => [130, 448], size: 6
    draw_text "Nr domu",                                              :at => [ 10, 435], size: 8
    draw_text ".........................",                            :at => [130, 435], size: 6
      draw_text "Nr lokalu",                                            :at => [200, 435], size: 8
      draw_text ".......................",                              :at => [240, 435], size: 6
        draw_text "Miejscowość",                                          :at => [295, 435], size: 8
        draw_text "....................................................", :at => [355, 435], size: 6
    draw_text "Kod pocztowy",                                         :at => [ 10, 422], size: 8
    draw_text ".........................",                            :at => [130, 422], size: 6
      draw_text "Poczta",                                               :at => [200, 422], size: 8
      draw_text "....................................................", :at => [240, 422], size: 6
        draw_text "Kraj",                                                 :at => [355, 422], size: 8
        draw_text "....................................................", :at => [385, 422], size: 6

    draw_text "Liczba dzieci",                                        :at => [  0, 407], size: 8
    draw_text "..............",                                       :at => [ 60, 407], size: 6
      draw_text "Data zatrudnienia (1)",                                :at => [95, 407], size: 8
      draw_text ".........................",                            :at => [182, 407], size: 6
        draw_text "Opis stanowiska pracy",                                :at => [235, 407], size: 8
        draw_text "#{coverage.insured.profession}",                       :at => [335, 407], size: 8, :style => :bold

    left_col = 0
    right_col = 525
    current_row = 397
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    current_row = 382
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    current_row = 367
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5

    draw_text "Imię i nazwisko Partnera/Współmałżonka(2)",    :at => [130, 387], size: 8
    draw_text "Data urodzenia (d-m-r)",                       :at => [415, 387], size: 8

    current_col = 0
    top_row = 397
    bottom_row = 367
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 525
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
 
    top_row = 382
    bottom_row = 367
    current_col = 510
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 495
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 480
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 465
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 450
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 435
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 420
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5

    current_col = 405
    top_row = 397
    bottom_row = 367
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5

    move_down 93
    text "Wskazanie partnera oznacza, że ochroną ubezpieczeniową z tytułu klauzul dodatkowych dotyczącycvh współmałżonka/partnera będą objęte zdarzenia dotyczące wyłącznie " +
         "partnera - również wówczas, gdy Ubezpieczony formalnie pozostaje lub będzie pozostawał na dzień zdarzenia w związku małżeńskim z inną osobą.", size: 6
    move_down 2
    text "Wskazanie partnera jest możliwe wyłącznie w przypadku umów zawartych na podstawie o.w.u. o indeksie GZ11 oraz tych umów zawartych na podstawie innych " +
         "indeksów o.w.u., gdzie strony umowy przewidziały taką możliwość.", size: 6, :style => :bold

    move_down 5
    text "CZĘŚĆ DOTYCZĄCA UBEZPIECZENIA ALLIANZ RODZINA", size: 10, :style => :bold

    text "Dane uposażonych", size: 8, :style => :bold

    left_col = 0
    right_col = 525
    current_row = 305
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    current_row = 290
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "1.", :at => [  2, 280], size: 8
    current_row = 275
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "2.", :at => [  2, 265], size: 8
    current_row = 260
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "3.", :at => [  2, 250], size: 8
    current_row = 245
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "4.", :at => [  2, 235], size: 8
    current_row = 230
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5

    draw_text "Lp",                         :at => [  2, 295], size: 8
    draw_text "Imię i nazwisko",            :at => [130, 295], size: 8
    draw_text "Data urodzenia (d-m-r)",     :at => [370, 295], size: 8
    draw_text "% świadczenia*",             :at => [482, 295], size: 5

    top_row = 305
    bottom_row = 230
    current_col = 0
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 15
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 360
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 480
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 525
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5

    top_row = 290
    bottom_row = 230
    current_col = 510
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 495
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 465
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 450
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 435
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 420
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 405
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 390
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 375
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5




    move_down 85
    text "Dane uposażonych zastępczych", size: 8, :style => :bold

    left_col = 0
    right_col = 525
    current_row = 210
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    current_row = 195
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "1.", :at => [  2, 185], size: 8
    current_row = 180
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "1.", :at => [  2, 170], size: 8
    current_row = 165
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5

    draw_text "Lp",                         :at => [  2, 200], size: 8
    draw_text "Imię i nazwisko",            :at => [130, 200], size: 8
    draw_text "Data urodzenia (d-m-r)",     :at => [370, 200], size: 8
    draw_text "% świadczenia*",             :at => [482, 200], size: 5

    top_row = 210
    bottom_row = 165
    current_col = 0
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 15
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 360
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 480
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 525
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5


    top_row = 195
    bottom_row = 165
    current_col = 510
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 495
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 465
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 450
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 435
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 420
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 405
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 390
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 375
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5

    move_down 50
    text "* suma wskazań musi być równa 100%", size: 5
    move_down 3
    text "Oświadczam, że w dniu podpisania niniejszej deklaracji przystąpienia do ubezpieczenia nie przebywam na zwolnieniu lekarskim.", size: 8
    move_down 2
    text "Deklaracja stanu zdrowia", size: 8, :style => :bold
    move_down 2
    text "Ja niżej podpisany/a oświadczam, że nie została u mnie rozpoznana żadna choroba przewlekła. W okresie ostatniego roku nie byłem/am na zwolnieniu " +
         "lekarskim dłużej niż 4 tygodnie. Nie mam wskazań lekarskich do okresowej kontroli medycznej po leczeniu poważnego zachorowania, ani do leczenia " +
         "operacyjnego. Nic mi nie wiadomo o przesłankach medycznych wskazujących na możliwość pogorszenia się mojego stanu zdrowia.", size: 8

    draw_text "Tak, jest to zgodne z moją najlepszą wiedzą.                             Nie, nie mogę podpisać takiego oświadczenia.", :at => [ 12, 78], size: 8  

    current_row = 85
    current_col = 0
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    current_row = 85
    current_col = 250
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
    stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

    move_down 23
    text "Oświadczam, iż byłem/am wcześniej ubezpieczony/a w umowie grupowego ubezpieczenia na życie Allianz Rodzina / umowie kontynuacji grupowego" +
         "ubezpieczenia na życie Allianz Rodzina.", size: 8

    move_down 10
    text "Polisa nr                                                                            Data końca ochrony", size: 8
    draw_text "#{@family.number}",                                                                :at => [ 45, 30], size: 11, :style => :bold
    if @family.applies_to.present?
      draw_text "#{@family.applies_to.strftime("%d.%m.%Y")}",                                       :at => [325, 30], size: 11, :style => :bold
    end
  end

  def data_page_2(coverage)
    start_new_page
    text "CZĘŚĆ DOTYCZĄCA UBEZPIECZENIA ALLIANZ RODZINA PRESTIGE", size: 10, :style => :bold

    text "Dane uposażonych", size: 8, :style => :bold

    left_col = 0
    right_col = 525
    current_row = 730
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    current_row = 715
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "1.", :at => [  2, 705], size: 8
    current_row = 700
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "2.", :at => [  2, 690], size: 8
    current_row = 685
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "3.", :at => [  2, 675], size: 8
    current_row = 670
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "4.", :at => [  2, 660], size: 8
    current_row = 655
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5

    draw_text "Lp",                         :at => [  2, 720], size: 8
    draw_text "Imię i nazwisko",            :at => [130, 720], size: 8
    draw_text "Data urodzenia (d-m-r)",     :at => [370, 720], size: 8
    draw_text "% świadczenia*",             :at => [482, 720], size: 5

    top_row = 730
    bottom_row = 655
    current_col = 0
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 15
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 360
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 480
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 525
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5


    top_row = 715
    bottom_row = 655
    current_col = 510
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 495
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 465
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 450
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 435
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 420
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 405
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 390
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 375
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5



    move_down 85
    text "Dane uposażonych zastępczych", size: 8, :style => :bold

    left_col = 0
    right_col = 525
    current_row = 635
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    current_row = 620
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "1.", :at => [  2, 610], size: 8
    current_row = 605
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5
    draw_text "1.", :at => [  2, 595], size: 8
    current_row = 590
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.5

    draw_text "Lp",                         :at => [  2, 625], size: 8
    draw_text "Imię i nazwisko",            :at => [130, 625], size: 8
    draw_text "Data urodzenia (d-m-r)",     :at => [370, 625], size: 8
    draw_text "% świadczenia*",             :at => [482, 625], size: 5

    top_row = 635
    bottom_row = 590
    current_col = 0
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 15
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 360
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 480
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 525
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5


    top_row = 620
    bottom_row = 590
    current_col = 510
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 495
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 465
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 450
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 435
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 420
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 405
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 390
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5
    current_col = 375
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.5

    move_down 50
    text "* suma wskazań musi być równa 100%", size: 5
    move_down 8
    text "Warunki umowy ubezpieczenia Allianz Rodzina Prestige (w szczególności zakres ubezpieczenia, wysokość świadczeń, warunki dotyczące " +
         "stażu ubezpieczeniowego oraz terminy realizacji praw i obowiązków wynikających z umowy) stanowią samodzielną  podstawę  do " +
         "wykonywania praw i zobowiązań z niej wynikających i nie pozostają w związku z warunkami innych umów ubezpieczenia zawartych między" +
         "TU Allianz Życie Polska S.A. a Ubezpieczajacym.", size: 8, :style => :bold, :align => :justify

    move_down 3
    text 'Do niniejszej deklaracji dołączam "Oświadczenie Ubezpieczonego o stanie zdrowia do deklaracji przystąpienia do umowy grupowego ubezpieczenia na ' +
         'życie Allianz Rodzina Prestige".', size: 8

    move_down 5
    text "CZĘŚĆ DOTYCZĄCA WSZYSTKICH UMÓW UBEZPIECZENIA", size: 9, :style => :bold

    move_down 3
    text "Oświadczenie o przystąpieniu do umowy grupowego ubezpieczenia na życie", size: 8, :style => :bold

    move_down 3
    text "Ja niżej podpisany/a, oświadczam, iż z dniem wymienionym poniżej przy podpisie dobrowolnie przystępuję do umowy grupowego ubezpieczenia na " +
         "życie zawartej z TU Allianz Życie Polska S.A. Oświadczam, że zapoznałem się z ogólnymi warunkami umów ubezpieczenia zawartych na moją rzecz, " +
         "przestawionymi mi przez Ubezpieczonego oraz wyrażam zgodę na wskazanie we wniosku o zawarcie umowy grupowego ubezpieczenia na życie " +
         "wysokości sumy ubezpieczenia, które zostały mi przedstawione przez Ubezpieczającego. Upoważniam Pracodawcę do potrącenia składki " +
         "ubezpieczeniowej za grupowe ubezpieczenie na życie z wynagrodzenia za pracę, z zasiłku na wypadek choroby lub macierzyństwa i innych wypłat.", size: 7, :align => :justify


    left_col = 0
    right_col = 525
    current_row = 435
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.1

    left_col = 0
    right_col = 525
    current_row = 272
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.1


    left_col = 0
    right_col = 525
    current_row = 205
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.1

    left_col = 0
    right_col = 525
    current_row = 132
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.1

    left_col = 0
    right_col = 525
    current_row = 40
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.1


    top_row = 435
    bottom_row = 40
    current_col = 0
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.1

    top_row = 435
    bottom_row = 40
    current_col = 525
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.1
 
    bounding_box([5, 430], :width => 515, :height => 380) do
      text "Deklaracja zgody na przetwarzanie danych", size: 7, :style => :bold
      move_down 3
      text "Niniejszym wyrażam dobrowolną zgodę na przetwarzanie moich danych osobowych podanych przeze mnie lub osoby trzecie, w tym danych dotyczących mojego stanu " +
           "zdrowia i nałogów, przez TU Allianz Życie Polska S.A. w zakresie i dla celów związanych z wykonaniem umów ubezpieczenia na życie. Ponadto oświadczam, że wyrażam " +
           "zgodę na przekazywanie ww. danych dotyczących umów ubezpieczenia na życie Allianz SE, z siedzibą D-80802  Monachium, Koeniginstrasse  28 i Kolnische " +
           "Ruckversicherungs-Gesellschaft AG z siedzibą NiederlassungWien, Renngasse 58 w związku z reasekurowaniem ryzyka przyjętego przez TU Allianz Życie Polska S.A. z " +
           "tytułu umowy ubezpieczenia na życie. Zgody powyższe obejmują również przetwarzanie ww. danych osobowych w przyszłości, o ile nie zmieni się cel ich przetwarzania. " +   
           "\n" + "\n" +
           "Niniejszym wyrażam zgodę na udostępnianie moich danych osobowych, w tym teleadresowych podanych dobrowolnie przeze mnie podmiotom świadczącym usługi " +
           "medyczne, w celu zawarcia umowy na świadczenie usług medycznych wynikających z umowy ubezpieczenia. " +
           "\n" + "\n" +
           "Oświadczam, że zostałem/am poinformowany przez TU Allianz Życie Polska S.A. o zasadach i prawach wynikających z ustawy z dnia 29 sierpnia 1997 roku o ochronie " +
           "danych osobowych (Dz.U.Nr 133, poz.883 z późn.zm), a w szczególności o tym, że posiadam prawo do wglądu do swoich danych i ich poprawiania oraz pisemnego żądania " +
           "zaprzestania przetwarzania danych, które to prawo przysługuje mi zarówno do TU Allianz Życie Polska S.A. jak również do podmiotów, którym dane zostały udostępnione. " +
           "Jednocześnie wyrażam zgodę, aby niniejszy dokument oświadczenia, dokumenty potwierdzające warunki objęcia ochroną zostały przedłożone TU Allianz Życie Polska S.A. " +
           "na mój rachunek. Moje oświadczenie stanowi zwolnienie z tajemnicy ubezpieczeniowej w rozumieniu art.19 ustawy z dnia 22 maja 2003 r. o działalności ubezpieczeniowej " +
           "(Dz.U. z 2003 r. Nr 124, poz.1151 ze zm.) w zakresie danych nim objętych. ", size: 7, :align => :justify

      move_down 7
      text "Oświadczenia końcowe", size: 7, :style => :bold
      move_down 3
      text "Potwierdzam, że wszelkie dane zawarte w tej deklaracji są prawdziwe i zgodne z moją najlepszą wiedzą. W razie zatajenia lub podania nieprawdziwych informacji TU Allianz " +
           "Życie Polska S.A. nie ponosi odpowiedzialności na warunkach przewidzianych przez przepisy Kodeksu cywilnego. Upoważniam lekarzy  oraz  placówki  służby  zdrowia  do " +
           "udzielenia pełnej informacji o moim stanie zdrowia, w tym również po mojej śmierci, a TU Allianz Życie Polska S.A. do  zasięgania  informacji  medycznych  dotyczących " +
           "mojego fizycznego i psychicznego stanu zdrowia u każdego lekarza, u którego zasięgałem/am porad lub przez którego byłem/am badany/a (powyższe upoważnienie dotyczy " +
           "również wszelkich placówek medycznych w szczególności przychodni, szpitali).", size: 7, :align => :justify

      draw_text "Wyrażam zgodę.                             Nie wyrażam zgody", :at => [ 12, 143], size: 8  

      current_row = 150
      current_col = 0
      stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
      stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
      stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
      stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

      current_row = 150
      current_col = 135
      stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
      stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
      stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
      stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5

      move_down 23
      text "na udostępnianie na pisemną  prośbę  innych  zakładów  ubezpieczeń  informacji  dotyczących  moich  danych  osobowych  w  zakresie  potrzebnym  do  oceny  ryzyka " +
           "ubezpieczeniowego, weryfikacji danych podanych przeze mnie przy zawieraniu umowy, ustalenia prawa do świaczenia z zawartej umowy ubezpieczenia  i  wysokości  tego " +
           "świadczenia, a także do udzielenia przez TU Allianz Życie Polska S.A. informacji o przyczynie mojej śmierci lub informacji niezbędnych do ustalenia prawa Uprawnionego do " +
           "świadczenia z tytułu umowy ubezpieczenia i jego wysokości, w myśl przepisu art.22 ust.5 Ustawy o działaności ubezpieczeniowej. Brak wskazania  oznacza  niewyrażenie " +
           "zgody na udostępnianie informacji innym zakładom ubezpieczeń.", size: 7, :align => :justify

      move_down 7
      text "Pełnomocnictwo", size: 7, :style => :bold
      move_down 3
      text "Udzielam Ubezpieczającemu pełnomocnictwo do reprezentowania mnie, w tym składania wszelkich oświadczeń  woli,  wcześniej  ze  mną  uzgodnionych,  koniecznych  do " +
           "zmiany, w tym także sumy ubezpieczenia, zawartych na moją rzecz umów ubezpieczenia na życie, do której niniejszym przystępuję. Pełnomocnictwo to obejmuje również " +
           "umocowanie do wyrażania zgody w moim imieniu na przedłużanie, w tym również na zmienionych warunkach, umowy ubezpieczenia na kolejne okresy roczne w formie i na " +
           "zasadach określonych w ogólnych warunkach ubezpieczenia Allianz Rodzina, Allianz Rodzina Prestige. ", size: 7, :align => :justify
      move_down 3
      text "* W przypadku braku zgody prosimy o postawienie X w polu poniżej.", size: 7
      move_down 3
      text "Ubezpieczony", size: 7, :style => :bold

      draw_text "Nie wyrażam zgody", :at => [ 80, 3], size: 8  

      current_row = 10
      current_col = 70
      stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
      stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
      stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
      stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5


      #transparent(0.5) { stroke_bounds }
    end

  end

  def data_page_3(coverage)
    start_new_page

    left_col = 0
    right_col = 525
    current_row = 760
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.1

    left_col = 0
    right_col = 525
    current_row = 460
    stroke_line [left_col, current_row], [right_col, current_row], self.line_width = 0.1

    top_row = 760
    bottom_row = 460
    current_col = 0
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.1

    top_row = 760
    bottom_row = 460
    current_col = 525
    stroke_line [current_col, top_row], [current_col, bottom_row], self.line_width = 0.1

    bounding_box([5, 755], :width => 515, :height => 290) do
      text "Klauzula informacyjna", size: 7, :style => :bold
      move_down 3
      text "Informujemy, że:" + "\n" +
           "Dane osobowe podane w niniejszym wniosku:" + "\n" +
           "a) będą przetwarzane przez Towarzystwo Ubezpieczeń Allianz Życie Polska S.A. (Administratora) z siedzibą w Warszawie, przy ul. Rodziny Hiszpańskich 1, 02-685 " +
           "Warszawa, w celu oceny ryzyka i podjęcia decyzji o zawarciu umowy ubezpieczenia oraz późniejszej obsługi tej umowy i jej wykonania, w celu analitycznym oraz w celu " +
           "marketingu bezpośredniego własnych produktów lub usług. Podanie danych jest dobrowolne, ale niezbędne do zawarcia umowy. Przysługuje Pani/Panu prawo dostępu do " +
           "treści danych i prawo ich poprawiania. " + "\n" +
           "b) nie będą nikomu udostępnione, za  wyjątkiem  wypadków  obowiązkowego  udzielenia  informacji  oreślonych  w  ustawie  o  działalności  ubezpieczeniowego  lub  jeżeli " +
           "Ubezpieczony/Ubezpieczający wyraził na to pisemną zgodę. " + "\n" +
           "W przypadku wyrażenia przez Panią/Pana zgody w ramach klauzuli marketingowej Pani/Pana dane będą udostępnione przez Administratora następującym podmiotom: " +
           "Towarzystwu Ubezpieczeń i Reasekuracji Allianz Polska S.A., Powszechnemu Towarzystwu Emerytalnemu Allianz Polska S.A. oraz funduszom przez  niego  zarządzanym, " +
           "Towarzystwu Funduszy Inwestycyjnych Allianz Polska S.A., Allianz Polska Services sp. z o.o., (adres  siedziby  ww.  podmiotów:  ul.  Rodziny  Hiszpańskich  1,  02-685 " +
           "Warszawa), zwanym dalej 'Spółkami Grupy Allianz Polska'. Ma  Pani/Pan  prawo  dostępu  do  treści  swoich  danych,  ich  poprawiania  oraz  prawo  pisemnego  żądania " +
           "zaprzestania przetwarzania danych, jak również sprzeciwu, które to uprawnienia przysługują w stosunku do każdego z ww. podmiotów. " + "\n" +
           "W przypadku  zawierania  przez  Panią/Pana  umowy  ubezpieczenia  w  związku  z  prowadzoną  działalnością  gospodarczą  wyrażona  poniżej  zgoda  w  ramach  klauzuli " +
           "marketingowej dotyczy ujawniania danych reprezentowanego przez Panią/Pana podmiotu i obejmuje zwolnienie z tajemnicy ubezpieczeniowej na rzecz pozostałych  Spółek " +
           "Grupy Allianz Polska.", size: 7, :align => :justify

      move_down 8
      text "Klauzula marketingowa (TUNZ003/v2.6):", size: 7, :style => :bold
      move_down 3
      text "Wyrażam dobrowolną zgodę* na udostępnianie moich danych, w tym danych osobowych, zawartych w niniejszym dokumencie oraz pozyskanych w związku z zawartymi i " +
           "wniskowanymi umowami, Spółkom Grupy Allianz Polska wymienionym w klauzuli informacyjnej w celach analitycznych i marketingowych (w tym zgodę na zestawienie moich " +
           "danych przez te Spółki) oraz przetwarzanie przez Administratora i Spółki Grupy Allianz Polska moich danych osobowych w celach  marketingowych  również  w  przypadku " +
           "niezawarcia umowy lub po jej rozwiązaniu.", size: 7, :align => :justify

      move_down 5
      text "* W przypadku braku zgody prosimy o postawienie X w polu obok", size: 7

      draw_text "Ubezpieczony",      :at => [ 300, 71], size: 8, :style => :bold  
      draw_text "Nie wyrażam zgody", :at => [ 390, 71], size: 8  

      current_row = 78
      current_col = 380
      stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
      stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
      stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
      stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5 


      move_down 8
      text "Klauzula zgody na przesyłanie informacji handlowych drogą elektroniczną (TUN003/E/v2.6):", size: 7, :style => :bold
      move_down 3
      text "Zgodnie z ustawą z dnia 18 lipca 2002 r. o świadczeniu usług drogą elektroniczną wyrażam zgodę* na przesyłanie informacji handlowych za pomocą  środków  komunikacji " +
           "elektronicznej, a także na przedstawienie oferty za pomocą środków porozumiewania się na odległość w rozumieniu art. 6 ust. 3 ustawy z dnia 2 marca 2001 r. o ochronie " +
           "niektórych praw konsumentów oraz o odpowiedzialności za szkodę wyrządzoną przez produkt niebezpieczny przez Administratora i Spółki Grupy Allianz Polska. ", size: 7, :align => :justify

      move_down 5
      text "* W przypadku braku zgody prosimy o postawienie X w polu obok", size: 7

      draw_text "Ubezpieczony",      :at => [ 300, 6], size: 8, :style => :bold  
      draw_text "Nie wyrażam zgody", :at => [ 390, 6], size: 8  

      current_row = 13
      current_col = 380
      stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
      stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
      stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5
      stroke_line [current_col+7, current_row], [current_col+7, current_row-7], self.line_width = 0.5 

      #transparent(0.5) { stroke_bounds }
    end

    draw_text "." *  90,                           :at => [  0, 390], size: 5  
    draw_text "." *  60,                           :at => [170, 390], size: 5  
    draw_text "." * 140,                           :at => [300, 390], size: 5  

    draw_text "Miejscowość",                       :at => [  0, 380], size: 7  
    draw_text "Data",                              :at => [170, 380], size: 7  
    draw_text "Czytelny podpis Ubezpieczonego",    :at => [300, 380], size: 7  
    text_box  "(podpis powinien być czytelny lub złożony w formi zwykle " +
              "używanej przez Ubezpieczonego, gdyż będzie przyjmowany " +
              "do weryfikacji osoby Ubezpieczonego przy dokonywanych " +
              "przez niego dyspozycjach w ramach umowy ubezpieczenia)", size: 6,
      :at => [300, 373], 
      :width => 220, 
      :height => 40

    draw_text "." *  90,                           :at => [  0, 290], size: 5  
    draw_text "." *  60,                           :at => [170, 290], size: 5  
    draw_text "." * 140,                           :at => [300, 290], size: 5  

    draw_text "Miejscowość",                       :at => [  0, 280], size: 7  
    draw_text "Data",                              :at => [170, 280], size: 7  
    draw_text "Czytelny podpis osoby reprezentującej Ubezpieczonego (4)",    :at => [300, 280], size: 7  


    draw_text "." *  60,                           :at => [170, 190], size: 5  
    draw_text "." * 140,                           :at => [300, 190], size: 5  

    draw_text "Data",                              :at => [170, 180], size: 7  
    draw_text "Czytelny podpis agenta/brokra",     :at => [300, 180], size: 7  


    move_down 370
    text "(4) Podpisuje osoba umocowana przez Ubezpieczającego do reprezentowania " +
         "i skłądania oświadczeń woli w jego imieniu w związku z zawarciem umowy grupowego ubezpieczenia na życie.", size: 5

  end

  def footer
    stroke_line [0, 10], [525,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
