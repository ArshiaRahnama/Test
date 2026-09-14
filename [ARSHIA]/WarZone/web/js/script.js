scriptName = 'WarZone'
$(document).ready(function() {

function OpenLobbey() {
    document.getElementById('LobbeyMenu').style.display = 'block'
}
function PlaySound( sound ) {
        var x = document.createElement("AUDIO");
        x.setAttribute("src",'sounds/'+sound+ '.mp3');
        x.setAttribute("autoplay", "autoplay");
        x.volume = 0.3;
        document.body.appendChild(x);
      }
function closeLobbey() {
    document.getElementById('LobbeyMenu').style.display = 'none'
    $.post('http://'+scriptName+'/exit', JSON.stringify({}));
}
document.getElementById("exit").addEventListener("click", closeLobbey);
function JoinLobbey() {
    PlaySound('1120')
    $.post('http://'+scriptName+'/start', JSON.stringify({}));
    document.getElementById('LobbeyMenu').style.display = 'none' 
}
document.getElementById("start").addEventListener("click", JoinLobbey);
function SetKill(kill) {
    document.getElementById("MyKill").innerHTML = kill
}
function SetSquad(Squad) {
    document.getElementById("Squads").innerHTML = Squad
}
function SetAllPlayer (Player) {
    document.getElementById("Alive").innerHTML = Player
}
function SetMyItem( armor , heal , Uav , self ) {
    document.getElementById("MyShield").innerHTML = armor
    document.getElementById("MyBandage").innerHTML = heal
    document.getElementById("MyUav").innerHTML = Uav 
    document.getElementById("MySelf").innerHTML = self
}
function KillMsg( killer , killed ) {
    document.getElementById("killer").innerHTML = killer 
    document.getElementById("killed").innerHTML = killed 
    document.getElementById('KilMassge').style.display = 'block'
    PlaySound('killefect')
}
function RemoveMsg() {
    document.getElementById('KilMassge').style.display = 'none'
    document.getElementById("killer").innerHTML = ' ... ' 
    document.getElementById("killed").innerHTML =  ' ... '  
   
}
function ShowYourSquad(Count , Name1 , Name2 , Name3 , MyName ) {
    document.getElementById('ShowPlayerOne').style.display = 'none'
    document.getElementById('ShowPlayerTwo').style.display = 'none'
    document.getElementById('ShowPlayerthree').style.display = 'none'
    document.getElementById("MyName").innerHTML = MyName
    if ( Name1 != 'none' ) {
        document.getElementById("Namep1").innerHTML = Name1
        document.getElementById('ShowPlayerOne').style.display = 'block'
    }
    if ( Name2 != 'none' ) {
        document.getElementById("Namep2").innerHTML = Name2
        document.getElementById('ShowPlayerTwo').style.display = 'block'
    }
    if ( Name3 != 'none' ) {
        document.getElementById("Namep3").innerHTML = Name3
        document.getElementById('ShowPlayerthree').style.display = 'block'
    }
}
function UpdateCash (MyCash , P1Cash , P2Cash , P3Cash) {
    document.getElementById("Cash").innerHTML   = ' - ' + MyCash + ' $'
 
}
function UpdateStatus (MyHealth ,MyArmor , Healp1 , Armorp1  , Healp2 , Armorp2 ,  Healp3 , Armorp3  ) {
    document.getElementById('myheal').style.width  = MyHealth - 100 + '%'
    document.getElementById('myarmor').style.width  =  MyArmor + '%'
    
    document.getElementById('healp1').style.width  = Healp1 - 100 + '%'
    document.getElementById('armorp1').style.width  =  Armorp1 + '%'

    document.getElementById('healp2').style.width  = Healp2 - 100 + '%'
    document.getElementById('armorp2').style.width  =  Armorp2 + '%'


    document.getElementById('healp3').style.width  = Healp3 - 100 + '%'
    document.getElementById('armorp3').style.width  =  Armorp3+ '%'

}
function OpenInGame() {

    document.getElementById('InGame').style.display = 'block'
}
function CloseInGame() {

    document.getElementById('InGame').style.display = 'none'
    HideSpectating()
}
function OpenAdminPanel(lobbyOpen, matchStarted) {
    document.getElementById('AdminPanel').style.display = 'block'
    if (matchStarted) {
        document.getElementById('AdminPanelOpenLobby').style.display = 'none'
        document.getElementById('AdminPanelStartForm').style.display = 'none'
        document.getElementById('AdminPanelStatus').innerHTML = 'A match is already running.'
    } else if (lobbyOpen) {
        document.getElementById('AdminPanelOpenLobby').style.display = 'none'
        document.getElementById('AdminPanelStartForm').style.display = 'block'
        document.getElementById('AdminPanelStatus').innerHTML = 'Lobby is open — set up the match:'
    } else {
        document.getElementById('AdminPanelOpenLobby').style.display = 'block'
        document.getElementById('AdminPanelStartForm').style.display = 'none'
        document.getElementById('AdminPanelStatus').innerHTML = 'Lobby is closed.'
    }
}
function CloseAdminPanel() {
    document.getElementById('AdminPanel').style.display = 'none'
    $.post('http://'+scriptName+'/adminPanelClose', JSON.stringify({}));
}
function ShowSpectating(name) {
    document.getElementById('SpectatorBar').style.display = 'block'
    document.getElementById('SpectatorName').innerHTML = name
}
function HideSpectating() {
    document.getElementById('SpectatorBar').style.display = 'none'
}
document.getElementById('adminOpenLobbyBtn').addEventListener('click', function () {
    $.post('http://'+scriptName+'/adminOpenLobby', JSON.stringify({}));
})
document.getElementById('adminStartBtn').addEventListener('click', function () {
    var payload = {
        blood: document.getElementById('apBlood').value,
        time: document.getElementById('apTime').value,
        map: document.getElementById('apMap').value,
        team: document.getElementById('apTeam').value,
    }
    $.post('http://'+scriptName+'/adminStart', JSON.stringify(payload));
    document.getElementById('AdminPanel').style.display = 'none'
})
document.getElementById('adminPanelCloseBtn').addEventListener('click', CloseAdminPanel);
window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.message == 'close' ) {
        closeLobbey()
    }
    else if (item.message == 'open' ) {
        OpenLobbey()
    }
    else if (item.message == 'Ingame' ) {
        OpenInGame()
    }
    else if  (item.message == 'closeIngame' ) {
        CloseInGame()
    }
    else if (item.message == 'kill' ) {
        SetKill(item.MyKill) 
    }
    else if (item.message == 'Members' ) {
        SetSquad( item.Squad) ;
        SetAllPlayer( item.Players) ; 
    }
    else if (item.message == 'item' ) {
        SetMyItem ( item.Armor , item.Heal , item.Uav ,item.Self  )
    }
    else if (item.message == 'showsquad') {
        ShowYourSquad(item.count ,item.NameOne , item.NameTwo , item.NameThree , item.MyName )
    }
    else if (item.message == 'cash') {
        UpdateCash ( item.MyCash )
    }
    else if ( item.message == 'UpdateStatus') {
        UpdateStatus(item.MyHealth , item.MyArmor , item.p1heal , item.p1armor , item.p2heal , item.p2armor , item.p3heal , item.p3armor)
    }
    else if (item.message == 'kilmsg') {
        KillMsg(item.Killer , item.killed )
    }
    else if (item.message == 'delmsg') {
        RemoveMsg() 
    }
    else if ( item.message == 'music' ) {
        PlaySound( item.Name )
    }
    else if ( item.message == 'TeamWon' ) {
        document.getElementById("p1").innerHTML = item.PlayerOne 
        document.getElementById("p2").innerHTML = item.PlayerTwo  
        document.getElementById("p3").innerHTML = item.PlayerThree
        document.getElementById("p4").innerHTML = item.PlayerFour
        document.getElementById('Winner').style.display = 'block'
    }
    else if ( item.message == 'RTeamWon' ) {
        document.getElementById('Winner').style.display = 'none'
        document.getElementById("p1").innerHTML = ''
        document.getElementById("p2").innerHTML = '' 
        document.getElementById("p3").innerHTML = ''
        document.getElementById("p4").innerHTML = ''
  }
    else if ( item.message == 'openAdminPanel' ) {
        OpenAdminPanel(item.lobbyOpen, item.matchStarted)
    }
    else if ( item.message == 'spectating' ) {
        ShowSpectating(item.Name)
    }
  })
})