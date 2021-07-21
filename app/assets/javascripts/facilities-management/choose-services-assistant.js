$(() => {
  function initialiseChooseServices() {
    const obj = new ChooserComponent('procurement', 'services', common.getCachedData('fm-locations'));
    if (obj.validate()) {
      return obj;
    }
    return null;
  }

  if ($('.chooser-component').length > 0) {
    try {
      let activeChooser = null;
      if (activeChooser === null) {
        if ($('.services').length > 0) {
          activeChooser = initialiseChooseServices();
        }
      }

      if (activeChooser !== null) {
        activeChooser.init();
        activeChooser.PrimeBasket();
      }
    } catch (e) {
      console.log('No service chooser component found');
    }
  }
});
