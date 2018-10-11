class Branch < ApplicationRecord
  DEFAULT_SEARCH_RANGE_IN_MILES = 25

  belongs_to :supplier

  validates :postcode, presence: true, postcode: true
  validates :location, presence: true
  validates :telephone_number, presence: true
  validates :contact_name, presence: true
  validates :contact_email, presence: true

  def self.near(point, within_metres:)
    where(
      [
        'ST_DWithin(location, :point, :within_metres)',
        point: point, within_metres: within_metres
      ]
    )
  end

  def self.to_xlsx
    # wb = xlsx_package.workbook
    # wb.add_worksheet(name: 'Suppliers') do |sheet|
    #   sheet.add_row ['Supplier name', 'Contact name', 'Contact email']
    #   @branches.each do |branch|
    #     sheet.add_row [branch.supplier.name, branch.contact_name, branch.contact_email]
    #   end
    # end
  end
end
