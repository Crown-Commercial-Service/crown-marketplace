# This class reads the services specification CSV file and parses all the
# headings, sub-headings, clauses and sub-clauses, into a hash, ready to be
# rendered via an ERB template. The initialize method reads and parses the whole
# file, then the call method extracts just the parts relevant the specified
# service.
#
# To replace the CSV file take the 'RM3830 DIRECT AWARD Deliverables Matrix -
# template v3.0.xlsx' file and export just the 'Service Descriptions' tab as a
# CSV named according to the DATA_FILE_PATH constant.

class FacilitiesManagement::RM3830::ServiceSpecificationParser
  DATA_FILE_PATH = Rails.root.join('data', 'facilities_management', 'rm3830', 'service_specifications.csv')

  WORK_PACKAGE_REGEX = /^work package ([A-Z]) /i
  SERVICE_REGEX = /^[0-9]+\.[^.]*[Ss]ervice\s+([A-Z]:{1,2}[0-9]+)/
  GENERIC_CLAUSE_REGEX = /^[0-9]+\.[^.]*generic/i

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def initialize
    csv = CSV.read(DATA_FILE_PATH)

    lines = csv.pluck(3)

    @work_packages = {}
    work_package_code = nil
    service_code = nil
    generic = false

    lines.each do |line|
      next if line.blank?

      sanitized_line = sanitize(line)
      leading_number_removed_line = remove_front_number(sanitized_line)

      # New work package
      match = line.match(WORK_PACKAGE_REGEX)
      if match
        work_package_code = match[1]
        @work_packages[work_package_code] = { heading: leading_number_removed_line, generic: {}, services: {} }
        next
      end

      # New service
      match = line.match(SERVICE_REGEX)
      if match
        generic = false
        service_code = match[1].sub('::', ':') # Some service codes in the spreadsheet are known to have TWO colons
        @work_packages[work_package_code][:services][service_code] = { heading: leading_number_removed_line, clauses: [] }
        next
      end

      # New and subsequent generic clauses for work package
      match = line.match(GENERIC_CLAUSE_REGEX)
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
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity

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
    str.tr('–', '-')                 # Convert non-ascii hyphens to ascii
       .tr('‘', "'")                 # Convert non-ascii left apostrophes to ascii
       .tr('’', "'")                 # Convert non-ascii right apostrophes to ascii
       .delete("^\u{0000}-\u{007F}") # Remove any remaining non-ascii chars
  end

  def remove_front_number(str)
    str.sub(/\d+\.\W+/, '') # Using \W (non-word char) because spaces seem to be non-ascii from the XLS export
  end

  def split_number_and_clause(str)
    number = nil
    match = str.match(/\A[\d.]+/) # Must have a '#santize'd string

    if match
      str.slice!(match[0])
      number = match[0]
    end

    { number: number, body: str.strip }
  end
end
