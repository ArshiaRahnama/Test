$(function(){
    /* Links the game with messages from the phone (the React parent posts
       { type:'ui', display:true/false, scoreboard:[...] } into this iframe).
       Registered immediately (not on window.onload) so it's ready before the
       parent sends the first show message. */
    window.addEventListener('message', (event) => {
        var item = event.data;
        if (item !== undefined && item.type === "ui") {
            if (item.display === true) {
                $('body').css('display', 'block')
                $('#frame').css('display', 'block')
                $('#main').css('display', 'block')
            } else {
                $('body').css('display', 'none')
                $('#frame').css('display', 'none')
                $('#main').css('display', 'none')
            }
        }
    });
    window.addEventListener('keydown', function(event){
        if(event.key === "Escape" || event.key === "Backspace" ){
            window.parent.postMessage({ pacman: 'close' }, '*');
        }
    });
});
