class ListBenefitsNNW1Pdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(rotation, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @rotation = rotation
    @insurance = @rotation.insurance
    @company = @insurance.company
    @groups = @insurance.groups.by_number

    @view = view

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 11

    length_groups = @groups.length

    @groups.each_with_index do |current_group, i|
      logo
      header_left_corner
      data(current_group, @rotation)
      footer
      start_new_page if ((i+1) < length_groups)
    end

  end


  def logo
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner
    draw_text "NNW1 - Wykaz świadczeń", :at => [0, 775], size: 11, :style => :bold
    draw_text "Załącznik nr 25 do polisy grupowego ubezpieczenia", :at => [0, 760], size: 11, :style => :bold
    draw_text "następstw nieszczęśliwych wypadków",               :at => [0, 745], size: 11, :style => :bold
    draw_text "Nr polisy #{@insurance.number}", :at => [0, 719], size: 15

    text_box "#{@insurance.user.name}" +
             " - #{@insurance.user.agent_number}" , size: 11, :style => :bold, 
      :at => [290, 729], 
      :width => 250, 
      :height => 25
    draw_text "Firma: #{@company.name}", :at => [0, 695], size: 10
  end


  def data(current_group, current_rotation)
    current_row = 680
    start_col = 0
    end_col = 525
    stroke_line [start_col, current_row], [end_col, current_row], self.line_width = 0.5
    #pionowe boczne
    stroke_line [start_col, current_row], [start_col, current_row-350], self.line_width = 0.5
    stroke_line [end_col, current_row], [end_col, current_row-350], self.line_width = 0.5

    #pionowa 1 
    stroke_line [start_col+285, current_row], [start_col+285, current_row-225], self.line_width = 0.5


    current_row -= 15
    draw_text "Grupa osób ubezpieczonych nr:",    :at => [ start_col+5,   current_row], size: 7
    draw_text "#{current_group.number}",          :at => [ start_col+125, current_row], size: 12, :style => :bold
    draw_text "liczba osób:",                     :at => [ start_col+155, current_row], size: 7
    draw_text "#{count_insureds(current_group, current_rotation)}", :at => [ start_col+205, current_row], size: 12, :style => :bold

    draw_text "System świadczeń:",                :at => [ start_col+290, current_row], size: 7
    draw_text "proporcjonalnych",                 :at => [ start_col+395, current_row], size: 7
    draw_text "stałych",                          :at => [ start_col+480, current_row], size: 7


    # w modelu jest tariff_fixed? ? 'Stałych' : 'Proporcjonalnych'
    if current_group.tariff_fixed
      draw_text "x",                                :at => [ start_col+471, current_row], size: 8
    else
      draw_text "x",                                :at => [ start_col+386, current_row], size: 8
    end

    current_col = 385
    offset_row = 6
    kross_width = 7
    stroke_line [current_col, current_row+offset_row], [current_col, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row], [current_col+kross_width, current_row+offset_row], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row-kross_width], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col+kross_width, current_row+offset_row], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    # proporcjonalnych

    current_col = 470
    offset_row = 6
    kross_width = 7
    stroke_line [current_col, current_row+offset_row], [current_col, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row], [current_col+kross_width, current_row+offset_row], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row-kross_width], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col+kross_width, current_row+offset_row], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    # stałych


    current_row -= 20

    draw_text "Grupa ryzyka:",                    :at => [ start_col+5,   current_row], size: 7
    draw_text "#{current_group.risk_group}",      :at => [ start_col+65, current_row], size: 12, :style => :bold
  
    draw_text "Zakres ubezpieczenia:",            :at => [ start_col+290, current_row], size: 7
    draw_text "pełny",                            :at => [ start_col+395, current_row], size: 7
    draw_text "ograniczony",                      :at => [ start_col+480, current_row], size: 7

    # w modelu jest full_range? ? 'Pełny' : 'Ograniczony'
    if current_group.full_range
      draw_text "x",                                :at => [ start_col+386, current_row], size: 8
    else
      draw_text "x",                                :at => [ start_col+471, current_row], size: 8
    end

    current_col = 385
    offset_row = 6
    kross_width = 7
    stroke_line [current_col, current_row+offset_row], [current_col, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row], [current_col+kross_width, current_row+offset_row], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row-kross_width], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col+kross_width, current_row+offset_row], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    # pełny


    current_col = 470
    offset_row = 6
    kross_width = 7
    stroke_line [current_col, current_row+offset_row], [current_col, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row], [current_col+kross_width, current_row+offset_row], self.line_width = 0.5
    stroke_line [current_col, current_row+offset_row-kross_width], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    stroke_line [current_col+kross_width, current_row+offset_row], [current_col+kross_width, current_row+offset_row-kross_width], self.line_width = 0.5
    # ograniczony


    current_row -= 10
    stroke_line [start_col, current_row], [end_col, current_row], self.line_width = 0.5
    #pionowa 2
    stroke_line [start_col+40, current_row], [start_col+40,current_row-180], self.line_width = 0.5
    #pionowa 3
    stroke_line [start_col+410, current_row], [start_col+410,current_row-305], self.line_width = 0.5
    current_row -= 10
    draw_text "Suma ubezpiecznia (zł)",           :at => [ start_col+290, current_row], size: 7, :style => :bold
    draw_text "Składka za osobę (zł)",            :at => [ start_col+415, current_row], size: 7, :style => :bold
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Świadczenie na wypadek trwałego uszczerbku na zdrowiu",           :at => [ start_col+45, current_row], size: 7
    text_box "#{with_delimiter_and_separator(current_group.assurance)}", size: 7, :align => :right, 
      :at => [start_col+300, current_row+5], 
      :width => 100, 
      :height => 7
    text_box "#{with_delimiter_and_separator(current_group.assurance_component)}", size: 7, :align => :right, 
      :at => [start_col+415, current_row+5], 
      :width => 100, 
      :height => 7
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col-115, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Podwójne świadczenie na wypadek trwałego uszczerbku na zdrowiu",  :at => [ start_col+45, current_row], size: 7
    text_box "#{with_delimiter_and_separator(current_group.double_assurance)}", size: 7, :align => :right, 
      :at => [start_col+300, current_row+5], 
      :width => 100, 
      :height => 7
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col-115, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Świadczenie na wypadek śmierci",                                  :at => [ start_col+45, current_row], size: 7
    text_box "#{with_delimiter_and_separator(current_group.insurance_death_val)}", size: 7, :align => :right, 
      :at => [start_col+300, current_row+5], 
      :width => 100, 
      :height => 7
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col-115, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Przeszkolenie zawodowe inwalidów",                                :at => [ start_col+45, current_row], size: 7
    text_box "#{with_delimiter_and_separator(current_group.insurance_training_val)}", size: 7, :align => :right, 
      :at => [start_col+300, current_row+5], 
      :width => 100, 
      :height => 7
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col-115, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Zawał serca albo udar mózgu dla osób poniżej 30-go roku życia",   :at => [ start_col+45, current_row], size: 7
    text_box "#{with_delimiter_and_separator(current_group.insurance_infarct30_val)}", size: 7, :align => :right, 
      :at => [start_col+300, current_row+5], 
      :width => 100, 
      :height => 7
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col-115, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Świadczenie opiekuńcze na terenie Rzeczypospolitej Polskiej",     :at => [ start_col+45, current_row], size: 7
    #text_box "#{with_delimiter_and_separator(current_group.????)}", size: 7, :align => :right, 
    #  :at => [start_col+300, current_row+5], 
    #  :width => 100, 
    #  :height => 7
    current_row -= 5
    stroke_line [start_col, current_row], [end_col, current_row], self.line_width = 0.5 # linia kończąca sekcję podstawową

    current_row -= 10
    draw_text "Koszty leczenia",                  :at => [ start_col+45, current_row], size: 7
    if current_group.treatment > 0
      text_box "#{with_delimiter_and_separator(current_group.treatment)}", size: 7, :align => :right, 
        :at => [start_col+300, current_row+5], 
        :width => 100, 
        :height => 7

      text_box "#{with_delimiter_and_separator(current_group.treatment_component)}", size: 7, :align => :right, 
        :at => [start_col+415, current_row+5], 
        :width => 100, 
        :height => 7
    end
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Zasiłek ambulatoryjny",            :at => [ start_col+45, current_row], size: 7
    if current_group.ambulatory > 0
      text_box "#{with_delimiter_and_separator(current_group.ambulatory)}", size: 7, :align => :right, 
        :at => [start_col+300, current_row+5], 
        :width => 100, 
        :height => 7

      text_box "#{with_delimiter_and_separator(current_group.ambulatory_component)}", size: 7, :align => :right, 
        :at => [start_col+415, current_row+5], 
        :width => 100, 
        :height => 7
    end
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Zasiłek szpitalny",                :at => [ start_col+45, current_row], size: 7
    if current_group.hospital > 0
      text_box "#{with_delimiter_and_separator(current_group.hospital)}", size: 7, :align => :right, 
        :at => [start_col+300, current_row+5], 
        :width => 100, 
        :height => 7

      text_box "#{with_delimiter_and_separator(current_group.hospital_component)}", size: 7, :align => :right, 
        :at => [start_col+415, current_row+5], 
        :width => 100, 
        :height => 7
    end
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Zawał serca albo udar mózgu",      :at => [ start_col+45, current_row], size: 7
    if current_group.infarct > 0
      text_box "#{with_delimiter_and_separator(current_group.infarct)}", size: 7, :align => :right, 
        :at => [start_col+300, current_row+5], 
        :width => 100, 
        :height => 7

      text_box "#{with_delimiter_and_separator(current_group.infarct_component)}", size: 7, :align => :right, 
        :at => [start_col+415, current_row+5], 
        :width => 100, 
        :height => 7
    end
    current_row -= 5
    stroke_line [start_col+40, current_row], [end_col, current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Trwala niezdolność do pracy",      :at => [ start_col+45, current_row], size: 7
    if current_group.inability > 0
      text_box "#{with_delimiter_and_separator(current_group.inability)}", size: 7, :align => :right, 
        :at => [start_col+300, current_row+5], 
        :width => 100, 
        :height => 7

      text_box "#{with_delimiter_and_separator(current_group.inability_component)}", size: 7, :align => :right, 
        :at => [start_col+415, current_row+5], 
        :width => 100, 
        :height => 7
    end
    current_row -= 5
    stroke_line [start_col, current_row], [end_col, current_row], self.line_width = 0.5 # linia kończąca sekcję dodatkową

    current_row -= 10
    draw_text "Składka podstawowa za osobę",      :at => [ start_col+5, current_row], size: 7, :style => :bold
    text_box "#{with_delimiter_and_separator(current_group.sum_component)}", size: 7, :align => :right, :style => :bold, 
      :at => [start_col+415, current_row+5], 
      :width => 100, 
      :height => 7

    current_row -= 5
    stroke_line [start_col, current_row], [end_col, current_row], self.line_width = 0.5 # 

    text_box "#{with_delimiter_and_separator(current_group.sum_after_discounts)}", size: 7, :align => :right, :style => :bold, 
      :at => [start_col+415, current_row-45], 
      :width => 100, 
      :height => 7
    stroke_line [start_col, current_row-55], [end_col, current_row-55], self.line_width = 0.5 # linia kończąca sekcję zniżek

    text_box "#{with_delimiter_and_separator(current_group.sum_after_increases)}", size: 7, :align => :right, :style => :bold, 
      :at => [start_col+415, current_row-100], 
      :width => 100, 
      :height => 7
    stroke_line [start_col, current_row-110], [end_col, current_row-110], self.line_width = 0.5 # linia kończąca sekcję zwyżek

    # zniżki
    current_row = 440
    @current_group_discounts = current_group.discounts.where("discount_increase < 0")

    @current_group_discounts.each do |current_discounts|
      current_row -= 10
      draw_text "Zniżka #{with_delimiter_and_separator(current_discounts.discount_increase)} %  #{current_discounts.description}",      :at => [ start_col+10, current_row], size: 7
    end


    # zwyżki
    current_row = 385
    @current_group_discounts = current_group.discounts.where("discount_increase > 0")

    @current_group_discounts.each do |current_discounts|
      current_row -= 10
      draw_text "Zwyżka #{with_delimiter_and_separator(current_discounts.discount_increase)} %  #{current_discounts.description}",      :at => [ start_col+10, current_row], size: 7
    end



    ##################################
    #frame II
    current_row = 310
    start_col = 0
    end_col = 525
    stroke_line [start_col, current_row], [end_col,current_row], self.line_width = 0.5
    #pionowe boczne
    stroke_line [start_col, current_row], [start_col,current_row-60], self.line_width = 0.5
    stroke_line [end_col, current_row], [end_col,current_row-60], self.line_width = 0.5


    current_row -= 10
    draw_text "Ubezpieczenie roczne",                                                                :at => [ start_col+5,   current_row], size: 7
    current_row -= 10
    draw_text "(Należy wypełnić wszystkie pola w przypadku płatności ratalnej jak i jednorazowej.)", :at => [ start_col+5, current_row], size: 7
    current_row -= 5
    stroke_line [start_col, current_row], [end_col,current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Składka roczna za osobę = #{with_delimiter_and_separator(current_group.sum_after_increases)} zł",                          :at => [ start_col+5,   current_row], size: 8
    current_row -= 10
    draw_text "/ 12 = #{with_delimiter_and_separator(current_group.sum_after_monthly)} zł",                                          :at => [ start_col+150, current_row], size: 8
    current_row -= 10
    draw_text "x 12 x liczba osób = #{with_delimiter_and_separator(count_insureds(current_group, current_rotation)*current_group.sum_after_year)} zł", :at => [ start_col+210, current_row], size: 8

    current_row -= 5
    stroke_line [start_col, current_row], [end_col,current_row], self.line_width = 0.5


    ##################################
    #frame III
    current_row -= 20
    start_col = 0
    end_col = 525
    stroke_line [start_col, current_row], [end_col,current_row], self.line_width = 0.5
    #pionowe boczne
    stroke_line [start_col, current_row], [start_col,current_row-60], self.line_width = 0.5
    stroke_line [end_col, current_row], [end_col,current_row-60], self.line_width = 0.5

    current_row -= 10
    draw_text "Ubezpieczenie roczne",                                                                :at => [ start_col+5,   current_row], size: 7
    current_row -= 10
    draw_text "(Należy wypełnić wszystkie pola w przypadku płatności ratalnej jak i jednorazowej.)", :at => [ start_col+5, current_row], size: 7
    current_row -= 5
    stroke_line [start_col, current_row], [end_col,current_row], self.line_width = 0.5

    current_row -= 10
    draw_text "Składka roczna za osobę = _____,__",   :at => [ start_col+5,   current_row], size: 8
    current_row -= 10
    draw_text "/ 12 = _____,__",                      :at => [ start_col+150, current_row], size: 8
    current_row -= 10
    draw_text "x 12 x liczba osób = _____,__",        :at => [ start_col+210, current_row], size: 8

    current_row -= 5
    stroke_line [start_col, current_row], [end_col,current_row], self.line_width = 0.5
  end

  def count_insureds(current_group, current_rotation)
    Coverage.where(group: current_group, rotation: current_rotation).length
  end

  def footer
    draw_text "#{@company.address_city},", :at => [ 5,39]

    draw_text "." * 80, :at => [0, 35], size: 6
    draw_text "Miejscowość i data", :at => [35, 25], size: 7 

    draw_text "." * 80, :at => [180, 35], size: 6
    draw_text "Ubezpieczający", :at => [220, 25], size: 7 
    draw_text "(podpis i pieczęć)", :at => [217, 16], size: 7, :style => :italic 

    draw_text "." * 80, :at => [350, 35], size: 6
    draw_text "Przedstawiciel TUiR Allianz Polska S.A.", :at => [360, 25], size: 7 
    draw_text "(podpis i pieczęć)", :at => [360, 16], size: 7, :style => :italic 


    stroke_line [0, 10], [525,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
