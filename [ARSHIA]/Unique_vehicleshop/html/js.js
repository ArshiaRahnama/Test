
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
      $(".power").empty();
      $(".brake").empty();
      let speed = (event.data.topspeed.toFixed(1) / 500) * 100;
      let torque = (event.data.torque.toFixed(1) / 500) * 100;
      let power = (event.data.power.toFixed(1) / 500) * 100;
      let brake = event.data.brakes.toFixed(1);
      html = `
      <li
      style="
        background: linear-gradient(
          180deg,
          #5dffb1 0%,
          rgba(93, 255, 177, 0) 135%
        );
      "
      ></li>
    `;
      if (power <= 10) {
        $(".power").prepend(html);
      } else if (power <= 20) {
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 30) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 40) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 50) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 60) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 70) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 80) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".powe").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 90) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      } else if (power <= 100) {
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
        $(".power").prepend(html);
      }
      if (brake <= 10) {
        $(".brake").prepend(html);
      } else if (brake <= 20) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 30) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 40) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 50) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 60) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 70) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 80) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 90) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      } else if (brake <= 100) {
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
        $(".brake").prepend(html);
      }
      if (speed <= 10) {
        $(".engine").prepend(html);
      } else if (speed <= 20) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 30) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 40) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 50) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 60) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 70) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 80) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 90) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      } else if (speed <= 100) {
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
        $(".engine").prepend(html);
      }
      if (torque <= 10) {
        $(".torque").prepend(html);
      } else if (speed <= 20) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 30) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 40) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 50) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 60) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 70) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 80) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 90) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      } else if (speed <= 100) {
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
        $(".torque").prepend(html);
      }
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
      $.post("https://Unique_vehicleshop/close");
  }
});

let lastveh = null;
function car(id) {
  $(".car").css("background", "rgba(255, 255, 255, 0.2)");
  document.getElementById(id).style.background =
    "radial-gradient(132% 132% at 50% 0%, rgba(93, 255, 177, 0.62) 0%, rgba(93, 255, 177, 0) 100%), rgba(255, 255, 255, 0.2)";
  $.post("http://Unique_vehicleshop/getcar", JSON.stringify({ id: id }));
  lastveh = id;
}

function cattegory(id) {
  $("#vehicle").empty();
  $(".cattegory-item-sellect").css(
    "background",
    "linear-gradient(180deg,rgba(255, 255, 255, 0.29) 0%,rgba(255, 255, 255, 0) 119.19%)"
  );
  document.getElementById(id).style.background =
    "radial-gradient(100% 100% at 50% 0%,rgba(93, 255, 177, 0.59) 0%,rgba(93, 255, 177, 0) 100%),linear-gradient(180deg,rgba(255, 255, 255, 0.29) 0%,rgba(255, 255, 255, 0) 119.19%)";
  $.post("http://Unique_vehicleshop/catlist", JSON.stringify({ id: id }));
}

function exit() {
  $(".bg").css("display", "none");
  $(".side-container").css("display", "none");
  $("#vehicle").empty();
  $(".cattegory").empty();
  $(".power").empty();
  $.post("https://Unique_vehicleshop/close");
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
      "http://Unique_vehicleshop/rightClick",
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
  for (i = 0; i < x.length; i++) {
    if (!x[i].innerHTML.toLowerCase().includes(input)) {
      y[i].style.display = "none";
    } else {
      y[i].style.display = "list-item";
    }
  }
}

$(document).on("click", ".color", function (e) {
  var rgb = RGBvalues.color($(this).css("background-color"));
  $.post(
    "https://Unique_vehicleshop/setcolour",
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
  $.post("https://Unique_vehicleshop/testdv");
}

function buy() {
  $(".bg").css("display", "none");
  $.post("https://Unique_vehicleshop/buy");
}
