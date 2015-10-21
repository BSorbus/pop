class ListInsuredsPdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(rotation, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :landscape)
    #super()
    @rotation = rotation
    @view = view
    @insurance_pay = @rotation.insurance.pay
    @company = rotation.insurance.company

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10

    @coverages = Coverage.joins(:rotation, :insured, :group).by_rotation(@rotation.id).references(:rotation, :insured, :group)
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
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    #image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [635, 535], :height => 34
  end

  def header_left_corner
    draw_text "#{@company.name}", :at => [0, 525], :style => :bold
    draw_text "Ubezpieczający (nazwa firma)", :at => [0, 515], size: 7

    draw_text "Nr polisy #{@rotation.insurance.number}", :at => [0, 494], size: 15

    draw_text "#{@rotation.insurance.user.name}" +
             " - #{@rotation.insurance.user.agent_number}", :at => [290, 494] , size: 11, :style => :bold 
  end


  def display_data_table
    bounding_box([0,480], :width => 770, :height => 430) do 
      if table_data.empty?
        text "No Events Found"
      else
        table( table_data,
              :header => true,
              :column_widths => [23, 127, 127, 60, 87, 36, 138, 60, 112],
              #:row_colors => ["ffffff", "c2ced7"],
              :cell_style => { size: 7, :border_width => 0.5 }
            ) do
          columns(0).align = :right
          columns(5).align = :center
          columns(7).align = :right
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
                     "Zakres ubezp. (według bieżącej polisy)",
                     "Składka #{@rotation.insurance.pay_name}",
                     "Nowy zakres",]] + 
                     @coverages.map { |p| [ next_lp, 
                                            p.insured.last_first_name,
                                            p.insured.street_house_number + "\n" + p.insured.postal_code_city, 
                                            p.insured.pesel, 
                                            p.insured.profession, 
                                            p.group.risk_group,
                                            p.group.fullinfo_for_pdf,
#                                            with_delimiter_and_separator(p.group.sum_after_monthly),
                                            with_delimiter_and_separator(contribution_for_pay(p.group)),
                                            ""] }
  end

  def next_lp
    @lp = @lp +1
    return @lp 
  end


  def contribution_for_pay(current_group)
    case @insurance_pay
    when 'K'
      current_group.sum_after_monthly*3
    when 'M'
      current_group.sum_after_monthly
    when 'P'
      current_group.sum_after_monthly*6
    when 'R'
      current_group.sum_after_monthly*12
    else
      'insurance.pay - Error !'
    end
  end

  def footer
    draw_text "Opis skrótów: KL-koszty leczenia, ZA-zasiłek ambulatoryjny, ZSZ-zasiłek szpitalny, ZS/UM-zawał serca/udar mózgu, TNP-trwała niezdolność do pracy", :at => [0, 14], size: 8
    stroke_line [0, 10], [770,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
