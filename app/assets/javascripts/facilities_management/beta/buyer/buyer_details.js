$(function () {
	if ($('#buyer_details').length > 0) {
		history.pushState(null, document.title, location.href);
		window.addEventListener('popstate', function (event) {
			window.status = "Stopped back";
			history.pushState(null, document.title, location.href);
		});
		
		$('.back_to_start_link').prop('href', '#');
	}
});

