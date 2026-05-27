class FilterTableRow {
  $row: JQuery<HTMLTableRowElement>
  rowValue: string

  constructor ($row: JQuery<HTMLTableRowElement>) {
    this.$row = $row
    this.rowValue = (this.$row.find('th').text() ?? '').toUpperCase()
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
  $searchBox: JQuery<HTMLInputElement>
  tableRows: FilterTableRow[]

  constructor ($filterTable: JQuery<HTMLElement>) {
    this.$searchBox = $filterTable.find<HTMLInputElement>('input')
    this.tableRows = $filterTable.find<HTMLTableRowElement>('table > tbody > tr').get().map(tableRowElement => new FilterTableRow($(tableRowElement)))
  }

  init = () => {
    this.$searchBox.on('keyup', () => { this.filterTable(String(this.$searchBox.val() ?? '').toUpperCase()) })
  }

  filterTable = (filter: string): void => { this.tableRows.forEach(tableRow => { tableRow.checkRowAndToggleVisibility(filter) }) }
}


const initFilterTable = () => {
  if ($('[data-module="filter-table"]').length) new FilterTable($('[data-module="filter-table"]')).init()
}

export default initFilterTable