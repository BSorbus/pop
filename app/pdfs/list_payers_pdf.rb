class ListPayersPdf < Prawn::Document
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
    @company = rotation.insurance.company

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10

    #@coverages = Coverage.joins(:rotation, :payer, :group).by_rotation(@rotation.id).references(:rotation, :payer, :group).order("individuals.last_name, individuals.last_name, individuals.address_city").all

    #@coverages = Coverage.select('"coverages"."payer_id", count("coverages"."payer_id") AS ilosc').joins(:payer)
    # powyższe działa ale chcąc zliczać "ilość" zrezygnowałem z tego
    @coverages = Coverage.select('"coverages"."payer_id"').joins(:payer)
      .select('"individuals"."last_name", "individuals"."first_name", "individuals"."address_city"')
      .by_rotation(@rotation.id)
      .group('"coverages"."payer_id", "individuals"."last_name", "individuals"."first_name", "individuals"."address_city"')
      .order('"individuals"."last_name", "individuals"."first_name", "individuals"."address_city"').all


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
    draw_text "Lista płatników", :at => [0, 775]
    draw_text "#{@company.name}", :at => [0, 760], :style => :bold
    draw_text "Ubezpieczający (nazwa firma)", :at => [0, 749], size: 7
    draw_text "Nr polisy #{@rotation.insurance.number}", :at => [0, 719], size: 15

    text_box "#{@rotation.insurance.user.name}" +
             " - #{@rotation.insurance.user.agent_number}" , size: 11, :style => :bold, 
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
              :column_widths => [23, 158, 158, 60, 66, 60],
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
      display_total_table  
    end  
  end

  def table_data
    @lp = 0
    @sum_all_insureds = 0
    @sum_all_contributions = 0
    table_data ||= [["Lp.",
                     "Nazwisko i imię",
                     "Adres",
                     "PESEL",
                     "Liczba osób za które jest opłacana skł.",
                     "Składka #{@rotation.insurance.pay_name}"]] + 
                     @coverages.map { |p| [ next_lp, 
                                            p.payer.last_first_name,
                                            p.payer.street_house_number + "\n" + p.payer.postal_code_city, 
                                            p.payer.pesel, 
                                            sum_insureds_for_current_payer(p.payer.id),
                                            with_delimiter_and_separator(sum_monthly_contribution_for_current_payer(p.payer.id))] }
  end

  def next_lp
    @lp = @lp +1
    return @lp 
  end

  def sum_insureds_for_current_payer(id_payer)
    sum_current_insureds = Coverage.where(rotation_id: @rotation.id, payer_id: id_payer).all.size

    @sum_all_insureds += sum_current_insureds
    return sum_current_insureds
  end

  def sum_monthly_contribution_for_current_payer(id_payer)
    @coverage_contribution = Coverage.joins(:rotation, :payer, :group).where(rotation: @rotation.id, payer: id_payer).references(:rotation, :payer, :group).all

    case @insurance_pay
    when 'K'
      sum_current = @coverage_contribution.sum(:sum_after_monthly)*3
    when 'M'
      sum_current = @coverage_contribution.sum(:sum_after_monthly)
    when 'P'
      sum_current = @coverage_contribution.sum(:sum_after_monthly)*6
    when 'R'
      sum_current = @coverage_contribution.sum(:sum_after_monthly)*12
    else
      sum_current = 'insurance.pay - Error !'
    end
    @sum_all_contributions += sum_current
    return sum_current
  end

  def display_total_table
    #move_down 5    
    #stroke_line [350, cursor], [525,cursor], self.line_width = 2
    move_down 5    
    text_box "Razem:",                                                  :at => [355, cursor], :width => 40, :height => 12, size: 9, :align => :right  
    text_box "#{@sum_all_insureds}",                                    :at => [400, cursor], :width => 60, :height => 12, size: 9, :style => :bold, :align => :center  
    text_box "#{with_delimiter_and_separator(@sum_all_contributions)}", :at => [465, cursor], :width => 60, :height => 12, size: 9, :style => :bold, :align => :right  
    move_down 12    
    stroke_line [350, cursor], [525,cursor], self.line_width = 2
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
