module FacilitiesManagement::RM3830
  module Procurements::ContractDetailsHelper
    include ProcurementsHelper

    def show_page_content
      options = case @page_name
                when :pricing, :what_next, :important_information, :review_and_generate, :review, :sending
                  [false, true, true]
                when :contract_details
                  [false, true]
                else
                  []
                end

      [@page_description, @procurement] + options
    end

    def partial_prefix
      @partial_prefix ||= 'facilities_management/rm3830/procurements/contract_details/edit_partials'
    end

    def sorted_supplier_list
      @sorted_supplier_list ||= @procurement.procurement_suppliers.where(direct_award_value: Procurement::DIRECT_AWARD_VALUE_RANGE).map { |i| { price: i[:direct_award_value], name: i.supplier_name } }
    end

    def supplier_plural
      'supplier'.pluralize(sorted_supplier_list.count)
    end

    def link_to_add_row(name, form, association, **args)
      new_object = form.object.send(association).klass.new
      id = new_object.object_id
      fields = form.fields_for(association, new_object, child_index: id) do |builder|
        render("#{partial_prefix}/#{association.to_s.singularize}", ff: builder)
      end
      link_to(name, '#', class: args[:class], data: { id: id, fields: fields.gsub('\n', '') })
    end

    def object_name(name)
      name.gsub('[', '_')[0..-2]
    end

    def cant_find_address_link
      facilities_management_rm3830_procurement_contract_details_edit_path(page: @address_step)
    end

    def security_policy_document_file_type
      @procurement.security_policy_document_file.content_type == 'application/pdf' ? :pdf : :doc
    end
  end
end
