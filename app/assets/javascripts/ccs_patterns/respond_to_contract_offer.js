$(function () {
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