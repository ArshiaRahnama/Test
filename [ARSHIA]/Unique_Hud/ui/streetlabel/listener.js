window.onload = (e) => {
  window.addEventListener('message', onMessageRecieved);
};
let oldHud = true
function onMessageRecieved(event){
  let item = event.data;
  if (!item) return
    if (item.type === 'streetLabel:MSG') {
      if (item.hud != oldHud){
        oldHud = item.hud;
        if (item.hud) {
          // $("#container").css({"left":"19.5%"});
          $("#container").css({"bottom":"5vh"});
        }else{
          // $("#container").css({"left":"40%"});
          $("#container").css({"bottom":"87vh"});
        }
      }
      if (!item.active) {
          $("#sl").hide();
      } else {
        $("#sl").show();
      }
              
      let direction = item.direction;
      let zone = item.zone;
      let street = item.street;
      let timestamp = item.time;

      $('#timestamp').text(timestamp);
      $('#timestamp2').text(item.ts);
      $('#src').text(item.src);
      $('#server').text(item.server);
      $('#direction').text(direction);
      $('#zone').text(zone);
      $('#street').text(street);
  } else if (item.type == "newbie") {
    if(item.action) {
      $('#newbie').fadeIn();
    } else {
      $('#newbie').fadeOut();
    }
  } else if (item.type == "displayaddress") {
    let direction = item.direction;
    let zone = item.zone;
    let street = item.street;
    let timestamp = item.time;
    $('#timestamp').text(timestamp);
    $('#direction').text(direction);
    $('#zone').text(zone);
    $('#street').text(street);
    if (!item.active) {
      $('.directionHolder').hide();
      $('.addressHolder').hide();
    } else {
      $('.directionHolder').show();
      $('.addressHolder').show();
    }
  }
}
