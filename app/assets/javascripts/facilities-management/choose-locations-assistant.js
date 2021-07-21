$(() => {
  function initialiseChooseLocations() {
    const obj = new ChooserComponent('procurement', 'locations', common.getCachedData('fm-locations'));
    if (obj.validate()) {
      return obj;
    }
    return null;
  }

  if ($('.chooser-component').length > 0) {
    try {
      let activeChooser = null;
      activeChooser = initialiseChooseLocations();

      if (activeChooser !== null) {
        activeChooser.init();
        activeChooser.PrimeBasket();
      }
    } catch (e) {
      console.log(e);
      console.log('No location chooser component found');
    }
  }
});
