$(function () {

    const leadingZero = function (num) {
        return num < 10 ? '0' + num : num;
    };

    const clearContractEndDate = function () {
        $('#contract-end-date-dd').val('');
        $('#contract-end-date-mm').val('');
        $('#contract-end-date-yyyy').val('');
        clearMobilisationDates()
    };

    const clearMobilisationDates = function () {
        $('#mobilisation-start-date-dd').val('');
        $('#mobilisation-start-date-mm').val('');
        $('#mobilisation-start-date-yyyy').val('');
        $('#mobilisation-end-date-dd').val('');
        $('#mobilisation-end-date-mm').val('');
        $('#mobilisation-end-date-yyyy').val('');
    };

    const clearMobilisationPeriod = function () {
        $('#facilities_management_procurement_mobilisation_period').val('');
        clearMobilisationDates();
    };

    const displayContractDates = function () {

        let initialCallOffPeriod = parseInt($('#facilities_management_procurement_initial_call_off_period').val());
        let ds = $('#facilities_management_procurement_initial_call_off_start_date_dd').val();
        let ms = $('#facilities_management_procurement_initial_call_off_start_date_mm').val();
        let ys = $('#facilities_management_procurement_initial_call_off_start_date_yyyy').val();

        if (initialCallOffPeriod && ds && ms && ys) {
            let mobilisationPeriod = parseInt($('#facilities_management_procurement_mobilisation_period').val());
            let dd = parseInt(ds);
            let mm = parseInt(ms);
            let yyyy = parseInt(ys);
            let contractStartDate = new Date(yyyy, mm - 1, dd);
            let contractEndDate = contractDateUtils.contractEndDate(contractStartDate, initialCallOffPeriod);
            /* Display contract end date */
            $('#contract-end-date-dd').val(leadingZero(contractEndDate.getDate()));
            $('#contract-end-date-mm').val(leadingZero(contractEndDate.getMonth() + 1));
            $('#contract-end-date-yyyy').val(leadingZero(contractEndDate.getFullYear()));

            if (mobilisationPeriod && dd !== NaN) {
                let dates = contractDateUtils.calcContractDates(contractStartDate, initialCallOffPeriod, mobilisationPeriod);
                /* display mobilisation start date */
                $('#mobilisation-start-date-dd').val(dates['Contract-Mob-Start'].substr(8, 2));
                $('#mobilisation-start-date-mm').val(dates['Contract-Mob-Start'].substr(5, 2));
                $('#mobilisation-start-date-yyyy').val(dates['Contract-Mob-Start'].substr(0, 4));

                /* display mobilisation end date */
                $('#mobilisation-end-date-dd').val(dates['Contract-Mob-End'].substr(8, 2));
                $('#mobilisation-end-date-mm').val(dates['Contract-Mob-End'].substr(5, 2));
                $('#mobilisation-end-date-yyyy').val(dates['Contract-Mob-End'].substr(0, 4));

            } else {
                clearMobilisationDates();
            }
        } else {
            clearContractEndDate();
        }

    };

    $('#facilities_management_procurement_mobilisation_period').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_dd').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_mm').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_start_date_yyyy').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_initial_call_off_period').on('keyup', function (e) {
        displayContractDates();
    });

    $('#facilities_management_procurement_mobilisation_period_required_false').on('click', function (e) {
        clearMobilisationPeriod();
    });

    displayContractDates();

});
