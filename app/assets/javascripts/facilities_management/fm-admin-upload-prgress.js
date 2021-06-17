$(() => {
  const stateToProgress = {
    not_started: {
      progress: 10,
      wait: 500,
      state: 'progress-0',
    },
    in_progress: {
      progress: 10,
      wait: 500,
      state: 'progress-0',
    },
    checking_file: {
      progress: 30,
      wait: 500,
      state: 'progress-1',
    },
    processing_file: {
      progress: 50,
      wait: 500,
      state: 'progress-2',
    },
    publishing_data: {
      progress: 70,
      wait: 500,
      state: 'progress-3',
    },
    published: {
      progress: 100,
      wait: 500,
      state: 'progress-4',
      colourClass: 'ccs-progress-bar--succeed',
    },
    failed: {
      progress: 100,
      wait: 500,
      state: 'progress-4',
      colourClass: 'ccs-progress-bar--fail',
    },
  };

  const adminFileImport = {
    continue: true,
    currentState: 'in_progress',

    init() {
      this.url = `${window.location.pathname}/progress`;

      setTimeout(this.checkImportProgress, this.interval);
    },

    checkImportProgress() {
      $.ajax({
        type: 'GET',
        url: adminFileImport.url,
        data: $(this).serialize(),
        dataType: 'json',
        success(data) {
          adminFileImport.currentState = data.import_status;
        },
        error() {
          adminFileImport.continue = false;
        },
        complete() {
          adminFileImport.processImportStatus();
        },
      });
    },

    processImportStatus() {
      if (this.continue) {
        $('#fm-admin-import-progress').attr('style', `width: ${stateToProgress[this.currentState].progress}%`);
        this.updateCurrentState();
        let continueFunction = this.checkImportProgress;

        if (this.currentState === 'published' || this.currentState === 'failed') {
          $('#fm-admin-import-progress').addClass(stateToProgress[this.currentState].colourClass);
          continueFunction = this.processComplete;
        }

        setTimeout(continueFunction, stateToProgress[this.currentState].wait);
      } else {
        this.processComplete();
      }
    },

    updateCurrentState() {
      $('.ccs-upload-progress-container > div').each(this.updateShownStatus.bind(this));
    },

    updateShownStatus(_, element) {
      if ($(element).attr('id') === stateToProgress[this.currentState].state) {
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

  if ($('#fm-admin-import-progress').length) {
    adminFileImport.init();
  }
});
