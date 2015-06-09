class CompanyFamiliesDatatable < AjaxDatatablesRails::Base
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
                              Family.number 
                              Family.concluded 
                              Family.valid_from 
                              Family.applies_to 
                              Family.pay 
                              Family.protection_variant 
                              Family.family_lock 
                              Family.note
                            )
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= %w(
                              Family.number 
                              Family.concluded 
                              Family.valid_from 
                              Family.applies_to 
                              Family.pay 
                              Family.protection_variant 
                              Family.family_lock 
                              Family.note
                            )
  end

  private

  def data
    # comma separated list of the values for each cell of a table row
    # example: record.attribute,
    records.map do |record|
      [
        record.id,
        record.number,
        record.concluded,
        record.valid_from,
        record.applies_to,
        record.pay,
        record.protection_variant, 
        #record.family_lock? ? 'Tak' : 'Nie',
        record.family_lock? ? '<div style="text-align: center"><div class="glyphicon glyphicon-lock"></div></div>' : ' ', 
        record.note
      ]
    end
  end

  def get_raw_records
    Family.where(company_id: options[:only_for_current_company_id]).all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
