var WhatsappSearchActive = false;
var OpenedChatPicture = null;

$(document).ready(function(){
    $("#whatsapp-search-input").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".whatsapp-chats .whatsapp-chat").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
});

$(document).on('click', '#whatsapp-search-chats', function(e){
    e.preventDefault();

    if ($("#whatsapp-search-input").css('display') == "none") {
        $("#whatsapp-search-input").fadeIn(150);
        WhatsappSearchActive = true;
    } else {
        $("#whatsapp-search-input").fadeOut(150);
        WhatsappSearchActive = false;
    }
});

$(document).on('click', '.whatsapp-chat', function(e){
    e.preventDefault();

    var ChatId = $(this).attr('id');
    var ChatData = $("#"+ChatId).data('chatdata');

    MI.Phone.Functions.SetupChatMessages(ChatData);

    $.post('http://Unique_Phone/ClearAlerts', JSON.stringify({
        number: ChatData.number
    }));

    if (WhatsappSearchActive) {
        $("#whatsapp-search-input").fadeOut(150);
    }

    $(".whatsapp-openedchat").css({"display":"block"});
    $(".whatsapp-openedchat").animate({
        left: 0+"vh"
    },200);
    
    $(".whatsapp-chats").animate({
        left: 30+"vh"
    },200, function(){
        $(".whatsapp-chats").css({"display":"none"});
    });

    $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 150);

    if (OpenedChatPicture == null) {
        OpenedChatPicture = "./img/jobs/default.png";
        if (ChatData.picture != null || ChatData.picture != undefined || ChatData.picture != "default") {
            OpenedChatPicture = ChatData.picture
        }
        
        $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
    }
});

$(document).on('click', '#whatsapp-openedchat-back', function(e){
    e.preventDefault();
    $.post('http://Unique_Phone/GetWhatsappChats', JSON.stringify({}), function(chats){
        MI.Phone.Functions.LoadWhatsappChats(chats);
    });
    OpenedChatData.number = null;
    $(".whatsapp-chats").css({"display":"block"});
    $(".whatsapp-chats").animate({
        left: 0+"vh"
    }, 200);
    $(".whatsapp-openedchat").animate({
        left: -30+"vh"
    }, 200, function(){
        $(".whatsapp-openedchat").css({"display":"none"});
    });
    OpenedChatPicture = null;
});

MI.Phone.Functions.GetLastMessage = function(messages) {
    var CurrentDate = new Date();
    var CurrentMonth = CurrentDate.getMonth();
    var CurrentDOM = CurrentDate.getDate();
    var CurrentYear = CurrentDate.getFullYear();
    var LastMessageData = {
        time: "00:00",
        message: "nikss"
    }

    $.each(messages[messages.length - 1], function(i, msg){
        var msgData = msg[msg.length - 1];
        LastMessageData.time = msgData.time
        LastMessageData.message = msgData.message
    });

    return LastMessageData
}

GetCurrentDateKey = function() {
    var CurrentDate = new Date();
    var CurrentMonth = CurrentDate.getMonth();
    var CurrentDOM = CurrentDate.getDate();
    var CurrentYear = CurrentDate.getFullYear();
    var CurDate = ""+CurrentDOM+"-"+CurrentMonth+"-"+CurrentYear+"";

    return CurDate;
}

// MI.Phone.Functions.LoadWhatsappChats = function(chats) {
//     $(".whatsapp-chats").html("");
//     $.each(chats, function(i, chat){
//         var profilepicture = "./img/default.png";
//         if (chat.picture !== "default") {
//             profilepicture = chat.picture
//         }
//         if (chat.number === 'Police Deparment') {
//             profilepicture = "./img/jobs/pd.png";
//         } else if (chat.number === 'Sheriff Deparment') {
//             profilepicture = "./img/jobs/sh.png";
//         } else if ((chat.number === 'Ambulance Deparment')) {
//             profilepicture = "./img/jobs/md.png";
//         } else if ((chat.number === 'Unique_Post')) {
//             profilepicture = "./img/jobs/post.png";
//         }

//         var LastMessage = MI.Phone.Functions.GetLastMessage(chat.messages);

//         var ChatElement = `
//             <div class="whatsapp-chat" id="whatsapp-chat-${i}">
//                 <div class="whatsapp-chat-picture" style="background-image: url(${profilepicture});"></div>
//                 <div class="whatsapp-chat-name"><p>${chat.name}</p></div>
//                 <div class="whatsapp-chat-lastmessage"><p>${LastMessage.message}</p></div>
//                 <div class="whatsapp-chat-lastmessagetime"><p>${LastMessage.time}</p></div>
//                 <div class="whatsapp-chat-unreadmessages unread-chat-id-${i}">1</div>
//                 <div class="whatsapp-chat-delete" data-chatid="${i}" style="position:absolute; right:20px; top:75%; transform:translateY(-80%); cursor:pointer;">
//                     🗑️
//                 </div>
//             </div>
//         `;

//         $(".whatsapp-chats").append(ChatElement);
//         $("#whatsapp-chat-"+i).data('chatdata', chat);

//         if (chat.Unread > 0 && chat.Unread !== undefined && chat.Unread !== null) {
//             $(".unread-chat-id-"+i).html(chat.Unread);
//             $(".unread-chat-id-"+i).css({"display":"block"});
//         } else {
//             $(".unread-chat-id-"+i).css({"display":"none"});
//         }

//         $("#confirm-delete-yes").off("click");
//         $("#confirm-delete-no").off("click");

//         // کلیک روی آیکون حذف
//         $(`.whatsapp-chat-delete[data-chatid="${i}"]`).on("click", function(e) {
//             e.stopPropagation();
//             const chatId = $(this).data("chatid");
//             var chatData = $(`#whatsapp-chat-${chatId}`).data('chatdata');

//             console.log(chatData.number)
//             // ذخیره ID چت برای حذف بعدی
//             $("#confirm-delete-dialog").data("chatid", chatId);

//             // نمایش دیالوگ
//             $("#overlay").show();
//             $("#confirm-delete-dialog").show();
//         });
//     });

//     // دکمه "خیر"
//     $("#confirm-delete-yes").on("click", function() {
//         $("#confirm-delete-dialog").hide();
//         $("#overlay").hide();
//     });

//     // دکمه "بله"
//     $("#confirm-delete-no").on("click", function() {
//         var chatId = $("#confirm-delete-dialog").data("chatid");
//         $(`#whatsapp-chat-${chatId}`).remove();
//         $("#confirm-delete-dialog").hide();
//         $("#overlay").hide();

//         // اگر بخوای از آرایه هم حذف کنی:
//         // chats.splice(chatId, 1);
//     });
// };









MI.Phone.Functions.LoadWhatsappChats = function(chats) {
    $(".whatsapp-chats").html("");
    $.each(chats, function(i, chat){
        var profilepicture = "./img/default.png";
        if (chat.picture !== "default") {
            profilepicture = chat.picture
        }
        if (chat.number === 'Police Deparment') {
            profilepicture = "./img/jobs/pd.png";
        } else if (chat.number === 'Sheriff Deparment') {
            profilepicture = "./img/jobs/sh.png";
        } else if ((chat.number === 'Ambulance Deparment')) {
            profilepicture = "./img/jobs/md.png";
        } else if ((chat.number === 'Unique_Post')) {
            profilepicture = "./img/jobs/post.png";
        }

        var LastMessage = MI.Phone.Functions.GetLastMessage(chat.messages);

        var ChatElement = `
            <div class="whatsapp-chat" id="whatsapp-chat-${i}">
                <div class="whatsapp-chat-picture" style="background-image: url(${profilepicture});"></div>
                <div class="whatsapp-chat-name"><p>${chat.name}</p></div>
                <div class="whatsapp-chat-lastmessage"><p>${LastMessage.message}</p></div>
                <div class="whatsapp-chat-lastmessagetime"><p>${LastMessage.time}</p></div>
                <div class="whatsapp-chat-unreadmessages unread-chat-id-${i}">1</div>
                <div class="whatsapp-chat-delete" data-chatid="${i}" style="position:absolute; right:20px; top:75%; transform:translateY(-80%); cursor:pointer;">
                    🗑️
                </div>
            </div>
        `;

        $(".whatsapp-chats").append(ChatElement);
        $("#whatsapp-chat-"+i).data('chatdata', chat);

        if (chat.Unread > 0 && chat.Unread !== undefined && chat.Unread !== null) {
            $(".unread-chat-id-"+i).html(chat.Unread);
            $(".unread-chat-id-"+i).css({"display":"block"});
        } else {
            $(".unread-chat-id-"+i).css({"display":"none"});
        }

        $("#confirm-delete-yes").off("click");
        $("#confirm-delete-no").off("click");

        $(`.whatsapp-chat-delete[data-chatid="${i}"]`).on("click", function(e) {
            e.stopPropagation();
            const chatId = $(this).data("chatid");
            

            $("#confirm-delete-dialog").data("chatid", chatId);

            $("#overlay").show();
            $("#confirm-delete-dialog").show();
        });
    });

    $("#confirm-delete-yes").off("click");
    $("#confirm-delete-no").off("click");

    $("#confirm-delete-yes").on("click", function() {
        var chatId = $("#confirm-delete-dialog").data("chatid");
        var chatData = $(`#whatsapp-chat-${chatId}`).data('chatdata');
        $(`#whatsapp-chat-${chatId}`).remove();
        $("#confirm-delete-dialog").hide();
        $("#overlay").hide();

        $.post("https://"+GetParentResourceName()+"/Delete_Message", JSON.stringify({
            phone_number: chatData.number
        }))
    });

    $("#confirm-delete-no").on("click", function() {
        $("#confirm-delete-dialog").hide();
        $("#overlay").hide();
    });
};

MI.Phone.Functions.ReloadWhatsappAlerts = function(chats) {
    $.each(chats, function(i, chat){
        if (chat.Unread > 0 && chat.Unread !== undefined && chat.Unread !== null) {
            $(".unread-chat-id-"+i).html(chat.Unread);
            $(".unread-chat-id-"+i).css({"display":"block"});
        } else {
            $(".unread-chat-id-"+i).css({"display":"none"});
        }
    });
}

const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

FormatChatDate = function(date) {
    var TestDate = date.split("-");
    var NewDate = new Date((parseInt(TestDate[1]) + 1)+"-"+TestDate[0]+"-"+TestDate[2]);

    var CurrentMonth = monthNames[NewDate.getMonth()];
    var CurrentDOM = NewDate.getDate();
    var CurrentYear = NewDate.getFullYear();
    var CurDateee = CurrentDOM + "-" + NewDate.getMonth() + "-" + CurrentYear;
    var ChatDate = CurrentDOM + " " + CurrentMonth + " " + CurrentYear;
    var CurrentDate = GetCurrentDateKey();

    var ReturnedValue = ChatDate;
    if (CurrentDate == CurDateee) {
        ReturnedValue = "Today";
    }

    return ReturnedValue;
}

FormatMessageTime = function() {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    if (NewHour < 10) {
        Hourssssss = "0" + NewHour;
    }
    var MessageTime = Hourssssss + ":" + Minutessss
    return MessageTime;
}

$(document).on('click', '#whatsapp-openedchat-send', function(e){
    e.preventDefault();

    var Message = $("#whatsapp-openedchat-message").val();

    if (Message !== null && Message !== undefined && Message !== "") {
        $.post('http://Unique_Phone/SendMessage', JSON.stringify({
            ChatNumber: OpenedChatData.number,
            ChatDate: GetCurrentDateKey(),
            ChatMessage: Message,
            ChatTime: FormatMessageTime(),
            ChatType: "message",
        }));
  
        $("#whatsapp-openedchat-message").val('').trigger('change');
        var $messageField = $("#whatsapp-openedchat-message");
        if ($messageField.length) {
            $messageField.val('');
        }


    } else {
        MI.Phone.Notifications.Add("fab fa-whatsapp", MI.Phone.Functions.Lang("WHATSAPP_TITLE"), MI.Phone.Functions.Lang("WHATSAPP_BLANK_MSG"), "#25D366", 1750);
    }
});

$(document).on('keypress', function (e) {
    if (OpenedChatData.number !== null) {
        if(e.which === 13){
            var Message = $("#whatsapp-openedchat-message").val();
    
            if (Message !== null && Message !== undefined && Message !== "") {
                $.post('http://Unique_Phone/SendMessage', JSON.stringify({
                    ChatNumber: OpenedChatData.number,
                    ChatDate: GetCurrentDateKey(),
                    ChatMessage: Message,
                    ChatTime: FormatMessageTime(),
                    ChatType: "message",
                }));
                $("#whatsapp-openedchat-message").val("");
            } else {
                MI.Phone.Notifications.Add("fab fa-whatsapp", MI.Phone.Functions.Lang("WHATSAPP_TITLE"), MI.Phone.Functions.Lang("WHATSAPP_BLANK_MSG"), "#25D366", 1750);
            }
        }
    }
});

$(document).on('click', '#send-location', function(e){
    e.preventDefault();

    $.post('http://Unique_Phone/SendMessage', JSON.stringify({
        ChatNumber: OpenedChatData.number,
        ChatDate: GetCurrentDateKey(),
        ChatMessage: "Shared Location",
        ChatTime: FormatMessageTime(),
        ChatType: "location",
    }));
});


MI.Phone.Functions.SetupChatMessages = function(cData, NewChatData) {
    if (cData) {
        OpenedChatData.number = cData.number;

        if (OpenedChatPicture == null) {
            $.post('https://Unique_Phone/GetProfilePicture', JSON.stringify({
                number: OpenedChatData.number,
            }), function(picture){
                OpenedChatPicture = "./img/default.png";
                if (picture != "default" && picture != null) {
                    OpenedChatPicture = picture
                }
                if (OpenedChatData.number === 'Police Deparment') {
                    var OpenedChatPicture = "./img/jobs/pd.png";
                } else if (OpenedChatData.number === 'Sheriff Deparment') {
                    var OpenedChatPicture = "./img/jobs/sh.png";
                } else if ((OpenedChatData.number === 'Ambulance Deparment')) {
                    var OpenedChatPicture = "./img/jobs/md.png";
                } else if ((OpenedChatData.number === 'Unique_Post')) {
                    var OpenedChatPicture = "./img/jobs/post.png";
                }
                $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
            });
        } else {
            $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
        }

        $(".whatsapp-openedchat-name").html("<p>"+cData.name+"</p>");
        $(".whatsapp-openedchat-messages").html("");

        $.each(cData.messages, function(i, chat){

            var ChatDate = FormatChatDate(chat.date);
            var ChatDiv = '<div class="whatsapp-openedchat-messages-'+i+' unique-chat"><div class="whatsapp-openedchat-date">'+ChatDate+'</div></div>';

            $(".whatsapp-openedchat-messages").append(ChatDiv);

            $.each(cData.messages[i].messages, function(index, message){

                $.post('https://Unique_Phone/GetIranianDateTime', JSON.stringify({}), function(response) {
                    if (response && response.dateString) {
                        
                       
                    
              
                        message.message = DOMPurify.sanitize(message.message , {
                            ALLOWED_TAGS: [],
                            ALLOWED_ATTR: []
                        });
                        if (message.message == '') message.message = 'Hmm, I shouldn\'t be able to do this...'
                        var Sender = "me";
                        if (message.sender !== MI.Phone.Data.PlayerData.identifier) { Sender = "other"; }
                        var MessageElement
                        if (message.type == "message") {
                            MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+'">'+message.message+'<div class="whatsapp-openedchat-message-time">'+response.timeString+'</div></div><div class="clearfix"></div>'
                        } else if (message.type == "location") {
                            MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+' whatsapp-shared-location" data-x="'+message.data.x+'" data-y="'+message.data.y+'"><span style="font-size: 1.2vh;"><i class="fas fa-map-marker-alt" style="font-size: 1vh;"></i> Location</span><div class="whatsapp-openedchat-message-time">'+message.time+'</div></div><div class="clearfix"></div>'
                        } else if (message.type == "picture") {
                            MessageElement = '<div class="whatsapp-openedchat-message whatsapp-openedchat-message-'+Sender+'" data-id='+OpenedChatData.number+'><img class="wppimage" src='+message.data.url +'  style=" border-radius:4px; width: 100%; position:relative; z-index: 1; right:1px;height: auto;"></div><div class="whatsapp-openedchat-message-time">'+message.time+'</div></div><div class="clearfix"></div>'
                        }
                        $(".whatsapp-openedchat-messages-"+i).append(MessageElement);
                    }
                });
            });
        });
        $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 1);
    } else {
        OpenedChatData.number = NewChatData.number;
        if (OpenedChatPicture == null) {
            $.post('https://Unique_Phone/GetProfilePicture', JSON.stringify({
                number: OpenedChatData.number,
            }), function(picture){
                OpenedChatPicture = "./img/default.png";
                if (picture != "default" && picture != null) {
                    OpenedChatPicture = picture
                }
                $(".whatsapp-openedchat-picture").css({"background-image":"url("+OpenedChatPicture+")"});
            });
        }
        $(".whatsapp-openedchat-name").html("<p>"+NewChatData.name+"</p>");
        $(".whatsapp-openedchat-messages").html("");
        
        // دریافت تاریخ و زمان از سرور
        $.post('https://Unique_Phone/GetIranianDateTime', JSON.stringify({}), function(response) {
            if (response && response.dateString) {
                var ChatDiv = `
                    <div class="whatsapp-openedchat-messages-${response.dateString} unique-chat">
                        <div class="whatsapp-openedchat-date">
                            TODAY • ${response.timeString}
                        </div>
                    </div>
                `;
                
                // اضافه کردن چت به صفحه
                $(".whatsapp-openedchat-messages").append(ChatDiv);
            }
        });


    }

    $('.whatsapp-openedchat-messages').animate({scrollTop: 9999}, 1);

}

$(document).on('click', '.whatsapp-shared-location', function(e){
    e.preventDefault();
    var messageCoords = {}
    messageCoords.x = $(this).data('x');
    messageCoords.y = $(this).data('y');

    $.post('http://Unique_Phone/SharedLocation', JSON.stringify({
        coords: messageCoords,
    }))
});

var ExtraButtonsOpen = false;

$(document).on('click', '#whatsapp-openedchat-message-extras', function(e){
    e.preventDefault();

    if (!ExtraButtonsOpen) {
        $(".whatsapp-extra-buttons").css({"display":"block"}).animate({
            left: 0+"vh"
        }, 250);
        ExtraButtonsOpen = true;
    } else {
        $(".whatsapp-extra-buttons").animate({
            left: -10+"vh"
        }, 250, function(){
            $(".whatsapp-extra-buttons").css({"display":"block"});
            ExtraButtonsOpen = false;
        });
    }
});



$(document).on('click', '#send-image', function(e){
    e.preventDefault();
    let ChatNumber2 = OpenedChatData.number;
    $.post('https://Unique_Phone/TakePhoto', JSON.stringify({}),function(url){
        if(url){
        $.post('https://Unique_Phone/SendMessage', JSON.stringify({
        ChatNumber: ChatNumber2,
        ChatDate: GetCurrentDateKey(),
        ChatMessage: "Photo",
        ChatTime: FormatMessageTime(),
        ChatType: "picture",
        url : url,
        Time : Math.floor(Date.now() / 1000),
    }))}})
   MI.Phone.Functions.Close();
});