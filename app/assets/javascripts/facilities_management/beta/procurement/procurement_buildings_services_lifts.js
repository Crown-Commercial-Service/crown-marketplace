// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function LiftDataUI(jqContainer) {
    this.containerDiv = jqContainer;
    this.liftDataContainer = jqContainer.find(".liftdata");
}
LiftDataUI.prototype.addNewLift = function() {
    // get the current number of lifts
    let currentCount = Number(this.liftDataContainer.find("div[data-propertyname='Lift Data']").length);
    let newInputElement = $("<div>", {
        "class": "govuk-form-group",
        "data-propertyname":"Lift Data",
        "data-liftcount":currentCount+1,
    }).append([
        $("<label>",{"class":"govuk-label", "for":"newlift_"+(currentCount+1)}).append("Lift " + (currentCount+1) + "."),
        $("<span>",{"class":"govuk-caption-m"}).append("Number of floors"),
        $("<input>",{"class":"govuk-input govuk-input--width-2", "type":"number","maxlength":"3","min":"1","max":"1000","step":"1", "required":"required",
                     "id":"newlift_"+(currentCount+1),
                     "name":"facilities_management_procurement_building_service[lift_data][]"}),
        $("<button>",{"class":"govuk-!-margin-left-2 govuk-button govuk-button--secondary removelift",
                      "data-liftcount":(currentCount+1)}).append("Remove")
    ]);
    newInputElement.find("button").on("click", function(e) {
        e.preventDefault();
        let targetLift = Number(e.currentTarget.getAttribute("data-liftcount"));
        this.removeLift(targetLift);
    }.bind(this));
    //this.restrictInput(newInputElement.find("input")[0]);
    this.liftDataContainer.find("button[data-liftcount=" + currentCount + "]").addClass("govuk-visually-hidden");
    this.liftDataContainer.append(newInputElement);
};

LiftDataUI.prototype.removeLift = function(nLiftIndex) {
    let toRemove = this.liftDataContainer.find("div[data-liftcount=" + nLiftIndex + "]");
    toRemove.remove();
    $($(".addliftbtn").get(0)).val("Add new lift (" + (100 - nLiftIndex) +" remaining)");
    this.liftDataContainer.find("button[data-liftcount=" + (nLiftIndex-1) + "]").removeClass("govuk-visually-hidden");
};
LiftDataUI.prototype.connectAddLiftButton = function(){
    if (this.containerDiv) {
        let addNewButton = this.containerDiv.find(".addliftbtn");
        if ( addNewButton.length > 0 ) {
            addNewButton.on("click", function(e){
                if ($(".govuk-form-group").length < 99 ) {
                    e.preventDefault();
                    this.addNewLift();
                    $($(".addliftbtn").get(0)).val("Add new lift (" + (99 - $(".govuk-form-group").length) +" remaining)");
                } else {
                    e.preventDefault();
                }
            }.bind(this));
        }
    }
};
LiftDataUI.prototype.connectRemoveLiftButtons = function() {
    if ( this.liftDataContainer){
        let removeButtons = this.liftDataContainer.find(".removelift");
        if ( removeButtons.length > 0 ) {
            removeButtons.on("click", function(e) {
                e.preventDefault();
                let targetLift = Number(e.currentTarget.getAttribute("data-liftcount"));
                this.removeLift(targetLift);
            }.bind(this));
        }
    }
};
LiftDataUI.prototype.restrictInputKeys = function(){
    if ( this.liftDataContainer) {
        let inputs = this.liftDataContainer.find("input[type='number']");
        let i = 0;
        for (i = 0; i < inputs.length; i++) {
            this.restrictInput(inputs[i]);
        }
    }
};
LiftDataUI.prototype.restrictInput = function(jqElem) {
    $(jqElem).keypress(function(e) {
        let verified = (e.which == 8 || e.which == undefined || e.which == 0) ? null : String.fromCharCode(e.which).match(/[^0-9]/);
        if (verified) {e.preventDefault();}
    });
};
LiftDataUI.prototype.connectButtons = function() {
    this.connectAddLiftButton();
    this.connectRemoveLiftButtons();
    // this.restrictInputKeys();
};
$(function(){
   let liftDataContainer = $(".liftdatacontainer");
   if (liftDataContainer.length > 0 ) {
       this.liftHelper = new LiftDataUI(liftDataContainer);
       this.liftHelper.connectButtons();
   }
});
