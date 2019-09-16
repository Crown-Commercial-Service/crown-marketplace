module SupplyTeachers
  module Admin
    class Upload < ApplicationRecord
      include AASM
      self.table_name = 'supply_teachers_admin_uploads'
      default_scope { order(created_at: :desc) }
      ATTRIBUTES = %i[current_accredited_suppliers geographical_data_all_suppliers lot_1_and_lot_2_comparisons master_vendor_contacts neutral_vendor_contacts pricing_for_tool supplier_lookup].freeze

      mount_uploader :current_accredited_suppliers, SupplyTeachersFileUploader
      mount_uploader :geographical_data_all_suppliers, SupplyTeachersFileUploader
      mount_uploader :lot_1_and_lot_2_comparisons, SupplyTeachersFileUploader
      mount_uploader :master_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :neutral_vendor_contacts, SupplyTeachersFileUploader
      mount_uploader :pricing_for_tool, SupplyTeachersFileUploader
      mount_uploader :supplier_lookup, SupplyTeachersFileUploader

      attr_accessor :current_accredited_suppliers_cache, :geographical_data_all_suppliers_cache, :lot_1_and_lot_2_comparisons_cache, :master_vendor_contacts_cache, :neutral_vendor_contacts_cache, :pricing_for_tool_cache, :supplier_lookup_cache

      validate :any_present?, on: :create
      validate :reject_uploads_and_cp_files, on: :create

      aasm do
        state :in_progress, initial: true
        state :in_review, :failed, :approved, :rejected, :canceled, :uploading
        event :review do
          transitions from: :in_progress, to: :in_review
        end
        event :fail do
          transitions from: %i[in_progress uploading], to: :failed, after: :cleanup_input_files
        end
        event :upload do
          transitions from: :in_review, to: :uploading
        end
        event :approve do
          transitions from: :uploading, to: :approved
        end
        event :reject do
          transitions from: :in_review, to: :rejected, after: :cleanup_input_files
        end
        event :cancel do
          transitions from: %i[in_review in_progress uploading], to: :canceled, after: :cleanup_input_files
        end
      end

      def cleanup_input_files
        current_data = CurrentData.first_or_create
        current_data.current_accredited_suppliers = Upload.previous_uploaded_file(:current_accredited_suppliers) if available_for_cp(:current_accredited_suppliers)
        current_data.geographical_data_all_suppliers = Upload.previous_uploaded_file(:geographical_data_all_suppliers) if available_for_cp(:geographical_data_all_suppliers)
        current_data.lot_1_and_lot_2_comparisons = Upload.previous_uploaded_file(:lot_1_and_lot_2_comparisons) if available_for_cp(:lot_1_and_lot_2_comparisons)
        current_data.master_vendor_contacts = Upload.previous_uploaded_file(:master_vendor_contacts) if available_for_cp(:master_vendor_contacts)
        current_data.neutral_vendor_contacts = Upload.previous_uploaded_file(:neutral_vendor_contacts) if available_for_cp(:neutral_vendor_contacts)
        current_data.pricing_for_tool = Upload.previous_uploaded_file(:pricing_for_tool) if available_for_cp(:pricing_for_tool)
        current_data.supplier_lookup = Upload.previous_uploaded_file(:supplier_lookup) if available_for_cp(:supplier_lookup)
        current_data.save!
      end

      def files_count
        count = 0
        [current_accredited_suppliers, geographical_data_all_suppliers, lot_1_and_lot_2_comparisons, master_vendor_contacts, neutral_vendor_contacts, pricing_for_tool, supplier_lookup].each do |uploaded_file|
          count += 1 if uploaded_file.file.present?
        end
        count
      end

      def datetime
        created_at.strftime('%d %b %Y at %l:%M%P')
      end

      def self.previous_uploaded_file(attr_name)
        previous_uploaded_file_object(attr_name).try(:send, attr_name)
      end

      def self.previous_uploaded_file_url(attr_name)
        previous_uploaded_file_object(attr_name).try(:send, attr_name.to_s + '_url')
      end

      def self.previous_uploaded_file_object(attr_name)
        where(aasm_state: :approved).where.not("#{attr_name}": nil).first
      end

      def self.in_review_or_in_progress
        in_review + in_progress + uploading
      end

      def self.perform_upload(upload_id)
        upload_session = find(upload_id)
        upload_session.upload!
        SupplyTeachers::DataUploadWorker.perform_async(upload_id)
        upload_session
      end

      private

      def any_present?
        errors.add :base, :none_present unless ATTRIBUTES.any? { |attr| send(attr).try(:present?) }
      end

      def reject_uploads_and_cp_files
        return if errors.any?

        reject_previous_uploads
        copy_files_to_input_folder
      rescue StandardError => e
        errors.add(:base, e.message)
      end

      def copy_files_to_input_folder
        current_data = CurrentData.first_or_create
        current_data.current_accredited_suppliers = self.current_accredited_suppliers if current_accredited_suppliers_changed?
        current_data.geographical_data_all_suppliers = self.geographical_data_all_suppliers if geographical_data_all_suppliers_changed?
        current_data.lot_1_and_lot_2_comparisons = self.lot_1_and_lot_2_comparisons if lot_1_and_lot_2_comparisons_changed?
        current_data.master_vendor_contacts = self.master_vendor_contacts if master_vendor_contacts_changed?
        current_data.neutral_vendor_contacts = self.neutral_vendor_contacts if neutral_vendor_contacts_changed?
        current_data.pricing_for_tool = self.pricing_for_tool if pricing_for_tool_changed?
        current_data.supplier_lookup = self.supplier_lookup if supplier_lookup_changed?
        current_data.save!
      end

      def reject_previous_uploads
        self.class.in_review.map(&:cancel!)
        self.class.in_progress.map(&:cancel!)
        self.class.uploading.map(&:cancel!)
      end

      def available_for_cp(attr_name)
        send(attr_name).file.present? && self.class.previous_uploaded_file(attr_name).try(:file).present?
      end
    end
  end
end
