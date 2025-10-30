module FacilitiesManagement
  module RM6378
    class Procurement < Procurement
      class CannotCreateNameError < StandardError; end

      validates :requirements_linked_to_pfi, inclusion: { in: [true, false] }, on: :contract_name

      before_create :generate_contract_number

      def suppliers
        @suppliers ||= Supplier::Framework.with_services_and_jurisdiction(service_ids, jurisdiction_ids).order('supplier.name')
      end

      def services
        @services ||= Service.where(id: service_ids).ordered_by_category_and_number
      end

      def jurisdictions
        @jurisdictions ||= Jurisdiction.where(id: jurisdiction_ids).ordered_by_category_and_number
      end

      def update_contract_name_with_security
        remove_excess_whitespace_from_name

        saved_names = self.class.where(user: user, framework_id: 'RM6378').where('contract_name LIKE :prefix', prefix: "#{contract_name}%").pluck(:contract_name)

        inital_contract_name = contract_name

        self.contract_name = "#{inital_contract_name} (Security)"

        return contract_name if saved_names.exclude?(contract_name)

        100.times do |number|
          self.contract_name = "#{inital_contract_name} (Security #{number + 1})"

          return contract_name if saved_names.exclude?(contract_name)
        end

        raise CannotCreateNameError
      end

      ATTRIBUTES_AND_DEFAULT_VALUES = [
        ['service_ids', []],
        ['jurisdiction_ids', []],
        ['annual_contract_value', nil],
        ['requirements_linked_to_pfi', nil, ->(value) { ActiveModel::Type::Boolean.new.cast(value) }],
      ].freeze

      ATTRIBUTES_AND_DEFAULT_VALUES.each do |attribute, default_value, cast_func|
        define_method(attribute.to_sym) { attribute_getter(attribute, default_value) }
        define_method(:"#{attribute}=") { |value| attribute_setter(attribute, value, cast_func) }
      end

      private

      def generate_contract_number
        self.contract_number = ContractNumberGenerator.new(framework: framework_id, model: self.class).new_number
      end
    end
  end
end
