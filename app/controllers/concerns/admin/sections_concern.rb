module Admin::SectionsConcern
  extend ActiveSupport::Concern

  included do
    helper_method :section_attributes, :change_type_attributes
  end

  private

  def section_attributes(section)
    self.class::SECTION_TO_PARAMS[section] || []
  end

  def change_type_attributes(change_type)
    self.class::SECTION_TO_PARAMS[CHANGE_TYPE_TO_SECTION[change_type]] || []
  end

  SECTION_TO_CHANGE_TYPE = {
    basic_supplier_information: ChangeLog::CHANGE_TYPES[:update_supplier_information],
    supplier_contact_information: ChangeLog::CHANGE_TYPES[:update_supplier_contact_information],
    additional_supplier_information: ChangeLog::CHANGE_TYPES[:update_supplier_additional_information],
  }.freeze

  CHANGE_TYPE_TO_SECTION = SECTION_TO_CHANGE_TYPE.invert.freeze
end
