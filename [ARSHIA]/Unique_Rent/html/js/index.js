var in_options = false;

window.addEventListener("message", function (event) {
  if (event.data.action == "open") {
    main_menu(event.data.content.vehicles);
  } else if (event.data.action == "close") {
    $(".ui").fadeOut();
  } else if (event.data.action == "show_timer") {
    timer_menu(event.data.content.time, event.data.content.vehicle);
  } else if (event.data.action == "hide_timer") {
    hide_timer_menu();
  }
});

$(document).ready(function () {
  $("body").on("keyup", function (key) {
    if (Config.closeKeys.includes(key.which)) {
      closeMenu();
    }
  });

  $("#btn-close").on("click", function () {
    closeMenu();
  });
});
