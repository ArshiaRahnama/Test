window.addEventListener('message', function (event) {
    var data = event.data;
    if (data.id == 'hud') {
        if (data.event == 'toggleDisplay3') {
            toggleDisplay3(data.key, data.state);
        } else if (data.event == 'setData') {
            if (data.health != undefined) {
                progressCircle(data.health, '.health');
            }
            if (data.armor != undefined) {
                progressCircle(data.armor, '.armor');
            }
            if (data.microphone != undefined) {
                progressCircle(data.microphone, '.microphone');
            }
            if (data.hunger != undefined) {
                progressCircle(data.hunger, '.hunger');
            }
            if (data.thirst != undefined) {
                progressCircle(data.thirst, '.thirst');
            }
            if (data.stamina != undefined) {
                progressCircle(data.stamina, '.stamina');
            }
            if (data.oxygen != undefined) {
                progressCircle(data.oxygen, '.oxygen');
            }
            if (data.talking != undefined) {
                var micCircle = document.getElementById('microphone-circle');
                if (micCircle) {
                    micCircle.style.stroke = data.talking ? '#00FF00' : '#696969';
                }
            }
        }
    }
});

function progressCircle(percent, selector) {
    const circle = document.querySelector(selector);
    if (!circle) return;
    const radius = circle.r.baseVal.value;
    const circumference = radius * 2 * Math.PI;

    circle.style.strokeDasharray = `${circumference} ${circumference}`;

    const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
    circle.style.strokeDashoffset = -offset;
}

function toggleDisplay3(id, state) {
    const el = document.querySelector(id);
    if (!el) return;
    el.style.display = state ? 'block' : 'none';
}

progressCircle(100, '.health');
progressCircle(100, '.armor');
