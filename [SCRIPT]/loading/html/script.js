$(document).ready(function($) {
    $('.input-text').keyup(function(event) {
        var textBox = event.target;
        var start = textBox.selectionStart;
        var end = textBox.selectionEnd;
        textBox.value = textBox.value.charAt(0).toUpperCase() + textBox.value.slice(1).toLowerCase();
    });
});

    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
            if (event.data.enable) {
                // wait a frame so the browser registers display:block before
                // we flip the class that triggers the CSS transition —
                // otherwise the fade/rise never animates, it just snaps in.
                requestAnimationFrame(function() {
                    requestAnimationFrame(function() {
                        var card = document.getElementById('formCard');
                        if (card) card.classList.add('is-ready');
                    });
                });
            }
        }else if (event.data.action == "notification") {
          popupkon('Warning' ,event.data.message);
        }
    });

    // ---------- ambient floating particles (purely decorative) ----------
    (function spawnAmbientParticles() {
        var host = document.getElementById('ambientParticles');
        if (!host) return;
        var COUNT = 22;
        for (var i = 0; i < COUNT; i++) {
            var mote = document.createElement('div');
            mote.className = 'mote';
            var left = Math.random() * 100;
            var duration = 10 + Math.random() * 12;
            var delay = Math.random() * 14;
            var drift = (Math.random() * 60 - 30).toFixed(0) + 'px';
            var size = (2 + Math.random() * 2).toFixed(1) + 'px';
            mote.style.left = left + 'vw';
            mote.style.width = size;
            mote.style.height = size;
            mote.style.setProperty('--drift', drift);
            mote.style.animationDuration = duration + 's';
            mote.style.animationDelay = delay + 's';
            host.appendChild(mote);
        }
    })();

    // ---------- subtle 3D tilt on the ID card, following the cursor ----------
    (function idCardTilt() {
        var card = document.getElementById('idCard');
        if (!card) return;
        var maxTilt = 8; // degrees

        document.addEventListener('mousemove', function(e) {
            var rect = card.getBoundingClientRect();
            var cx = rect.left + rect.width / 2;
            var cy = rect.top + rect.height / 2;
            var dx = (e.clientX - cx) / (rect.width / 2);
            var dy = (e.clientY - cy) / (rect.height / 2);
            dx = Math.max(-1, Math.min(1, dx));
            dy = Math.max(-1, Math.min(1, dy));
            card.style.setProperty('--tiltX', (dx * maxTilt).toFixed(2) + 'deg');
            card.style.setProperty('--tiltY', (-dy * maxTilt).toFixed(2) + 'deg');
        });

        document.addEventListener('mouseleave', function() {
            card.style.setProperty('--tiltX', '0deg');
            card.style.setProperty('--tiltY', '0deg');
        });
    })();

$("#name, #family").on("keydown", function(event){
  // Allow controls such as backspace, tab etc.
  var arr = [8,9,16,17,20,35,36,37,38,39,40,45,46];

  // Allow letters
  for(var i = 65; i <= 90; i++){
    arr.push(i);
  }

  // Prevent default if not in array
  if(jQuery.inArray(event.which, arr) === -1){
    event.preventDefault();
  }
});
$(document).ready(function() {
  $('#dateofbirth').datepicker({ dateFormat: 'yyyy-mm-dd' });

  // --- live ID card preview ---
  function updateCardPreview() {
    var name = $('#name').val().trim();
    var family = $('#family').val().trim();
    var dob = $('#dateofbirth').val().trim();

    var $name = $('#previewName');
    var $family = $('#previewFamily');
    var $dob = $('#previewDob');

    $name.text(name ? name.toUpperCase() : '— — —').toggleClass('is-filled', !!name);
    $family.text(family ? family.toUpperCase() : '— — —').toggleClass('is-filled', !!family);
    $dob.text(dob ? dob : '--/--/----').toggleClass('is-filled', !!dob);
  }

  $('#name, #family').on('keyup change', updateCardPreview);
  $('#dateofbirth').on('change', updateCardPreview);
  // gijgo's datepicker doesn't always fire a plain change event, poll lightly instead
  setInterval(updateCardPreview, 400);

  $('.register').on('click', function(e){
    if(($('#name').val().length < 3 ) || ($('#family').val().length < 3 ) || ($('#name').val().length < 3 )) {
      popupkon('Warning', 'hade aghal bayad 3 character vared konid!');
      return false;
    } else {
      e.preventDefault(); // Prevent form from submitting

      // stamp the ID card before handing off to the game
      var $stamp = $('#idStamp');
      $stamp.text('Approved').addClass('is-approved');

      $.post('http://loading/register', JSON.stringify({
        name: $("#name").val(),
        family: $("#family").val(),
        dateofbirth: $("#dateofbirth").val()
      }));
    }
  });
});
function popupkon(title,msg) {
  $('#modalTitle').text(title);
  $('#modalText').text(msg);
  $('#clicktomod').click();
}
