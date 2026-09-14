
let timertime =  36000;

function fixdigits(number) {
    return number.toString().length === 1 ? '0' + number : number
}

let timer = null
window.onload = (e) => {
    $('body').fadeOut(0)
};
function StartTimer() {
    timer = setInterval(() => {
        timertime = timertime - 100;
        let time = timertime
        const minutes = Math.floor(time / 6000);
        time = time - minutes * 6000;
        const seconds = Math.floor(time / 100);
        time = time - seconds * 100;
        const miliseconds = time
        $("#timer").text(fixdigits(minutes) + ":" + fixdigits(seconds) )
        if (timertime === 0) {
            clearInterval(timer)
            timer = null
            setTimeout(() => {
                $('body').fadeOut(1000)
            }, 250)
        }
    }, 1000);
}


window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'new') {
        timertime = data.time / 10;
        if (timer === null) {
            StartTimer()
            $('body').fadeIn(1000)
        }
    }

    if (data.action === 'hide') {
        $('body').fadeOut(1000)
    }
});
