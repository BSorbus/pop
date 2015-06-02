class InvoicePdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(user, invoice_date, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @invoice_customer = user
    @invoice_seller = User.find(1)
    @invoice_date = invoice_date
    @view = view

    case @invoice_customer.id
    when 2
      @invoice_customer_address_with_nip = "#{@invoice_customer.address} \n NIP: 851-28-18-179"  # Pieciukiewicz 
      @invoice_netto = 129.00       
    when 3
      @invoice_customer_address_with_nip = "#{@invoice_customer.address} \n NIP: 816-134-07-80"  # Maniecki           
      @invoice_netto = 129.00       
    when 4
      @invoice_customer_address_with_nip = "#{@invoice_customer.address} \n NIP: 554-153-36-50"  # Tyburski        
      @invoice_netto = 129.00       
    else
      @invoice_customer_address_with_nip = "#{@invoice_customer.address} \n NIP:?"          
      @invoice_netto = 129.00       
    end


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
    image "#{Rails.root}/app/assets/images/pop_logo.png", :at => [440, 780], :height => 50
  end

  def header_left_corner
    draw_text "Faktura VAT nr:", :at => [0, 690], size: 11
    draw_text "#{@invoice_customer.id}/#{@invoice_date.month}/-#{@invoice_customer.agent_number}-/#{@invoice_date.year}", :at => [0, 675], size: 12

    draw_text "Nabywca:", :at => [0, 630], size: 12, :style => :bold
    text_box "#{@invoice_customer_address_with_nip}", size: 12, 
      :at => [0, 615], 
      :width => 265, 
      :height => 100
  end

  def header_right_corner
    draw_text "Data wystawienia i miejsce:", :at => [300, 690], size: 11
    draw_text "#{@invoice_date.strftime("%d.%m.%Y")}, Bydgoszcz", :at => [300, 675], size: 12

    draw_text "Sprzedawca:", :at => [300, 630], size: 11, :style => :bold
    text_box "#{@invoice_seller.address}", size: 12, 
      :at => [300, 615], 
      :width => 170, 
      :height => 100
  end


  def data

    #move_down 80

    current_row = 525
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    draw_text "Lp.",                      :at => [  4, current_row-10], size: 9
    draw_text "Nazwa towaru lub usługi",  :at => [ 24, current_row-10], size: 9
    draw_text "PKWiU",                    :at => [210, current_row-10], size: 9
    draw_text "Wartość bez",              :at => [250, current_row-10], size: 9
    draw_text "podatku VAT",              :at => [250, current_row-20], size: 9
    draw_text "(PLN)",                    :at => [250, current_row-30], size: 9
    draw_text "Podatek VAT",              :at => [345, current_row-10], size: 9
    draw_text "Stawka(%)    Kwota(PLN)",  :at => [320, current_row-27], size: 9
    draw_text "Wartość z",                :at => [440, current_row-10], size: 9
    draw_text "podatkiem VAT",            :at => [440, current_row-20], size: 9
    draw_text "(PLN)",                    :at => [440, current_row-30], size: 9

    stroke_line [316, current_row-15], [436,current_row-15], self.line_width = 0.5

    stroke_line [0, current_row-35], [525,current_row-35], self.line_width = 0.5

    stroke_line [376, current_row-15], [376, current_row-95], self.line_width = 0.5

    stroke_line [  0, current_row], [  0, current_row-95], self.line_width = 0.5
    stroke_line [ 20, current_row], [ 20, current_row-95], self.line_width = 0.5
    stroke_line [206, current_row], [206, current_row-95], self.line_width = 0.5
    stroke_line [246, current_row], [246, current_row-95], self.line_width = 0.5
    stroke_line [316, current_row], [316, current_row-95], self.line_width = 0.5
    stroke_line [436, current_row], [436, current_row-95], self.line_width = 0.5
    stroke_line [525, current_row], [525, current_row-95], self.line_width = 0.5

    draw_text " 1.",                                                  :at => [  4, current_row-50], size: 9
    draw_text "Usługa informatyczna",                                 :at => [ 24, current_row-50], size: 9
    draw_text '"POP" w chmurze',                                      :at => [ 24, current_row-62], size: 9
    draw_text "#{with_delimiter_and_separator(@invoice_netto)}",      :at => [278, current_row-50], size: 9
    draw_text "23%",                                                  :at => [340, current_row-50], size: 9
    draw_text "#{with_delimiter_and_separator(@invoice_netto*0.23)}", :at => [402, current_row-50], size: 9
    draw_text "#{with_delimiter_and_separator(@invoice_netto*1.23)}", :at => [485, current_row-50], size: 9

    stroke_line [0, current_row-70], [525,current_row-70], self.line_width = 0.5

    draw_text "Razem",                                                :at => [ 24, current_row-85], size: 9, :style => :bold
    draw_text "#{with_delimiter_and_separator(@invoice_netto)}",      :at => [276, current_row-85], size: 9, :style => :bold
    draw_text "#{with_delimiter_and_separator(@invoice_netto*0.23)}", :at => [400, current_row-85], size: 9, :style => :bold
    draw_text "#{with_delimiter_and_separator(@invoice_netto*1.23)}", :at => [475, current_row-85], size: 12, :style => :bold

    stroke_line [0, current_row-95], [525,current_row-95], self.line_width = 0.5

    current_row = current_row - 145
    draw_text "Abonament za okres",               :at => [ 15, current_row], size: 10
    draw_text "Data płatności do",                :at => [ 15, current_row-15], size: 10
    draw_text "Forma płatności",                  :at => [ 15, current_row-30], size: 10
    draw_text "Rachunek bankowy",                 :at => [ 15, current_row-45], size: 10

    draw_text "#{@invoice_date.strftime("%d.%m.%Y")} - #{(@invoice_date + 1.month - 1.day).strftime("%d.%m.%Y")}", :at => [ 200, current_row], size: 10
    draw_text "#{(@invoice_date + 9.day).strftime("%d.%m.%Y")}",                                                   :at => [ 200, current_row-15], size: 10
    draw_text "przelew",                          :at => [ 200, current_row-30], size: 10
    draw_text "05 1020 1462 0000 7002 0128 4637", :at => [ 200, current_row-45], size: 10

    image "#{Rails.root}/app/assets/images/signature.png", :at => [current_row-100, 320], :height => 68

  end

  def footer
    stroke_line [0, 10], [525,10], self.line_width = 0.1
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

end
