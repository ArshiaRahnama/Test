var reportList = []
var currentState = "closed"
var resourceName = GetParentResourceName()

window.addEventListener('message', function(event) {

    switch (event.data.action) {
        case 'startReportForm':
            currentState = "reportForm";
			$("#reportForm").show();
            break
        case 'openReportList':
            $(".reportSelected").hide();
            currentState = "reportList";
			$("#reportContainer").fadeIn("fast");
            $(".reportList").show();
            break
        case 'updateReportList':
            reportList = event.data.reportList
			reloadReportList()
            break
		case 'notification':
			showNewReportNotification()
            break
    }
});

$(document).on('click', ".closebutton", function() { 
    currentState = "closed"
    $("#reportContainer").fadeOut("fast");
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "close",
    }));
});

$(document).on('click', ".reportSelected .screenshot-handler", function() {
    currentState = "fullscreen"
	$("#fullsize").attr("src", currentReport.screenshotLink || "test.png");
    $("#fullsize-screenshot").fadeIn();
});

$(document).on('click', "#fullsize-screenshot .closeicon", function() { 
    $("#fullsize-screenshot").fadeOut();
});

/* reportList[0] = {
       id : 1,
       playername : "jonny_sins",
       playerid: 10,
       title : "Found bug",
       description : "I found a bug here in the police hq",
       solved: false,
       screenshotLink: "test.png",
   }

   reportList[1] = {
       id : 1,
       playername : "Matif",
       title : "Anti RP",
       description : "Player id 87 killed me with no motive",
       solved: false,
       screenshotLink: "test.png",
   }*/

$(document).on('click', "#load", function() { 
    reloadReportList()
});

function reloadReportList() {
    var wrapper = $(".reportList").find(".reports-wrapper");
    wrapper.empty();
    $.each(reportList, function(index, value) {
        // پاکسازی داده‌ها قبل از درج در HTML
        let safeName = DOMPurify.sanitize(value.owner.name);
        let safeMessage = DOMPurify.sanitize(value.message);

        wrapper.append(`<div class="item" data-reportId="${index}">
            <div class="firstcolumn column"><div class="player-id"><b></b> ${index + ' - ' + safeName}</div></div>
            <div class="secondcolumn column"><div class="report-title">${safeMessage}</div></div>
            <div class="forthcolumn column"> <div class="screenshot">Screenshot</div></div> 
            <div class="forthcolumn column"> <div class="morebutton">MORE INFO</div></div>               
        </div>`);
    });
}


$(document).on('click', ".item .morebutton", function() { 
    var id = $(this).parent().parent().attr("data-reportId");
    openReportPage(id);
    currentState = "reportDetails";
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "morebutton",
    }));
});

$(document).on('click', ".item .screenshot", function() { 
    var id = $(this).parent().parent().attr("data-reportId");
    currentState = "fullscreen"
	$("#fullsize").attr("src", reportList[id].screenshotLink || "test.png");
    $("#fullsize-screenshot").fadeIn();
});

$(document).on('click', ".reportSelected .backicon", function() { 
    $(".reportSelected").hide();
    $(".reportList").show();
    currentState = "reportList";
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "morebuttonback",
    }));
});

var currentReportId, currentReport

function openReportPage(id) {
    currentReportId = id;
    $(".reportList").hide();
    var thisPage = $(".reportSelected");
    var data = reportList[id];
    currentReport = data;

    let safeName = DOMPurify.sanitize(data.owner.name);
    let safeMessage = DOMPurify.sanitize(data.message);

    thisPage.show();
    thisPage.find(".playerId").text(`Report Id: ${id} ${safeName}`);
    var datawrapper = thisPage.find(".data-wrapper");
    datawrapper.find(".title").html(`<b>Title:</b> ${safeMessage}`);
    datawrapper.find(".description").html(`<b>Description:</b> ${safeMessage}`);
    datawrapper.find(".screenshot-handler").children().attr("src", data.screenshotLink || "test.png");
}

$(document).on('click', ".closereport", function() { 
    $("#reportContainer").fadeOut("fast");
    console.log(currentReport.id);
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "closeReport",
        id: currentReport.id
    }));
});

$(document).on('click', ".gospectate", function() { 
    $("#reportContainer").fadeOut("fast");
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "spectate",
        id: currentReport.id
    }));
    currentState = "closed"
});

$(document).on('click', ".teleport", function() { 
    $("#reportContainer").fadeOut("fast");
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "teleport",
        id: currentReport.id
    }));
    currentState = "closed"
});


$(document).on('click', ".check", function() { 
    //$("#reportContainer").fadeOut("fast");
	SolvedReport(currentReport.id,false)
	$(".reportSelected").hide();
	$(".reportList").show();
	currentState = "reportList"
    //currentState = "closed"
});

function SolvedReport(id,can) {
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "solvedreport",
        id: id,
		can: can
    }));
}

$(document).on('click', "#cancelButton", function() { 
    $("#reportForm").fadeOut("fast");
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "close",
    }));
	cleanReportForm();
    currentState = "closed"
});

$(document).on('click', "#submitButton", function() { 
    var title = DOMPurify.sanitize($("#inputReportTitle").val());
    var description = DOMPurify.sanitize($("#inputReportDescription").val());
    $("#reportForm").fadeOut("fast");
    $.post('https://sunset_admin/action', JSON.stringify({
        action: "createNewReport",
        title: title,
        description: description,
    }));
    cleanReportForm();
    currentState = "closed";
});


function cleanReportForm() {
    $("#inputReportTitle").val("");
    $("#inputReportDescription").val("");
}

$(document).ready(function(){
    document.onkeyup = function (data) {
        if (data.which == 27) {
            if ($("#fullsize-screenshot").is(':visible')){
                $("#fullsize-screenshot").fadeOut();
                currentState = "reportDetails";
                return;
            }
            switch (currentState) {
                case 'reportDetails' :
                    $(".reportSelected").fadeOut("fast");
                    $(".reportList").show();
                    currentState = "reportList"
                break
                case 'reportList' : 
                    $("#reportContainer").fadeOut("fast");
                    currentState = "closed"
                    $.post('https://sunset_admin/action', JSON.stringify({
                        action: "close",
                    }));
                    break
                case 'reportForm' :
                    cleanReportForm();
                    $("#reportForm").fadeOut("fast");
                    currentState = "closed"
                    $.post('https://sunset_admin/action', JSON.stringify({
                    action: "close",
                    }));
                    break
            }
            
        }
    };
});

const sound = new Howl({
	src: ['sound.mp3'],
	volume: 0.5,
});

function showNewReportNotification() {
	sound.play();
    $("#reportNotification").fadeIn(400);
    setTimeout(function () {
        $("#reportNotification").fadeOut(400);
    }, 2000)
}

