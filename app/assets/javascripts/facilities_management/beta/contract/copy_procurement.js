/*global FM */
$(function () {

    function putCharsLeft(value, maxLength) {
        let charsLeft = FM.calcCharsLeft(value, maxLength);
        $("#facilities_management_procurement_supplier_character_left").text("You have " + charsLeft + " characters remaining");
    }

    // Check if on a procurement supplier page
    if ($("#facilities_management_copy_contract").length) {
        let textField = document.getElementById("facilities_management_procurement_contract_name");
        let maxLength = parseInt($(textField).attr("maxLength"), 10);

        putCharsLeft(textField.value, maxLength);

        $(textField).on("keyup", function(e) {
            let value = e.target.value;
            putCharsLeft(value, maxLength);
        });
    }
});