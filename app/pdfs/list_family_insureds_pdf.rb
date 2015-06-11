class ListFamilyInsuredsPdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(family_rotation, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @family_rotation = family_rotation
    @view = view
    @family_pay = @family_rotation.family.pay
    @family_assurance_component = @family_rotation.family.assurance_component
    @company = family_rotation.family.company

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10

    @family_coverages = FamilyCoverage.joins(:family_rotation, :insured).by_family_rotation(@family_rotation.id).references(:family_rotation, :insured)
      .order("individuals.last_name, individuals.last_name, individuals.address_city").all


    display_data_table

    repeat(:all, :dynamic => true) do
      logo
      header_left_corner
      footer
      text "Strona #{page_number} / #{page_count}", size: 7, :align => :left, :valign => :bottom  
    end

  end


  def logo
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner
    draw_text "Lista ubezpieczonych", :at => [0, 775]
    draw_text "#{@company.name}", :at => [0, 760], :style => :bold
    draw_text "Ubezpieczający (nazwa firma)", :at => [0, 749], size: 7
    draw_text "Nr polisy #{@family_rotation.family.number}", :at => [0, 719], size: 15

    text_box "#{@family_rotation.family.user.name}" +
             " - #{@family_rotation.family.user.agent_number}" , size: 11, :style => :bold, 
      :at => [290, 729], 
      :width => 250, 
      :height => 25
  end


  def display_data_table
    bounding_box([0,700], :width => 525, :height => 590) do 
      if table_data.empty?
        text "No Events Found"
      else
        table( table_data,
              :header => true,
              :column_widths => [23, 158, 158, 60, 76, 50],
              #:row_colors => ["ffffff", "c2ced7"],
              :cell_style => { size: 7, :border_width => 0.5 }
            ) do
          columns(0).align = :right
          columns(4).align = :center
          columns(5).align = :right
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
                     "Data ur."]] + 
                     @family_coverages.map { |p| [ next_lp, 
                                    p.insured.last_first_name,
                                    p.insured.street_house_number + "\n" + p.insured.postal_code_city, 
                                    p.insured.pesel, 
                                    p.insured.profession,
                                    p.insured.birth_date.strftime("%d.%m.%Y") ] }
  end

  def next_lp
    @lp = @lp +1
    return @lp 
  end


  def footer
    draw_text "Opis skrótów: KL-koszty leczenia, ZA-zasiłek Ambulatoryjny, ZSZ-zasiłek szpitalny, ZS/UM-zawał serdca/udar muzgu, TNP-trwała niezdolność do pracy", :at => [0, 14], size: 8
    stroke_line [0, 10], [770,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
