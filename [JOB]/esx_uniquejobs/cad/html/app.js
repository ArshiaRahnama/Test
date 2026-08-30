//Config !

const backgrounds = {
    ['Menu'] : 'https://idtop.ir/files/images/TblGalleryImage/2d1128da-48f3-414a-8d8d-ccb88bc657ac-upload-8.PNGipad.PNGx.PNG',
    ['Setting'] : '#f7f7f7',
    ['Contacts'] : '#f7f7f7',
    ['Call'] : '#f7f7f7',
    ['FaceTime'] : '#f7f7f7',
    ['Tweeter'] : '#243f4b',
    ['Message'] : '#f7f7f7',
}

let DuckMdt = {}
let currenttab = 'MainPanel';
let inswitchpage = false
let steam =  null
let plate = null

DuckMdt.Loading = function(firstpage, nextpage, time) {
    $("#" + firstpage).fadeOut()
    $("#LoadingPage").fadeIn()
    setTimeout(function(){
        $("#LoadingPage").fadeOut()
        $("#" + nextpage).fadeIn()
    }, time)
}

DuckMdt.Login = function() {
    $.post('https://esx_uniquejobs/Login', JSON.stringify({}));  
    DuckMdt.Loading('LoginPage', 'MainPage', 1000)
}

DuckMdt.PageSwitch = function(FirstPage, NextPage, Time) {
    // console.log('#Page_Button_' + NextPage)
    $('#Page_Button_' + FirstPage).removeClass('MainPageTabActiveButton')
    $('#Page_Button_' + NextPage).addClass('MainPageTabActiveButton')

    if (NextPage === 'TenCodes') {
        $.post('https://esx_uniquejobs/LoadTenCodes', JSON.stringify({}));
    } else if (NextPage === 'LoginPage') {
        $("#MainPage").fadeOut()
        $("#LoginPage").fadeIn()
    }

    if (currenttab === 'CitizensDetailInfo') {
        $('#Page_Button_CitizensList').removeClass('MainPageTabActiveButton')
    } else if (currenttab === 'CarDetailInfo') {
        $('#Page_Button_VehiclesList').removeClass('MainPageTabActiveButton')
    }

    $("#Page_" + FirstPage).fadeOut()
    setTimeout(function(){
        $("#Page_" + NextPage).fadeIn()
    }, Time)
}

DuckMdt.TabSelected = function(NewTab) {
    if (!inswitchpage) {
        if (NewTab === 'MainPanel') {
            $.post('https://esx_uniquejobs/Login', JSON.stringify({}));  
        } else if (NewTab === 'CS_Cases') {
            $.post('https://esx_uniquejobs/CS_GetCases', JSON.stringify({}));
        } else if (NewTab === 'CS_Wanted') {
            $.post('https://esx_uniquejobs/CS_GetWanted', JSON.stringify({}));
        } else if (NewTab === 'CS_Bolo') {
            $('#CS_BoloResult').text('');
            $.post('https://esx_uniquejobs/CS_GetBolos', JSON.stringify({}));
        } else if (NewTab === 'CS_Records') {
            $.post('https://esx_uniquejobs/CS_GetRecords', JSON.stringify({}));
        } else if (NewTab === 'CS_Leaderboard') {
            $.post('https://esx_uniquejobs/CS_GetLeaderboard', JSON.stringify({}));
        } else if (NewTab === 'CS_ColdCases') {
            $.post('https://esx_uniquejobs/CS_GetColdCases', JSON.stringify({}));
        } else if (NewTab === 'CS_IA') {
            $('#CS_IAReviewerSection').css('display', CS_IAReviewerJobs.indexOf(CS_playerJob) !== -1 ? 'block' : 'none')
            if (CS_IAReviewerJobs.indexOf(CS_playerJob) !== -1) {
                $.post('https://esx_uniquejobs/CS_GetOfficerActivity', JSON.stringify({}));
                $.post('https://esx_uniquejobs/CS_GetIAReports', JSON.stringify({}));
            }
        }
        DuckMdt.PageSwitch(currenttab, NewTab, 500)
        currenttab = NewTab
        inswitchpage = true
        setTimeout(function() {
            inswitchpage = false
        }, 500)
    }
}



DuckMdt.BackToCitzenList = function() {
    DuckMdt.Loading('MainPage', 'MainPage', 800)
    setTimeout(() => {
        $('#Page_CitizensList').show()
        $('#Page_CitizensDetailInfo').hide()
        currenttab = 'CitizensList'
    }, 500);
}

DuckMdt.BackToCarList = function() {
    DuckMdt.Loading('MainPage', 'MainPage', 800)
    setTimeout(() => {
        $('#Page_VehiclesList').show()
        $('#Page_CarDetailInfo').hide()
        currenttab = 'VehiclesList'
    }, 500);
}



function Open_Citizen_Profile(steam) {
    // // console.log(typeof steam)
    $.post('https://esx_uniquejobs/CitizenProfile', JSON.stringify({Steam: steam}));
}   

function Open_Car_Profile(plate) {
    $.post('https://esx_uniquejobs/CarProfile', JSON.stringify({Plate: plate}));
}

function DataButton() {
    $('#myModal').show()
}

function CloseDataModal() {
    $('#NewDataReason').text('')
    $('#myModal').hide()
}

function SaveNewData(steam) {
    let reason = $('#NewDataReason').val()
    // console.log(reason)
    if (reason != '') {
        $.post('https://esx_uniquejobs/SaveNewData', JSON.stringify({Reason: reason, steam: steam}));
        CloseDataModal()
    } else {
        $('#NewDataReason').addClass('Input-error')
    }
}

function DeleteData(id, steam) {
    if (id) {
        $.post('https://esx_uniquejobs/DeleteData', JSON.stringify({id: id, steam: steam}));
    }
}


function CloseCProfileModal() {
    $('#NewCPorfileUrl').text('')
    $('#NewCPorfileUrlModal').hide()
}


function SetProfileCitizen() {
    $('#NewCPorfileUrlModal').show()
}

function SetNewProfilePic(steam) {
    let picurl = $("#NewCPorfileUrl").val()
    $("#Character_Profile_Picture").attr('src', picurl && picurl !== '' ? picurl : 'img/no_photo.png')
    $.post('https://esx_uniquejobs/UpdateProfilePicCharacter', JSON.stringify({url: picurl, steam: steam}));
    CloseCProfileModal()
}



function CloseCarProfileModal() {
    $('#NewCarPorfileUrl').text('')
    $('#NewCarPorfileUrlModal').hide()
}


function Car_SetProfileCitizen() {
    $('#NewCarPorfileUrlModal').show()
}

function Car_SetNewProfilePic(plate) {
    let picurl = $("#NewCarPorfileUrl").val()
    $("#Car_Profile_Picture").attr('src', picurl && picurl !== '' ? picurl : 'img/no_photo.png')
    $.post('https://esx_uniquejobs/UpdateProfilePicCar', JSON.stringify({url: picurl, plate: plate}));
    CloseCarProfileModal()
}

function ExitTablet() {
    $.post('https://esx_uniquejobs/Exit', JSON.stringify({}));
}

// ===================== Crime Scene Investigation (crimescene/) =====================
// Bridges this NUI to crimescene/server/main.lua's callbacks/events through
// cad/client/main.lua. See CS_* RegisterNUICallback entries there.

let CS_currentCaseId = null
let CS_playerJob = null
const CS_ReferralJobs = ['judge', 'cia', 'fbi']
const CS_IAReviewerJobs = ['judge', 'cia', 'fbi']
const CS_StatusLabels = {
    open: 'Open', cold: 'Cold', closed: 'Closed',
    referred_judge: 'Referred: Judge', referred_cia: 'Referred: CIA', referred_fbi: 'Referred: FBI',
}
const CS_WarrantLabels = { requested: 'Warrant: Requested', approved: 'Warrant: Approved', denied: 'Warrant: Denied' }
const CS_TypeLabels = { hint: 'Hint', vehicle: 'Vehicle', strong_lead: 'Strong Lead' }

function CS_ApplyJobVisibility(job) {
    CS_playerJob = job
    let isDoj = ['cid', 'cia', 'marshal', 'fbi', 'judge', 'doa'].indexOf(job) !== -1
    let isLaw = ['police', 'sheriff', 'mt'].indexOf(job) !== -1
    $('.doj-tab').css('display', isDoj ? 'inline-block' : 'none')
    $('.law-tab').css('display', isLaw ? 'inline-block' : 'none')
    $('.cs-tab').css('display', (isDoj || isLaw) ? 'inline-block' : 'none')
}

function CS_OpenCase(id) {
    CS_currentCaseId = id
    $.post('https://esx_uniquejobs/CS_GetCaseDetail', JSON.stringify({ id: id }))
}

function CS_AddNote() {
    let note = $('#CS_NewNote').val()
    if (note && CS_currentCaseId) {
        $.post('https://esx_uniquejobs/CS_AddNote', JSON.stringify({ id: CS_currentCaseId, note: note }))
        $('#CS_NewNote').val('')
    }
}

function CS_ReferCase(job) {
    if (CS_currentCaseId) $.post('https://esx_uniquejobs/CS_ReferCase', JSON.stringify({ id: CS_currentCaseId, job: job }))
}

function CS_RunMatch() {
    if (CS_currentCaseId) $.post('https://esx_uniquejobs/CS_RunMatch', JSON.stringify({ id: CS_currentCaseId }))
}

function CS_IssueBOLO() {
    if (CS_currentCaseId) $.post('https://esx_uniquejobs/CS_IssueBOLO', JSON.stringify({ id: CS_currentCaseId }))
}

function CS_RequestWarrant() {
    if (CS_currentCaseId) $.post('https://esx_uniquejobs/CS_RequestWarrant', JSON.stringify({ id: CS_currentCaseId }))
}

function CS_DecideWarrant(approved) {
    if (CS_currentCaseId) $.post('https://esx_uniquejobs/CS_DecideWarrant', JSON.stringify({ id: CS_currentCaseId, approved: approved }))
}

function CS_CloseCase() {
    if (!CS_currentCaseId) return
    UniquePrompt('Verdict / outcome:', function(verdict) {
        if (verdict === null) return
        $.post('https://esx_uniquejobs/CS_CloseCase', JSON.stringify({ id: CS_currentCaseId, verdict: verdict }))
    })
}

function CS_CheckNearestVehicle() {
    $('#CS_BoloResult').text('Checking...')
    $.post('https://esx_uniquejobs/CS_CheckNearestVehicle', JSON.stringify({}))
}

function CS_SubmitBooking() {
    let suspectName = $('#CS_BookSuspect').val()
    let charges = $('#CS_BookCharges').val()
    if (!suspectName || !charges) {
        UniqueAlert('Suspect name and charges are required')
        return
    }
    $.post('https://esx_uniquejobs/CS_SubmitBooking', JSON.stringify({
        targetServerId: $('#CS_BookTarget').val() || null,
        caseId: $('#CS_BookCase').val() || null,
        suspectName: suspectName,
        charges: charges,
        fine: $('#CS_BookFine').val() || 0,
        jailMinutes: $('#CS_BookJail').val() || 0,
    }))
    $('#CS_BookTarget, #CS_BookCase, #CS_BookSuspect, #CS_BookCharges, #CS_BookFine, #CS_BookJail').val('')
}

function CS_ReopenCase(id) {
    $.post('https://esx_uniquejobs/CS_ReopenCase', JSON.stringify({ id: id }))
}

let CS_SelectedOfficer = null // { name, identifier, job }
let CS_IASearchTimer = null

function CS_SearchIAOfficer() {
    CS_SelectedOfficer = null
    let text = $('#CS_IATargetSearch').val()

    clearTimeout(CS_IASearchTimer)
    if (!text) {
        $('#CS_IAOfficerResults').hide().empty()
        return
    }

    CS_IASearchTimer = setTimeout(function() {
        $.post('https://esx_uniquejobs/SearchOfficers', JSON.stringify({ Text: text }))
    }, 250)
}

function CS_SelectIAOfficer(name, identifier, job) {
    CS_SelectedOfficer = { name: name, identifier: identifier, job: job }
    $('#CS_IATargetSearch').val(name + '  (' + job + ')')
    $('#CS_IAOfficerResults').hide().empty()
}

function CS_ArchiveCase(id) {
    $.post('https://esx_uniquejobs/CS_ArchiveCase', JSON.stringify({ id: id }))
}

function CS_SubmitIAReport() {
    let description = $('#CS_IADescription').val()
    if (!CS_SelectedOfficer || !description) {
        UniqueAlert(CS_SelectedOfficer ? 'Description is required' : 'Pick an officer from the list -- type a name and select a result')
        return
    }
    $.post('https://esx_uniquejobs/CS_FileIAReport', JSON.stringify({
        targetName: CS_SelectedOfficer.name,
        targetJob: CS_SelectedOfficer.job,
        targetIdentifier: CS_SelectedOfficer.identifier,
        category: $('#CS_IACategory').val(),
        description: description,
    }))
    $('#CS_IATargetSearch, #CS_IADescription').val('')
    CS_SelectedOfficer = null
}

function CS_CloseIAReport(id, outcome) {
    UniquePrompt((outcome === 'disciplined' ? 'Disciplinary action taken:' : 'Notes (optional):'), function(verdict) {
        if (verdict === null) return
        $.post('https://esx_uniquejobs/CS_CloseIAReport', JSON.stringify({ id: id, outcome: outcome, verdict: verdict }))
    })
}




// Themed replacements for native alert()/prompt(). The browser's own
// alert()/prompt() render as an unstyled OS-level popup on top of this
// app -- completely breaks the dark/gold theme (looked like a Windows
// error box floating over the tablet). These reuse the existing
// .modal / .modal-content classes so a message or input request looks
// like part of the app instead.
function UniqueAlert(message) {
    $('#UniqueDialogTitle').text('Notice')
    $('#UniqueDialogMessage').text(message)
    $('#UniqueDialogInputRow').hide()
    $('#UniqueDialogCancel').hide()
    $('#UniqueDialogConfirm').text('OK').off('click').on('click', function() {
        $('#UniqueDialogModal').hide()
    })
    $('#UniqueDialogModal').show()
}

function UniquePrompt(message, callback) {
    $('#UniqueDialogTitle').text('Input Required')
    $('#UniqueDialogMessage').text(message)
    $('#UniqueDialogInput').val('')
    $('#UniqueDialogInputRow').show()
    $('#UniqueDialogCancel').show().off('click').on('click', function() {
        $('#UniqueDialogModal').hide()
        callback(null)
    })
    $('#UniqueDialogConfirm').text('Submit').off('click').on('click', function() {
        let val = $('#UniqueDialogInput').val() || ''
        $('#UniqueDialogModal').hide()
        callback(val)
    })
    $('#UniqueDialogModal').show()
    $('#UniqueDialogInput').trigger('focus')
}

$(document).ready(function(){
    if ($('#UniqueDialogModal').length === 0) {
        $('body').append(
            '<div id="UniqueDialogModal" class="modal">' +
              '<div class="modal-content">' +
                '<h1 id="UniqueDialogTitle">Notice</h1>' +
                '<hr>' +
                '<p id="UniqueDialogMessage" style="color: var(--text); font-size: 13px; margin: 10px 0;"></p>' +
                '<div id="UniqueDialogInputRow" style="margin: 12px 0;">' +
                  '<input type="text" id="UniqueDialogInput" style="width: 100%; box-sizing: border-box;">' +
                '</div>' +
                '<div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 16px;">' +
                  '<button id="UniqueDialogCancel" class="DiscardButton">Cancel</button>' +
                  '<button id="UniqueDialogConfirm" class="PrimaryButton">OK</button>' +
                '</div>' +
              '</div>' +
            '</div>'
        )
    }

    $("#CitizenSearch").keyup(function(event) {
        if (event.keyCode === 13) {
            let SearchInput = $("#CitizenSearch").val()
            if (SearchInput != "") {
                $.post('https://esx_uniquejobs/SearchCitizen', JSON.stringify({Text: SearchInput}));
            }
        }
    });


    $("#VehicleSearch").keyup(function(event) {
        if (event.keyCode === 13) {
            let SearchInput = $("#VehicleSearch").val()
            if (SearchInput != "") {
                $.post('https://esx_uniquejobs/SearchCars', JSON.stringify({Text: SearchInput}));
            }
        }
    });

    $("#Character_Profile_Select_Wanted").on('change', function() {
        // console.log(this.value)
        switch (this.value) {
            case 'standard':
                $("#Character_Profile_Select_Wanted").css('color', 'white')
                $("#WantedColor_Character").css('background-color', 'white')
                $.post('https://esx_uniquejobs/UpdateCharacterStatus', JSON.stringify({NewStatus: this.value, steam: steam}));  
            break;

            case 'arrested':
            case 'wanted':
                // console.log('its working')
                $("#Character_Profile_Select_Wanted").css('color', 'rgb(201, 36, 36)')
                $("#WantedColor_Character").css('background-color', 'rgb(201, 36, 36)')
                $.post('https://esx_uniquejobs/UpdateCharacterStatus', JSON.stringify({NewStatus: this.value, steam: steam}));  
            break;

            case 'in_prison':
            case 'special':
                $("#Character_Profile_Select_Wanted").css('color', 'rgb(36, 74, 201)')
                $("#WantedColor_Character").css('background-color', 'rgb(36, 74, 201)')
                $.post('https://esx_uniquejobs/UpdateCharacterStatus', JSON.stringify({NewStatus: this.value, steam: steam}));  
            break;
        }
    })

    $("#Car_Profile_Select_Wanted").on('change', function() {
        // console.log(this.value)
        switch (this.value) {
            case 'standard':
                $("#Car_Profile_Select_Wanted").css('color', 'white')
                $("#WantedColor_Car").css('background-color', 'white')
                $.post('https://esx_uniquejobs/UpdateCarStatus', JSON.stringify({NewStatus: this.value, plate: plate}));  

            break;
            
            case 'arrested':
            case 'wanted':
                $("#Car_Profile_Select_Wanted").css('color', 'rgb(201, 36, 36)')
                $("#WantedColor_Car").css('background-color', 'rgb(201, 36, 36)')
                $.post('https://esx_uniquejobs/UpdateCarStatus', JSON.stringify({NewStatus: this.value, plate: plate}));  
            break;

            case 'in_prison':
            case 'special':
                $("#Car_Profile_Select_Wanted").css('color', 'rgb(36, 74, 201)')
                $("#WantedColor_Car").css('background-color', 'rgb(36, 74, 201)')
                $.post('https://esx_uniquejobs/UpdateCarStatus', JSON.stringify({NewStatus: this.value, plate: plate}));  
            break;
        }
    })


});



// other functons

function truncate(source, size) {
    return source.length > size ? source.slice(0, size - 1) + "…" : source;
  }





window.addEventListener('message', function(event) {
    var data = event.data;
      if (data.type === "MDT") {
        if (data.info == "Open") {
            $(".tablet").show();
        } else if (data.info == "Close") {
            $(".tablet").hide();
            DuckMdt.PageSwitch(currenttab, 'LoginPage', 100)
        }
      } else if (data.type === "LoginUpdate") {
        $('#Main_Page_PeopleWanted_List').empty()
        $('#Main_Page_CarsWanted_List').empty()
          $('#username_mdt').text(data.name)
          $('#Rank_mdt').text(data.rank)
          CS_ApplyJobVisibility(data.job)
          data.PeopleWanteds.forEach(element =>
                // $('#Main_Page_PeopleWanted_List').append('<div class="List_Row" style="border-top: 9px solid rgb(196, 0, 0);"><p>' + element['playerName'] + '</p><p>' + element['phone'] + '</p></div>')
                $('#Main_Page_PeopleWanted_List').append('<div class="List_Row" onclick="Open_Citizen_Profile(`' + element['identifier'] + '`)"><p>' + element['playerName'] + '</p><p>' + element['phone'] + '</p></div>')
            );

        data.WantedCars.forEach(element =>
            // $('#Main_Page_CarsWanted_List').append('<div class="List_Row" style="border-top: 9px solid rgb(196, 0, 0);"><p>' + element['model'] + '</p><p>' + element['plate'] + '</p></div>')
            $('#Main_Page_CarsWanted_List').append('<div class="List_Row" onclick="Open_Car_Profile(`' + element['plate'] + '`)"><p>' + element['modelname'] + '</p><p>' + element['plate'] + '</p></div>')
        );
      } else if (data.type === "SearchResult") {
        if (data.Stype === 'Citizen') {
            // console.log('s')
            let number = 1;
            DuckMdt.Loading('MainPage', 'MainPage', 1500)
                setTimeout(function(){
                    $('#Citizens_List_Search_Resualts').empty()
                    data.object.forEach(element => {
                        if (element['playerName'] != "") {
                            if (element['WantedLevel'] != 'standard') {
                                $('#Citizens_List_Search_Resualts').append('<div class="List_Row List_Row_Wanted" id="Citizen_SearchResult_List"  style="padding-right: 120px;" onclick="Open_Citizen_Profile(`' + element['identifier'] + '`)"><p>' + number++ + '</p><p>' + element['playerName'] + '</p><p>' + element['phone'] + '</p><p style="color: rgb(255, 47, 47);">Wanted</p></div>')
                            } else {
                                $('#Citizens_List_Search_Resualts').append('<div class="List_Row" id="Citizen_SearchResult_List"  style="padding-right: 265px; padding-left: 25px;" onclick="Open_Citizen_Profile(`' + element['identifier'] + '`)"><p>' + number++ + '</p><p>' + element['playerName'] + '</p><p>' + element['phone'] + '</p></div>')
                            }
                        }
                    })
                }, 500)


            } else if (data.Stype === 'Officer') {
                $('#CS_IAOfficerResults').empty()
                if (!data.object || data.object.length === 0) {
                    $('#CS_IAOfficerResults').append('<div class="List_Row" style="opacity: .6;"><p>No officers found</p></div>').show()
                    return
                }
                data.object.forEach(element => {
                    $('#CS_IAOfficerResults').append('<div class="List_Row" onclick="CS_SelectIAOfficer(`' + element['playerName'] + '`, `' + element['identifier'] + '`, `' + element['job'] + '`)"><p>' + element['playerName'] + '</p><p style="text-transform: uppercase;">' + element['job'] + '</p></div>')
                })
                $('#CS_IAOfficerResults').show()
            } else if (data.Stype === 'Car') {
                // console.log('s')
                let number = 1;
                DuckMdt.Loading('MainPage', 'MainPage', 500)
                    setTimeout(function(){
                        $('#Cars_List_Search_Resualts').empty()
                        data.object.forEach(element => {
                            if (element['plate'] != "") {
                                let status = 'Impound'
                                if (element['stored']) {
                                    status = 'Parking'
                                }
                                if (element['WantedLevel'] != 'standard') {
                                    $('#Cars_List_Search_Resualts').append('<div class="List_Row List_Row_Wanted" id="Cars_SearchResult_List"  style="padding-right: 120px;" onclick="Open_Car_Profile(`' + element['plate'] + '`)" onclick="Open_Car_Profile(`' + element['owner'] + '`)"><p>' + number++ + '</p><p>' + element['plate'] + '</p><p>' + status + '</p><p style="color: rgb(255, 47, 47);">Wanted</p></div>')
                                } else {
                                    $('#Cars_List_Search_Resualts').append('<div class="List_Row" id="Cars_SearchResult_List"  style="padding-right: 265px; padding-left: 25px;" onclick="Open_Car_Profile(`' + element['plate'] + '`)" onclick="Open_Car_Profile(`' + element['owner'] + '`)"><p>' + number++ + '</p><p>' + element['plate'] + '</p><p>' + status + '</p></div>')
                                }
                            }
                        })
                    }, 500)
            }

    } else if (data.type === "LoadCitizenProfile") {
        if (currenttab === 'MainPanel') {
            // $('#Page_MainPanel').hide()
            DuckMdt.PageSwitch('MainPanel', 'CitizensList', 500)
        }
        currenttab = 'CitizensDetailInfo'
        let user = data.object[0]
        let gender = 'female'
        if (user['sex'] != 1) {
            gender = 'male'
        }
        DuckMdt.Loading('MainPage', 'MainPage', 500)
        setTimeout(function(){
            $('#Page_CitizensList').hide()
            $('#Page_CitizensDetailInfo').show()
            $("#Character_Details_Gender").text(gender)
            $("#Character_Details_Phonenumber").text(user['phone'])
            $("#Character_Details_Bank").text(user['bank'])
            $("#Character_Profile_Select_Wanted").val(user['WantedLevel']).change();
            $('#CharacterName_P').text(user['playerName'].split('_').join(' ')) // ic name
            $("#Character_Profile_Picture").attr('src', user['Profile_Pic'] && user['Profile_Pic'] !== '' ? user['Profile_Pic'] : 'img/no_photo.png')
            $("#Character_Profile_Picture_Button").attr('onclick', 'SetProfileCitizen()')
            $("#Character_SetNewProfilePic").attr('onclick', 'SetNewProfilePic("' + user['identifier'] + '")')
            steam =  user.identifier
            $("#SaveNewData").attr('onclick', 'SaveNewData("' + user['identifier'] + '")')
            let number = 1;
            // console.log(data.cars)
            $('#Character_Profile_Cars_List').empty() // make list of vehicles empty
            data.cars.forEach(element => {
                let status = 'Impound'
                if (element['stored']) {
                    status = 'Parking'
                }
                if (element['WantedLevel'] != 'standard') {
                    $('#Character_Profile_Cars_List').append('<div class="List_Row List_Row_Wanted" id="Cars_SearchResult_List"  style="padding-right: 120px;" onclick="Open_Car_Profile(`' + element['plate'] + '`)" onclick="Open_Car_Profile(`' + element['owner'] + '`)"><p>' + number++ + '</p><p>' + element['plate'] + '</p><p>' + status + '</p><p style="color: rgb(255, 47, 47);">Wanted</p></div>')
                } else {
                    $('#Character_Profile_Cars_List').append('<div class="List_Row" id="Cars_SearchResult_List"  style="padding-right: 265px; padding-left: 25px;" onclick="Open_Car_Profile(`' + element['plate'] + '`)" onclick="Open_Car_Profile(`' + element['owner'] + '`)"><p>' + number++ + '</p><p>' + element['plate'] + '</p><p>' + status + '</p></div>')
                }
            })

            $('#Character_Profile_Records_List').empty()
            let records = data.records || []
            if (!records.length) {
                $('#Character_Profile_Records_List').append('<div class="data_Row"><p>-</p><p>No record</p><p>-</p></div>')
            }
            records.forEach(r => {
                $('#Character_Profile_Records_List').append('<div class="data_Row"><p>' + r['charges'] + '</p><p>$' + r['fine'] + ' / ' + r['jail_minutes'] + 'm</p><p>' + (r['booked_by_name'] || '?') + '</p></div>')
            })
        }, 500)

    } else if (data.type === "LoadCarProfile") {
        // console.log(currenttab)
        if (currenttab === 'MainPanel') {
            // $('#Page_MainPanel').hide()
            DuckMdt.PageSwitch('MainPanel', 'VehiclesList', 500)
        } else if (currenttab === 'CitizensDetailInfo') {
            DuckMdt.PageSwitch('CitizensDetailInfo', 'VehiclesList', 500)
        }
        currenttab = 'CarDetailInfo'
        // if (!data.object) 
        // // let user = data.object[0]
        // let gender = 'male'
        // if (user['gender'] != 0) {
        //     gender = 'female'
        // }
        DuckMdt.Loading('MainPage', 'MainPage', 500)
        let car = data.object[0]
        let owner = data.owner[0]
        setTimeout(function(){
            $('#Page_CitizensDetailInfo').hide()
            $('#Page_VehiclesList').hide()
            $('#Page_CarDetailInfo').show()
            $("#Car_Details_Owner").text(owner['playerName'])
            $("#Car_Details_Owner_Phone_Number").text(owner['phone'])
            $("#Car_Profile_Select_Wanted").val(car['WantedLevel']).change();
            $('#CarName_P').text(car['plate']) // plate as ic name
            $("#Car_Profile_Picture").attr('src', car['Profile_Pic'] && car['Profile_Pic'] !== '' ? car['Profile_Pic'] : 'img/no_photo.png')
            $("#Car_Profile_Picture_Button").attr('onclick', 'Car_SetProfileCitizen()')
            $("#Car_SetNewProfilePic").attr('onclick', 'Car_SetNewProfilePic("' + car['plate'] + '")')
            plate = car['plate']
        }, 500);
    } else if (data.type === 'LoadDataList') {
        // console.log('s')
        $('#list_data_citizen').empty()
        let number = 1;
       
        data.object.forEach(element => {
            if (element['date']) {
                let date = new Date(element['date']); // تبدیل مقدار دریافتی به تاریخ جاوااسکریپت
                let formattedDate = `${date.getFullYear()}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getDate().toString().padStart(2, '0')} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
        
                $('#list_data_citizen').append(`
                    <div style="width: 100%;">
                        <div class="data_Row" style="float: left;">
                            <p>${number++}</p>
                            <p>${element['author']}</p>
                            <p>${formattedDate}</p> <!-- نمایش تاریخ واقعی -->
                            <p>${element['reason']}</p>
                        </div>
                        <div style="float: right;">
                            <button class="Data_Delete_Button" onclick="DeleteData(${element['id']}, \`${element['steam']}\`)">✖</button>
                        </div>
                    </div>
                `);
            }
        });

    } else if (data.type === 'LoadTenCodes') {
        $('#Page_TenCodes').empty()
        data.Codes.forEach(element => {
            $('#Page_TenCodes').append('<span style="font-size: 1.5vw;">' + element + '</span><br>')
        })

    } else if (data.type === 'CS_Cases') {
        $('#CS_CasesList').empty()
        if (!data.list.length) $('#CS_CasesList').append('<p style="color: var(--text-dim);">No cases</p>')
        data.list.forEach(c => {
            $('#CS_CasesList').append('<div class="List_Row" onclick="CS_OpenCase(' + c.id + ')"><p>#' + c.id + '</p><p>' + c.rob_name + '</p><p>' + (CS_StatusLabels[c.status] || c.status) + '</p></div>')
        })

    } else if (data.type === 'CS_CaseDetail') {
        let c = data.data
        if (!c) return
        let caseRow = c.case
        $('#CS_CaseTitle_P').text('Case #' + caseRow.id + ' - ' + caseRow.rob_name)
        let statusText = CS_StatusLabels[caseRow.status] || caseRow.status
        if (caseRow.warrant_status && caseRow.warrant_status !== 'none') {
            statusText += ' | ' + (CS_WarrantLabels[caseRow.warrant_status] || caseRow.warrant_status)
        }
        $('#CS_CaseStatus_P').text(statusText)

        $('#CS_SuspectsList').empty()
        if (!c.suspects || !c.suspects.length) {
            $('#CS_SuspectsList').append('<div class="data_Row"><p>' + caseRow.suspect_name + '</p><p>primary</p></div>')
        } else {
            c.suspects.forEach(s => {
                $('#CS_SuspectsList').append('<div class="data_Row"><p>' + s.suspect_name + '</p><p>' + s.role + '</p></div>')
            })
        }

        $('#CS_EvidenceList').empty()
        if (!c.evidence.length) $('#CS_EvidenceList').append('<div class="data_Row"><p>-</p><p>No evidence yet</p><p>-</p></div>')
        c.evidence.forEach(ev => {
            $('#CS_EvidenceList').append('<div class="data_Row"><p>' + (CS_TypeLabels[ev.type] || ev.type) + '</p><p>' + ev.content + '</p><p>' + (ev.found_by_name || '?') + '</p></div>')
        })

        $('#CS_NotesList').empty()
        if (!c.notes.length) $('#CS_NotesList').append('<div class="data_Row"><p>-</p><p>No notes yet</p></div>')
        c.notes.forEach(n => {
            $('#CS_NotesList').append('<div class="data_Row"><p>' + (n.author_name || '?') + '</p><p>' + n.note + '</p></div>')
        })

        let actionsHtml = ''
        let openLike = caseRow.status === 'open' || caseRow.status === 'cold'
        if (openLike) {
            CS_ReferralJobs.forEach(job => {
                actionsHtml += '<button class="ExitButton" style="margin-right:6px;margin-bottom:6px;" onclick="CS_ReferCase(\'' + job + '\')">Refer: ' + job.toUpperCase() + '</button>'
            })
            actionsHtml += '<button class="ExitButton" style="margin-right:6px;margin-bottom:6px;" onclick="CS_RunMatch()">Run Fingerprint Match</button>'
            if (c.evidence.some(ev => ev.type === 'vehicle')) {
                actionsHtml += '<button class="ExitButton" style="margin-right:6px;margin-bottom:6px;" onclick="CS_IssueBOLO()">Issue BOLO</button>'
            }
            if (!caseRow.warrant_status || caseRow.warrant_status === 'none' || caseRow.warrant_status === 'denied') {
                actionsHtml += '<button class="ExitButton" style="margin-right:6px;margin-bottom:6px;" onclick="CS_RequestWarrant()">Request Warrant</button>'
            }
        }
        if (CS_playerJob === 'judge' && caseRow.warrant_status === 'requested') {
            actionsHtml += '<button class="ExitButton" style="margin-right:6px;margin-bottom:6px;" onclick="CS_DecideWarrant(true)">Approve Warrant</button>'
            actionsHtml += '<button class="DiscardButton" style="margin-right:6px;margin-bottom:6px;" onclick="CS_DecideWarrant(false)">Deny Warrant</button>'
        }
        if (CS_ReferralJobs.indexOf(CS_playerJob) !== -1 && caseRow.status === ('referred_' + CS_playerJob)) {
            actionsHtml += '<button class="ExitButton" onclick="CS_CloseCase()">Close Case + Verdict</button>'
        }
        $('#CS_CaseActions').html(actionsHtml)

        if (currenttab !== 'CS_CaseDetail') {
            DuckMdt.PageSwitch('CS_Cases', 'CS_CaseDetail', 300)
            currenttab = 'CS_CaseDetail'
        }

    } else if (data.type === 'CS_Wanted') {
        $('#CS_WantedList').empty()
        if (!data.list.length) $('#CS_WantedList').append('<p style="color: var(--text-dim);">No repeat codes yet</p>')
        data.list.forEach(row => {
            $('#CS_WantedList').append('<div class="List_Row List_Row_Wanted"><p>#' + row.suspect_hint_id + '</p><p>Hits: ' + row.hits + '</p><p>' + (row.last_seen || '') + '</p></div>')
        })

    } else if (data.type === 'CS_Bolos') {
        $('#CS_BoloList').empty()
        if (!data.list.length) $('#CS_BoloList').append('<p style="color: var(--text-dim);">No active BOLOs</p>')
        data.list.forEach(row => {
            $('#CS_BoloList').append('<div class="List_Row List_Row_Wanted"><p>' + row.plate + '</p><p>Case #' + row.caseId + '</p><p>' + (row.issuedBy || '') + '</p></div>')
        })

    } else if (data.type === 'CS_PlateCheckResult') {
        if (data.noVehicle) {
            $('#CS_BoloResult').css('color', 'var(--text-dim)').text('No vehicle nearby')
        } else if (data.found) {
            $('#CS_BoloResult').css('color', 'var(--danger)').text('MATCH! Plate ' + data.plate + ' is wanted (Case #' + data.caseId + ')')
        } else {
            $('#CS_BoloResult').css('color', 'var(--ok)').text('Clean - no BOLO for this plate')
        }

    } else if (data.type === 'CS_Records') {
        $('#CS_RecordsList').empty()
        if (!data.list.length) $('#CS_RecordsList').append('<p style="color: var(--text-dim);">No records yet</p>')
        data.list.forEach(row => {
            $('#CS_RecordsList').append('<div class="List_Row"><p>' + row.suspect_name + '</p><p>' + row.charges + '</p><p>$' + row.fine + ' / ' + row.jail_minutes + 'm</p></div>')
        })

    } else if (data.type === 'CS_Leaderboard') {
        $('#CS_LeaderInvestigators').empty()
        ;(data.data.investigators || []).forEach((row, i) => {
            $('#CS_LeaderInvestigators').append('<div class="List_Row"><p>#' + (i + 1) + '</p><p>' + row.name + '</p><p>' + row.score + '</p></div>')
        })
        $('#CS_LeaderOfficers').empty()
        ;(data.data.officers || []).forEach((row, i) => {
            $('#CS_LeaderOfficers').append('<div class="List_Row"><p>#' + (i + 1) + '</p><p>' + row.name + '</p><p>' + row.score + '</p></div>')
        })

    } else if (data.type === 'CS_ColdCases') {
        $('#CS_ColdCasesList').empty()
        if (!data.list.length) $('#CS_ColdCasesList').append('<p style="color: var(--text-dim); padding: 10px;">No cold cases</p>')
        data.list.forEach(c => {
            let archived = !!c.archived_at
            let actions = archived
                ? '<span style="color: var(--text-dim);">Archived</span>'
                : '<button class="ExitButton" style="margin-right:6px;" onclick="event.stopPropagation(); CS_ReopenCase(' + c.id + ')">Reopen</button>' +
                  '<button class="DiscardButton" onclick="event.stopPropagation(); CS_ArchiveCase(' + c.id + ')">Archive</button>'
            $('#CS_ColdCasesList').append(
                '<div class="List_Row" onclick="CS_OpenCase(' + c.id + ')"><p>#' + c.id + '</p><p>' + c.rob_name + '</p><p>' + actions + '</p></div>'
            )
        })

    } else if (data.type === 'CS_OfficerActivity') {
        $('#CS_OfficerActivityList').empty()
        if (!data.list.length) $('#CS_OfficerActivityList').append('<p style="color: var(--text-dim); padding: 10px;">No recent activity</p>')
        data.list.forEach(row => {
            $('#CS_OfficerActivityList').append(
                '<div class="List_Row"><p>' + (row.booked_by_name || '?') + '</p><p>Booked ' + row.suspect_name + '</p><p>' + row.charges + '</p></div>'
            )
        })

    } else if (data.type === 'CS_IAReports') {
        $('#CS_IAReportsList').empty()
        if (!data.list.length) $('#CS_IAReportsList').append('<p style="color: var(--text-dim); padding: 10px;">No reports</p>')
        data.list.forEach(r => {
            let actions = r.status === 'open'
                ? '<button class="ExitButton" style="margin-right:6px;" onclick="CS_CloseIAReport(' + r.id + ', \'cleared\')">Clear</button>' +
                  '<button class="DiscardButton" onclick="CS_CloseIAReport(' + r.id + ', \'disciplined\')">Discipline</button>'
                : '<span style="color: var(--text-dim);">' + r.status + '</span>'
            $('#CS_IAReportsList').append(
                '<div class="List_Row"><p>' + r.target_name + '</p><p>' + r.category + '</p><p>' + r.description + '</p><p>' + actions + '</p></div>'
            )
        })
    }


});









