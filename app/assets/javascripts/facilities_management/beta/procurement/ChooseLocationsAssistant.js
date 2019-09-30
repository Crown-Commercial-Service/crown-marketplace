$(function () {
    if ($('.chooser-component').length > 0) {
        try {
            let activeChooser = null;

            if (null === activeChooser) {
                activeChooser = initialiseChooseLocations();
            }

            if (null !== activeChooser) {
                activeChooser.init();
                activeChooser.PrimeBasket();
            }
        } catch (e) {
            console.log("No location chooser component found");
        }
    }
    function initialiseChooseLocations() {
        let obj = new ChooserComponent("procurement", "locations", locationCheckboxCallback, pageUtils.getCachedData('fm-locations'));
        if (obj.validate()) {
            return obj;
        } else {
            return null;
        }
    }
    function locationCheckboxCallback(sectionEvent) {
        if (sectionEvent.isValid) {
            //pageUtils.toggleInlineErrorMessage(false);
        } else {
            //pageUtils.toggleInlineErrorMessage(true);
        }
    }

})();