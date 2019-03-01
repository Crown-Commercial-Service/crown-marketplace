function initSearchResults(id){
    var accord = id.find('.CCS-AT-checkbox-accordian'); 

    accord.each(function(index) {
        var link = $(this).find('.CCS-AT-show');
        var wrap = $(this);//.find('.CCS-AT-checkboxes-wrap');

        link.attr('aria-expanded', 'false').click(function(e){
            e.preventDefault();//if 'a' tag

            $(this).attr('aria-expanded',$(this).attr('aria-expanded')==='true'?'false':'true' )
            .find('span').text(function(i, text){
                return text === "Show" ? "Hide" : "Show";
            });
            wrap.toggleClass('show');//could use '+' css selector on aria attr val, but this supports legacy browsers
        });
    });
}











function initCustomFnc() {
    


    var filt = $('#ccs-at-results-filters');
    if(filt.length){//it exists
        initSearchResults(filt);
    }
}

