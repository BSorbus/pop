class IndividualDatatable < AjaxDatatablesRails::Base
  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  # include AjaxDatatablesRails::Extensions::Kaminari
  # include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator

  def_delegators :@view, :link_to, :h, :mailto

  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @sortable_columns ||= %w( 
                              Individual.last_name 
                              Individual.first_name 
                              Individual.address_city 
                              Individual.address_street 
                              Individual.address_house 
                              Individual.address_number 
                              Individual.pesel  
                              Individual.birth_date        
                          )
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= %w(
                              Individual.last_name 
                              Individual.first_name 
                              Individual.address_city 
                              Individual.address_street 
                              Individual.address_house 
                              Individual.address_number 
                              Individual.pesel 
                              Individual.birth_date        
                            )
  end

  private

  def data
    # comma separated list of the values for each cell of a table row
    # example: record.attribute,
    records.map do |record|
      [
        record.id,
        record.last_name, 
        record.first_name,
        record.address_city,
        record.address_street,
        record.address_house,
        record.address_number,
        record.pesel,
        record.birth_date        
      ]
    end
  end

  def get_raw_records
    if options[:only_for_current_user_id] == -1 # user.admin?
      Individual.all
    else
      Individual.by_user(options[:only_for_current_user_id]).all
    end
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
