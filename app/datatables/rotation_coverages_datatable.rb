class RotationCoveragesDatatable < AjaxDatatablesRails::Base
  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  # include AjaxDatatablesRails::Extensions::Kaminari
  # include AjaxDatatablesRails::Extensions::WillPaginate
  # include AjaxDatatablesRails::Extensions::SimplePaginator

  def_delegators :@view, :link_to, :h, :mailto

  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'

    #@sortable_columns ||= %w(
    #                          Group.number 
    #                          Individual.last_name 
    #                          "payers_coverages"."last_name" 
    #                          Coverage.note 
    #                        )    

    #@sortable_columns ||= [ 
    #                          'groups.number',
    #                          'individuals.last_name',
    #                          '"payers_coverages"."last_name"',
    #                          'coverages.note' 
    #                        ]

    @sortable_columns ||= [
                                'Group.number', 
                                'Insured.last_name', 
                                "payers_coverages.last_name", 
                                'Coverage.note'
                          ]
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    #@searchable_columns ||= %w(
    #                          Group.number 
    #                          Individual.last_name 
    #                          Individual.first_name 
    #                          Individual.address_city 
    #                          Coverage.note 
    #                        )

    @searchable_columns ||= [
                              'Insured.last_name', 
                              'Insured.first_name', 
                              'Insured.address_city',
                              "payers_coverages.last_name", 
                              "payers_coverages.first_name", 
                              "payers_coverages.address_city" 
    ]
  end

  private

  def data
    # comma separated list of the values for each cell of a table row
    # example: record.attribute,
    records.map do |record|
      [
        record.id,
        link_to(record.group.fullname, @view.insurance_group_path(record.group.insurance, record.group)),
        link_to(record.insured.fullname, @view.individual_path(record.insured_id)),
        link_to(record.payer.fullname, @view.individual_path(record.payer_id)),
        record.note,
        link_to(' ', @view.edit_coverage_path(record.id, back_url: @view.insurance_rotation_path(record.rotation.insurance, record.rotation)), 
                    class: 'glyphicon glyphicon-edit', 
                    title: 'Edycja', rel: 'tooltip') + " " +
        link_to(' ', @view.coverage_path(record.id), 
                            method: :delete, 
                            data: { confirm: "Czy na pewno chcesz usunąć ten wpis?" }, 
                            class: "glyphicon glyphicon-trash", title: 'Usuń', rel: 'tooltip')      ]
    end
  end

  def get_raw_records
    Coverage.joins(:rotation, :group).includes(:insured, :payer).by_rotation(options[:only_for_rotation_id]).references(:rotation, :group, :insured, :payer).all
    #Coverage.joins(:rotation, :group, :insured, :payer).where(rotation_id: options[:only_for_rotation_id]).references(:rotation, :group, :insured, :payer).all

    # działa
    # Coverage.all.where(rotation_id: options[:only_for_rotation_id])
  end

  def deprecated_search_condition(column, value)
    model, column = column.split('.')
    table = begin
              table = model.singularize.titleize.gsub( / /, '' ).constantize.arel_table
            rescue
              table = ::Arel::Table.new(model.to_sym, ::ActiveRecord::Base)
            end
 
    casted_column = ::Arel::Nodes::NamedFunction.new('CAST', [table[column.to_sym].as(typecast)])
    casted_column.matches("%#{value}%")
  end


  # ==== Insert 'presenter'-like methods below if necessary
end
