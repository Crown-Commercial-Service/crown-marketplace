const uploadFileImport = {
  continue: true,
  currentState: 'in_progress',

  init(stateToProgress, succeeded_state, failed_state) {
    this.url = `${window.location.pathname}/progress`;
    this.stateToProgress = stateToProgress;
    this.succeeded_state = succeeded_state;
    this.failed_state = failed_state;

    setTimeout(this.checkImportProgress, this.interval);
  },

  checkImportProgress() {
    $.ajax({
      type: 'GET',
      url: uploadFileImport.url,
      data: $(this).serialize(),
      dataType: 'json',
      success(data) {
        uploadFileImport.currentState = data.import_status;
      },
      error() {
        uploadFileImport.continue = false;
      },
      complete() {
        uploadFileImport.processImportStatus();
      },
    });
  },

  processImportStatus() {
    if (this.continue) {
      $('#upload-import-progress').attr('style', `width: ${this.stateToProgress[this.currentState].progress}%`);
      this.updateCurrentState();
      let continueFunction = this.checkImportProgress;

      if (this.currentState === this.succeeded_state || this.currentState === this.failed_state) {
        $('#upload-import-progress').addClass(this.stateToProgress[this.currentState].colourClass);
        continueFunction = this.processComplete;
      }

      setTimeout(continueFunction, this.stateToProgress[this.currentState].wait);
    } else {
      this.processComplete();
    }
  },

  updateCurrentState() {
    $('.ccs-upload-progress-container > div').each(this.updateShownStatus.bind(this));
  },

  updateShownStatus(_, element) {
    if ($(element).attr('id') === this.stateToProgress[this.currentState].state) {
      $(element).attr('aria-current', true);
      $(element).addClass('govuk-!-font-weight-bold');
    } else {
      $(element).removeAttr('aria-current');
      $(element).removeClass('govuk-!-font-weight-bold');
    }
  },

  processComplete() {
    window.location.reload();
  },
};
