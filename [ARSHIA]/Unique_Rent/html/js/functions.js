var timeleft = 0;
var totaltime = 0;
var time_function = null;

const RING_CIRCUMFERENCE = 2 * Math.PI * 52; // r=52 from the SVG circle

const TYPE_ICONS = {
  car: 'bi-car-front-fill',
  bike: 'bi-scooter',
  bicycle: 'bi-bicycle'
};

function typeIcon(type) {
  return TYPE_ICONS[type] || 'bi-question-circle';
}

function typeLabel(type) {
  if (!type) return '';
  return type.charAt(0).toUpperCase() + type.slice(1);
}

function main_menu(vehicles) {
  $(".ui").fadeIn();
  $(".container-timer").css('display', 'none');

  if (!vehicles || vehicles.length === 0) {
    $(".vehicles").css('display', 'none').html('');
    $("#filters").css('display', 'none').html('');
    $("#panel-empty").css('display', 'flex');
    return;
  }

  $("#panel-empty").css('display', 'none');
  $(".vehicles").css('display', 'flex');
  $(".vehicles").html('');

  // Build the filter tabs from whichever vehicle types are actually present.
  var types = [];
  $.each(vehicles, function (index, vehicle) {
    if (types.indexOf(vehicle.type) === -1) types.push(vehicle.type);
  });

  if (types.length > 1) {
    var tabsHtml = '<button class="filter-tab is-active" data-type="all">All</button>';
    $.each(types, function (index, type) {
      tabsHtml += `<button class="filter-tab" data-type="${type}"><i class="${typeIcon(type)}"></i> ${typeLabel(type)}</button>`;
    });
    $("#filters").html(tabsHtml).css('display', 'flex');
  } else {
    $("#filters").html('').css('display', 'none');
  }

  $.each(vehicles, function (index, vehicle) {
    $(".vehicles").append(`
    <div class="vehicle" id="vehicle-${vehicle.id}" data-type="${vehicle.type}" style="animation-delay:${Math.min(index * 0.03, 0.3)}s">
      <div class="header">
          <div class="header-title">${vehicle.label}</div>
          <div class="header-description">${vehicle.description}</div>
      </div>
      <div class="image">
          <img src="assets/${vehicle.image}.png" alt="${vehicle.model}">
          <div class="rent-cta"><i class="bi-key-fill"></i> Rent now</div>
      </div>
      <div class="footer">
          <div class="footer-type"><i class="${typeIcon(vehicle.type)}"></i> ${vehicle.type}</div>
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
      closeMenu();
    });
  });

  $(".filter-tab").off('click').on('click', function () {
    $(".filter-tab").removeClass('is-active');
    $(this).addClass('is-active');

    var type = $(this).data('type');
    if (type === 'all') {
      $(".vehicle").fadeIn(150);
    } else {
      $(".vehicle").each(function () {
        if ($(this).data('type') === type) {
          $(this).fadeIn(150);
        } else {
          $(this).hide();
        }
      });
    }
  });
}

function setRingProgress(fraction) {
  var offset = RING_CIRCUMFERENCE * (1 - fraction);
  $("#ring-progress").css('stroke-dashoffset', offset);
}

function timer_menu(time, vehicle) {
  $(".ui").fadeIn();

  $(".vehicles").css('display', 'none');
  $(".container-timer").css('display', 'flex');

  $("#timer").html('');
  $("#ring-progress").removeClass('is-critical');

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
  clearInterval(time_function);
  timeleft = 0;
}

function closeMenu() {
  $.post("https://Unique_Rent/CloseUI", JSON.stringify({}));
}
