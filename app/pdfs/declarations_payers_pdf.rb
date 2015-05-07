class DeclarationsPayersPdf < Prawn::Document

  def initialize(rotation, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @rotation = rotation
    @view = view

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 11

    #@coverages = Coverage.joins(:rotation, :insured).by_rotation(@rotation.id).references(:rotation, :insured).order("individuals.last_name, individuals.last_name, individuals.address_city").all
    @coverages = Coverage.select('"coverages"."payer_id", count("coverages"."payer_id") AS ilosc').joins(:payer)
      .select('"individuals"."last_name", "individuals"."first_name", "individuals"."address_city"')
      .by_rotation(@rotation.id)
      .group('"coverages"."payer_id", "individuals"."last_name", "individuals"."first_name", "individuals"."address_city"')
      .order('"individuals"."last_name", "individuals"."first_name", "individuals"."address_city"').all


    length_coverages = @coverages.length

    @coverages.each_with_index do |coverage, i|
      logo
      header_left_corner(coverage)
      title
      data
      footer
      start_new_page if ((i+1) < length_coverages)
    end

  end


  def logo
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    #image "#{Rails.root}/app/assets/images/pop_logo.png", :at => [430, 760]
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner(coverage)
    move_down 15
    #text insurance.fullname, :align => :center
    text "POLISA NR #{@rotation.insurance.number}", size: 14, :style => :bold
    move_down 20
    text "Firma:", size: 10, :style => :italic
    text "#{@rotation.insurance.company.name}", :style => :bold
    move_down 20
    text "#{coverage.payer.last_first_name}"
    text "#{coverage.payer.street_house_number}"
    text "#{coverage.payer.postal_code_city}"
  end


  def title
    #draw_text "OSWIADCZENIE UBEZPIECZONEGO", :at => [100, 475], size: 22    
    move_down 100
    text "OŚWIADCZENIE PŁATNIKA SKŁADKI", size: 16, :align => :center    
  end

  def data
    move_down 30
    text "W związku z przystąpieniem do grupowego ubezpieczenia następstw nieszczęśliwych wypadków, " +
         "upoważniam Pracodawcę do potrącania składki ubezpieczeniowej z wynagrodzenia za pracę, " +
         "zasiłku na wypadek choroby lub macierzyństwa i innych wypłat"
    draw_text "." * 80, :at => [310, 300], size: 6
    draw_text "data i czytelny podpis Pracownika  ", :at => [340, 290], size: 7, :style => :italic
  end

  def footer
    draw_text "Ubezpieczenie obsługuje: #{@rotation.insurance.user.name} - #{@rotation.insurance.user.agent_number}", :at => [0, 15], size: 10    
    stroke_line [0, 10], [525,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
