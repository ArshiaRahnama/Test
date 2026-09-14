

console.log('[Unique_ALLGangs] html/js.js (boss panel) loaded and parsing');
// FIX ("Uiloaded request FAILED"): this kept failing even after the
// nested-iframe was removed (section 18), which means it was never
// really about iframe nesting - it's a startup race. This page's
// document.ready can fire before client/boss.lua has reached its
// RegisterNUICallback('Uiloaded', ...) line (Lua client scripts and
// the NUI page both start loading around the same time, in no
// guaranteed order). A single one-shot post can lose that race.
// Fix: retry with a short backoff until it actually succeeds, instead
// of giving up after one failed attempt.
function pingUiloaded(attempt) {
    attempt = attempt || 1;
    $.post('https://' + GetParentResourceName() + '/Uiloaded', JSON.stringify({}))
        .done(function() { console.log('[Unique_ALLGangs] Uiloaded response received OK (attempt ' + attempt + ')') })
        .fail(function(xhr, status, err) {
            console.log('[Unique_ALLGangs] Uiloaded request FAILED (attempt ' + attempt + '):', status, err);
            if (attempt < 20) {
                setTimeout(function() { pingUiloaded(attempt + 1) }, 500);
            } else {
                console.log('[Unique_ALLGangs] Uiloaded gave up after 20 attempts - client/boss.lua may not be running at all');
            }
        });
}
$(document).ready(function() {
    console.log('[Unique_ALLGangs] html/js.js $(document).ready fired, posting Uiloaded');
    pingUiloaded();
})    
window.addEventListener('message', function(event) {
    if (event.data.type == 'displaynone') {
        var mapla = document.querySelector('.bg');
        mapla.style.display = "none";
      } if (event.data.type == "displayblock") {
        $('#kutular').empty()
        $('.profile').css('background-image' , 'url('+event.data.logo +')')
        var map = document.querySelector('.bg');
        map.style.display = "block";
        }if (event.data.type == "changename") {
            $('.profile-name').html(event.data.name)
            $('.box-1-class').html(event.data.jobname)
            $('.box-1-cizgi').html(event.data.dec)
            $('.box-1-price').html("$"+event.data.money)
        }if (event.data.type == "add") { 
            html = `
            <div class="box-4-item">
            <div class="box-4-item-name">`+event.data.name+`</div>
            <div class="box-4-item-box">GRADE `+event.data.jobname+`</div>
            <div class="box-4-online-png"></div>
            <div class="box-4-online-text">ONLINE</div>
            </div>
            `
            $('#kutular').prepend(html);
        }if (event.data.type == "add-2") { 
            html = `
            <div class="recruit-item">
            <div class="recruit-name">`+event.data.name+`</div>
            <div class="recruit-button">GRADE `+event.data.jobname+`</div>
            <div class="up" id="`+event.data.id+`"></div>
            <div class="down" id="`+event.data.id+`"></div>
            <div class="fire" id="`+event.data.Hex+`" ></div>
            <div class="online-img-2"></div>
            </div>
            `
            $('#kutular2').prepend(html);
        }
        if (event.data.type == "player") { 
            $('.online-text span2').html(event.data.onlineplayer);
            $('.online-text span').html("/"+event.data.total);
            $('.box-4-members span').html("/"+event.data.total);
            $('.box-4-members span2').html(event.data.onlineplayer);
        }
        if (event.data.type == "case-update") { 
            $('.case-price span').html(event.data.case);
            
        }
        if (event.data.type == "add-offline") { 
            html = `
            <div class="box-4-item">
            <div class="box-4-item-name">`+event.data.name+`</div>
            <div class="box-4-item-box">GRADE `+event.data.jobname+`</div>
            <div class="box-4-offline-png"></div>
            <div class="box-4-offline-text">OFFLINE</div>
        </div>
            `
            $('#kutular').prepend(html);
        }
        if (event.data.type == "add-offline-2") { 
            html = `
            <div class="recruit-item">
            <div class="recruit-name">`+event.data.name+`</div>
            <div class="recruit-button">GRADE `+event.data.jobname+`</div>
            <div class="up" id="`+event.data.id+`"></div>
            <div class="down" id="`+event.data.id+`"></div>
            <div class="fire" id="`+event.data.Hex+`" ></div>
            <div class="offline-img-2"></div>
            </div>
            `
            $('#kutular2').prepend(html);
        }
    })   

    $(document).on('click', '.box-2-button', function(event) {
        var thisid = this.id
        var maps = document.querySelector('.recruit');
        maps.style.display = "none";
        var map = document.querySelector('.case');
        map.style.display = "block";
        $.post('https://' + GetParentResourceName() + '/opencase', JSON.stringify({}));
    });

    $(document).on('click', '.box-1-mini', function(event) {
        var thisid = this.id
        var maps = document.querySelector('.recruit');
        maps.style.display = "none";
        var map = document.querySelector('.case');
        map.style.display = "block";
        $.post('https://' + GetParentResourceName() + '/opencase', JSON.stringify({}));
    });

    let ReloadColdDown = false 
    $(document).on('click', '.box-3-button', function(event) {
        if (ReloadColdDown) return 
        ReloadColdDown = true 
        setTimeout(() => {
            ReloadColdDown = false 
        }, 2500);
        var thisid = this.id
        var maps = document.querySelector('.recruit');
        maps.style.display = "block";
        $('#kutular2').empty()
        var map = document.querySelector('.case');
        map.style.display = "none";
        $.post('https://' + GetParentResourceName() + '/openrecruit', JSON.stringify({}));
    });

    $(document).on('click', '.box-2-mini', function(event) {
        if (ReloadColdDown) return 
        ReloadColdDown = true 
        setTimeout(() => {
            ReloadColdDown = false 
        }, 2500);
        var thisid = this.id
        var maps = document.querySelector('.recruit');
        maps.style.display = "block";
        $('#kutular2').empty()
        var map = document.querySelector('.case');
        map.style.display = "none";
        $.post('https://' + GetParentResourceName() + '/openrecruit', JSON.stringify({}));
    });
    
    
    $(document).on('click', '.exit-button', function(event) {
        $.post('https://' + GetParentResourceName() + '/close', JSON.stringify({}));
        var map = document.querySelector('.bg');
        map.style.display = "none";
    });

    function close2() { 
        var map = document.querySelector('.case');
        map.style.display = "none";
        
    }

    function close3() { 
        var map = document.querySelector('.recruit');
        map.style.display = "none";
    }

    function withdraw() {
        var para = $(".input").val()
        $.post('https://' + GetParentResourceName() + '/witmoney', JSON.stringify({
            para: para
        }));
        var map = document.querySelector('.bg');
        map.style.display = "none";
        var maps = document.querySelector('.case');
        maps.style.display = "none";
        $(".input").val("")
    }

    function stash() {
        $.post('https://' + GetParentResourceName() + '/stash', JSON.stringify({}));
        var map = document.querySelector('.bg');
        map.style.display = "none";
        var maps = document.querySelector('.case');
        maps.style.display = "none";
        $(".input").val("")
    }

    function deposit() {
        var para = $(".input").val()
        $.post('https://' + GetParentResourceName() + '/deposit', JSON.stringify({
            para: para
        }));
        var map = document.querySelector('.bg');
        map.style.display = "none";
        var maps = document.querySelector('.case');
        maps.style.display = "none";
        $(".input").val("")
    }

    $(document).on('click', '.up', function(event) {
        var thisid = this.id
        $.post('https://' + GetParentResourceName() + '/addrutbe', JSON.stringify({
            id: thisid
        }));
        var map = document.querySelector('.recruit');
        map.style.display = "none";
        var maps = document.querySelector('.bg');
        maps.style.display = "none";
    });

    $(document).on('click', '.down', function(event) {
        var thisid = this.id
        console.log(true)
        $.post('https://' + GetParentResourceName() + '/removerutbe', JSON.stringify({
   
            id: thisid
        }));
        var map = document.querySelector('.recruit');
        map.style.display = "none";
        var maps = document.querySelector('.bg');
        maps.style.display = "none";
    });
    $(document).on('click', '.fire', function(event) {
        var thisid = this.id
        $.post('https://' + GetParentResourceName() + '/fireplayer', JSON.stringify({
            cid: thisid
        }));
        var map = document.querySelector('.recruit');
        map.style.display = "none";
        var maps = document.querySelector('.bg');
        maps.style.display = "none";
    });
  
    function givejob() {
        var id = $(".input2").val()
        $.post('https://' + GetParentResourceName() + '/givejob', JSON.stringify({
            id: id
        }));
        var map = document.querySelector('.bg');
        map.style.display = "none";
        $(".input2").val("")
    }