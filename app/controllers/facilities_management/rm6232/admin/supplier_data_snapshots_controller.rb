module FacilitiesManagement
  module RM6232
    module Admin
      class SupplierDataSnapshotsController < FacilitiesManagement::Admin::FrameworkController
        def new
          @snapshot = SupplierData::Snapshot.new
        end

        def create
          @snapshot = SupplierData::Snapshot.new(snapshot_params)
          if @snapshot.valid?
            send_data @snapshot.generate_snapshot_zip, filename: @snapshot.snapshot_filename, type: 'application/zip'
          else
            render :new
          end
        end

        private

        def snapshot_params
          params.expect(
            facilities_management_rm6232_admin_supplier_data_snapshot: %i[
              snapshot_date_yyyy
              snapshot_date_mm
              snapshot_date_dd
              snapshot_time_hh
              snapshot_time_mm
            ],
          )
        end
      end
    end
  end
end
