// $(document).ready(function(){
//     $(".main").addClass('open');
//     $(".box-animation").addClass('open');
    
// });
let playTime = 0;
setInterval(() => {
    playTime+= 60;
    $('.box3-pt .count div').text(calculateJoinedTime(playTime));
}, 60000);
$(document).ready(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type == 'toggle') {
            if (event.data.action) {
                $('.main').addClass('open');
            } else {
                $('.main').removeClass('open');
            }
        } else if (event.data.type == 'updateInfo') {
            let dt = event.data.data;
            $('.box-admins .count div').text(dt.admins);
            $('.box-police .count div').text(dt.police);
            $('.box-fbi .count div').text(dt.fbi);
            $('.box-sheriff .count div').text(dt.sheriff);
            $('.box-amb .count div').text(dt.ambulance);
            $('.box-mecano .count div').text(dt.mecano);
            $('.box-taxi .count div').text(dt.taxi);
            $('.box-coffee .count div').text(dt.coffee);
            $('.box-night .count div').text(dt.nightclub);
            $('.box2-players .count div').text(dt.players);
            $('[req="game"]').attr("class", (dt.game)?'ss-active':'ss-deactive');
            $('[req="discord"]').attr("class", (dt.discord)?'ss-active':'ss-deactive');
            $('[req="website"]').attr("class", (dt.website)?'ss-active':'ss-deactive');
        }
    });
});
function calculateJoinedTime(d) {
    d = Number(d);
    var h = Math.floor(d / 3600);
    var m = Math.floor(d % 3600 / 60);
    return `${h.toString().padStart(2, 0)}:${m.toString().padStart(2, 0)}`;
}
