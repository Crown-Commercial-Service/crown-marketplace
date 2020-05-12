$("#procurement-building-services-volume").on("keypress", ".services-volume", (function (e) {
    var ev = e || window.event;
    if(ev.charCode < 48 || ev.charCode > 57) {
      return false; // block decimals
    } else {
      return true;
    }
  }));