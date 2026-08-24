Setuppolices = function(data) {
    $(".polices-list").html("");
    var uwucafe = [];
    var mechanic = [];
    var taxi = [];
    var sheriff = [];
    var ambulance = [];
    var LSPD = [];
    var weazel = [];

    if (data.length > 0) {
        $.each(data, function(i, police) {
            if (police.typejob == "uwucafe") {
                uwucafe.push(police);
            }
            if (police.typejob == "police") {
                LSPD.push(police);
            }
            if (police.typejob == "mechanic") {
                mechanic.push(police);
            }
            if (police.typejob == "taxi") {
                taxi.push(police);
            }
            if (police.typejob == "sheriff") {
                sheriff.push(police);
            }
            if (police.typejob == "ambulance") {
                ambulance.push(police);
            }
            if (police.typejob == "weazel") {
                weazel.push(police);
            }
        });

      
        $(".polices-list").append('<h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; border-top-left-radius: .5vh; border-top-right-radius: .5vh; width:100%; display:block; background-color: rgb(43, 43, 43);">Police (' + (LSPD.length > 5 ? "+5" : LSPD.length) + ')</h1>');

        if (LSPD.length > 0) {
            var police1 = LSPD[0]; 
            var element = '<div class="police-list" id="policeid1-0"> <div class="police-list-firstletter" style="background-color: rgb(43, 43, 43);"><img src="./img/jobs/pd.png" alt="Police" style="width: 100%; height: 100%; object-fit: cover;"></div> <div class="police-list-fullname">Police</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>';
            $(".polices-list").append(element);
            $("#policeid1-0").data('policeData', police1); 
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no Police available.</div></div>';
            $(".polices-list").append(element);
        }

       
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(138, 84, 33);">Sheriff (' + (sheriff.length > 5 ? "+5" : sheriff.length) + ')</h1>');

        if (sheriff.length > 0) {
            var police = sheriff[0];
            var element = '<div class="police-list" id="policeid-0"> <div class="police-list-firstletter" style="background-color: rgb(138, 84, 33); display: flex; align-items: center; justify-content: center;"> <img src="./img/jobs/sh.png" alt="Sheriff" style="width: 100%; height: 100%; object-fit: contain;"> </div> <div class="police-list-fullname">Sheriff</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>';
            $(".polices-list").append(element);
            $("#policeid-0").data('policeData', police);
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no Sheriff available.</div></div>';
            $(".polices-list").append(element);
        }

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">Ambulance (' + ambulance.length + ')</h1>');

        if (ambulance.length > 0) {
            var police2 = ambulance[0]; 
            var element = '<div class="police-list" id="policeid2-0"> <div class="police-list-firstletter" style="background-color: rgb(255, 0, 0); display: flex; align-items: center; justify-content: center;"> <img src="./img/jobs/md.png" alt="Ambulance" style="width: 100%; height: 100%; object-fit: contain;"> </div> <div class="police-list-fullname">Ambulance</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>';
            $(".polices-list").append(element);
            $("#policeid2-0").data('policeData', police2);
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no Ambulance available.</div></div>';
            $(".polices-list").append(element);
        }
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 190, 27);">Taxi (' + taxi.length + ')</h1>');

        if (taxi.length > 0) {
            var police3 = taxi[0]; 
            var element = '<div class="police-list" id="policeid3-0"> <div class="police-list-firstletter" style="background-color: rgb(253, 202, 74); display: flex; align-items: center; justify-content: center;"> <img src="./img/jobs/tx.png" alt="Taxi" style="width: 100%; height: 100%; object-fit: contain;"> </div> <div class="police-list-fullname">Taxi</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>';
            $(".polices-list").append(element);
            $("#policeid3-0").data('policeData', police3);
        } else {
            var element = '<div class="police-list"><div class="no-polices">There are no taxis available.</div></div>';
            $(".polices-list").append(element);
        }
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 128, 0);">Mechanic (' + mechanic.length + ')</h1>');
        var element = '<div class="police-list" id="policeid4-0"> <div class="police-list-firstletter" style="background-color: rgb(255, 128, 0); display: flex; align-items: center; justify-content: center;"> <img src="./img/jobs/mc.png" alt="Mechanic" style="width: 100%; height: 100%; object-fit: contain;"> </div> <div class="police-list-fullname">Mechanic</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>';
        if (mechanic.length > 0) {
            var police4 = mechanic[0]; 

            $(".polices-list").append(element);
            $("#policeid4-0").data('policeData', police4);
        } else {
            var element = '<div class="police-list"><div class="no-polices">There is no Mechanic available.</div></div>';
            $(".polices-list").append(element);
        }
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(182, 20, 182);">UwU Cafe (' + uwucafe.length + ')</h1>');

        if (uwucafe.length > 0) {
            $.each(uwucafe, function(i, police5) {
                var element = '<div class="police-list" id="policeid5-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(182, 20, 182); display: flex; align-items: center; justify-content: center;"> <img src="./img/jobs/uwu.png" alt="Police" style="width: 100%; height: 100%; object-fit: contain;"> </div> <div class="police-list-fullname">' + police5.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>';
                $(".polices-list").append(element);
                $("#policeid5-" + i).data('policeData', police5);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There is no UwU Cafe available.</div></div>'
            $(".polices-list").append(element);
        }

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">Weazel News (' + weazel.length + ')</h1>');

        if (weazel.length > 0) {
            $.each(weazel, function(i, police6) {
                var element = '<div class="police-list" id="policeid6-' + i + '"> <div class="police-list-firstletter" style="background-color: rgb(255, 0, 0); display: flex; align-items: center; justify-content: center;"> <img src="./img/jobs/wz.png" alt="Police" style="width: 100%; height: 100%; object-fit: contain;"> </div> <div class="police-list-fullname">' + police6.name + '</div> <div class="police-list-call"><i class="fas fa-phone"></i></div> </div>';
                $(".polices-list").append(element);
                $("#policeid6-" + i).data('policeData', police6);
            });
        } else {
            var element = '<div class="police-list"><div class="no-polices">There is no Weazel News available.</div></div>'
            $(".polices-list").append(element);
        }
    } else {
        $(".polices-list").append('<h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; border-top-left-radius: .5vh; border-top-right-radius: .5vh; width:100%; display:block; background-color: rgb(138, 84, 33);">Sheriff (' + sheriff.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Sheriff available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(43, 43, 43);">Police (' + LSPD.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Police available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">Ambulance (' + ambulance.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Ambulance available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#F5F5DC; margin-top:0; width:100%; display:block; background-color: rgb(255, 190, 27);">Taxi (' + taxi.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no taxis available.</div></div>'
        $(".polices-list").append(element);
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 128, 0);">Mechanic (' + mechanic.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Mechanic a available.</div></div>'
        $(".polices-list").append(element);
        
        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(182, 20, 182);">UwU Cafe (' + uwucafe.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no UwU Cafe a available.</div></div>'
        $(".polices-list").append(element);

        $(".polices-list").append('<br><h1 style="font-size:1.641025641025641vh; padding:1.0256410256410255vh; color:#fff; margin-top:0; width:100%; display:block; background-color: rgb(255, 0, 0);">Weazel News (' + weazel.length + ')</h1>');

        var element = '<div class="police-list"><div class="no-polices">There are no Weazel News a available.</div></div>'
        $(".polices-list").append(element);
    }
}

var lastRequestTime = 0;
var cooldownTime = 5 * 60 * 1000; 


$(document).on('click', '.police-list-call', function(e) {
    e.preventDefault();

    var policeData = $(this).parent().data('policeData');
    
    var cData = {
        number: policeData.phone,
        name: policeData.name,
        job: policeData.typejob
    };


    if (policeData.typejob === "uwucafe" || policeData.typejob === "weazel") {
 
        $.post('https://Unique_Phone/CallContact', JSON.stringify({
            ContactData: cData,
            Anonymous: MI.Phone.Data.AnonymousCall,
        }), function(status) {
            if (cData.number !== MI.Phone.Data.PlayerData.charinfo.phone) {
                if (status.IsOnline) {
                    if (status.CanCall) {
                        if (!status.InCall) {
                            if (MI.Phone.Data.AnonymousCall) {
                                MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You started an anonymous call!");
                            }
                            $(".phone-call-outgoing").css({"display":"block"});
                            $(".phone-call-incoming").css({"display":"none"});
                            $(".phone-call-ongoing").css({"display":"none"});
                            $(".phone-call-outgoing-caller").html(cData.name);
                            MI.Phone.Functions.HeaderTextColor("white", 400);
                            MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                            setTimeout(function() {
                                $(".polices-app").css({"display":"none"});
                                MI.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                                MI.Phone.Functions.ToggleApp("phone-call", "block");
                            }, 450);

                            CallData.name = cData.name;
                            CallData.number = cData.number;
                        
                            MI.Phone.Data.currentApplication = "phone-call";
                        } else {
                            MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You are already connected to a call!");
                        }
                    } else {
                        MI.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is already in a call");
                    }
                } else {
                    MI.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
                }
            } else {
                MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You can't call your own number!");
            }
        });
    } else {

        if (policeData.typejob === "mechanic" || policeData.typejob === "taxi") {
            $.post('https://Unique_Phone/Unique_Phone:RequestToJobs', JSON.stringify({
                contactData: policeData.typejob
            }), function(response) {
                
            
                if (response) {
                    if (response) {
                        
                        MI.Phone.Functions.Close(); 
                    }
                }
               
            });
        } else {
            if (Date.now() - lastRequestTime < cooldownTime) {
                var timeLeft = cooldownTime - (Date.now() - lastRequestTime);
                var minutes = Math.floor(timeLeft / 60000); 
                var seconds = Math.ceil((timeLeft % 60000) / 1000); 
                MI.Phone.Notifications.Add(
                    "fas fa-phone", 
                    "Phone", 
                    "Lotfan ( <span style='color:red; font-size:15px; font-weight:bold;'>" + minutes + " : " + seconds + "</span> ) Saniye Sabr Konid"
                );
                
                return;
            } else {
                lastRequestTime = Date.now();
                if (policeData.typejob === "police" || policeData.typejob === "sheriff" || policeData.typejob === "ambulance") {



                    if (policeData.typejob === "police") {
                        var Number = "Police Deparment";
                        var message = "Man Be Police Niyaz Daram";
                    } else if (policeData.typejob === "sheriff") {
                        var Number = "Sheriff Deparment";
                        var message = "Man Be Sheriff Niyaz Daram";
                    } else if (policeData.typejob === "ambulance") {
                        var Number = "Ambulance Deparment";
                        var message = "Man Be Medic Niyaz Daram";
                    }

                    $.post('http://Unique_Phone/SendMessageToJobs', JSON.stringify({
                        ChatNumber: Number,
                        ChatDate: GetCurrentDateKey(),
                        ChatMessage: message,
                        ChatTime: FormatMessageTime(),
                        ChatType: "message",
                    }));
            
                    $.post('http://Unique_Phone/SendMessageToJobs', JSON.stringify({
                        ChatNumber: Number,
                        ChatDate: GetCurrentDateKey(),
                        ChatMessage: "Shared Location",
                        ChatTime: FormatMessageTime(),
                        ChatType: "location",
                    
                    }));

                    if (policeData.typejob === "police") {
                        MI.Phone.Notifications.Add("fas fa-user", "Request Sended (Police) Wait 15m", " ", "#93BFCF", 7000);
                    } else if (policeData.typejob === "sheriff") {
                        MI.Phone.Notifications.Add("fas fa-user", "Request Sended (Sheriff) Wait 15m", " ", "#93BFCF", 7000);
                    } else if (policeData.typejob === "ambulance") {
                        MI.Phone.Notifications.Add("fas fa-user", "Request Sended (Medic) Wait 15m", " ", "#93BFCF", 7000);
                    }
                

                } 
            }
        }
    }
});




