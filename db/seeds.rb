DB_USER_ID = User.last.id


companies = Company.create([
    { #id: 1,
      short: 'ARTEX',
      name: 'Artex-SOFTWARE Sp z o.o.', 
      address_city:         'Bydgoszcz',
      address_street:       'ul. Wojska Polskiego',
      address_house:        '23',
      address_number:       '',
      address_postal_code:  '85-825',
      phone:                '601-333-456',
      email:                'artex.soft@gmail.com',
      nip:                  '953-23-86-625',
      regon:                '092905962',
      pesel:                '',
      informal_group:       true,
      note:                 'Przykładowa firma 1',
      user_id:              DB_USER_ID },
    { #id: 2,
      short: 'DRONEX',
      name: 'Przedsiębiorstwo Wielobranżowe "DRONEX" SA', 
      address_city:         'Bydgoszcz',
      address_street:       'ul. Kwiatowa',
      address_house:        '101',
      address_number:       '',
      address_postal_code:  '85-660',
      phone:                '',
      email:                '',
      nip:                  '953-23-86-626',
      regon:                '',
      pesel:                '',
      informal_group:       false,
      note:                 'Przykładowa firma 3',
      user_id:              DB_USER_ID },
    { #id: 3,
      short: 'KOWALSKI',
      name: 'Kowalski Jan - Grupa nieformalna', 
      address_city:         'Bydgoszcz',
      address_street:       'ul. Niezapominajki',
      address_house:        '12',
      address_number:       '1',
      address_postal_code:  '85-665',
      phone:                '',
      email:                '',
      nip:                  '953-23-86-627',
      regon:                '',
      pesel:                '',
      informal_group:       true,
      note:                 'Przykładowa firma 2 jako przykład grupy nieformalnej.',
      user_id:              DB_USER_ID }
])

@company_1 = Company.find_by(nip: '953-23-86-625')
@company_2 = Company.find_by(nip: '953-23-86-626')
@company_3 = Company.find_by(nip: '953-23-86-627')


Individual.transaction do

  @company_1_individual_11 = Individual.create(    
    { #id: 1,
      first_name:           'Jan', 
      last_name:            'Kowalski',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Kubusia Puchatka',
      address_house:        '23',
      address_number:       '8',
      address_postal_code:  '85-850',
      pesel:                '66122212398',
      birth_date:           '1966-12-22',
      profession:           'informatyk',
      note:                 'Przykładowa osoba 1. Pracownik zatrudniony w "ARTEX"',
      user_id:              DB_USER_ID }
    )
  @company_1_individual_12 = Individual.create(    
    { #id: 2,
      first_name:           'Maria', 
      last_name:            'Kowalska',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Kubusia Puchatka',
      address_house:        '23',
      address_number:       '8',
      address_postal_code:  '85-850',
      pesel:                '65101012785',
      birth_date:           '1965-10-10',
      profession:           'nauczyciel',
      note:                 'Przykładowa osoba 2. Żona Kowalskiego Jana',
      user_id:              DB_USER_ID }
    )
  @company_1_individual_13 = Individual.create(    
    { #id: 3,
      first_name:           'Piotr', 
      last_name:            'Kowalski',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Kubusia Puchatka',
      address_house:        '23',
      address_number:       '8',
      address_postal_code:  '85-850',
      pesel:                '89032200352',
      birth_date:           '1989-03-22',
      profession:           'student',
      note:                 'Przykładowa osoba 3. Syn Kowalskiego Jana',
      user_id:              DB_USER_ID }
    )
  @company_1_individual_14 = Individual.create(    
    { #id: 4,
      first_name:           'Weronika', 
      last_name:            'Kowalska',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Kubusia Puchatka',
      address_house:        '23',
      address_number:       '8',
      address_postal_code:  '85-850',
      pesel:                '92081904504',
      birth_date:           '1992-08-19',
      profession:           'studentka',
      note:                 'Przykładowa osoba 4. Córka Kowalskiego Jana',
      user_id:              DB_USER_ID }
    )

  @company_1_individual_21 = Individual.create(    
    { #id: 5,
      first_name:           'Antoni', 
      last_name:            'Nowakowski',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Klasztorna',
      address_house:        '56',
      address_number:       '11',
      address_postal_code:  '85-865',
      pesel:                '58021506003',
      birth_date:           '1958-02-15',
      profession:           'programista',
      note:                 'Przykładowa osoba 5. Pracownik zatrudniony w "ARTEX"',
      user_id:              DB_USER_ID }
    )
  @company_1_individual_22 = Individual.create(    
    { #id: 6,
      first_name:           'Marek', 
      last_name:            'Nowakowski',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Klasztorna',
      address_house:        '56',
      address_number:       '11',
      address_postal_code:  '85-865',
      pesel:                '87111410555',
      birth_date:           '1987-11-14',
      profession:           'student',
      note:                 'Przykładowa osoba 6. Syn Antoniego Nowakowskiego',
      user_id:              DB_USER_ID }
    )
  @company_1_individual_23 = Individual.create(    
    { #id: 7,
      first_name:           'Kamila', 
      last_name:            'Nowakowska',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Klasztorna',
      address_house:        '56',
      address_number:       '11',
      address_postal_code:  '85-865',
      pesel:                '84082717302',
      birth_date:           '1984-08-27',
      profession:           'student - pracujący',
      note:                 'Przykładowa osoba 7. Córka Antoniego Nowakowskiego',
      user_id:              DB_USER_ID }
    )

  @company_1_individual_31 = Individual.create(    
    { #id: 8,
      first_name:           'Ryszard', 
      last_name:            'Nowak',
      address_city:         'Nakło nad Notecią',
      address_street:       'ul.Polna',
      address_house:        '17',
      address_number:       '5',
      address_postal_code:  '89-100',
      pesel:                '63121007235',
      birth_date:           '1963-12-10',
      profession:           'Analityk',
      note:                 'Przykładowa osoba 8.',
      user_id:              DB_USER_ID }
    )
  @company_1_individual_32 = Individual.create(    
    { #id: 9,
      first_name:           'Grażyna', 
      last_name:            'Nowak',
      address_city:         'Nakło nad Notecią',
      address_street:       'ul.Polna',
      address_house:        '17',
      address_number:       '5',
      address_postal_code:  '89-100',
      pesel:                '68110109284',
      birth_date:           '1968-11-01',
      profession:           'kasjer',
      note:                 'Przykładowa osoba 9. Żona Ryszarda Nowaka',
      user_id:              DB_USER_ID }
    )
  @company_1_individual_33 = Individual.create(    
    { #id: 10,
      first_name:           'Katarzyna', 
      last_name:            'Nowak',
      address_city:         'Nakło nad Notecią',
      address_street:       'ul.Polna',
      address_house:        '17',
      address_number:       '5',
      address_postal_code:  '89-100',
      pesel:                '99010201406',
      birth_date:           '1999-01-02',
      profession:           'uczeń',
      note:                 'Przykładowa osoba 10. Córka Ryszarda Nowaka',
      user_id:              DB_USER_ID }
    )

  @company_1_individual_41 = Individual.create(    
    { #id: 11,
      first_name:           'Robert', 
      last_name:            'Sawicki',
      address_city:         'Koronowo',
      address_street:       'ul.Zwycięstwa',
      address_house:        '17',
      address_number:       '5',
      address_postal_code:  '86-010',
      pesel:                '76012410777',
      birth_date:           '1976-01-24',
      profession:           'informatyk',
      note:                 'Przykładowa osoba 11.',
      user_id:              DB_USER_ID }
    )

  @company_1_individual_51 = Individual.create(    
    { #id: 12,
      first_name:           'Zuzanna', 
      last_name:            'Zwolińska',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Palmowa',
      address_house:        '72',
      address_number:       '3',
      address_postal_code:  '86-835',
      pesel:                '72032005508',
      birth_date:           '1972-03-20',
      profession:           'projektant',
      note:                 'Przykładowa osoba 12.',
      user_id:              DB_USER_ID }
    )

  @company_2_individual_11 = Individual.create(    
    { #id: 13/2-1,
      first_name:           'Barbara', 
      last_name:            'Brudzińska',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Kasztanowa',
      address_house:        '7',
      address_number:       '22',
      address_postal_code:  '86-855',
      pesel:                '63122507581',
      birth_date:           '1963-12-25',
      profession:           'księgowa',
      note:                 'Przykładowa osoba 13.',
      user_id:              DB_USER_ID }
    )
  @company_2_individual_12 = Individual.create(    
    { #id: 14/2-2,
      first_name:           'Monika', 
      last_name:            'Brudzińska',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Kasztanowa',
      address_house:        '7',
      address_number:       '22',
      address_postal_code:  '86-855',
      pesel:                '05322002129',
      birth_date:           '2005-12-20',
      profession:           'dziecko',
      note:                 'Przykładowa osoba 14. Córka Barbary Brudzińskiej',
      user_id:              DB_USER_ID }
    )

  @company_2_individual_21 = Individual.create(    
    { #id: 15/2-3,
      first_name:           'Agnieszka', 
      last_name:            'Sawicka',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Polna',
      address_house:        '6',
      address_number:       '',
      address_postal_code:  '86-888',
      pesel:                '62020508324',
      birth_date:           '1962-02-05',
      profession:           'sekretarka',
      note:                 'Przykładowa osoba 15.',
      user_id:              DB_USER_ID }
    )

  @company_2_individual_31 = Individual.create(    
    { #id: 16/2-4,
      first_name:           'Alicja', 
      last_name:            'Pietras',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Wyzwolenia',
      address_house:        '62',
      address_number:       '9',
      address_postal_code:  '86-854',
      pesel:                '74062302923',
      birth_date:           '1974-06-23',
      profession:           'handlowiec',
      note:                 'Przykładowa osoba 16.',
      user_id:              DB_USER_ID }
    )

  @company_2_individual_41 = Individual.create(    
    { #id: 17/2-5,
      first_name:           'Krzysztof', 
      last_name:            'Dębczyński',
      address_city:         'Bydgoszcz',
      address_street:       'Aleje Niepodległości',
      address_house:        '124',
      address_number:       '3',
      address_postal_code:  '86-857',
      pesel:                '63121713479',
      birth_date:           '1963-12-17',
      profession:           'handlowiec',
      note:                 'Przykładowa osoba 17.',
      user_id:              DB_USER_ID }
    )

  @company_2_individual_51 = Individual.create(    
    { #id: 18/2-6,
      first_name:           'Bartosz', 
      last_name:            'Kozłowski',
      address_city:         'Bydgoszcz',
      address_street:       'Aleje Wyzwolenia',
      address_house:        '33A',
      address_number:       '4',
      address_postal_code:  '86-832',
      pesel:                '81090906816',
      birth_date:           '1981-09-09',
      profession:           'piekarz',
      note:                 'Przykładowa osoba 18.',
      user_id:              DB_USER_ID }
    )

  @company_3_individual_11 = Individual.create(    
    { #id: 19/3-1,
      first_name:           'Juliusz', 
      last_name:            'Malicki',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Kwiatowa',
      address_house:        '11',
      address_number:       '51',
      address_postal_code:  '86-812',
      pesel:                '69090808277',
      birth_date:           '1969-09-08',
      profession:           'technik maszyn',
      note:                 'Przykładowa osoba 19.',
      user_id:              DB_USER_ID }
    )

  @company_3_individual_21 = Individual.create(    
    { #id: 20/3-2,
      first_name:           'Józefa', 
      last_name:            'Ostrowska',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Długa',
      address_house:        '62',
      address_number:       '7',
      address_postal_code:  '86-810',
      pesel:                '62011714202',
      birth_date:           '1962-01-17',
      profession:           'technik maszyn',
      note:                 'Przykładowa osoba 20.',
      user_id:              DB_USER_ID }
    )

  @company_3_individual_31 = Individual.create(    
    { #id: 21/3-3,
      first_name:           'Zdzisław', 
      last_name:            'Czapliński',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Graniczna',
      address_house:        '14',
      address_number:       '50',
      address_postal_code:  '85-630',
      pesel:                '60091501336',
      birth_date:           '1960-09-15',
      profession:           'technik maszyn',
      note:                 'Przykładowa osoba 21.',
      user_id:              DB_USER_ID }
    )
  @company_3_individual_32 = Individual.create(    
    { #id: 22/3-4,
      first_name:           'Jaroslaw', 
      last_name:            'Czapliński',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Graniczna',
      address_house:        '14',
      address_number:       '50',
      address_postal_code:  '85-630',
      pesel:                '84020416610',
      birth_date:           '1984-02-04',
      profession:           'student',
      note:                 'Przykładowa osoba 22.',
      user_id:              DB_USER_ID }
    )
  @company_3_individual_33 = Individual.create(    
    { #id: 23/3-5,
      first_name:           'Adrian', 
      last_name:            'Czapliński',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Graniczna',
      address_house:        '14',
      address_number:       '50',
      address_postal_code:  '85-630',
      pesel:                '85110108310',
      birth_date:           '1985-11-01',
      profession:           'student',
      note:                 'Przykładowa osoba 23.',
      user_id:              DB_USER_ID }
    )

  @company_3_individual_41 = Individual.create(    
    { #id: 24/3-6,
      first_name:           'Paulina', 
      last_name:            'Sikora',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Pułaskiego',
      address_house:        '18',
      address_number:       '3',
      address_postal_code:  '85-815',
      pesel:                '73112306928',
      birth_date:           '1973-11-23',
      profession:           'student',
      note:                 'Przykładowa osoba 24.',
      user_id:              DB_USER_ID }
    )

  @company_3_individual_51 = Individual.create(    
    { #id: 25/3-7,
      first_name:           'Paweł', 
      last_name:            'Tomaszewski',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Fordońska',
      address_house:        '183',
      address_number:       '4',
      address_postal_code:  '85-825',
      pesel:                '53012900640',
      birth_date:           '1953-01-29',
      profession:           'nauczyciel',
      note:                 'Przykładowa osoba 25.',
      user_id:              DB_USER_ID }
    )

  @company_3_individual_61 = Individual.create(    
    { #id: 26/3-8,
      first_name:           'Arkadiusz', 
      last_name:            'Dolina',
      address_city:         'Bydgoszcz',
      address_street:       'ul.Przyjazna',
      address_house:        '8',
      address_number:       '49',
      address_postal_code:  '85-851',
      pesel:                '53101300573',
      birth_date:           '1953-10-13',
      profession:           'krawiec',
      note:                 'Przykładowa osoba 26.',
      user_id:              DB_USER_ID }
    )
end


date_insurance_1 = Time.new() - 1.year - 6.month
date_insurance_2 = Time.new() - 1.year + 1.month - 10.day
date_insurance_3 = Time.new() - 1.year + 2.month
date_insurance_4 = Time.new() + 3.day


def next_nr_1
  (101 + 10*DB_USER_ID).to_s.last(3)
end
def next_nr_2
  (102 + 10*DB_USER_ID).to_s.last(3)
end
def next_nr_3
  (103 + 10*DB_USER_ID).to_s.last(3)
end
def next_nr_4
  (104 + 10*DB_USER_ID).to_s.last(3)
end



insurances = Insurance.create([
    { #id: 1,
      number:               "229-15-654-#{next_nr_1}11111",
      concluded:            date_insurance_1,
      valid_from:           date_insurance_1,
      applies_to:           date_insurance_1 + 1.year - 1.day,
      pay:                  'M',
      insurance_lock:       false,
      created_at:           date_insurance_1,
      updated_at:           date_insurance_1 + 1.year,
      note:                 'Przykładowa polisa 1. Widoczna "Kłódka" oznacza, że polisa jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać jej rotacji, grup i ochrony.',
      company_id:           @company_1.id,
      user_id:              DB_USER_ID },
    { #id: 2,
      number:               "229-15-654-#{next_nr_2}11222",
      concluded:            date_insurance_2,
      valid_from:           date_insurance_2,
      applies_to:           date_insurance_2 + 1.year - 1.day,
      pay:                  'K',
      insurance_lock:       false,
      created_at:           date_insurance_2,
      updated_at:           date_insurance_2 + 1.year,
      note:                 'Przykładowa polisa 2. Różowy kolor w tabeli oznacza, że termin ważności polisy mija w ciągu następnych 30 dni. Podejmij działania, by ją przedlużyć!',
      company_id:           @company_2.id,
       user_id:              DB_USER_ID },
    { #id: 3,
      number:               "229-15-654-#{next_nr_3}11333",
      concluded:            date_insurance_3,
      valid_from:           date_insurance_3,
      applies_to:           date_insurance_3 + 1.year - 1.day,
      pay:                  'R',
      insurance_lock:       false,
      created_at:           date_insurance_3,
      updated_at:           date_insurance_3 + 1.year,
      note:                 'Przykładowa polisa 3. Zielony kolor oznacza, że termin ważności polisy na pewno nie upływa w czasie krótszym niż 30 dni',
      company_id:           @company_3.id,
      user_id:              DB_USER_ID },
    { #id: 4,
      number:               "229-15-654-#{next_nr_4}11444",
      concluded:            date_insurance_4,
      valid_from:           date_insurance_4,
      applies_to:           date_insurance_4 + 1.year - 1.day,
      pay:                  'M',
      insurance_lock:       false,
      created_at:           date_insurance_4 - 10.day,
      updated_at:           date_insurance_4 - 10.day,
      note:                 'Przykładowa polisa 4. Kontynuacja polisy. Dokumenty przygotowane z wyprzedzeniem.',
      company_id:           @company_1.id,
      user_id:              DB_USER_ID }
])

@company_1_insurance_1 = Insurance.find_by(number: "229-15-654-#{next_nr_1}11111")
@company_2_insurance_1 = Insurance.find_by(number: "229-15-654-#{next_nr_2}11222")
@company_3_insurance_1 = Insurance.find_by(number: "229-15-654-#{next_nr_3}11333")
@company_1_insurance_2 = Insurance.find_by(number: "229-15-654-#{next_nr_4}11444")





# grupy dla polisy 1
@company_1_insurance_1_group_1 = Group.create(
  { #id: 11,
      number:               1,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'A',
      assurance:            5000.00,
      created_at:           date_insurance_1,
      updated_at:           date_insurance_1, 
      insurance_id:         @company_1_insurance_1.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -50.00,
                        group_id:             @company_1_insurance_1_group_1.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka miesięczna',     
                        discount_increase:    12.00,
                        group_id:             @company_1_insurance_1_group_1.id })

@company_1_insurance_1_group_2 = Group.create(
  { #id: 11,
      number:               3,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'D',
      assurance:            5000.00,
      created_at:           date_insurance_1,
      updated_at:           date_insurance_1, 
      insurance_id:         @company_1_insurance_1.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -50.00,
                        group_id:             @company_1_insurance_1_group_2.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka miesięczna',     
                        discount_increase:    12.00,
                        group_id:             @company_1_insurance_1_group_2.id })

@company_1_insurance_1_group_3 = Group.create(
  { #id: 11,
      number:               2,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'A',
      assurance:            10000.00,
      treatment:            1000.00,
      hospital:             50.00,
      infarct:              3000.00,
      created_at:           date_insurance_1,
      updated_at:           date_insurance_1, 
      insurance_id:         @company_1_insurance_1.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -50.00,
                        group_id:             @company_1_insurance_1_group_3.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka miesięczna',     
                        discount_increase:    12.00,
                        group_id:             @company_1_insurance_1_group_3.id })
      Discount.create({ category:             'IP',
                        description:          'Zniżka z tytułu wykupienia min. 3 świadczeń dodatkowych',     
                        discount_increase:    -5.00,
                        group_id:             @company_1_insurance_1_group_3.id })



# grupy dla polisy 2
@company_2_insurance_1_group_1 = Group.create(
  { #id: 11,
      number:               1,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'A',
      assurance:            5000.00,
      created_at:           date_insurance_1,
      updated_at:           date_insurance_1, 
      insurance_id:         @company_2_insurance_1.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -45.00,
                        group_id:             @company_2_insurance_1_group_1.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka kwartalna',     
                        discount_increase:    8.00,
                        group_id:             @company_2_insurance_1_group_1.id })

@company_2_insurance_1_group_2 = Group.create(
  { #id: 11,
      number:               2,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'D',
      assurance:            5000.00,
      created_at:           date_insurance_2,
      updated_at:           date_insurance_2, 
      insurance_id:         @company_2_insurance_1.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -45.00,
                        group_id:             @company_2_insurance_1_group_2.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka kwartalna',     
                        discount_increase:    8.00,
                        group_id:             @company_2_insurance_1_group_2.id })



# grupy dla polisy 3
@company_3_insurance_1_group_1 = Group.create(
  { #id: 11,
      number:               1,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'A',
      assurance:            5000.00,
      created_at:           date_insurance_3,
      updated_at:           date_insurance_3, 
      insurance_id:         @company_3_insurance_1.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -20.00,
                        group_id:             @company_3_insurance_1_group_1.id })

@company_3_insurance_1_group_2 = Group.create(
  { #id: 11,
      number:               2,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'D',
      assurance:            5000.00,
      created_at:           date_insurance_3,
      updated_at:           date_insurance_3, 
      insurance_id:         @company_3_insurance_1.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -20.00,
                        group_id:             @company_3_insurance_1_group_2.id })



# grupy dla polisy 4
@company_1_insurance_2_group_1 = Group.create(
  { #id: 11,
      number:               1,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'A',
      assurance:            5000.00,
      created_at:           date_insurance_4,
      updated_at:           date_insurance_4, 
      insurance_id:         @company_1_insurance_2.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -50.00,
                        group_id:             @company_1_insurance_2_group_1.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka miesięczna',     
                        discount_increase:    12.00,
                        group_id:             @company_1_insurance_2_group_1.id })

@company_1_insurance_2_group_2 = Group.create(
  { #id: 11,
      number:               3,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'D',
      assurance:            5000.00,
      created_at:           date_insurance_4,
      updated_at:           date_insurance_4, 
      insurance_id:         @company_1_insurance_2.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -50.00,
                        group_id:             @company_1_insurance_2_group_2.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka miesięczna',     
                        discount_increase:    12.00,
                        group_id:             @company_1_insurance_2_group_2.id })

@company_1_insurance_2_group_3 = Group.create(
  { #id: 11,
      number:               2,
      quotation:            'A',
      tariff_fixed:         false,
      full_range:           false,
      risk_group:           'A',
      assurance:            10000.00,
      treatment:            1000.00,
      hospital:             50.00,
      infarct:              3000.00,
      created_at:           date_insurance_4,
      updated_at:           date_insurance_4, 
      insurance_id:         @company_1_insurance_2.id }
)
      Discount.create({ category:             'IL',
                        description:          'Zniżka grupowa',     
                        discount_increase:    -50.00,
                        group_id:             @company_1_insurance_2_group_3.id })
      Discount.create({ category:             'OK',
                        description:          'Podwyżka z tytułu płatności ratalnej - składka miesięczna',     
                        discount_increase:    12.00,
                        group_id:             @company_1_insurance_2_group_3.id })
      Discount.create({ category:             'IP',
                        description:          'Zniżka z tytułu wykupienia min. 3 świadczeń dodatkowych',     
                        discount_increase:    -5.00,
                        group_id:             @company_1_insurance_2_group_3.id })





@company_1_insurance_1_rotation_1 = Rotation.create(
  #date_insurance_1 = Time.new() - 1.year - 6.month
  { #id: 11,
      rotation_date:        date_insurance_1,
      rotation_lock:        false,
      date_file_send:       date_insurance_1,
      created_at:           date_insurance_1,
      updated_at:           date_insurance_1, 
      note:                 'Przykładowa rotacja 1. Widoczna "Kłódka" oznacza, że rotacja jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać chronionych osób, ani modyfikować grup, które są użyte w jakiejkolwiek zablokowanej rotacji.',
      insurance_id:         @company_1_insurance_1.id }
)
@company_1_insurance_1_rotation_2 = Rotation.create(    
  { #id: 12,
      rotation_date:        date_insurance_1 + 2.month,
      rotation_lock:        false,
      date_file_send:       date_insurance_1 + 2.month,
      created_at:           date_insurance_1 + 2.month,
      updated_at:           date_insurance_1 + 2.month, 
      note:                 'Przykładowa rotacja 2. Widoczna "Kłódka" oznacza, że rotacja jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać chronionych osób, ani modyfikować grup, które są użyte w jakiejkolwiek zablokowanej rotacji.',
      insurance_id:         @company_1_insurance_1.id }
)
@company_1_insurance_1_rotation_3 = Rotation.create(    
  { #id: 13,
      rotation_date:        date_insurance_1 + 3.month,
      rotation_lock:        false,
      date_file_send:       date_insurance_1 + 3.month,
      created_at:           date_insurance_1 + 3.month,
      updated_at:           date_insurance_1 + 3.month, 
      note:                 'Przykładowa rotacja 3. Widoczna "Kłódka" oznacza, że rotacja jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać chronionych osób, ani modyfikować grup, które są użyte w jakiejkolwiek zablokowanej rotacji.',
      insurance_id:         @company_1_insurance_1.id }
)

@company_2_insurance_1_rotation_1 = Rotation.create(    
    #date_insurance_2 = Time.new() - 1.year + 1.month - 10.day
    { #id: 21,
      rotation_date:        date_insurance_2,
      rotation_lock:        false,
      date_file_send:       date_insurance_2,
      created_at:           date_insurance_2,
      updated_at:           date_insurance_2, 
      note:                 'Przykładowa rotacja 1. Widoczna "Kłódka" oznacza, że rotacja jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać chronionych osób, ani modyfikować grup, które są użyte w jakiejkolwiek zablokowanej rotacji.',
      insurance_id:         @company_2_insurance_1.id }
)
@company_2_insurance_1_rotation_2 = Rotation.create(    
    { #id: 22,
      rotation_date:        date_insurance_2 + 1.month,
      rotation_lock:        false,
      date_file_send:       date_insurance_2 + 1.month,
      created_at:           date_insurance_2 + 1.month,
      updated_at:           date_insurance_2 + 1.month, 
      note:                 'Przykładowa rotacja 2. Widoczna "Kłódka" oznacza, że rotacja jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać chronionych osób, ani modyfikować grup, które są użyte w jakiejkolwiek zablokowanej rotacji.',
      insurance_id:         @company_2_insurance_1.id }
)

@company_3_insurance_1_rotation_1 = Rotation.create(    
    #date_insurance_3 = Time.new() - 1.year + 3.month
    { #id: 31,
      rotation_date:        date_insurance_3,
      rotation_lock:        false,
      date_file_send:       date_insurance_3,
      created_at:           date_insurance_3,
      updated_at:           date_insurance_3, 
      note:                 'Przykładowa rotacja 1. Widoczna "Kłódka" oznacza, że rotacja jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać chronionych osób, ani modyfikować grup, które są użyte w jakiejkolwiek zablokowanej rotacji.',
      insurance_id:         @company_3_insurance_1.id }
)
@company_3_insurance_1_rotation_2 = Rotation.create(    
    { #id: 32,
      rotation_date:        date_insurance_3 + 9.month + 7.day,
      rotation_lock:        false,
      date_file_send:       date_insurance_3 + 9.month + 7.day,
      created_at:           date_insurance_3 + 9.month + 7.day,
      updated_at:           date_insurance_3 + 9.month + 7.day, 
      note:                 'Przykładowa rotacja 2. Widoczna "Kłódka" oznacza, że rotacja jest zablokowana i nie można jej ani edytować, ani dodawać lub zmieniać chronionych osób, ani modyfikować grup, które są użyte w jakiejkolwiek zablokowanej rotacji.',
      insurance_id:         @company_3_insurance_1.id }
)
@company_1_insurance_2_rotation_1 = Rotation.create(    
    #date_insurance_4 = Time.new() - 1.year + 6.month
    { #id: 41,
      rotation_date:        date_insurance_4,
      rotation_lock:        false,
      date_file_send:       nil,
      created_at:           @company_1_insurance_2.created_at,
      updated_at:           @company_1_insurance_2.updated_at, 
      note:                 'Przykładowa rotacja 1. Do czasu zablokowania tej rotacji lub polisy możesz edytować dane z nią związane (np dodawać nowe osoby do ochrony lub zmieniać im grupę ubezpieczeniową)',
      insurance_id:         @company_1_insurance_2.id }

)






Coverage.transaction do
  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_11.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_1.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_12.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_13.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_14.id,
                    payer_id:       @company_1_individual_11.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_21.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_22.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_23.id,
                    payer_id:       @company_1_individual_21.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_31.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_1.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_32.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_33.id,
                    payer_id:       @company_1_individual_31.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_1.id, 
                    insured_id:     @company_1_individual_41.id,
                    payer_id:       @company_1_individual_41.id })

  #Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
  #                  rotation_id:    @company_1_insurance_1_rotation_1.id, 
  #                  insured_id:     @company_1_individual_51.id,
  #                  payer_id:       @company_1_individual_51.id })
end

@company_1_insurance_1_rotation_1.rotation_lock = true
@company_1_insurance_1_rotation_1.save!

Coverage.transaction do
  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_11.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_1.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_12.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_13.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_14.id,
                    payer_id:       @company_1_individual_11.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_21.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_22.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_23.id,
                    payer_id:       @company_1_individual_21.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_31.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_32.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_2.id, 
                    insured_id:     @company_1_individual_33.id,
                    payer_id:       @company_1_individual_31.id })

  #Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
  #                  rotation_id:    @company_1_insurance_1_rotation_2.id, 
  #                  insured_id:     @company_1_individual_41.id,
  #                  payer_id:       @company_1_individual_41.id })

  #Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
  #                  rotation_id:    @company_1_insurance_1_rotation_2.id, 
  #                  insured_id:     @company_1_individual_51.id,
  #                  payer_id:       @company_1_individual_51.id })
end

@company_1_insurance_1_rotation_2.rotation_lock = true
@company_1_insurance_1_rotation_2.save!

Coverage.transaction do
  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_11.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_1.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_12.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_13.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_14.id,
                    payer_id:       @company_1_individual_11.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_1.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_21.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_22.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_23.id,
                    payer_id:       @company_1_individual_21.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_31.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_3.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_32.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_33.id,
                    payer_id:       @company_1_individual_31.id })

  #Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
  #                  rotation_id:    @company_1_insurance_1_rotation_3.id, 
  #                  insured_id:     @company_1_individual_41.id,
  #                  payer_id:       @company_1_individual_41.id })

  Coverage.create({ group_id:       @company_1_insurance_1_group_2.id,
                    rotation_id:    @company_1_insurance_1_rotation_3.id, 
                    insured_id:     @company_1_individual_51.id,
                    payer_id:       @company_1_individual_51.id })
end

@company_1_insurance_1_rotation_3.rotation_lock = true
@company_1_insurance_1_rotation_3.save!

@company_1_insurance_1.insurance_lock = true
@company_1_insurance_1.save!


###  END @company_1_insurance_1
#####################################################

Coverage.transaction do
  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_1.id, 
                    insured_id:     @company_2_individual_11.id,
                    payer_id:       @company_2_individual_11.id })
  Coverage.create({ group_id:       @company_2_insurance_1_group_2.id,
                    rotation_id:    @company_2_insurance_1_rotation_1.id, 
                    insured_id:     @company_2_individual_12.id,
                    payer_id:       @company_2_individual_11.id })

  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_1.id, 
                    insured_id:     @company_2_individual_21.id,
                    payer_id:       @company_2_individual_21.id })

  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_1.id, 
                    insured_id:     @company_2_individual_31.id,
                    payer_id:       @company_2_individual_31.id })

  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_1.id, 
                    insured_id:     @company_2_individual_41.id,
                    payer_id:       @company_2_individual_41.id })

  #Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
  #                  rotation_id:    @company_2_insurance_1_rotation_1.id, 
  #                  insured_id:     @company_2_individual_51.id,
  #                  payer_id:       @company_2_individual_51.id })
end

@company_2_insurance_1_rotation_1.rotation_lock = true
@company_2_insurance_1_rotation_1.save!

Coverage.transaction do
  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_2.id, 
                    insured_id:     @company_2_individual_11.id,
                    payer_id:       @company_2_individual_11.id })
  Coverage.create({ group_id:       @company_2_insurance_1_group_2.id,
                    rotation_id:    @company_2_insurance_1_rotation_2.id, 
                    insured_id:     @company_2_individual_12.id,
                    payer_id:       @company_2_individual_11.id })

  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_2.id, 
                    insured_id:     @company_2_individual_21.id,
                    payer_id:       @company_2_individual_21.id })

  #Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
  #                  rotation_id:    @company_2_insurance_1_rotation_2.id, 
  #                  insured_id:     @company_2_individual_31.id,
  #                  payer_id:       @company_2_individual_31.id })

  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_2.id, 
                    insured_id:     @company_2_individual_41.id,
                    payer_id:       @company_2_individual_41.id })

  Coverage.create({ group_id:       @company_2_insurance_1_group_1.id,
                    rotation_id:    @company_2_insurance_1_rotation_2.id, 
                    insured_id:     @company_2_individual_51.id,
                    payer_id:       @company_2_individual_51.id })
end

@company_2_insurance_1_rotation_2.rotation_lock = true
@company_2_insurance_1_rotation_2.save!

###  END @company_2_insurance_1
#####################################################

Coverage.transaction do
  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_1.id, 
                    insured_id:     @company_3_individual_11.id,
                    payer_id:       @company_3_individual_11.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_1.id, 
                    insured_id:     @company_3_individual_21.id,
                    payer_id:       @company_3_individual_21.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_1.id, 
                    insured_id:     @company_3_individual_31.id,
                    payer_id:       @company_3_individual_31.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_2.id,
                    rotation_id:    @company_3_insurance_1_rotation_1.id, 
                    insured_id:     @company_3_individual_32.id,
                    payer_id:       @company_3_individual_31.id })
  Coverage.create({ group_id:       @company_3_insurance_1_group_2.id,
                    rotation_id:    @company_3_insurance_1_rotation_1.id, 
                    insured_id:     @company_3_individual_33.id,
                    payer_id:       @company_3_individual_31.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_1.id, 
                    insured_id:     @company_3_individual_41.id,
                    payer_id:       @company_3_individual_41.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_1.id, 
                    insured_id:     @company_3_individual_51.id,
                    payer_id:       @company_3_individual_51.id })

  #Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
  #                  rotation_id:    @company_3_insurance_1_rotation_1.id, 
  #                  insured_id:     @company_3_individual_61.id,
  #                  payer_id:       @company_3_individual_61.id })
end

@company_3_insurance_1_rotation_1.rotation_lock = true
@company_3_insurance_1_rotation_1.save!

Coverage.transaction do
  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_2.id, 
                    insured_id:     @company_3_individual_11.id,
                    payer_id:       @company_3_individual_11.id })

  #Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
  #                  rotation_id:    @company_3_insurance_1_rotation_2.id, 
  #                  insured_id:     @company_3_individual_21.id,
  #                  payer_id:       @company_3_individual_21.id })

  #Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
  #                  rotation_id:    @company_3_insurance_1_rotation_2.id, 
  #                  insured_id:     @company_3_individual_31.id,
  #                  payer_id:       @company_3_individual_31.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_2.id,
                    rotation_id:    @company_3_insurance_1_rotation_2.id, 
                    insured_id:     @company_3_individual_32.id,
                    payer_id:       @company_3_individual_31.id })
  Coverage.create({ group_id:       @company_3_insurance_1_group_2.id,
                    rotation_id:    @company_3_insurance_1_rotation_2.id, 
                    insured_id:     @company_3_individual_33.id,
                    payer_id:       @company_3_individual_31.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_2.id, 
                    insured_id:     @company_3_individual_41.id,
                    payer_id:       @company_3_individual_41.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_2.id, 
                    insured_id:     @company_3_individual_51.id,
                    payer_id:       @company_3_individual_51.id })

  Coverage.create({ group_id:       @company_3_insurance_1_group_1.id,
                    rotation_id:    @company_3_insurance_1_rotation_2.id, 
                    insured_id:     @company_3_individual_61.id,
                    payer_id:       @company_3_individual_61.id })
end

@company_3_insurance_1_rotation_2.rotation_lock = true
@company_3_insurance_1_rotation_2.save!

###  END @company_3_insurance_1
#####################################################


Coverage.transaction do
  Coverage.create({ group_id:       @company_1_insurance_2_group_3.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_11.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_2_group_1.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_12.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_2_group_2.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_13.id,
                    payer_id:       @company_1_individual_11.id })
  Coverage.create({ group_id:       @company_1_insurance_2_group_2.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_14.id,
                    payer_id:       @company_1_individual_11.id })

  Coverage.create({ group_id:       @company_1_insurance_2_group_1.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_21.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_2_group_2.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_22.id,
                    payer_id:       @company_1_individual_21.id })
  Coverage.create({ group_id:       @company_1_insurance_2_group_2.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_23.id,
                    payer_id:       @company_1_individual_21.id })

  Coverage.create({ group_id:       @company_1_insurance_2_group_3.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_31.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_2_group_3.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_32.id,
                    payer_id:       @company_1_individual_31.id })
  Coverage.create({ group_id:       @company_1_insurance_2_group_2.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_33.id,
                    payer_id:       @company_1_individual_31.id })

  #Coverage.create({ group_id:       @company_1_insurance_2_group_2.id,
  #                  rotation_id:    @company_1_insurance_2_rotation_1.id, 
  #                  insured_id:     @company_1_individual_41.id,
  #                  payer_id:       @company_1_individual_41.id })

  Coverage.create({ group_id:       @company_1_insurance_2_group_2.id,
                    rotation_id:    @company_1_insurance_2_rotation_1.id, 
                    insured_id:     @company_1_individual_51.id,
                    payer_id:       @company_1_individual_51.id })
end