
window.addEventListener('message',  function(event) {
	var data = event.data;
	if (data.id == 'hud') {
		if (data.event == 'toggleDisplay') {
			toggleDisplay(data.key, data.state);
        }else if(data.event == 'toggleDisplay2'){
            toggleDisplay2(data.key, data.state);
		}else if(data.event == 'toggleDisplay3'){
            toggleDisplay3(data.key, data.state);
		}else if(data.event == 'setData'){
            if (data.health != undefined){
                setOptionalValue(data.health, 'healthBar')
                $(`#healthBarIcon`).text(data.health-100);
            }
            if (data.armor != undefined){
                setBasicValue(data.armor, 'armorBar')
                $(`#armorBarIcon`).text(data.armor);
            }
			if (data.microphone != undefined){
                progressCircle(data.microphone, '.microphone')
            }
			if (data.hunger != undefined){
                progressCircle(data.hunger, '.hunger')
            }
			if (data.thirst != undefined){
                progressCircle(data.thirst, '.thirst')
            }
			if (data.engine != undefined || data.engine != null){
                progressCircle(data.engine, '.engine')
            }
			if (data.stress != undefined){
                progressCircle(data.stress, '.stress')
            }
			if (data.stamina != undefined){
                progressCircle(data.stamina, '.stamina')
            }
			if (data.oxygen != undefined){
                progressCircle(data.oxygen, '.oxygen')
            }
			if (data.talking != undefined){
				$('#microphone-circle').css('stroke', data.talking && '#00FF00' || '#696969');
            }
			if (data.indicator != undefined){
				updateIndicator(data.indicator)
            }
        }
	}
});

function toggleDisplay(id, state){
    if(state) {
        $(`.${id}`).show();
        if ($(`.${id}`).hasClass("animation-left-rightElements")) {
            $(`.${id}`).removeClass("animation-left-rightElements");
        }
        $(`.${id}`).css("position", "relative");
        $(`.${id}`).addClass("animation-right-rightElements");
    }else{
        if ($(`.${id}`).hasClass("animation-right-rightElements")) {
            $(`.${id}`).removeClass("animation-right-rightElements");
        }
        $(`.${id}`).addClass("animation-left-rightElements");
        setTimeout(() => {
            $(`.${id}`).css("position", "absolute");
            $(`.${id}`).hide();
        }, 300);
    }
}

function toggleDisplay2(id, state){
    if(state) {
        $(`#${id}`).show();
        if ($(`#${id}`).hasClass("animation-left-rightElements")) {
            $(`#${id}`).removeClass("animation-left-rightElements");
        }
        $(`#${id}`).css("position", "relative");
        $(`#${id}`).addClass("animation-right-rightElements");
    }else{
        if ($(`#${id}`).hasClass("animation-right-rightElements")) {
            $(`#${id}`).removeClass("animation-right-rightElements");
        }
        $(`.${id}`).addClass("animation-left-rightElements");
        setTimeout(() => {
            $(`#${id}`).css("position", "absolute");
            $(`#${id}`).hide();
        }, 300);
    }
}

function setOptionalValue(value, element) {
    if (value > 100) {
      $(`#${element}1`).show();
    } else $(`#${element}1`).hide();
    if (value > 115) {
      $(`#${element}2`).show();
    } else $(`#${element}2`).hide();
    if (value > 120) {
      $(`#${element}3`).show();
    } else $(`#${element}3`).hide();
    if (value > 130) {
      $(`#${element}4`).show();
    } else $(`#${element}4`).hide();
    if (value > 140) {
      $(`#${element}5`).show();
    } else $(`#${element}5`).hide();
    if (value > 150) {
      $(`#${element}6`).show();
    } else $(`#${element}6`).hide();
    if (value > 160) {
      $(`#${element}7`).show();
    } else $(`#${element}7`).hide();
    if (value > 170) {
      $(`#${element}8`).show();
    } else $(`#${element}8`).hide();
    if (value > 180) {
      $(`#${element}9`).show();
    } else $(`#${element}9`).hide();
    if (value > 190) {
      $(`#${element}10`).show();
    } else $(`#${element}10`).hide();
}
function setBasicValue(value, element) {
    if (value > 5) {
      $(`#${element}1`).show();
    } else $(`#${element}1`).hide();
    if (value > 10) {
      $(`#${element}2`).show();
    } else $(`#${element}2`).hide();
    if (value > 20) {
      $(`#${element}3`).show();
    } else $(`#${element}3`).hide();
    if (value > 30) {
      $(`#${element}4`).show();
    } else $(`#${element}4`).hide();
    if (value > 40) {
      $(`#${element}5`).show();
    } else $(`#${element}5`).hide();
    if (value > 50) {
      $(`#${element}6`).show();
    } else $(`#${element}6`).hide();
    if (value > 60) {
      $(`#${element}7`).show();
    } else $(`#${element}7`).hide();
    if (value > 70) {
      $(`#${element}8`).show();
    } else $(`#${element}8`).hide();
    if (value > 80) {
      $(`#${element}9`).show();
    } else $(`#${element}9`).hide();
    if (value > 90) {
      $(`#${element}10`).show();
    } else $(`#${element}10`).hide();
}

let progressCircle = (percent, element) => {
  const circle = document.querySelector(element);
  const radius = circle.r.baseVal.value;
  const circumference = radius * 2 * Math.PI;
  const html = $(element).parent().parent().find("span");

  circle.style.strokeDasharray = `${circumference} ${circumference}`;
  circle.style.strokeDashoffset = `${circumference}`;

  const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
  circle.style.strokeDashoffset = -offset;

  html.text(Math.round(percent));
}

function toggleDisplay3(id, state){
    if(state) {
        $(`${id}`).css('display', 'block');
    }else{
        $(`${id}`).css('display', 'none');
    }
}


function updateIndicator(talkings){
	$('.indicator').html('');
	for (let [id, data] of Object.entries(talkings)) {
		$('.indicator').append(`<tr><td><img src="hud/img/radio.png"></td><td>${data.id}</td></tr>`);
	}
}
$(document).ready(function() {
    progressCircle(50, '.microphone')
});