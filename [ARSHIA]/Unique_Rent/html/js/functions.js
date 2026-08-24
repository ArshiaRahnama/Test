var timeleft = 0;
var totaltime = 0;
var time_function = null;

const RING_CIRCUMFERENCE = 2 * Math.PI * 52; // r=52 from the SVG circle

function main_menu(vehicles){
  $(".ui").fadeIn();
  $(".container-timer").css('display', 'none')
  $(".vehicles").css('display', 'flex');
  $(".vehicles").html('');

  $.each(vehicles, function(index, vehicle) {
    $(".vehicles").append(`
    <div class="vehicle" id="vehicle-${vehicle.id}" style="animation-delay:${Math.min(index * 0.03, 0.3)}s">
      <div class="header">
          <div class="header-title">${vehicle.label}</div>
          <div class="header-description">${vehicle.description}</div>
      </div>
      <div class="image">
          <img src="assets/${vehicle.image}.png" alt="${vehicle.model}">
      </div>
      <div class="footer">
          <div class="footer-type">${vehicle.type}</div>
          <div class="footer-price">${vehicle.price}${Config.Currency}</div>
      </div>
    </div>
    `);

    $(`#vehicle-${vehicle.id}`).click(function () {
      $.post('https://Unique_Rent/rent', JSON.stringify({
          model: vehicle.model,
          price: vehicle.price,
          location: vehicle.location
      }));
      closeMenu()
    })

  })

}

function setRingProgress(fraction){
  var offset = RING_CIRCUMFERENCE * (1 - fraction);
  $("#ring-progress").css('stroke-dashoffset', offset);
}

function timer_menu(time){
  $(".ui").fadeIn();

  $(".vehicles").css('display', 'none')
  $(".container-timer").css('display', 'flex')

  $("#timer").html('')
  $("#ring-progress").removeClass('is-critical');

  timeleft = time;
  totaltime = time;
  setRingProgress(1);

  time_function = setInterval(function(){

  if(timeleft <= 0){
    $('.container-timer').fadeOut();
    clearInterval(time_function);
    $.post('https://Unique_Rent/finish', JSON.stringify({}));
    return;
  } else if (timeleft <= 10) {
    $("#ring-progress").addClass('is-critical');
    $('#timer').css('animation', 'alert 0.6s infinite')
  }

  $('#timer').html(`${timeleft}s`)
  setRingProgress(totaltime > 0 ? (timeleft / totaltime) : 0);
  timeleft -= 1;
}, 1000);
}

function hide_timer_menu(){
  $("#timer").html('')
  $('.container-timer').fadeOut();
  clearInterval(time_function);
  timeleft = 0
} 

function closeMenu() {
  $.post("http://Unique_Rent/CloseUI", JSON.stringify({}));
}
