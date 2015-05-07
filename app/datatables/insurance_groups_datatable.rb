class InsuranceGroupsDatatable < AjaxDatatablesRails::Base
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
                              Group.number 
                              Group.quotation  
                              Group.tariff_fixed 
                              Group.full_range 
                              Group.risk_group 
                              Group.assurance 
                              Group.treatment 
                              Group.ambulatory 
                              Group.hospital 
                              Group.infarct 
                              Group.inability 
                              Group.death_100_percent 
                              Group.sum_after_monthly 
                             )
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= %w(
                              Group.number 
                              Group.quotation  
                              Group.tariff_fixed 
                              Group.full_range 
                              Group.risk_group 
                              Group.assurance 
                              Group.treatment 
                              Group.ambulatory 
                              Group.hospital 
                              Group.infarct 
                              Group.inability 
                              Group.death_100_percent 
                              Group.sum_after_monthly
                            )
  end

  private

  def data
    # comma separated list of the values for each cell of a table row
    # example: record.attribute,
    records.map do |record|
      [
        record.id, 
        record.insurance_id, 
        record.number, 
        record.quotation_name, 
        record.tariff_fixed_name,
        record.full_range_name,
        record.risk_group,
        record.assurance, 
        record.treatment,
        record.ambulatory,
        record.hospital,
        record.infarct,
        record.inability,
        record.death_100_percent? ? 'Tak' : 'Nie',
        record.sum_after_monthly      
      ]
    end
  end

  def get_raw_records
    # insert query here
    #Insurance.by_user(options[:only_for_current_user_id])

     #Group.all
     Group.all.where(insurance_id: options[:only_for_current_insurance_id])
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
