class ChangeLog
  module Loggable
    extend ActiveSupport::Concern

    module ClassMethods
      def log_upload_supplier_data!(admin_upload:, supplier_data:)
        create!(user: admin_upload.user, framework: admin_upload.framework, change_type: CHANGE_TYPES[:upload_supplier_data], change_data: { admin_upload_id: admin_upload.id, supplier_data: supplier_data })
      end

      def log_update_supplier_information!(user:, framework:, model:)
        log_generic_update_supplier_information!(user: user, framework: framework, model: model, supplier_name: model.name, change_type: CHANGE_TYPES[:update_supplier_information])
      end

      def log_update_supplier_contact_information!(user:, framework:, model:)
        log_generic_update_supplier_information!(user: user, framework: framework, model: model, supplier_name: model.supplier_framework.supplier_name, change_type: CHANGE_TYPES[:update_supplier_contact_information])
      end

      def log_update_supplier_additional_information!(user:, framework:, model:)
        log_generic_update_supplier_information!(user: user, framework: framework, model: model, supplier_name: model.supplier_framework.supplier_name, change_type: CHANGE_TYPES[:update_supplier_additional_information])
      end

      def log_update_supplier_framework_lot_status!(user:, framework:, model:)
        log_generic_update_supplier_information!(user: user, framework: framework, model: model, supplier_name: model.supplier_framework.supplier_name, change_type: CHANGE_TYPES[:update_supplier_framework_lot_status], lot_id: model.lot_id)
      end

      def log_update_supplier_framework_lot_services!(user:, framework:, model:, added:, removed:)
        log_generic_update_list_update!(user: user, framework: framework, model: model, supplier_name: model.supplier_framework.supplier_name, lot_id: model.lot_id, change_type: CHANGE_TYPES[:update_supplier_framework_lot_services], added: added, removed: removed)
      end

      def log_update_supplier_framework_lot_jurisdictions!(user:, framework:, model:, added:, removed:)
        log_generic_update_list_update!(user: user, framework: framework, model: model, supplier_name: model.supplier_framework.supplier_name, lot_id: model.lot_id, change_type: CHANGE_TYPES[:update_supplier_framework_lot_jurisdictions], added: added, removed: removed)
      end

      def log_update_supplier_framework_lot_rates!(user:, framework:, model:, rates:)
        log_generic_update_supplier_framework_lot_rates!(user: user, framework: framework, model: model, rates: rates, change_type: CHANGE_TYPES[:update_supplier_framework_lot_rates])
      end

      def log_update_supplier_framework_lot_branch!(user:, framework:, model:)
        log_generic_update_supplier_information!(user: user, framework: framework, model: model, supplier_name: model.supplier_framework_lot.supplier_framework.supplier_name, change_type: CHANGE_TYPES[:update_supplier_framework_lot_branch], lot_id: model.supplier_framework_lot.lot_id)
      end

      def log_add_rates_for_supplier_framework_lot_jurisdiction!(user:, framework:, model:, rates:)
        log_generic_update_supplier_framework_lot_rates!(user: user, framework: framework, model: model, rates: rates, change_type: CHANGE_TYPES[:add_rates_for_supplier_framework_lot_jurisdiction])
      end

      def log_remove_rates_for_supplier_framework_lot_jurisdiction!(user:, framework:, model:, rates:)
        log_generic_update_supplier_framework_lot_rates!(user: user, framework: framework, model: model, rates: rates, change_type: CHANGE_TYPES[:remove_rates_for_supplier_framework_lot_jurisdiction])
      end

      private

      # rubocop:disable Metrics/ParameterLists
      def log_generic_update_supplier_information!(user:, framework:, model:, supplier_name:, change_type:, **)
        return unless model.saved_changes?

        model_changes = collect_changes_from_model(model)

        create!(user: user, framework_id: framework, change_type: change_type, change_data: { id: model.id, supplier_name: supplier_name, before: model_changes[:before], after: model_changes[:after], ** })
      end

      def log_generic_update_list_update!(user:, framework:, model:, supplier_name:, lot_id:, change_type:, added:, removed:)
        return unless added.any? || removed.any?

        create!(user: user, framework_id: framework, change_type: change_type, change_data: { id: model.id, supplier_name: supplier_name, lot_id: lot_id, added: added, removed: removed })
      end

      def log_generic_update_supplier_framework_lot_rates!(user:, framework:, model:, change_type:, rates:)
        change_data = { id: model.id, supplier_name: model.supplier_framework.supplier_name, lot_id: model.lot_id, rates: [] }

        rates.each_value do |rate|
          change_data_item = collect_rate_changes(rate)

          unless change_data_item.nil?
            change_data[:jurisdiction_id] ||= rate.jurisdiction.jurisdiction_id
            change_data[:rates] << change_data_item
          end
        end

        create!(user: user, framework_id: framework, change_type: change_type, change_data: change_data) if change_data[:rates].any?
      end
      # rubocop:enable Metrics/ParameterLists

      def collect_changes_from_model(model)
        changes = { before: {}, after: {} }

        model.saved_changes.except(:updated_at).each do |attribute, (old_value, new_value)|
          if old_value.is_a?(Hash) && new_value.is_a?(Hash)
            changed_keys = (old_value.keys + new_value.keys).uniq.reject do |key|
              old_value[key] == new_value[key]
            end

            changes[:before][attribute] = old_value.slice(*changed_keys)
            changes[:after][attribute] = new_value.slice(*changed_keys)
          else
            changes[:before][attribute] = old_value
            changes[:after][attribute] = new_value
          end
        end

        changes
      end

      def collect_rate_changes(rate)
        change_data_item = {}

        if rate.previously_new_record?
          change_data_item[:after] = rate.rate
        elsif rate.destroyed?
          change_data_item[:before] = rate.rate
        elsif rate.saved_changes?
          change_data_item[:before] = rate.saved_changes['rate'][0]
          change_data_item[:after] = rate.saved_changes['rate'][1]
        else
          return nil
        end

        change_data_item.merge(
          {
            id: rate.id,
            position_id: rate.position_id,
          }
        )
      end
    end
  end
end
