$(function () {

    const leadingZero = function (num) {
        return num < 10 ? "0" + num : num;
    };

    const clearContractEndDate = function () {
        $("#contract-end-date-dd").val("");
        $("#contract-end-date-mm").val("");
        $("#contract-end-date-yyyy").val("");
        clearMobilisationDates()
    };

    const clearMobilisationDates = function () {
        $("#mobilisation-start-date-dd").val("");
        $("#mobilisation-start-date-mm").val("");
        $("#mobilisation-start-date-yyyy").val("");
        $("#mobilisation-end-date-dd").val("");
        $("#mobilisation-end-date-mm").val("");
        $("#mobilisation-end-date-yyyy").val("");
    };

    const clearMobilisationPeriod = function () {
        $("#facilities_management_procurement_mobilisation_period").val("");
        clearMobilisationDates();
    };

    const displayContractDates = function () {

        let initialCallOffPeriod = parseInt($("#facilities_management_procurement_initial_call_off_period").val());
        let ds = $("#facilities_management_procurement_initial_call_off_start_date_dd").val();
        let ms = $("#facilities_management_procurement_initial_call_off_start_date_mm").val();
        let ys = $("#facilities_management_procurement_initial_call_off_start_date_yyyy").val();

        if (initialCallOffPeriod && ds && ms && ys) {
            let mobilisationPeriod = parseInt($("#facilities_management_procurement_mobilisation_period").val());
            let dd = parseInt(ds);
            let mm = parseInt(ms);
            let yyyy = parseInt(ys);
            let contractStartDate = new Date(yyyy, mm - 1, dd);
            let contractEndDate = contractDateUtils.contractEndDate(contractStartDate, initialCallOffPeriod);
            /* Display contract end date */

            if (contractEndDate == null) {
                $("#contract-end-date-dd").val(null);
                $("#contract-end-date-mm").val(null);
                $("#contract-end-date-yyyy").val(null);
            } else {
                $("#contract-end-date-dd").val(leadingZero(contractEndDate.getDate()));
                $("#contract-end-date-mm").val(leadingZero(contractEndDate.getMonth() + 1));
                $("#contract-end-date-yyyy").val(leadingZero(contractEndDate.getFullYear()));
            }

            if (mobilisationPeriod && !isNaN(dd)) {
                let dates = contractDateUtils.calcContractDates(contractStartDate, initialCallOffPeriod, mobilisationPeriod);
                /* display mobilisation start date */
                $("#mobilisation-start-date-dd").val(leadingZero(dates["Contract-Mob-Start"].getDate()));
                $("#mobilisation-start-date-mm").val(leadingZero(dates["Contract-Mob-Start"].getMonth() + 1));
                $("#mobilisation-start-date-yyyy").val(leadingZero(dates["Contract-Mob-Start"].getFullYear()));
                
                /* display mobilisation end date */
                $("#mobilisation-end-date-dd").val(leadingZero(dates["Contract-Mob-End"].getDate()));
                $("#mobilisation-end-date-mm").val(leadingZero(dates["Contract-Mob-End"].getMonth() + 1));
                $("#mobilisation-end-date-yyyy").val(leadingZero(dates["Contract-Mob-End"].getFullYear()));

            } else {
                clearMobilisationDates();
            }
        } else {
            clearContractEndDate();
        }

    };

    $("#facilities_management_procurement_mobilisation_period").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_start_date_dd").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_start_date_mm").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_start_date_yyyy").on("blur", function (e) {
        displayContractDates();
    });

    $("#facilities_management_procurement_initial_call_off_period").on("blur", function (e) {
        displayContractDates();
    });

    displayContractDates();

    let formObject = $(".contract-dates").closest("form");
    let form_helper = null;


});
