$(function () {
	// hidden by default - only shown while actually inside an NCZ zone
	$("#hud").hide();
});

window.addEventListener('message', function (event) {
	try {
		switch (event.data.action) {
			case 'disable':
				$("#hud").stop(true, true).fadeOut(150);
				break;
			case 'enable':
				$("#hud").stop(true, true).fadeIn(200);
				break;
		}
	} catch (err) {}
});
