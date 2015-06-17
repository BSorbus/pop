class DeclarationsAccession2Pdf < Prawn::Document
  include ApplicationHelper #funkcja with_delimiter_and_separator()

  def initialize(coverages, view)
    # New document, A4 paper, landscaped
    # pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    # wiec komentuje super() i ...
    super(:page_size => "A4", :page_layout => :portrait)
    #super()
    @coverages = coverages
    if !@coverages.empty?
      @rotation = @coverages.first.rotation
      @insurance = @rotation.insurance
      @company = @rotation.insurance.company
      @user = @rotation.insurance.user
    end
    @view = view

    font_families.update("DejaVu Sans" => {
      :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf", 
      :bold  => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
      :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
      :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf"
    })
    font "DejaVu Sans", size: 10

    count_coverages = @coverages.size

    @coverages.each_with_index do |coverage, i|
      logo
      header_left_corner(coverage)
      header_right_corner(coverage)
      title
      data(coverage)
      footer
      start_new_page if ((i+1) < count_coverages)
    end

  end


  def logo
    #logopath =  "#{Rails.root}/app/assets/images/pop_logo.png"
    #image logopath, :width => 197, :height => 91
    image "#{Rails.root}/app/assets/images/allianz_logo.png", :at => [390, 780], :height => 34
  end

  def header_left_corner(coverage)
    move_down 0
    text "#{coverage.insured.last_first_name}"
    text "#{coverage.insured.street_house_number}"
    text "#{coverage.insured.postal_code_city}"
    text "ur. #{coverage.insured.birth_date.strftime("%d.%m.%Y")}"
    text "#{coverage.insured.profession}"
  end

  def header_right_corner(coverage)
    text_box "TUiR Allianz Polska S.A." + "\n" +
             "ul. Rodziny Hiszpańskich 1" + "\n" +
             "02-685 Warszawa", size: 9, 
      :at => [390, 730], 
      :width => 170, 
      :height => 70
  end

  def title   
    move_down 22
    text "DEKLARACJA PRZYSTĄPIENIA DO UMOWY GRUPOWEGO UBEZPIECZENIA NASTĘPSTW NIESZCZĘŚLIWYCH WYPADKÓW W FORMIE IMIENNEJ", size: 11, :style => :bold, :align => :center
    draw_text "Nr polisy:",           :at => [  0, 645], size: 10
    draw_text "#{@insurance.number}", :at => [  85, 645], size: 10, :style => :bold
    draw_text "Ubezpieczający:",      :at => [  0, 630], size: 10
    draw_text "#{@company.name}",     :at => [  85, 630], size: 10, :style => :bold
  end

  def data(coverage)
    move_down 42
    #text "Suma ubezpieczenia z tytułu śmierci w wypadku:  #{with_delimiter_and_separator(coverage.group.insurance_death_val)} zł"
    #move_down 5
    text "Wyrażam zgodę na przystąpienie do umowy grupowego ubezpieczenia następstw nieszczęśliwych wypadków w formie imiennej na " +
         "podstawie ogólnych warunków ubezpieczenia następstw nieszczęśliwych wypadków TU Allianz Polska S.A. obowiązujących w dniu " +
         "zawarcia umowy, które w wypadku zaistnienia zdarzenia objętego ochroną ubezpieczeniową zobowiązuję się stosować.", size: 8
    move_down 5
    text "Data przystąpienia do umowy grupowego ubezpieczenia NNW:  #{@rotation.rotation_date.strftime("%d.%m.%Y")}"
    move_down 5
    text "Akceptuję poniższy zakres ochrony ubezpieczeniowej:"
    text_box "System świadczeń:", size: 7,                            
      :at => [  0, 550],
      :width => 160, 
      :height => 10
    text_box "#{coverage.group.tariff_fixed_name}", size: 7, 
      :at => [165, 550], 
      :width => 90, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Świadczenie na wypadek trwałego uszczerbku na zdrowiu:", size: 6,                            
      :at => [  0, 540],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.assurance)} zł", size: 6, 
      :at => [210, 540], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Podwójne świadczenie na wypadek trwałego uszczerbku na zdrowiu:", size: 6,                            
      :at => [  0, 530],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.double_assurance)} zł", size: 6, 
      :at => [210, 530], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Świadczenie na wypadek śmierci:", size: 6,                            
      :at => [  0, 520],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.insurance_death_val)} zł", size: 6, 
      :at => [210, 520], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Przeszkolenie zawodowe inwalidów:", size: 6,                            
      :at => [  0, 510],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.insurance_training_val)} zł", size: 6, 
      :at => [210, 510], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Zawał serca / udar mózgu dla osób poniżej 30 roku życia:", size: 6,                            
      :at => [  0, 500],
      :width => 180, 
      :height => 10
    text_box "limity zgodnie z OWU", size: 6, 
      :at => [180, 500], 
      :width => 75, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Świadczenie opiekuńcze na terenie RP:", size: 6,                            
      :at => [  0, 490],
      :width => 180, 
      :height => 10
    text_box "limity zgodnie z OWU", size: 6, 
      :at => [180, 490], 
      :width => 75, 
      :height => 10,
      :style => :bold, :align => :right


    # prawa kolumna
    text_box "Zakres ubezpieczenia:", size: 7,                            
      :at => [  266, 550],
      :width => 160, 
      :height => 10
    text_box "#{coverage.group.full_range_name}", size: 7, 
      :at => [431, 550], 
      :width => 90, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Suma ubezpieczenia kosztów leczenia na terenie RP:", size: 6,                            
      :at => [  266, 540],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.treatment)} zł", size: 6, 
      :at => [476, 540], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Kwota zasiłku ambulatoryjnego:", size: 6,                            
      :at => [  266, 530],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.ambulatory)} zł", size: 6, 
      :at => [476, 530], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Kwota zasiłku szpitalnego (za każdy dzień):", size: 6,                            
      :at => [  266, 520],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.hospital)} zł", size: 6, 
      :at => [476, 520], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Suma ubezpieczenia na wypadek zawału serca albo udaru mózgu:", size: 6,                            
      :at => [  266, 510],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.infarct)} zł", size: 6, 
      :at => [476, 510], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Suma ubezpieczenia na wypadek trwałej niezdolności do pracy:", size: 6,                            
      :at => [  266, 500],
      :width => 220, 
      :height => 10
    text_box "#{with_delimiter_and_separator(coverage.group.inability)} zł", size: 6, 
      :at => [476, 500], 
      :width => 45, 
      :height => 10,
      :style => :bold, :align => :right

    text_box "Składka:", size: 6,                            
      :at => [ 266, 480],
      :width => 100, 
      :height => 10
    text_box "#{coverage.group.contribution}", size: 6, 
      :at => [366, 480], 
      :width => 155, 
      :height => 10,
      :style => :bold, :align => :right



    move_down 80
    text "Uposażeni:", size: 10

    draw_text "Lp.",                      :at => [  4, 452], size: 9
    draw_text "Imię (imiona) i nazwisko", :at => [ 24, 452], size: 9
    draw_text "Adres",                    :at => [200, 452], size: 9
    draw_text "PESEL / data ur.",         :at => [350, 452], size: 9
    draw_text "Udział w środkach",        :at => [440, 452], size: 9
    draw_text "(% świadczenia)",          :at => [440, 441], size: 9

    current_row = 465

    stroke_line [  0, current_row], [  0, current_row-78], self.line_width = 0.5
    stroke_line [ 20, current_row], [ 20, current_row-78], self.line_width = 0.5
    stroke_line [196, current_row], [196, current_row-78], self.line_width = 0.5
    stroke_line [346, current_row], [346, current_row-78], self.line_width = 0.5
    stroke_line [436, current_row], [436, current_row-78], self.line_width = 0.5
    stroke_line [525, current_row], [525, current_row-78], self.line_width = 0.5

    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 30
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 16
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 16
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    current_row -= 16
    stroke_line [0, current_row], [525,current_row], self.line_width = 0.5

    move_down 80
    text "*Suma wskazań procentowych musi być równa 100%", size: 7
    move_down 5
    text "Oświadczenia Ubezpieczonego:", size: 10, :style => :bold 
    text "1. Niniejszym wyrażam zgodę na przetwarzanie moich danych osobowych podanych " +
         "dobrowolnie przeze mnie lub osoby trzecie, w tym danych dotyczących mojego " +
         "stanu zdrowia i nałogów przez TU Allianz Polska S.A. dla celów związanych z " +
         "wykonywaniem umowy ubezpieczenia oraz działalnością statutową TU Allianz Polska SA. " +
         "Ponadto oświadczam, że wyrażam zgodę na przekazywanie ww. danych podmiotom " +
         "przewidzianym przepisami prawa. Zgody powyższe obejmują również przetwarzanie ww. " +
         "danych osobowych w przyszłości, o ile nie zmieni się cel ich przetwarzania." + "\n" +
         "2. Oświadczam, że zostałem/-am poinformowany/-a przez TU Allianz Polska SA " +
         "o zasadach i prawach wynikających z ustawy z dnia 29 sierpnia 1997 roku o ochronie " +
         "danych osobowych (Dz. U. Nr 133, poz. 883 z późn. zm.), a w szczególności o tym, " +
         "że posiadam prawo do wglądu do swoich danych i ich poprawiania. TU Allianz Polska SA " +
         "informuje, że dane osobowe podane w niniejszej deklaracji zbierane są na zasadzie dobrowolności. " + "\n" +
         "3. Potwierdzam, że wszelkie dane zawarte w tej deklaracji są prawdziwe i zgodne " +
         "z moją najlepszą wiedzą. W razie zatajenia lub podania nieprawdziwych informacji " +
         "TU Allianz Polska SA nie ponosi odpowiedzialności na warunkach przewidzianych przez " +
         "przepisy Kodeksu cywilnego. Upoważniam lekarzy oraz placówki służby zdrowia do udzielenia " +
         "pełnej informacji o moim stanie zdrowia, w tym również po mojej śmierci, a TU Allianz " +
         "Polska SA do zasięgania informacji medycznych dotyczących mojego fizycznego i psychicznego " +
         "stanu zdrowia u każdego lekarza, u którego zasięgałem/-am porad lub przez którego " +
         "byłem/-am badany/-a. Powyższe upoważnienie dotyczy również wszelkich placówek " +
         "medycznych w szczególności przychodni, szpitali. Oświadczam także, że zapoznałem/-am " +
         "się z ogólnymi warunkami ubezpieczenia oraz Tabelą oceny procentowej trwałego " +
         "uszczerbku na zdrowiu wskutek nieszczęśliwego wypadku.", size: 6, :align => :justify
    move_down 2
    text "4." , size: 6
    current_row = 265
    current_col = 13
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5

    current_col = 20
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5

    draw_text "Wyrażam zgodę", :at => [current_col+4, current_row-6], size: 6

    current_col = 113
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5
    stroke_line [current_col, current_row], [current_col+7, current_row], self.line_width = 0.5
    stroke_line [current_col, current_row-7], [current_col+7, current_row-7], self.line_width = 0.5

    current_col = 120
    stroke_line [current_col, current_row], [current_col, current_row-7], self.line_width = 0.5

    draw_text "Nie wyrażam zgody", :at => [current_col+4, current_row-6], size: 6

    move_down 2
    text "na usodstępnianie na pisemną prośbę innych zakładów informacji dotyczących moich " +
         "danych osobowych podanych w zakresie potrzebnym do weryfikacji danych podanych przez mnie " +
         "przy zawieraniu umowy, ustalenia prawa do świadczenia z zawartej umowy ubezpieczenia i wysokości " +
         "tego świadczenia, a także do udzielania przez TU Allianz Polsa SA informacji o przyczynie " +
         "mojej śmierci lub informacji niezbędnych do ustalenia prawa uprawnionego do świadczenia " +
         "z tytułu umowy ubezpieczenia i jego wysokości, w myśl przepisu art. 22 ust. 5 ustawy o " +
         "działalności ubezpieczeniowej. Brak wskazania oznacza niewyrażenie zgody na udostępnianie " +
         "informacji innym zakładom ubezpieczeń. " + "\n" +
         "5. Wyrażam zgodę na przetwarzanie moich danych osobowych w celach marketingowych i akwizycyjnych " +
         "oraz w ceu planowania działalności przez Towarzystwo Ubezpieczeń Allianz Polska Spółka Akcyjna, " +
         "Towarzystwo Ubezpieczeń Allianz Życie Polska Spółka Akcyjna, Powszechne Towarzystwo Emerytalne " +
         "Allianz Polska Spółka Akcyjna, Towarzystwo Funduszy Inwestycyjnych Allianz Polska Spółka Akcyjna, " +
         "Allianz Polska Services Spółka z ograniczoną odpowiedzialnością (adres siedziby wszystkich spółek: " +
         "ul Rodzin Hiszpańskich 1, 02-685 Warszawa) oraz podmioty, których akcjonariuszami lub udziałowcami " +
         "są lub będą te spółki. Jestem świadomy/-a, że mam prawo dostępu do treści moich danych, ich poprawiania " +
         "oraz prawo wniesienia umotywowanego pisemnego żądania zaprzestania przetwarzania moich danych " +
         "jak również sprzeciwu, które to uprawnienia przysługują mi zarówno w stosunku do Towarzystwa " +
         "Ubezpieczeń Allianz Polska Spółka Akcyjna jak i w stosunku do wymienionych powyżej spółek, którym " +
         "Towarzystwo Ubezpieczeń Allianz Polska Spółka Akcyjna przekaże dane.*** " + "\n" +
         "*** w przypadku braku zgody pkt 5 należy skreślić ", size: 6, :align => :justify

    current_row = 125
    draw_text "#{@company.address_city},", :at => [ 5,current_row+5]

    draw_text "." * 65, :at => [ 0,current_row], size: 6
    draw_text "Miejscowość i data", :at => [ 30,current_row-9], size: 7

    draw_text "." * 65, :at => [ 132,current_row], size: 6
    draw_text "Ubezpieczony (podpis)", :at => [ 150,current_row-9], size: 7

    draw_text "." * 65, :at => [ 264,current_row], size: 6
    draw_text "Ubezpieczyciel (podpis i pieczęć)", :at => [ 267,current_row-9], size: 7

    draw_text "." * 65, :at => [396,current_row], size: 6
    draw_text "Przedstawiciel TU Allianz Polska SA", :at => [400,current_row-9], size: 7

  end


  def footer
    draw_text "Ubezpieczenie obsługuje: #{@rotation.insurance.user.name} - #{@rotation.insurance.user.agent_number}", :at => [0, 41], size: 7    
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
