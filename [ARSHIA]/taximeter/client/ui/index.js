const resource = GetParentResourceName();
var formatMoney = "es-ES"

async function fetchNui(eventName, data) {
  const resp = await fetch(`https://${resource}/${eventName}`, {
    method: 'post',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify(data),
  });

  return await resp.json();
}

function updatePrice(price){
    let totalPrice = new Intl.NumberFormat(formatMoney, { maximumFractionDigits: 1, minimumFractionDigits: 1 }).format(parseFloat(price))
    $("#price").text(totalPrice)
}

function translate(lang){
    $("#free").text(lang.free);
    $("#occupied").text(lang.occupied);
    $("#stopped").text(lang.stopped);
    $("#rateLabel").text(lang.rate);
    $("#currency").text(lang.currency);
    $("#distance").text(lang.distance);
}
function reloadConfig(){
    fetchNui("initialConfig", [])
}

$(function() {

    window.addEventListener("message", function(ev) {
        switch (ev.data.type) {
            case "menuOpacityActive":
                $("#meter").addClass("menuOpen")
            break;
            case "menuOpacityDisabled":
                $("#meter").removeClass("menuOpen")
            break;
            case "initialData":
                let lang = ev.data.lang;
                translate(lang);
                formatMoney = ev.data.formatMoney;
            break;
            case 'update_total':
                updatePrice(ev.data.price)
            break;
            case 'select_rate':
                $(".status").removeClass("active");
                if(ev.data.rate == 0){
                    $("#rate").text("");
                    $("#free").addClass("active");
                }else{
                    $("#rate").text(ev.data.rate);
                    $("#occupied").addClass("active");
                }
            break;
            case 'pause':
                $(".status").removeClass("active");
                $("#stopped").addClass("active");
                $("#price").addClass("pause")
            break;
            case 'play':
                $(".status").removeClass("active");
                $("#occupied").addClass("active");
                $("#price").removeClass("pause");
            break;
            case 'reset':
                $(".status").removeClass("active");
                $("#rate").text("");
                $("#free").addClass("active");
                $("#price").text("");
            break;
            case 'open':
                $("#meter").show();
            break;
            case 'close':
                $("#meter").hide();
            break;
        }
    });
});
