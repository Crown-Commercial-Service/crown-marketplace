class AllowedEmailDomain
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor :email_domain

  before_validation :remove_excess_space
  validates :email_domain, presence: true, format: { with: /\A[a-z0-9\-.]*\z/ }
  validate :email_domain_not_in_list, unless: -> { errors.any? }

  def save
    if valid?
      add_email_domain_to_the_allow_list
      true
    else
      false
    end
  end

  def domain_in_allow_list?
    allow_list.include? email_domain&.downcase
  end

  def allow_list
    @allow_list ||= if Rails.env.production?
                      allow_list_s3_object.get.body.string.split("\n")
                    else
                      File.read(allow_list_file_path).split
                    end
  end

  def search_allow_list
    remove_excess_space
    allow_list.select { |allowed_email_domains| allowed_email_domains.include? email_domain }
  end

  def remove_email_domain
    update_the_allow_list(sorted_allow_list_with_email_domain_removed)
  end

  private

  def allow_list_s3_object
    @allow_list_s3_object ||= Aws::S3::Resource.new(region: ENV.fetch('COGNITO_AWS_REGION', nil)).bucket(ENV.fetch('CCS_APP_API_DATA_BUCKET', nil)).object(ENV.fetch('ALLOW_LIST_KEY', nil))
  end

  def allow_list_file_path
    @allow_list_file_path ||= Rails.root.join(ENV.fetch('ALLOWED_EMAIL_DOMAINS_FILE_PATH', nil))
  end

  def remove_excess_space
    self.email_domain = email_domain.to_s.downcase.squish
  end

  def email_domain_not_in_list
    errors.add(:email_domain, :taken) if domain_in_allow_list?
  end

  def update_the_allow_list(allow_list)
    if Rails.env.production?
      allow_list_s3_object.put({ body: allow_list })
    else
      File.write(allow_list_file_path, allow_list)
    end
  end

  def add_email_domain_to_the_allow_list
    update_the_allow_list(sorted_allow_list_with_email_domain_added)
  end

  def sorted_allow_list_with_email_domain_added
    allow_list << email_domain
    allow_list.sort!
    allow_list.join("\n")
  end

  def sorted_allow_list_with_email_domain_removed
    allow_list.delete(email_domain)
    allow_list.sort!
    allow_list.join("\n")
  end
end
