class InvoicePdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(user, invoice_date, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @invoice_user = user
    @invoice_date = Time.new(invoice_date)
    @view = view

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10


    logo
    header_left_corner
    header_right_corner
    data
    footer
  end


  def logo
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    #image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner
    draw_text "Faktura VAT nr:", :at => [0, 760], size: 11
    draw_text "#{@invoice_user.id}/#{@invoice_date.month}/-#{@invoice_user.agent_number}-/#{@invoice_date.year}", :at => [0, 745], size: 12
  end

  def header_right_corner
    draw_text "Data wystawienia i miejsce:", :at => [330, 760], size: 11
    draw_text "#{@invoice_date.strftime("%Y-%m-%d")}, Bydgoszcz", :at => [330, 745], size: 12
  end


  def data
    move_down 20

    draw_text "." * 80, :at => [300, 50], size: 6
    draw_text "Przedstawiciel TUiR Allianz Polska S.A.", :at => [310, 41], size: 7
  end

  def footer
    stroke_line [0, 10], [525,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
