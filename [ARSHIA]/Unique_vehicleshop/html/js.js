
// FiveM injects GetParentResourceName() into every NUI page - it always returns
// this resource's actual current name, so NUI callback URLs below keep working
// no matter what the resource folder/manifest is renamed to.
const RESOURCE_NAME =
  typeof GetParentResourceName === "function"
    ? GetParentResourceName()
    : "Unique_vehicleshop";

// value: 0-100 percent. Every 10% adds one bar segment (max 10 segments)
function fillBar(selector, value, segmentHtml) {
  let count = Math.min(10, Math.max(0, Math.ceil(value / 10)));
  for (let i = 0; i < count; i++) {
    $(selector).prepend(segmentHtml);
  }
}

$(document).ready(function () {
  window.addEventListener("message", function (event) {
    if (event.data.action == "openmenu") {
      $("#vehicle").empty();
      $(".big-name").html(event.data.shopname);
      $(".dec").html(event.data.dec);
      $(".cattegory").empty();
      $(".bg").css("display", "block");
    }
    if (event.data.action == "update-deta-veh") {
    }
    if (event.data.action == "loadvehicle") {
      html =
        `
        <div class="sil" id="sil">
    <div class="car" onclick="car(this.id)" id="` +
        event.data.name +
        `">
    <div class="car-left"><div class="car-cat-img" style="background-image: url(./img/` +
        event.data.carimg +
        `);"></div></div>
    <div class="car-name">` +
        event.data.label +
        `</div>
    <div class="car-price">$` +
        event.data.price +
        `</div>
    <i id="speed" class="fa-solid fa-gauge-simple-high"></i>
    <div class="speed-text">` +
        event.data.speed.toFixed(0) +
        `</div>
  </div>
</div>
  `;
      $("#vehicle").prepend(html);
    }
    if (event.data.action == "update") {
      $(".engine").empty();
      $(".torque").empty();
      $(".power").empty();
      $(".brake").empty();
      let speed = (event.data.topspeed.toFixed(1) / 500) * 100;
      let torque = (event.data.torque.toFixed(1) / 500) * 100;
      let power = (event.data.power.toFixed(1) / 500) * 100;
      let brake = event.data.brakes.toFixed(1);
      let segment = `
      <li
      style="
        background: linear-gradient(
          180deg,
          #ffc107 0%,
          rgba(255, 193, 7, 0) 135%
        );
      "
      ></li>
    `;
      // instead of 10 repetitive if/else branches, just compute the segment count and fill it
      fillBar(".power", power, segment);
      fillBar(".brake", brake, segment);
      fillBar(".engine", speed, segment);
      fillBar(".torque", torque, segment);
    }
    if (event.data.action == "updatela") {
      $(".price-main span").html("$" + event.data.price);
      $(".car-cat-name").html(event.data.label);
    }
    if (event.data.action == "cattegory") {
      html =
        `
        <div class="cattegory-item-sellect" onclick="cattegory(this.id)" id="` +
        event.data.label +
        `">
        <div class="cattegory-img" id="` +
        event.data.label +
        `" style="background-image: url(./img/` +
        event.data.label +
        `.png);"></div>
        <div class="cattegory-text">` +
        event.data.label +
        `</div>
      </div>
  `;
      $(".cattegory").prepend(html);
    }
  });
});

$(document).on("keydown", function (event) {
  switch (event.keyCode) {
    case 27: // ESC
      $(".bg").css("display", "none");
      $(".side-container").css("display", "none");
      $("#vehicle").empty();
      $(".cattegory").empty();
      $.post(`https://${RESOURCE_NAME}/close`);
  }
});

let lastveh = null;
function car(id) {
  $(".car").css("background", "rgba(255, 255, 255, 0.2)");
  document.getElementById(id).style.background =
    "radial-gradient(132% 132% at 50% 0%, rgba(255, 193, 7, 0.45) 0%, rgba(255, 193, 7, 0) 100%), rgba(255, 255, 255, 0.2)";
  $.post(`https://${RESOURCE_NAME}/getcar`, JSON.stringify({ id: id }));
  lastveh = id;
}

function cattegory(id) {
  $("#vehicle").empty();
  $(".cattegory-item-sellect").css(
    "background",
    "linear-gradient(180deg,rgba(255, 255, 255, 0.29) 0%,rgba(255, 255, 255, 0) 119.19%)"
  );
  document.getElementById(id).style.background =
    "radial-gradient(100% 100% at 50% 0%,rgba(255, 193, 7, 0.5) 0%,rgba(255, 193, 7, 0) 100%),linear-gradient(180deg,rgba(255, 255, 255, 0.29) 0%,rgba(255, 255, 255, 0) 119.19%)";
  $.post(`https://${RESOURCE_NAME}/catlist`, JSON.stringify({ id: id }));
}

function exit() {
  $(".bg").css("display", "none");
  $(".side-container").css("display", "none");
  $("#vehicle").empty();
  $(".cattegory").empty();
  $(".power").empty();
  $.post(`https://${RESOURCE_NAME}/close`);
}

document.addEventListener("mousedown", function (e) {
  if (e.button === 2) {
    $(".bg").animate(
      {
        opacity: "0.7",
      },
      1000
    );
    $.post(
      `https://${RESOURCE_NAME}/rightClick`,
      JSON.stringify({}),
      function () {
        $(".bg").animate(
          {
            opacity: "0.99",
          },
          1000
        );
      }
    );
  }
});

function myFunctionnn() {
  let input = document.getElementById("searchj").value;
  input = input.toLowerCase();
  let x = document.getElementsByClassName("car-name");
  let y = document.getElementsByClassName("sil");
  let visibleCount = 0;
  for (i = 0; i < x.length; i++) {
    if (!x[i].innerHTML.toLowerCase().includes(input)) {
      y[i].style.display = "none";
    } else {
      y[i].style.display = "list-item";
      visibleCount++;
    }
  }
  document.getElementById("no-result").style.display =
    visibleCount === 0 ? "block" : "none";
}

$(document).on("click", ".color", function (e) {
  var rgb = RGBvalues.color($(this).css("background-color"));
  $.post(
    `https://${RESOURCE_NAME}/setcolour`,
    JSON.stringify({ rgb: rgb }),
    function (x) {}
  );
});

var RGBvalues = (function () {
  var _hex2dec = function (v) {
    return parseInt(v, 16);
  };

  var _splitHEX = function (hex) {
    var c;
    if (hex.length === 4) {
      c = hex.replace("#", "").split("");
      return {
        r: _hex2dec(c[0] + c[0]),
        g: _hex2dec(c[1] + c[1]),
        b: _hex2dec(c[2] + c[2]),
      };
    } else {
      return {
        r: _hex2dec(hex.slice(1, 3)),
        g: _hex2dec(hex.slice(3, 5)),
        b: _hex2dec(hex.slice(5)),
      };
    }
  };

  var _splitRGB = function (rgb) {
    var c = rgb.slice(rgb.indexOf("(") + 1, rgb.indexOf(")")).split(",");
    var flag = false,
      obj;
    c = c.map(function (n, i) {
      return i !== 3 ? parseInt(n, 10) : (flag = true), parseFloat(n);
    });
    obj = {
      r: c[0],
      g: c[1],
      b: c[2],
    };
    if (flag) obj.a = c[3];
    return obj;
  };

  var color = function (col) {
    var slc = col.slice(0, 1);
    if (slc === "#") {
      return _splitHEX(col);
    } else if (slc.toLowerCase() === "r") {
      return _splitRGB(col);
    } else {
      console.log(
        "!Ooops! RGBvalues.color(" + col + ") : HEX, RGB, or RGBa strings only"
      );
    }
  };

  return {
    color: color,
  };
})();

function test() {
  $(".bg").css("display", "none");
  $.post(`https://${RESOURCE_NAME}/testdv`);
}

function buy() {
  $(".bg").css("display", "none");
  $.post(`https://${RESOURCE_NAME}/buy`);
}

// ===================================================================
// Vehicle rental - countdown ring widget, migrated in full from the old
// standalone Unique_Rent resource (its own html/js/index.js + functions.js).
// rent_client.lua posts "show_timer" / "hide_timer" here via SendNUIMessage.
// Uses the shared RESOURCE_NAME constant from the top of this file, so the
// NUI callback URL below is correct however this resource ends up named.
// ===================================================================

window.addEventListener("message", function (event) {
  if (event.data.action == "show_timer") {
    rentTimerMenu(event.data.content.time, event.data.content.vehicle);
  } else if (event.data.action == "hide_timer") {
    rentHideTimerMenu();
  }
});

let rentTimeLeft = 0;
let rentTotalTime = 0;
let rentTimerInterval = null;

const RENT_RING_CIRCUMFERENCE = 2 * Math.PI * 52; // r=52 from the SVG circle in ui.html

function setRentRingProgress(fraction) {
  $("#rent-ring-progress").css("stroke-dashoffset", RENT_RING_CIRCUMFERENCE * (1 - fraction));
}

function rentTimerMenu(time, vehicle) {
  $(".rent-ui").fadeIn();
  $(".rent-container-timer").css("display", "flex");

  $("#rent-timer").html("");
  $("#rent-ring-progress").removeClass("is-critical");

  // Defensive: clear any interval from a previous rentTimerMenu() call so
  // two countdowns can never run stacked on top of each other.
  clearInterval(rentTimerInterval);

  if (vehicle && vehicle.label) {
    $("#rent-timer-vehicle").html(vehicle.label);
    $("#rent-timer-sub").html("Rented · return to the marker");
  } else {
    $("#rent-timer-vehicle").html("Rental Active");
    $("#rent-timer-sub").html("Return the vehicle to the marker");
  }

  rentTimeLeft = time;
  rentTotalTime = time;
  setRentRingProgress(1);

  rentTimerInterval = setInterval(function () {
    if (rentTimeLeft <= 0) {
      $(".rent-container-timer").fadeOut();
      $(".rent-ui").fadeOut();
      clearInterval(rentTimerInterval);
      $.post(`https://${RESOURCE_NAME}/finish`, JSON.stringify({}));
      return;
    } else if (rentTimeLeft <= 10) {
      $("#rent-ring-progress").addClass("is-critical");
      $("#rent-timer").css("animation", "rent-alert 0.6s infinite");
    }

    $("#rent-timer").html(`${rentTimeLeft}s`);
    setRentRingProgress(rentTotalTime > 0 ? rentTimeLeft / rentTotalTime : 0);
    rentTimeLeft -= 1;
  }, 1000);
}

function rentHideTimerMenu() {
  $("#rent-timer").html("");
  $(".rent-container-timer").fadeOut();
  $(".rent-ui").fadeOut();
  clearInterval(rentTimerInterval);
  rentTimeLeft = 0;
}
