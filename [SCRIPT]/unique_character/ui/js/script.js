$(function () {
    var RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'unique_character';
    var MIN = 3, MAX = 10;
    var unlockTimer = null;

    function post(name, body) {
        return $.ajax({
            url: 'https://' + RES + '/' + name,
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(body || {})
        });
    }

    function unlock() {
        clearTimeout(unlockTimer);
        var btn = $('#submit');
        btn.prop('disabled', false);
        btn.find('span').text('ایجاد کاراکتر');
    }

    // Auto-capitalize first letter, lowercase the rest (same as Sunset)
    $('.input-wrapper input[type="text"]').on('input', function (event) {
        var box = event.target;
        var start = box.selectionStart, end = box.selectionEnd;
        // only A-Z are allowed; strip anything else as the user types
        box.value = box.value.replace(/[^A-Za-z]/g, '');
        if (box.value.length > 0) {
            box.value = box.value.charAt(0).toUpperCase() + box.value.slice(1).toLowerCase();
        }
        box.setSelectionRange(start, end);
    });

    window.addEventListener('message', function (event) {
        var data = event.data;

        if (data.type === 'enableui') {
            document.body.style.display = data.enable ? 'block' : 'none';
            if (data.enable) {
                $('#firstname').val('');
                $('#lastname').val('');
                unlock();
                setTimeout(function () { $('#firstname').focus(); }, 100);
            }
        }

        if (data.action === 'notification') showNotification(data.message);
        if (data.action === 'unlock') unlock();
    });

    $('#register').submit(function (event) {
        event.preventDefault();

        var firstname = $('#firstname').val().trim();
        var lastname = $('#lastname').val().trim();

        if (!firstname || !lastname) {
            showNotification('لطفا تمام فیلدها را پر کنید');
            return;
        }
        if (!/^[A-Za-z]+$/.test(firstname) || !/^[A-Za-z]+$/.test(lastname)) {
            showNotification('فقط حروف انگلیسی و بدون فاصله مجاز است');
            return;
        }
        if (firstname.length < MIN || lastname.length < MIN ||
            firstname.length > MAX || lastname.length > MAX) {
            showNotification('نام و نام خانوادگی باید بین ۳ تا ۱۰ حرف باشد');
            return;
        }

        var btn = $('#submit');
        if (btn.prop('disabled')) return; // double submit guard
        btn.prop('disabled', true);
        btn.find('span').text('در حال ایجاد...');

        // the client script answers with 'unlock' when the server rejects the
        // request; this timer only covers a lost reply
        unlockTimer = setTimeout(unlock, 10000);

        post('register', { firstname: firstname, lastname: lastname }).fail(unlock);
    });

    $('input').on('keypress', function (e) {
        if (e.which === 13) $('#register').submit();
    });

    post('initialize', {});
});

function showNotification(message) {
    var notification = $('#notification');
    $('#notificationText').text(message);
    notification.removeClass('hidden').addClass('show');
    setTimeout(function () {
        notification.removeClass('show');
        setTimeout(function () { notification.addClass('hidden'); }, 400);
    }, 3000);
}
