window.addEventListener('popstate', function (e) {
	alert(e.state.href);
});

function checkLoggedInState(loggedInCallback, loggedoutCallback) {
	let body = $(document.body);
	if (body.attr('validation_id') !== '') {
		$.ajax({
				method: 'get',
				url: '/facilities-management/gateway/validate/' + body.attr('validation_id'),
				success: function (data, status, xhr) {
					if (data.result === 'false') {
						loggedoutCallback();
					} else {
						loggedInCallback();
					}
				},
				error: function (xhr, status, err) {
					loggedInCallback();
				},
				accepts: 'json'
			}
		);
	} else {
		loggedInCallback();
	}
}

function preventBack() {
	checkLoggedInState(function () {
		showContent();
	}, function () {
		hideContent();
	});
}

if (window.location.pathname.indexOf('facilities-management') > -1) {
	if (!(['gateway', 'sign-in', 'start'].some(function (word) {
		return window.location.pathname.indexOf(word) > 0;
	}))) {
		setTimeout(preventBack, 0);
	} else {
		showContent();
	}
} else {
	showContent();
}

function showContent() {
	$('#main-content').attr('style', 'visibility:visible');
}

function hideContent() {
	window.location.replace('<%= facilities_management_new_user_session_path %>');
}
