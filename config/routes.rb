Rails.application.routes.draw do


  devise_for :users
  #resources :users
  resources :users, except: [:show, :index] do
    get 'pdf_invoice', on: :collection
  end

  resources :insurances do
    resources :rotations, except: [:index], controller: 'insurances/rotations' do
      post 'datatables_index', on: :collection
      get 'duplicate', on: :member
      get 'export_coverages_current', on: :member
      get 'export_coverages_add_remove', on: :member
      patch 'lock', on: :member
      patch 'unlock', on: :member
      get 'pdf_list_benefits_nnw1', on: :member
      get 'pdf_list_insureds_nnw2', on: :member
      get 'pdf_groups_with_insureds_add', on: :member
      get 'pdf_groups_with_insureds_remove', on: :member
      get 'pdf_list_insureds', on: :member
      get 'pdf_declarations_accession1', on: :member
      get 'pdf_declarations_accession2', on: :member
      get 'pdf_list_payers', on: :member
      get 'pdf_declarations_payers', on: :member
      get 'pdf_certifications_insureds', on: :member
      get 'pdf_dispositions_insureds', on: :member
    end
    resources :groups, except: [:index], controller: 'insurances/groups' do
      resources :discounts, except: [:index, :show], controller: 'insurances/groups/discounts'
      post 'datatables_index', on: :collection
      get 'duplicate', on: :member
    end
    post 'datatables_index', on: :collection
    post 'datatables_index_company', on: :collection # for Company
    get 'export_coverages_current', on: :member
    get 'export_coverages_add_remove', on: :member
    get 'duplicate', on: :member
    patch 'numbering_groups', on: :member
    patch 'lock', on: :member
    patch 'unlock', on: :member
    get 'pdf_list_benefits_nnw1', on: :member
    get 'pdf_list_insureds_nnw2', on: :member
    get 'pdf_groups_with_insureds_add', on: :member
    get 'pdf_groups_with_insureds_remove', on: :member
    get 'pdf_list_insureds', on: :member
    get 'pdf_declarations_accession1', on: :member
    get 'pdf_declarations_accession2', on: :member
    get 'pdf_list_payers', on: :member
    get 'pdf_declarations_payers', on: :member
    get 'pdf_certifications_insureds', on: :member
    get 'pdf_dispositions_insureds', on: :member
  end

  resources :families do
    resources :family_rotations, except: [:index], controller: 'families/family_rotations' do
      post 'datatables_index', on: :collection
      get 'duplicate', on: :member
      patch 'lock', on: :member
      patch 'unlock', on: :member
      get 'pdf_list_insureds', on: :member
      get 'pdf_declarations_accession', on: :member
      get 'pdf_list_payers', on: :member
      get 'pdf_declarations_payers', on: :member
    end
    post 'datatables_index', on: :collection
    post 'datatables_index_company', on: :collection # for Company
    patch 'lock', on: :member
    patch 'unlock', on: :member
    get 'pdf_list_insureds', on: :member
    get 'pdf_declarations_accession', on: :member
    get 'pdf_list_payers', on: :member
    get 'pdf_declarations_payers', on: :member
  end

  resources :companies do
    post 'datatables_index', on: :collection
    get 'select_his', on: :collection
  end

  resources :individuals do
    post 'datatables_index', on: :collection
    get 'select2_index', on: :collection
    get 'pdf_certifications_insureds', on: :member
    get 'pdf_dispositions_insureds', on: :member
  end

  resources :coverages, except: [:index, :show] do
    post 'datatables_index_rotation', on: :collection
    post 'datatables_index_group', on: :collection
    post 'datatables_index_insured', on: :collection
    post 'datatables_index_payer', on: :collection
  end

  resources :family_coverages, except: [:index, :show] do
    post 'datatables_index_rotation', on: :collection
    post 'datatables_index_insured', on: :collection
    post 'datatables_index_payer', on: :collection
  end

  resources :events

  root to: 'events#index'

end
