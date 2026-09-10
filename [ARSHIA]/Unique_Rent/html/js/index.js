var in_options = false;

window.addEventListener("message", function (event) {
  if (event.data.action == "open") {
    main_menu(event.data.content.vehicles, event.data.content.durations);
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
      // If the confirm modal is open, the close key backs out of the
      // modal first rather than closing the whole rental menu.
      if (confirmModalOpen()) {
        hideConfirm();
      } else {
        closeMenu();
      }
    }
  });

  $("#btn-close").on("click", function () {
    closeMenu();
  });

  $("#confirm-cancel").on("click", function () {
    hideConfirm();
  });

  // Clicking the dimmed backdrop (not the modal card itself) cancels too.
  $("#modal-backdrop").on("click", function (event) {
    if (event.target.id === "modal-backdrop") {
      hideConfirm();
    }
  });

  $("#confirm-pay").on("click", function () {
    if (!pendingRental) return;

    $.post('https://Unique_Rent/rent', JSON.stringify({
      model: pendingRental.vehicle.model,
      duration: pendingRental.duration ? pendingRental.duration.id : null,
      location: pendingRental.vehicle.location
    }));

    hideConfirm();
    closeMenu();
  });
});
