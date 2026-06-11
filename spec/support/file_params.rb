FILE_PARAMS = {
  valid_xlsx: [:xlsx, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
  valid_csv: [:csv, 'text/csv'],
  invalid_xlsx_file_extension: [:csv, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
  invalid_csv_file_extension: [:xlsx, 'text/csv'],
  invalid_xlsx_file_content: [:xlsx, 'text/csv'],
  invalid_csv_file_content: [:csv, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
}.freeze
