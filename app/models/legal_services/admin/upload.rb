module LegalServices
  module Admin
    class Upload < ApplicationRecord
      include AASM
      self.table_name = 'legal_services_admin_uploads'
      default_scope { order(created_at: :desc) }

      ATTRIBUTES = %i[suppliers rate_cards supplier_lot_1_service_offerings supplier_lot_2_service_offerings supplier_lot_3_service_offerings supplier_lot_4_service_offerings].freeze

      mount_uploader :suppliers, LegalServicesFileUploader
      mount_uploader :rate_cards, LegalServicesFileUploader
      mount_uploader :supplier_lot_1_service_offerings, LegalServicesFileUploader
      mount_uploader :supplier_lot_2_service_offerings, LegalServicesFileUploader
      mount_uploader :supplier_lot_3_service_offerings, LegalServicesFileUploader
      mount_uploader :supplier_lot_4_service_offerings, LegalServicesFileUploader

      attr_accessor :suppliers_cache, :rate_cards_cache, :supplier_lot_1_service_offerings_cache, :supplier_lot_2_service_offerings_cache, :supplier_lot_3_service_offerings_cache, :supplier_lot_4_service_offerings_cache

      validates :suppliers, presence: true
      validates :rate_cards, presence: true
      validates :supplier_lot_1_service_offerings, presence: true
      validates :supplier_lot_2_service_offerings, presence: true
      validates :supplier_lot_3_service_offerings, presence: true
      validates :supplier_lot_4_service_offerings, presence: true

      aasm do
        state :in_progress, initial: true
        state :in_review, :failed, :approved, :rejected, :canceled, :completed
        event :review do
          transitions from: :in_progress, to: :in_review
        end
        event :fail do
          transitions from: %i[in_progress approved], to: :failed
        end
        event :approve do
          after :start_upload
          transitions from: :in_review, to: :approved
        end
        event :complete do
          transitions from: :approved, to: :completed
        end
        event :reject do
          transitions from: :in_review, to: :rejected
        end
        event :cancel do
          transitions from: %i[in_review in_progress], to: :canceled
        end
      end

      def files_count
        count = 0
        [suppliers, rate_cards, supplier_lot_1_service_offerings, supplier_lot_2_service_offerings, supplier_lot_3_service_offerings, supplier_lot_4_service_offerings].each do |uploaded_file|
          count += 1 if uploaded_file.file.present?
        end
        count
      end

      def short_uuid
        id[0..7]
      end

      def self.in_review_or_in_progress
        in_review + in_progress
      end

      private

      def start_upload
        LegalServices::DataUploadWorker.perform_async(id)
      end

      def reject_previous_uploads
        self.class.in_review.map(&:cancel!)
        self.class.in_progress.map(&:cancel!)
      end
    end
  end
end
