window.addEventListener('message', function (event) {
    try {
        switch(event.data.action) {				
            case 'disable':
                $("#hud").fadeOut(0)
                $("#batman").fadeOut(0)
                $("#matn").fadeOut(0)
            break;
            case 'enable':
                 $("#hud").fadeIn(100)
                $("#batman").fadeIn(100)
                $("#matn").fadeIn(100)
            break;
        }
} catch(err) {}
});