function generateRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

$(document).ready(function(){
    var rand = generateRandomNumber(1, 2);
    if (rand == 2) {
        var image = $('#logo')
        image.css('margin-top', '54.5%');
        image.css('margin-left', '94.5%');
    }
})