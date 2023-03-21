module FacilitiesManagement
  module RM3830
    class ProcurementContactDetail < ApplicationRecord
      validates :name, presence: true, length: { maximum: 50 }, on: %i[new_invoicing_contact_details new_authorised_representative new_notices_contact_details]
      validates :job_title, presence: true, length: { maximum: 150 }, on: %i[new_invoicing_contact_details new_authorised_representative new_notices_contact_details]
      validates :email, presence: true, format: { with: /\A([\w+-].?)+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i }, on: %i[new_invoicing_contact_details new_authorised_representative new_notices_contact_details]

      include AddressValidator

      def contact_address
        [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county].compact.reject(&:empty?).join(', ') + " #{organisation_address_postcode}"
      end

      def full_name
        name
      end

      def full_organisation_address
        [organisation_address_line_1, organisation_address_line_2, organisation_address_town, organisation_address_county].compact.reject(&:empty?).join(', ') + " #{organisation_address_postcode}"
      end
    end
  end
end
