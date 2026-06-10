module FacilitiesManagement::RM6378::Admin::SectionsConcern
  extend ActiveSupport::Concern

  include Admin::SectionsConcern

  SECTION_TO_PARAMS = {
    basic_supplier_information: %i[name duns_number sme],
  }.freeze
end
