$(function() {
    // Auto-capitalize first letter, lowercase rest
    $('.input-wrapper input[type="text"]').on('input', function(event) {
        const textBox = event.target;
        const start = textBox.selectionStart;
        const end = textBox.selectionEnd;

        if (textBox.value.length > 0) {
            textBox.value = textBox.value.charAt(0).toUpperCase() + textBox.value.slice(1).toLowerCase();
            textBox.setSelectionRange(start, end);
        }
    });

    // Listen for NUI messages
    window.addEventListener('message', function(event) {
        const data = event.data;

        if (data.type === "enableui") {
            document.body.style.display = data.enable ? "block" : "none";

            if (data.enable) {
                // Reset form
                $('#firstname').val('');
                $('#lastname').val('');
                // Focus first input when UI opens
                setTimeout(() => {
                    $('#firstname').focus();
                }, 100);
            }
        }

        // Handle notification
        if (data.action === 'notification') {
            showNotification(data.message);
        }
    });

    // Handle form submission
    $("#register").submit(function(event) {
        event.preventDefault();

        const firstname = $("#firstname").val().trim();
        const lastname = $("#lastname").val().trim();

        // Validate
        if (!firstname || !lastname) {
            showNotification('لطفا تمام فیلدها را پر کنید');
            return;
        }

        // Check for spaces
        if (firstname.includes(' ') || lastname.includes(' ')) {
            showNotification('نام نباید دارای فاصله باشد!');
            return;
        }

        // Add loading state to button
        const btn = $('#submit');
        btn.prop('disabled', true);
        btn.find('span').text('در حال ایجاد...');

        // Send to client
        $.post('https://sun-character/register', JSON.stringify({
            firstname: firstname,
            lastname: lastname,
            sex: $("input[type='radio'][name='sex']:checked").val(),
            height: $("#height").val()
        }));

        // Reset button after short delay (in case UI stays open)
        setTimeout(() => {
            btn.prop('disabled', false);
            btn.find('span').text('ایجاد کاراکتر');
        }, 2000);
    });

    // Allow Enter key to submit from any input
    $('input').on('keypress', function(e) {
        if (e.which === 13) {
            $('#register').submit();
        }
    });

    // Notify that UI is ready
    $.post('https://sun-character/initialize', JSON.stringify({}));
});

function showNotification(message) {
    const notification = $('#notification');
    const notificationText = $('#notificationText');

    notificationText.text(message);
    notification.removeClass('hidden').addClass('show');

    setTimeout(() => {
        notification.removeClass('show');
        setTimeout(() => {
            notification.addClass('hidden');
        }, 400);
    }, 3000);
}
