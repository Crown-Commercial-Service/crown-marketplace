class FacilitiesManagement::RM6232::ServiceSpecificationParser
  DATA_FILE_PATH = Rails.root.join('data', 'facilities_management', 'rm6232', 'service_specifications.csv')
  SERVICE_LINE_REGEX = /\A[\d+.]+/.freeze

  attr_reader :work_package_service_lines, :service_lines

  def initialize(work_package_code, service_code)
    csv = CSV.read(DATA_FILE_PATH, headers: true)

    work_packages = csv[1..].group_by { |row| row[0] }

    work_package = work_packages[work_package_code].group_by { |row| row[1] }

    unformatted_work_package_service_lines = work_package[work_package_code]
    unformatted_service_lines = work_package[service_code].pluck('Service Line')

    @work_package_service_lines = split_service_lines(unformatted_work_package_service_lines.pluck('Service Line'))[1..] if unformatted_work_package_service_lines
    @service_lines = split_service_lines(unformatted_service_lines)
  end

  private

  def split_service_lines(full_service_lines)
    full_service_lines.map do |service_line|
      {
        numbers: get_service_line_number(service_line),           # Service line numbers
        body: service_line.split(SERVICE_LINE_REGEX).last.squish  # The service line itself
      }
    end
  end

  def get_service_line_number(service_line)
    (service_line.match(SERVICE_LINE_REGEX) || [''])[0].split('.')
  end
end
