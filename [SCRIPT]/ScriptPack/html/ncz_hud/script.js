window.addEventListener('message', function (event) {
    try {
        switch(event.data.action) {				
            case 'disable':
                $("#hud").fadeOut(0)
                $("#batman").fadeOut(0)
                $("#matn").fadeOut(0)
            break;
            case 'enable':
                // FIX: #hud and #batman are centered using CSS
                // "display: flex" (style.css). jQuery's fadeIn() has no
                // idea about that - when it un-hides a <div> that wasn't
                // already showing, it falls back to its own built-in
                // guess of "display: block" for that tag. That silently
                // overrides the flex layout the moment this ever fires,
                // collapsing the centered badge into a plain block box
                // pinned to the top-left instead. Setting display
                // explicitly first keeps the centering; fadeIn then only
                // has opacity left to animate.
                $("#hud").css('display', 'flex')
                $("#batman").css('display', 'flex')
                $("#hud").fadeIn(100)
                $("#batman").fadeIn(100)
                $("#matn").fadeIn(100)
            break;
        }
} catch(err) {}
});