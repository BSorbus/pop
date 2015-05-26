class InsuranceDatatable < AjaxDatatablesRails::Base
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
                              Insurance.number 
                              Company.short  
                              Insurance.concluded 
                              Insurance.valid_from 
                              Insurance.applies_to 
                              Insurance.pay 
                              Insurance.insurance_lock 
                              Insurance.note
                            )
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= %w(
                              Insurance.number 
                              Company.short  
                              Insurance.concluded 
                              Insurance.valid_from 
                              Insurance.applies_to 
                              Insurance.pay 
                              Insurance.insurance_lock 
                              Insurance.note
                            )
  end

  private

  def data
    # comma separated list of the values for each cell of a table row
    # example: record.attribute,
    records.map do |record|
      [
        record.id,
        link_to(record.number, @view.insurance_path(record)),
        link_to(record.company.short, @view.company_path(record.company)),
        record.concluded,
        record.valid_from,
        record.applies_to,
        record.pay,
        #record.insurance_lock? ? 'Tak' : 'Nie',
        record.insurance_lock? ? '<div style="text-align: center"><div class="glyphicon glyphicon-lock"></div></div>' : ' ', 
        record.note
      ]
    end
  end

  def get_raw_records
    # insert query here
    #Insurance.by_user(options[:only_for_current_user_id])

     Insurance.joins(:company).by_user(options[:only_for_current_user_id]).all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
