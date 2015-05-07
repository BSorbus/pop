class GroupPdf < Prawn::Document

  def initialize(group, view)
    super()
    @group = group
    @view = view

    header_page    
    data_page
    footer_page    
  end

  def logo
    logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    image logopath
  end

  def title
    move_down 10
    #text group.fullname, :align => :center
    text "Polisa NNW #{@group.insurance.number}"
    text "Grupa ubezpieczeniowa Nr #{@group.number}"
  end



  def header_page
    logo
    title
  end

  def footer_page
    text "wygenerowano z programu https://#{Rails.application.secrets.domain_name}  © Artex-Software", size: 6, :style => :italic, :align => :right, :valign => :bottom  
  end

  def data_page
    move_down 10
    draw_text "Receipt", :at => [220, 575], size: 22    
    text "Test"
    text "Test"
    text "Test"
  end

end
