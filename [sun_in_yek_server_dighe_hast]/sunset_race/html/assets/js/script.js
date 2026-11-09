let ResourceName = 'sunset_race';
let weapons = [
    'monster.png',
	'vigilante.png',
	'oppressor.png'
];

let maps = {
	"0": "0.jpg",
	"keshti": "keshti.jpg",
	"air":"air.jpg",
}


var lobbyID, TeamID, mapping,typem, SWeapon, lobbyname, roundNum, timer, head, armor;
var page = 0;

// Create Lobby Functions
function onCreateLobby() {
    $('.question').css('display', 'none');
    $('div[name="createlobby"]').css('display', 'block');
};
function onChangeMap() {
    var newSelect = $('#map').val();
    
    $('.map-img').attr('src', './assets/imgs/' + maps[newSelect])
};
function LeftWeaponButton() {
    var nowSelect = $('.weapon-select img').attr('src').split('/');
    if (weapons.indexOf(nowSelect[3]) > 0) {
        $('.weapon-select img').attr('src', './assets/vehicles/' + weapons[weapons.indexOf(nowSelect[3]) - 1]);
        $('.weapon-name').attr('id', weapons[weapons.indexOf(nowSelect[3]) - 1].split('.')[0]);
        $('.weapon-name').html(weapons[weapons.indexOf(nowSelect[3]) - 1].split('.')[0].replace('_', ' '));
    } else {
        $('.weapon-select img').attr('src', './assets/vehicles/' + weapons[weapons.length - 1]);
        $('.weapon-name').attr('id', weapons[weapons.length - 1].split('.')[0]);
        $('.weapon-name').html(weapons[weapons.length - 1].split('.')[0].replace('_', ' '));
    };
};
function RightWeaponButton() {
    var nowSelect = $('.weapon-select img').attr('src').split('/');
    if (weapons.indexOf(nowSelect[3]) == weapons.length - 1) {
        $('.weapon-select img').attr('src', './assets/vehicles/' + weapons[0]);
        $('.weapon-name').attr('id', weapons[0].split('.')[0]);
        $('.weapon-name').html(weapons[0].split('.')[0].replace('_', ' '));
    } else {
        $('.weapon-select img').attr('src', './assets/vehicles/' + weapons[weapons.indexOf(nowSelect[3]) + 1]);
        $('.weapon-name').attr('id', weapons[weapons.indexOf(nowSelect[3]) + 1].split('.')[0]);
        $('.weapon-name').html(weapons[weapons.indexOf(nowSelect[3]) + 1].split('.')[0].replace('_', ' '));
    };
};
function onSubmit() {

    lobbyname = $('#lname');
    lobbypass = $('#lbpass');
    roundNum = $('#round');
	fee = $('#fee').find(":selected").val();

    //StartCheckSubmit
    var submit = true;
    if (lobbyname.length == 0 || lobbyname.val().length < lobbyname.attr('minlength')) {
        $('#lname').css('border-color', 'red');
        submit = false;
    }
    if (roundNum.val() <= 0 || parseInt(roundNum.val()) > parseInt(roundNum.attr('max'))) {
        roundNum.val(roundNum.attr('max'));
        $('#round').css('border-color', 'red');
        submit = false;
    }
	if(typem == "0" || mapping == "0"){
		submit = false;
		onBack();
		onBack();
	}
    //EndCheckSubmit

    if (submit) {
        fetch(`https://${ResourceName}/CreateLobby`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                mapName: mapping,
                vehicleModel: SWeapon,
                lobbyName: lobbyname.val(),
                roundNum: roundNum.val(),
                Password: lobbypass.val(),
                type:typem,
				fee:fee
            })
        }).then(resp => resp.json()).then(lobid => {
            lobbyID = lobid
        });
        page = 100;
        TeamID = 0;
        $('div[name="createlobby"]').css('display', 'none');
        $('#startButton').css('display', 'block');
        $('div[name="main"]').css('display', 'block');
		
		CheckType(typem);
    }

};

function FilterTypematch(){
	 var type = $('#typem').val();
	 typem = type;
	 if(type == "0")
	 {
		 $('#map-section').hide();
	 }
	 else
	 {
		 $('#map-section').show();
	 }
	 
	 $("#map option").each(function() {
		$( this ).hide();
	 });
	 
	 $("." + type).each(function() {
		$( this ).show();
		
	 });
	 $("#map").val($("#map option:first").val());
	 onChangeMap();
	 
}

// Join In Lobby Functions
function onJoinLobby() {
    $('.question').css('display', 'none');
    $('.list').css('display', 'block');
    fetch(`https://${ResourceName}/LobbyList`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(data => {
        var jdata = JSON.parse(data);
        if (jdata.length != 0) {
            for (var i = 0; i < jdata.length; i++) {
                if (jdata[i].pass == null || jdata[i].pass == "") {
                    $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-' + jdata[i].LobbyId + '" onclick="onSelectLobby(this.id)">' + jdata[i].name + ' | ' + jdata[i].map + '</h1>');
                } else {
                    $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-' + jdata[i].LobbyId + '-locked" onclick="onSelectLobby(this.id)">' + jdata[i].name + ' | ' + jdata[i].map + ' | Locked</h1>');
                };
            };
        } else {
            $('.boxlobbeys').append('<h1 class="lobbeys"> Not Found Any Lobby ! </h1>');
        };
    });
};
function onSelectLobby(id) {
    var lid = id.split('-');
    lobbyID = lid[1];
    if (lid[2] == 'locked') {
        $('.lobby-password').css('display', 'block');
        $('.lobbeys').css('display', 'none');
        page = 85;
    } else {
        page = 0;
        TeamID = 0;
        $('.list').css('display', 'none');
        $('#startButton').css('display', 'none');
        $('div[name="main"]').css('display', 'block');
        fetch(`https://${ResourceName}/JoinLobby`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                LobbyId: lobbyID
            })
        }).then(resp => resp.json()).then(data => {
            var jdata = JSON.parse(data);
			CheckType(jdata.type);
			
            for (var i = 0; i < 3; i++) {
                var team = jdata[i];
                for (var i2 = 0; i2 < team.length; i2++) {
                    if (i == 0) {
                        $('.joiners').append(team[i2].value);
                    } else if (i == 1) {
                        $('.teamone').append(team[i2].value);
                    } else {
                        $('.teamtwo').append(team[i2].value);
                    };
                };
            };
        });
    };
};
function onJoin(id) {
    var tid = id.split('-')[1];
    fetch(`https://${ResourceName}/SwitchTeam`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            LastTeam: TeamID,
            JoinTeam: tid
        })
    }).then(resp => resp.json()).then(data => {
        if (data) {
            if (TeamID != 0) {
                $('#TM-' + TeamID).css('display', 'block');
            };
            $('#' + id).css('display', 'none');
            page = 100;
            TeamID = tid;
        };
    })
};


function CheckType(type){
	if(type == "sdm"){
		$("#boxt2").hide();
	}else{
		$("#boxt2").show();
	}
}


// In Lobby Functions
function onStart() {
    page = 0;
    fetch(`https://${ResourceName}/StartMatch`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID
        })
    }).then(resp => resp.json());
};
function onReady() {
    $('#ReadyButton').css('display', 'none');
    $('#UnReadyButton').css('display', 'block');
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: true
        })
    }).then(resp => resp.json());
};
function onUnready() {
    $('#UnReadyButton').css('display', 'none');
    $('#ReadyButton').css('display', 'block');
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: false
        })
    }).then(resp => resp.json());
};
function onLeave() {
    page = 0;
    $('.lobby').css('display', 'none');
    fetch(`https://${ResourceName}/QuitLobby`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID
        })
    }).then(resp => resp.json());
    TeamID = 0;
    lobbyID = 0;
    location.reload();
};

// Other Functions
function onNext() {
    if (page == 0) {
        $('#cancelButton').css('display', 'none');
        $('#backButton').css('display', 'block');
        $('.selectmap').css('display', 'none');
        $('.weapon-select').css('display', 'block');
        mapping = $('#map').val();
        page = page + 1;
    } else {
        $('#nextButton').css('display', 'none');
        $('#submitButton').css('display', 'block');
        $('.weapon-select').css('display', 'none');
        $('.setting').css('display', 'block');
        SWeapon = $('.weapon-name').attr('id');
        page = page + 1;
    };
};
function onBack() {
    if (page == 2) {
        $('#nextButton').css('display', 'block');
        $('#submitButton').css('display', 'none');
        $('.weapon-select').css('display', 'block');
        $('.setting').css('display', 'none');
        page = page - 1;
    } else {
        $('#cancelButton').css('display', 'block');
        $('#backButton').css('display', 'none');
        $('.selectmap').css('display', 'block');
        $('.weapon-select').css('display', 'none');
        page = page - 1;
    };
};
function onCancel() {
    page = 0;
    $('.lobby').css('display', 'none');
    fetch(`https://${ResourceName}/QuitFromMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json());
    location.reload()
};
function onBackQuestion() {
    if (page != 85) {
        $('.question').css('display', 'block');
        $('.list').css('display', 'none');
        $('.boxlobbeys').find('h1').remove();
    } else {
        page = 0
        $('.lobby-password').css('display', 'none');
        $('.lobbeys').css('display', 'block');
    };
};

//For Source And Timer


function startMatch() {
    _stopTimer = false;
    $('#who_won').hide();
    var fiveMinutes = 60 * 3,
        display = $('#time_counter');
    startTimer(fiveMinutes, display);
    Speak("The match has started!");
}

// Keyup Event
document.onkeyup = function (data) {
    if (data.which == 27) { // ESC Press
        if (page == 0) {
            fetch(`https://${ResourceName}/QuitFromMenu`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            }).then(resp => resp.json());
            location.reload();
        };
    } else if (data.which == 13) {
        if (page == 85) {
            var pass = $('#lpass').val();
            if (pass != null || pass != "") {
                fetch(`https://${ResourceName}/GetLobbyPassword`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({
                        LobbyId: lobbyID
                    })
                }).then(resp => resp.json()).then(data => {
                    if (data == pass) {
                        page = 0;
                        TeamID = 0;
                        $('.list').css('display', 'none');
                        $('#startButton').css('display', 'none');
                        $('div[name="main"]').css('display', 'block');
                        fetch(`https://${ResourceName}/JoinLobby`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: JSON.stringify({
                                LobbyId: lobbyID
                            })
                        }).then(resp => resp.json()).then(data => {
                            var jdata = JSON.parse(data);
							CheckType(jdata.type);
                            for (var i = 0; i < 3; i++) {
                                var team = jdata[i];
                                for (var i2 = 0; i2 < team.length; i2++) {
                                    if (i == 0) {
                                        $('.joiners').append(team[i2].value);
                                    } else if (i == 1) {
                                        $('.teamone').append(team[i2].value);
                                    } else {
                                        $('.teamtwo').append(team[i2].value);
                                    };
                                };
                            };
                        });
                    } else {
                        $('#lpass').css('border-color', 'red');
                    };
                });
            };
        };
    };
};

function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    var _interVal = setInterval(function () {


        if (--timer >= 0) {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);

            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            display.text(minutes + ":" + seconds);
        }
    }, 1000);
}

// NUI Sended Event
window.addEventListener("message", function (event) {
    if (event.data.type == 'show') {
        if (event.data.show) {
            $('.lobby').css('display', 'block');
			if(event.data.create != true){
				$('#btn_Create').attr("disabled", true);
			}
        } else {
            //$('.lobby').css('display', 'none');
            this.location.reload();
        };
    } else if (event.data.type == 'start') {
        $('#headerss').show();
        $('#round_counter').text(`Best Of ${event.data.round}`); //new edit
        startTimer(event.data.time, $('#time_counter'));
    } else if (event.data.type == 'stop') {
        $('#headerss').hide();
    } else if (event.data.type == "update") {
        $('.team1_score').text(event.data.t1);
        $('.team2_score').text(event.data.t2);
    } else if (event.data.type == "updatealive1") {
        $('.white').text(`(${event.data.t1}) Team 1`);//alive team 1
    } else if (event.data.type == "updatealive2") {
        $('.orange').text(`(${event.data.t2}) Team 2`);//alive team 2
    } else if (event.data.type == "time") {
        startTimer(event.data.time, $('#time_counter'));
    }


    if (event.data.action == 'JoinTeam') {
        if (event.data.team == 0) {
            $('.joiners').append(event.data.value);
        } else if (event.data.team == 1) {
            $('.teamone').append(event.data.value);
        } else {
            $('.teamtwo').append(event.data.value);
        };
    } else if (event.data.action == 'LeftTeam') {
        $('#' + event.data.player).remove();
    };


});