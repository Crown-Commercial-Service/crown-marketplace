require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'

class Upload < ApplicationRecord
  belongs_to :framework, inverse_of: :uploads

  def self.upload!(framework, suppliers)
    error = all_or_none(framework) do
      supplier_frameworks = Supplier::Framework.where(framework:)
      supplier_ids = supplier_frameworks.pluck(:supplier_id)

      supplier_frameworks.find_each(&:destroy)
      Supplier.where(id: supplier_ids).find_each(&:destroy)

      suppliers.each do |supplier_data|
        supplier = Supplier.create!(supplier_data.except(:supplier_frameworks))

        add_supplier_framework!(supplier, supplier_data)
      end
      create!(framework_id: framework)
    end
    raise error if error
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def self.smart_upload!(framework, suppliers)
    error = all_or_none(framework) do
      Supplier::Framework.where(framework:).destroy_all

      suppliers.each do |supplier_data|
        supplier = if supplier_data[:duns_number]
                     Supplier.find_by(duns_number: supplier_data[:duns_number]) || Supplier.find_by(name: supplier_data[:name])
                   elsif supplier_data[:id]
                     Supplier.find_by(id: supplier_data[:id])
                   end

        if supplier.present?
          supplier.update!(supplier_data.except(:id, :supplier_frameworks))
        else
          supplier = Supplier.create!(supplier_data.except(:supplier_frameworks))
        end

        add_supplier_framework!(supplier, supplier_data)
      end
    end
    raise error if error
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/BlockLength
  def self.add_supplier_framework!(supplier, supplier_data)
    supplier_data[:supplier_frameworks].each do |supplier_framework_data|
      supplier_framework = supplier.supplier_frameworks.create!(supplier_framework_data.slice(:framework_id, :enabled))

      Supplier::Framework::ContactDetail.create!(supplier_framework:, **supplier_framework_data[:supplier_framework_contact_detail]) if supplier_framework_data[:supplier_framework_contact_detail]
      Supplier::Framework::Address.create!(supplier_framework:, **supplier_framework_data[:supplier_framework_address]) if supplier_framework_data[:supplier_framework_address]

      supplier_framework_data[:supplier_framework_lots].each do |supplier_framework_lot_data|
        supplier_framework_lot = supplier_framework.lots.create!(supplier_framework_lot_data.slice(:lot_id, :enabled))

        Supplier::Framework::Lot::Service.import!(
          supplier_framework_lot_data[:supplier_framework_lot_services].map do |supplier_framework_lot_service_data|
            {
              supplier_framework_lot_id: supplier_framework_lot.id,
              **supplier_framework_lot_service_data
            }
          end
        )

        supplier_framework_lot_jurisdiction_ids = Supplier::Framework::Lot::Jurisdiction.import!(
          supplier_framework_lot_data[:supplier_framework_lot_jurisdictions].map do |supplier_framework_lot_jurisdiction_data|
            {
              supplier_framework_lot_id: supplier_framework_lot.id,
              **supplier_framework_lot_jurisdiction_data
            }
          end
        ).ids

        jurisdiction_id_to_supplier_framework_lot_jurisdiction = supplier_framework_lot_data[:supplier_framework_lot_jurisdictions].zip(supplier_framework_lot_jurisdiction_ids).to_h do |supplier_framework_lot_jurisdiction_data, supplier_framework_lot_jurisdiction_id|
          [
            supplier_framework_lot_jurisdiction_data[:jurisdiction_id],
            supplier_framework_lot_jurisdiction_id
          ]
        end

        Supplier::Framework::Lot::Rate.import!(
          supplier_framework_lot_data[:supplier_framework_lot_rates].map do |supplier_framework_lot_rate_data|
            {
              supplier_framework_lot_id: supplier_framework_lot.id,
              supplier_framework_lot_jurisdiction_id: jurisdiction_id_to_supplier_framework_lot_jurisdiction[supplier_framework_lot_rate_data[:jurisdiction_id]],
              **supplier_framework_lot_rate_data.except(:jurisdiction_id)
            }
          end
        )

        # Because of how slugs are generated, these need to be imported one at a time
        supplier_framework_lot_data[:supplier_framework_lot_branches].map do |supplier_framework_lot_branches_data|
          supplier_framework_lot_branches_data[:location] = Geocoding.point(
            latitude: supplier_framework_lot_branches_data[:lat],
            longitude: supplier_framework_lot_branches_data[:lon]
          )

          Supplier::Framework::Lot::Branch.create!(
            supplier_framework_lot_id: supplier_framework_lot.id,
            **supplier_framework_lot_branches_data.except(:lat, :lon)
          )
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/BlockLength

  def self.all_or_none(framework)
    error = nil

    lock_available = DistributedLocks.distributed_lock(framework[2..].to_i) do
      Supplier.transaction do
        yield
      rescue ActiveRecord::RecordInvalid => e
        error = e
        raise ActiveRecord::Rollback
      end
    end

    error = 'Upload already in progress, cannot do multiple uploads at the same time' unless lock_available

    error
  end
end
