class CompanyDatatable < AjaxDatatablesRails::Base
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
                              Company.short 
                              Company.name 
                              Company.address_city 
                              Company.address_street 
                              Company.address_house 
                              Company.address_number 
                              Company.nip 
                              Company.regon 
                              Company.pesel 
                            )
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= %w(
                              Company.short 
                              Company.name 
                              Company.address_city 
                              Company.address_street 
                              Company.address_house 
                              Company.address_number 
                              Company.nip 
                              Company.regon 
                              Company.pesel 
                            )
  end

  private

  def data
    # comma separated list of the values for each cell of a table row
    # example: record.attribute,
    records.map do |record|
      [
        record.id,
        #link_to(record.short, record), 
        record.short, 
        record.name,
        record.address_city,
        record.address_street,
        record.address_house,
        record.address_number,
        record.nip, 
        record.regon, 
        record.pesel
      ]
    end
  end

  def get_raw_records
    # insert query here
    Company.by_user(options[:only_for_current_user_id])
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
