class ListInsuredsNNW2Pdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(rotation, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @rotation = rotation
    @view = view
    @insurance_pay = @rotation.insurance.pay

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10

    @coverages = Coverage.joins(:rotation, :insured, :group).by_rotation(@rotation.id).references(:rotation, :insured, :group)
      .order("individuals.last_name, individuals.last_name, individuals.address_city").all

    length_coverages = @coverages.length

    display_data_table

    repeat(:all, :dynamic => true) do
      logo
      header_left_corner
      footer
      text "Strona #{page_number} / #{page_count}", size: 7, :align => :left, :valign => :bottom  
    end

  end


  def logo
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner
    draw_text "NNW2 - Lista osób ubezpieczonych (umowa imienna)", :at => [0, 775], size: 11, :style => :bold
    draw_text "Załącznik nr 4 do polisy grupowego ubezpieczenia", :at => [0, 760], size: 11, :style => :bold
    draw_text "następstw nieszczęśliwych wypadków",               :at => [0, 745], size: 11, :style => :bold
    draw_text "Nr polisy #{@rotation.insurance.number}", :at => [0, 719], size: 15

    text_box "#{@rotation.insurance.user.name}" +
             " - #{@rotation.insurance.user.agent_number}" , size: 11, :style => :bold, 
      :at => [290, 729], 
      :width => 250, 
      :height => 25
  end


  def display_data_table
    bounding_box([0,700], :width => 525, :height => 585) do 
      if table_data.empty?
        text "No Events Found"
      else
        table( table_data,
              :header => true,
              :column_widths => [23, 132, 132, 60, 87, 36, 55],
              #:row_colors => ["ffffff", "c2ced7"],
              :cell_style => { size: 7, :border_width => 0.5 }
            ) do
          columns(0).align = :right
          columns(5).align = :center
          columns(6).align = :center
          row(0).font_style = :bold 
          row(0).align = :left 
          #row(0).background_color = "#FF0000"
        end             
      end
    end  
  end

  def table_data
    @lp = 0
    table_data ||= [["Lp.",
                     "Nazwisko i imię",
                     "Adres",
                     "PESEL",
                     "Charakter wykonywanej pracy",
                     "Grupa ryzyka",
                     "Grupa osób ubezp. Nr"]] + 
                     @coverages.map { |p| [ next_lp, 
                                            p.insured.last_first_name,
                                            p.insured.street_house_number + "\n" + p.insured.postal_code_city, 
                                            p.insured.pesel, 
                                            p.insured.profession, 
                                            p.group.risk_group,
                                            p.group.number] }
  end

  def next_lp
    @lp = @lp +1
    return @lp 
  end


  def footer
    draw_text "#{@rotation.insurance.company.address_city},", :at => [ 5,64]

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
