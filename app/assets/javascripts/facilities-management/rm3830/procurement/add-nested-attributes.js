const addNestedAttributes = {
  maxRows: 99,

  init(nestedAttribute) {
    this.rowClass = nestedAttribute.rowClass;
    this.rowNumberClass = nestedAttribute.rowNumberClass;
    this.removeButtonClass = nestedAttribute.removeButtonClass;
    this.removedRowClassName = nestedAttribute.removedRowClassName;

    this.$addButton = nestedAttribute.$addButton;

    this.rowText = nestedAttribute.rowText;
    this.addButtonText = nestedAttribute.addButtonText;
    this.updateRemoveButtons = nestedAttribute.updateRemoveButtons;

    this.setRemoveRowEventListeners();
    this.setAddRowEventListeners();
    this.updateRows();
  },

  getNumberOfRows() {
    return $(this.rowClass).length;
  },

  setRowText() {
    $(`${this.rowClass} ${this.rowNumberClass}`).each((i, element) => {
      $(element).text(this.rowText(i + 1));
    });
  },

  updateAddButton() {
    const numberRemaining = this.maxRows - this.getNumberOfRows();

    this.$addButton.text(this.addButtonText(numberRemaining));
  },

  updateRows() {
    this.setRowText();
    this.updateRemoveButtons(this.getNumberOfRows());
    this.updateAddButton();
  },

  setRemoveRowEventListeners() {
    $('form').on('click', this.removeButtonClass, (event) => {
      const row = $(event.currentTarget.closest(this.rowClass));

      $(event.currentTarget).next().val('true');
      row.addClass(this.removedRowClassName);
      row.closest('div').removeClass(this.rowClass.slice(1));
      row.hide();
      this.updateRows();
      event.preventDefault();
    });
  },

  setAddRowEventListeners() {
    const addNestedAttributesObject = this;

    this.$addButton.click((event) => {
      if (addNestedAttributesObject.getNumberOfRows() < addNestedAttributesObject.maxRows) {
        const time = new Date().getTime();
        const regexp = new RegExp($(event.currentTarget).data('id'), 'g');
        $('.fields').append($(event.currentTarget).data('fields').replace(regexp, time));
        addNestedAttributesObject.updateRows();
      }

      event.preventDefault();
    });
  },
};
