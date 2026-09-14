window.addEventListener("message", function (event) {
  if (event.data.action == "show_timer") {
    timer_menu(event.data.content.time, event.data.content.vehicle);
  } else if (event.data.action == "hide_timer") {
    hide_timer_menu();
  }
});
