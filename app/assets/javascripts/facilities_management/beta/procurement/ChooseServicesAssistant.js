$(function () {
    if ($('.chooser-component').length > 0) {
        try {
            let activeChooser = null;
            if (null === activeChooser) {
                if ($('.services').length > 0) {
                    activeChooser = initialiseChooseServices();
                }
                if ($('.buildings').length > 0) {
                    activeChooser = initialiseChooseBuildings();
                }
            }

            if (null !== activeChooser) {
                activeChooser.init();
                activeChooser.PrimeBasket();
            }
        } catch (e) {
            console.log("No service chooser component found");
        }
    }
    function initialiseChooseServices() {
        let obj = new ChooserComponent("procurement", "services", serviceCheckboxCallback, pageUtils.getCachedData('fm-locations'));
        if (obj.validate()) {
            return obj;
        } else {
            return null;
        }
    }
    function initialiseChooseBuildings() {
        let obj = new ChooserComponent("procurement", "buildings", serviceCheckboxCallback, null);
        if (obj.validate()) {
            return obj;
        } else {
            return null;
        }
    }
    function serviceCheckboxCallback(sectionEvent) {
        if (sectionEvent.isValid) {
            //pageUtils.toggleInlineErrorMessage(false);
        } else {
            //pageUtils.toggleInlineErrorMessage(true);
        }
    }

});
