class FacilitiesManagement::ServiceSpecificationParser
  DATA_FILE_PATH = File.join(Rails.root, 'data', 'facilities_management', 'service_specifications.csv')

  def initialize
    csv = CSV.read(DATA_FILE_PATH)

    lines = csv.map { |row| row[3] }

    @work_packages = {}
    work_package_code = nil
    service_code = nil
    generic = false

    lines.each do |line|
      next if line.blank?

      sanitized_line = sanitize(line)
      leading_number_removed_line = remove_front_number(sanitized_line)

      # New work package
      match = line.match(/^work package ([A-Z]) /i)
      if match
        work_package_code = match[1]
        @work_packages[work_package_code] = { heading: leading_number_removed_line, generic: {}, services: {} }
        next
      end

      # New service
      match = line.match(/^[0-9]+\.[^\.]*service\s+([A-Z]:[0-9]+)\s/i)
      if match
        generic = false
        service_code = match[1]
        @work_packages[work_package_code][:services][service_code] = { heading: leading_number_removed_line, clauses: [] }
        next
      end

      # New and subsequent generic clauses for work package
      match = line.match(/^[0-9]+\.[^\.]*generic/i)
      if match || generic
        generic = true

        if @work_packages[work_package_code][:generic].empty?
          @work_packages[work_package_code][:generic] = { heading: leading_number_removed_line, clauses: [] }
        else
          @work_packages[work_package_code][:generic][:clauses] << split_number_and_clause(sanitized_line)
        end

        next
      end

      # Must be a clause of current service within a work package
      @work_packages[work_package_code][:services][service_code][:clauses] << split_number_and_clause(sanitized_line) if work_package_code && service_code
    end

=begin
# What to aim for
work_packages:
  'A':
    heading: 'Work Package A – Contract Management'
    generic: {}
    services:
      'A.1':
        heading: 'Service A:1 - Integration'
        clauses:
          - number: '1.1.'
            clause: 'Service A:1 – Integration is Mandatory for Lot 1a-1c.'
          - ...more clauses
      'more services': ...
  'C':
    heading: 'Work Package C – Maintenance Services',
    generic:
      heading: 20.   Generic maintenance requirements
      clauses:
        - number: '1.1.',
          clause: 'Service A:1 – Integration is Mandatory for Lot 1a-1c.'
        - ...more generic clauses
    services:
      'A.1':
        heading: 'Service A:1 - Integration'
        clauses:
          - number: '1.1.',
            clause: 'Service A:1 – Integration is Mandatory for Lot 1a-1c.'
          - ...more clauses
      'more services': ...
=end

  end

  def call(service_code, work_package_code)
    service_code_with_colon = service_code.tr('.', ':')

    {
      work_package: {
        heading: @work_packages[work_package_code][:heading],
        generic: @work_packages[work_package_code][:generic]
      },
      service: {
        heading: @work_packages[work_package_code][:services][service_code_with_colon][:heading],
        clauses: @work_packages[work_package_code][:services][service_code_with_colon][:clauses]
      }
    }
  end

  private

  def sanitize(str)
    str.tr('–', '-') # Non-ascii hyphens from the XLS export
  end

  def remove_front_number(str)
    str.sub(/\d+\.\W+/, '') # Using \W (non-word char) because spaces seem to be non-ascii from the XLS export
  end

  def split_number_and_clause(str)
    parts = str.split(/\s/)

    { number: parts.shift, clause: parts.join(' ') }
  end
end
