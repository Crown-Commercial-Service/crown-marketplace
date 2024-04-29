class FacilitiesManagement::Admin::Upload < ApplicationRecord
  include AASM

  self.abstract_class = true

  default_scope { order(created_at: :desc) }
  serialize :import_errors, type: Array, coder: YAML

  validate :supplier_files_validation, on: :upload

  aasm do
    state :not_started, initial: true
    state :in_progress
    state :checking_files
    state :processing_files
    state :checking_processed_data
    state :publishing_data
    state :published
    state :failed
    event :start_upload do
      transitions from: :not_started, to: :in_progress
      after do
        self.class::SERVICE::FileUploadWorker.perform_async(id)
      end
    end
    event :check_files do
      transitions from: :in_progress, to: :checking_files
    end
    event :process_files do
      transitions from: :checking_files, to: :processing_files
    end
    event :check_processed_data do
      transitions from: :processing_files, to: :checking_processed_data
    end
    event :publish_data do
      transitions from: :checking_processed_data, to: :publishing_data
    end
    event :publish do
      transitions from: :publishing_data, to: :published
    end
    event :fail do
      transitions from: %i[not_started in_progress checking_files processing_files checking_processed_data publishing_data published], to: :failed
    end
  end

  def short_uuid
    id[0..7]
  end

  def self.latest_upload
    published.order(created_at: :desc).first
  end

  private

  def supplier_files_validation
    self.class.attributes.each do |file|
      if send(file).attached?
        errors.add(file, :wrong_extension) unless send(file).blob.filename.to_s.end_with?('.xlsx')
      else
        errors.add(file, :not_attached)
      end
    end
  end
end
