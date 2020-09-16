$(function () {
  if($('#bulk-upload-in-progress').length){
    var procurement_id = document.getElementById('procurement_id').value
    var spreadsheet_import_id = document.getElementById('spreadsheet_import_id').value

    var url = '/facilities-management/procurements/' + procurement_id + '/spreadsheet_imports/' + spreadsheet_import_id + '/progress'

    var interval = 15000;

    function checkUploadProgress() {
      $.ajax({
        type: 'GET',
        url: url,
        data: $(this).serialize(),
        dataType: 'json',
        success: function (data) {
          processImportStatus(data.refresh);
        },
        complete: function (data) {
          checkIfContinue(data)
        }
      });
    }

    function processImportStatus(status){
      if (status) {
        location.reload();
      }
    }

    function checkIfContinue(data){
      if (data.status === 200) {
        if (data.responseJSON.continue) {
          setTimeout(checkUploadProgress, interval)
        }
      }
    }

    setTimeout(checkUploadProgress, interval);
  }
})