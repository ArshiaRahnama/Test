window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.id == 'hud') {
        if (data.event == 'toggleDisplay3') {
            toggleDisplay3(data.key, data.state);
        } else if (data.event == 'setData') {
            if (data.health != undefined) {
                progressCircle(data.health, '.health')
            }
            if (data.armor != undefined) {
                progressCircle(data.armor, '.armor')
            }
            if (data.microphone != undefined) {
                progressCircle(data.microphone, '.microphone')
            }
            if (data.hunger != undefined) {
                progressCircle(data.hunger, '.hunger')
            }
            if (data.thirst != undefined) {
                progressCircle(data.thirst, '.thirst')
            }
            if (data.talking != undefined) {
                $('#microphone-circle').css('stroke', data.talking && '#00FF00' || '#696969');
            }
        }
    }
});

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

function toggleDisplay3(id, state) {
    if (state) {
        $(`${id}`).css('display', 'block');
    } else {
        $(`${id}`).css('display', 'none');
    }
}

$(document).ready(function() {
    progressCircle(100, '.health')
    progressCircle(100, '.armor')
});
