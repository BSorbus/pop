class FamilyFamilyRotationsDatatable < AjaxDatatablesRails::Base
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
                              FamilyRotation.rotation_date 
                              FamilyRotation.rotation_lock 
                              FamilyRotation.date_file_send 
                              FamilyRotation.note 
                             )
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= %w(
                              FamilyRotation.rotation_date 
                              FamilyRotation.rotation_lock  
                              FamilyRotation.date_file_send 
                              FamilyRotation.note
                            )
  end

  private

  def data
    # comma separated list of the values for each cell of a table row
    # example: record.attribute,
    records.map do |record|
      [
        record.id, 
        record.family_id, 
        record.rotation_date, 
        #record.rotation_lock? ? 'Tak' : 'Nie', 
        #record.rotation_lock? ? '<div class="glyphicon glyphicon-lock"></div>' : ' ', 
        #record.rotation_lock? ? '<div style="text-align: center"><img src="/assets/my file.png" /> </div>' : ' ', 
        record.rotation_lock? ? '<div style="text-align: center"><div class="glyphicon glyphicon-lock"></div></div>' : ' ', 
        record.date_file_send,
        record.note      
      ]
    end
  end

  def get_raw_records
    # insert query here
    #Family.by_user(options[:only_for_current_user_id])

     #FamilyRotation.all
     FamilyRotation.where(family_id: options[:only_for_current_family_id]).all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
