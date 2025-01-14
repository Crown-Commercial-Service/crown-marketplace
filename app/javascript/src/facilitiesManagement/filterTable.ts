class FilterTableRow {
  private readonly $row: JQuery<HTMLTableRowElement>
  private readonly rowValue: string

  constructor ($row: JQuery<HTMLTableRowElement>, column: number) {
    this.$row = $row
    this.rowValue = (this.$row.children().get(column)?.textContent ?? '').toUpperCase()
  }

  checkRowAndToggleVisibility = (filter: string): void => {
    const isShown: boolean = this.rowValue.includes(filter)

    if (isShown) {
      this.$row.show()
    } else {
      this.$row.hide()
    }
  }
}

class FilterTable {
  private readonly $searchBox: JQuery<HTMLInputElement>
  private readonly column: number
  private readonly tableRows: FilterTableRow[] = []

  constructor () {
    this.$searchBox = $('#fm-table-filter-input')
    this.column = Number($('#fm-table-filter-input').attr('data-column')) || 0

    const $tableRows: JQuery<HTMLTableRowElement> = $('#fm-table-filter').find('tbody').find('tr')

    $tableRows.each((_index: number, tableRow: HTMLTableRowElement) => {
      this.tableRows.push(new FilterTableRow($(tableRow), this.column))
    })

    this.setEventListners()
  }

  private readonly setEventListners = (): void => {
    this.$searchBox.on('keyup', () => { this.filterTable(String(this.$searchBox.val() ?? '').toUpperCase()) })
  }

  private readonly filterTable = (filter: string): void => { this.tableRows.forEach(tableRow => { tableRow.checkRowAndToggleVisibility(filter) }) }
}

const initFilterTable = (): void => {
  if ($('#fm-table-filter-input').length > 0) new FilterTable()
}

export default initFilterTable
