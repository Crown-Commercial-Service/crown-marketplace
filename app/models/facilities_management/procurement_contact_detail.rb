module FacilitiesManagement
  class ProcurementContactDetail < ApplicationRecord
    validates :name, presence: true, format: { with: /\A([a-zA-Z\- ]*[\.]?[a-zA-Z\- ]*)\z/ }, length: { maximum: 50 }
    validates :job_title, presence: true, format: { with: /\A([a-zA-Z\- ]*)\z/ }, length: { maximum: 150 }

    validates :email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
    validates :organisation_address_line_1, presence: true, format: { with: /\A([a-zA-Z\- (0-9)]*)\z/ }
    validates :organisation_address_town, presence: true, format: { with: /\A([a-zA-Z\- ]*)\z/ }
    validates :organisation_address_postcode, presence: true, format: { with: /\A([a-zA-Z (0-9)]*)\z/ }

    def full_organisation_address
      "#{organisation_address_line_1}#{', ' + organisation_address_line_2 if organisation_address_line_2.present?}#{', ' + organisation_address_town}#{', ' + organisation_address_county if organisation_address_county.present?}#{', ' + organisation_address_postcode}"
    end
  end
end
