class DataLoader
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_reader :application, :task_name

  private

  attr_writer :application, :task_name

  public

  validates :application, inclusion: { in: -> { AVAILABL_TASKS.keys } }
  validates :task_name, inclusion: { in: ->(manage_tasks) { AVAILABL_TASKS[manage_tasks.application] } }, if: -> { errors[:application].none? }

  def initialize(**)
    assign_attributes(**)
  end

  def assign_attributes(**new_attributes)
    raise ArgumentError, 'When assigning attributes, you must pass a hash as an argument.' unless new_attributes.respond_to?(:stringify_keys)
    return if new_attributes.empty?

    attributes = new_attributes.stringify_keys

    attributes.each do |key, value|
      setter = :"#{key}="

      raise ActiveRecord::UnknownAttributeError.new(self, key) unless respond_to?(setter, true)

      send(setter, value)
    end
  end

  def invoke_task
    Rails.logger.info { "Running the data import for #{task_name}" }

    case task_name
    when 'bank_holidays'
      BankHolidays.update_bank_holidays_csv
    when 'update_frameworks'
      Frameworks.update_frameworks
    when 'import_test_data'
      TestData.import_test_data unless Marketplace.environment_name == :production
    end
  end

  AVAILABL_TASKS = begin
    task_list = {
      'fm' => [
        'bank_holidays',
        'update_frameworks',
      ],
      'legacy' => [
        'bank_holidays',
        'update_frameworks',
      ],
    }

    unless Marketplace.environment_name == :production
      task_list['fm'] << 'import_test_data'
      task_list['legacy'] << 'import_test_data'
    end

    task_list
  end
end
