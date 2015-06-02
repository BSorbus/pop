class GroupsWithInsuredsPdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(rotation, view, add_remove)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)

    @rotation = rotation
    if add_remove == "A" # A-dd
      @groups = @rotation.groups_for_coverages_add.order(:number)
      title1 = "PRZYSTĄPIENIE DO"
      title2 = "włączone"
    else
      @groups = @rotation.groups_for_coverages_remove.order(:number)
      title1 = "WYSTĄPIENIE Z"
      title2 = "wyłączone"
    end

    @insurance = @rotation.insurance
    @company = @insurance.company
    @user = @insurance.user
    @view = view

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10


    bounding_box([0,660], :width => 525, :height => 545) do 
      @groups.each do |group|
        display_data_group(group, add_remove)
      end
    move_down 5             
    text "Składka miesięczna za polisę wynosi:  #{with_delimiter_and_separator(sum_monthly_contribution_for_all)}", size: 10  
    end
    #move_down 5             
    #text "Składka miesięczna za polisę wynosi:  #{with_delimiter_and_separator(sum_monthly_contribution_for_all)}", size: 10  



    repeat(:all, :dynamic => true) do
      logo
      header_left_corner(title1, title2)
      footer
      text "Strona #{page_number} / #{page_count}", size: 7, :align => :left, :valign => :bottom  
    end

  end


  def logo
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner(title_one, title_two)
    draw_text "RAPORT O ROTACJI OSÓB UBEZPIECZONYCH POLISĄ GRUPOWEGO",  :at => [0, 775], size: 10
    draw_text "UBEZPIECZENIA NNW W FORMIE IMIENNEJ",                    :at => [0, 760], size: 10
    draw_text " - #{title_one} UBEZPIECZENIA",                          :at => [0, 745], size: 11, :style => :bold
    draw_text "Nr polisy #{@insurance.number}",                         :at => [0, 725], size: 15, :style => :bold

    text_box "#{@user.name}" +
             " - #{@user.agent_number}" , size: 11, :style => :bold, 
      :at => [290, 735], 
      :width => 250, 
      :height => 25

    draw_text "Ubezpieczający:",      :at => [  0, 705], size: 10
    draw_text "#{@company.name}",     :at => [  85, 705], size: 10, :style => :bold

    draw_text "Okres ubezpieczenia:", :at => [  0, 690], size: 9
    draw_text "#{@insurance.valid_from.strftime("%d.%m.%Y")} - #{@insurance.applies_to.strftime("%d.%m.%Y")}",:at => [ 115, 690], size: 9, :style => :bold

    draw_text "Do ww. umowy grupowego ubezpieczenia NNW z dniem                       zostają                        następujące osoby:", :at => [  0, 675], size: 9
    draw_text "#{@rotation.rotation_date.strftime("%d.%m.%Y")}              #{title_two}", :at => [ 255, 675], size: 9, :style => :bold
  end


  def display_data_group(group, add_remove)
    table( table_group(group, add_remove),
          :header => true,
          #:column_widths => [525],
          :cell_style => { size: 7, :border_width => 0.5 }
        ) do
      #columns(0).font_style = :bold
    end
    move_down 22             
  end

  def display_coverages_table(g, ar)
    make_table( table_coverage_data(g, ar),
          :header => true,
          :column_widths => [23, 160, 160, 60, 122],
          #:column_widths => [23, 132, 132, 60, 87, 36, 55],
          #:row_colors => ["ffffff", "c2ced7"],
          :cell_style => { size: 7, :border_width => 0.5 }
        ) do
      columns(0).align = :right
      columns(5).align = :center
      columns(6).align = :center
      #row(0).font_style = :bold 
      row(0).align = :left 
      #row(0).background_color = "#FF0000"
    end             
  end

  def table_group(g, ar)
    table_group ||= [
                      [{:content => "Nr Grupy: #{g.number}   Grupa ryzyka: #{g.risk_group}   Suma ubezpieczenia: #{with_delimiter_and_separator(g.assurance)}  Świadczenia dodatkowe: #{g.additional_for_pdf_in_new_line}", :colspan => 7, :width => 525, :font_style => :bold }],
                   #   [ "B", "C", "D", "E", "F", "G"],
                      [{:content => display_coverages_table(g, ar), :colspan => 7, :width => 525 }],
                      [{:content => "Liczba osób po zmianach: #{g.coverages.where(rotation: @rotation).size}    Składka miesięczna za osobę wynosi: #{with_delimiter_and_separator(g.sum_after_monthly)}", :colspan => 7, :width => 525, :font_style => :bold }]
                    ]  
  end


  def table_coverage_data(g, ar)
    @lp = 0
    if ar == "A" # A-dd
      @coverages = @rotation.coverages_add.includes(:insured).where(group: g).references(:insured).order('"individuals"."last_name", "individuals"."first_name", "individuals"."address_city"')
    else
      @coverages = @rotation.coverages_remove.includes(:insured).where(group: g).references(:insured).order('"individuals"."last_name", "individuals"."first_name", "individuals"."address_city"')
    end
    table_data ||= [["Lp.",
                     "Nazwisko i imię",
                     "Adres",
                     "PESEL",
                     "Charakter wykonywanej pracy"]] + 
                      @coverages.map { |p| [ next_lp, 
                                            p.insured.last_first_name,
                                            p.insured.street_house_number + "\n" + p.insured.postal_code_city, 
                                            p.insured.pesel, 
                                            p.insured.profession] }
  end

  def next_lp
    @lp = @lp +1
    return @lp 
  end

  def sum_monthly_contribution_for_all
    Coverage.joins(:group).where(rotation: @rotation.id).references(:group).all.sum(:sum_after_monthly)
  end



  def footer
    draw_text "#{@company.address_city},", :at => [ 5,64]

    draw_text "." * 80, :at => [0, 59], size: 6
    draw_text "Miejscowość i data", :at => [35, 50], size: 7 

    draw_text "." * 80, :at => [180, 59], size: 6
    draw_text "Ubezpieczający", :at => [220, 50], size: 7 
    draw_text "(podpis i pieczęć)", :at => [217, 41], size: 7, :style => :italic 

    draw_text "." * 80, :at => [350, 59], size: 6
    draw_text "Przedstawiciel TUiR Allianz Polska S.A.", :at => [360, 50], size: 7 
    draw_text "(podpis i pieczęć)", :at => [360, 41], size: 7, :style => :italic 


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
