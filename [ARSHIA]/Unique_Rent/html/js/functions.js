var timeleft = 0;
var totaltime = 0;
var time_function = null;

const RING_CIRCUMFERENCE = 2 * Math.PI * 52; // r=52 from the SVG circle

function setRingProgress(fraction) {
  var offset = RING_CIRCUMFERENCE * (1 - fraction);
  $("#ring-progress").css('stroke-dashoffset', offset);
}

function timer_menu(time, vehicle) {
  $(".ui").fadeIn();
  $(".container-timer").css('display', 'flex');

  $("#timer").html('');
  $("#ring-progress").removeClass('is-critical');

  // Defensive: clear any interval from a previous timer_menu() call so
  // two countdowns can never run stacked on top of each other.
  clearInterval(time_function);

  if (vehicle && vehicle.label) {
    $("#timer-vehicle").html(vehicle.label);
    $("#timer-sub").html('Rented · return to the red marker');
  } else {
    $("#timer-vehicle").html('Rental Active');
    $("#timer-sub").html('Return the vehicle to the red marker');
  }

  timeleft = time;
  totaltime = time;
  setRingProgress(1);

  time_function = setInterval(function () {

    if (timeleft <= 0) {
      $('.container-timer').fadeOut();
      $(".ui").fadeOut();
      clearInterval(time_function);
      $.post('https://Unique_Rent/finish', JSON.stringify({}));
      return;
    } else if (timeleft <= 10) {
      $("#ring-progress").addClass('is-critical');
      $('#timer').css('animation', 'alert 0.6s infinite');
    }

    $('#timer').html(`${timeleft}s`);
    setRingProgress(totaltime > 0 ? (timeleft / totaltime) : 0);
    timeleft -= 1;
  }, 1000);
}

function hide_timer_menu() {
  $("#timer").html('');
  $('.container-timer').fadeOut();
  $(".ui").fadeOut();
  clearInterval(time_function);
  timeleft = 0;
}
