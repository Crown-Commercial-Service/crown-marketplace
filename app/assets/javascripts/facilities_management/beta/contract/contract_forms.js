/*global FM */
$(function () {

    function putCharsLeft(value, maxLength) {
        let charsLeft = FM.calcCharsLeft(value, maxLength);
        $("#facilities_management_procurement_supplier_character_left").text("You have " + charsLeft + " characters remaining");
    }
    
    // Check if on a procurement supplier page
    if ($("#facilities_management_contract").length) {
        if ($(".edit_facilities_management_procurement_supplier").length) {
            let textArea = document.getElementsByTagName("textarea")[0].id;
            let maxLength = parseInt($("#" + textArea).attr("maxLength"), 10);

            putCharsLeft(document.getElementById(textArea).value, maxLength);

            $("#" + textArea).on("keyup", function(e) {
                let value = e.target.value;
                putCharsLeft(value, maxLength);
            });
        }
    }

    $("#contract-accepted-yes").on("click", function (e) {
        if (e.target.checked) {
            $("#contract-accepted-yes-container").removeClass("govuk-visually-hidden");
            $("#contract-accepted-no-container").addClass("govuk-visually-hidden");
        }
    });

    $("#contract-accepted-no").on("click", function (e) {
        if (e.target.checked) {
            $("#contract-accepted-no-container").removeClass("govuk-visually-hidden");
            $("#contract-accepted-yes-container").addClass("govuk-visually-hidden");
        }
    });
});