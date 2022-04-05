require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::WorkPackage, type: :model do
  describe 'work packages' do
    it 'there are 18 work packages' do
      expect(described_class.count).to eq 19
    end

    it 'there are the correct work package codes' do
      expect(described_class.pluck(:code)).to match ('A'..'S').to_a
    end
  end

  describe '.selectable' do
    it 'there are 14 selectable work packages' do
      expect(described_class.selectable.count).to eq 15
    end

    it 'there are the correct work package codes' do
      expect(described_class.selectable.pluck(:code)).to match ('E'..'S').to_a
    end
  end

  describe '.services' do
    work_packages_with_num_of_services = {
      'A': 18,
      'B': 1,
      'C': 1,
      'D': 1,
      'E': 21,
      'F': 13,
      'G': 8,
      'H': 10,
      'I': 18,
      'J': 16,
      'K': 5,
      'L': 15,
      'M': 8,
      'N': 13,
      'O': 5,
      'P': 14,
      'Q': 2,
      'R': 1,
      'S': 1
    }

    work_packages_with_num_of_services.each do |code, number_of_services|
      context "when considering work package with code #{code}" do
        it "has #{number_of_services} services" do
          expect(described_class.find(code).services.count).to eq number_of_services
        end
      end
    end
  end
end
