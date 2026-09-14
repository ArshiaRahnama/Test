var timeout;
var opened;
var recipes;
var names;
var level;
var Level;
var inventory = {};
var rawlevel;
var job;
var hidecraft;
var grade;
var categories;

function closeMenu() {
  $.post('https://uniquecafejobs/close', JSON.stringify({}));


  $("#main_container").fadeOut(400);
  timeout = setTimeout(function () {
    $("#main_container").html("");
    $("#main_container").fadeIn();
  }, 400);


}

function openCategory(catgory) {
  var first = '';

  var base = '<div class="" id="page"><!-- group -->' +
    '   <div class="clearfix grpelem scale-up-center" id="pu104-4"><!-- column -->' +
    '    <div class="clearfix colelem" id="u104-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +
    '     <p>WORKBENCH</p>' +
    '    </div>' +
    '    <div class="clearfix colelem" id="u139-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +
    '    </div>' +
    '    <div class="colelem" id="u136" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +
    '    <div class="colelem" id="u107" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +
    '<div id="recepies">';

 
  const targetCategory = catgory;

  for (const [key1, value1] of Object.entries(categories)) {
    if (key1 === targetCategory) { 
      var add = false;

      for (const [key, value] of Object.entries(recipes)) {
        if (value.Category == key1) {
          if (value.Level > Level) {
            if (!hidecraft) {
              add = true;
            }
          } else {
            if (value.requireBlueprint && (inventory[key + '_blueprint'] == 0 || inventory[key + '_blueprint'] == null)) {
              if (!hidecraft) {
                add = true;
              }
            } else {
              if (value.Jobs.includes(job) || Object.keys(value.Jobs).length == 0) {
                if (value.JobGrades.includes(grade) || Object.keys(value.JobGrades).length == 0) {
                  add = true;
                } else {
                  if (!hidecraft) {
                    add = true;
                  }
                }
              } else {
                if (!hidecraft) {
                  add = true;
                }
              }
            }
          }
        }
      }

      if (add) {
        first = first + '    <div class="clearfix colelem recipe" data-category="' + key1 + '" onclick="openCrafting(this)" id="pu212"><!-- group -->' +
          '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
          '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
          '      <p>' + value1.Label + '</p>' +
          '     </div>' +
          '     <div class="museBGSize grpelem" id="u264" style="background: url(nui://ox_inventory/web/images/' + value1.Image + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
          '    </div>';
      }
    }
  }

  base = base + first + '</div>' +
    '   </div>' +
    '   <div class="verticalspacer" data-offset-top="0" data-content-above-spacer="1060" data-content-below-spacer="0" data-sizePolicy="fixed" data-pintopage="page_fixedLeft"></div>' +
    '   <div class="grpelem" id="u559"><!-- simple frame --></div>' +
    '  </div>';

  $("#main_container").append(base);

  $(".recipe").hover(function () {
    playClickSound();
  });

  $("#u139-4").text(Level + ' LEVEL');
  setProgress((rawlevel % 100));


  autoOpenCategory(targetCategory);
}

function autoOpenCategory(targetCategory) {

  const targetRecipe = Object.entries(recipes).find(([key, value]) => value.Category === targetCategory);

  if (targetRecipe) {
    const [key, value] = targetRecipe;
    const fakeElement = document.createElement('div');
    fakeElement.dataset.category = targetCategory;

    openCrafting(fakeElement);
  }
}

function openCrafting(t) {

  $("#main_container").html('');

  var first = '';
  var second = '';
  var category = t.dataset.category;

  var base = '<div class="" id="page"><!-- group -->' +
    '   <div class="clearfix grpelem scale-up-center" id="pu104-4"><!-- column -->' +
    '    <div class="clearfix colelem" id="u104-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +
    '     <p>WORKBENCH</p>' +
    '    </div>' +
    '    <div class="clearfix colelem" id="u139-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- content -->' +

    '    </div>' +
    '    <div class="colelem" id="u136" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +
    '    <div class="colelem" id="u107" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu104-4"><!-- simple frame --></div>' +

    '<div id="recepies">';

  for (const [key, value] of Object.entries(recipes)) {

    var date = new Date(0);
    date.setSeconds(value.Time);
    var timeString = date.toISOString().substr(14, 5);

    if (value.Category == category) {

	// console.log(Level + " | " + value.Level)
      if (  value.Level > Level ) {

        if (!hidecraft) {
          if (String(names[key]).toUpperCase() != "UNDEFINED") {
              var title = String(names[key]).toUpperCase()
          }else{
              var title = String(key).toUpperCase()
			  title = title.replace("WEAPON_", ""); 
			  title = title.replace("_", " "); 
			  
          }
          
          second = second + '    <div class="clearfix colelem recipe" onclick="inspect(this)" data-item="' + key + '" style="opacity: 0.5;" id="pu212"><!-- group -->' +
            '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
            '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
            '      <p>' + title + '</p>' +
            '     </div>' +
            '     <div class="museBGSize grpelem" id="u264" style="background: url(nui://ox_inventory/web/images/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
            '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
            '      <p>' + timeString + '</p>' +
            '     </div>' +
            '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
            '      <p>' + value.Level + ' LVL</p>' +
            '     </div>' +
            '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
            '      <p> X' + value.Amount + '</p>' +
            '     </div>' +
            '    </div>';
        }


      } else {

        if (value.requireBlueprint && (inventory[key + '_blueprint'] == 0 || inventory[key + '_blueprint'] == null)) {
          if (!hidecraft) {
            if (String(names[key]).toUpperCase() != "UNDEFINED") {
              var title = String(names[key]).toUpperCase()
            }else{
              var title = String(key).toUpperCase()
			  title = title.replace("WEAPON_", ""); 
			  title = title.replace("_", " "); 
			  
            }
            second = second + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" style="opacity: 0.5;" id="pu212"><!-- group -->' +
              '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
              '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              '      <p>' + title + '</p>' +
              '     </div>' +
              '     <div class="museBGSize grpelem" id="u264" style="background: url(nui://ox_inventory/web/images/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
              '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              '      <p>' + timeString + '</p>' +
              '     </div>' +
              '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              '      <p>' + value.Level + ' LVL</p>' +
              '     </div>' +
              '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
              '      <p> X' + value.Amount + '</p>' +
              '     </div>' +
              '    </div>';
          }
        } else {

          if (value.Jobs.includes(job) || Object.keys(value.Jobs).length == 0) {
            
            if (value.JobGrades.includes(grade) || Object.keys(value.JobGrades).length == 0) {
                if (String(names[key]).toUpperCase() != "UNDEFINED") {
                    var title = String(names[key]).toUpperCase()
                }else{
                    var title = String(key).toUpperCase()
					title = title.replace("WEAPON_", ""); 
					title = title.replace("_", " "); 
					
                }
              first = first + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" id="pu212"><!-- group -->' +
                '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + title + '</p>' +
                '     </div>' +
                '     <div class="museBGSize grpelem" id="u264" style="background: url(nui://ox_inventory/web/images/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + timeString + '</p>' +
                '     </div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + value.Level + ' LVL</p>' +
                '     </div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p> X' + value.Amount + '</p>' +
                '     </div>' +
                '    </div>';
            } else {
              if (!hidecraft) {
                if (String(names[key]).toUpperCase() != "UNDEFINED") {
                    var title = String(names[key]).toUpperCase()
                }else{
                    var title = String(key).toUpperCase()
					title = title.replace("WEAPON_", ""); 
					title = title.replace("_", " "); 
					
                }
                second = second + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" style="opacity: 0.5;" id="pu212"><!-- group -->' +
                  '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                  '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  '      <p>' + title + '</p>' +
                  '     </div>' +
                  '     <div class="museBGSize grpelem" id="u264" style="background: url(nui://ox_inventory/web/images/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                  '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  '      <p>' + timeString + '</p>' +
                  '     </div>' +
                  '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  '      <p>' + value.Level + ' LVL</p>' +
                  '     </div>' +
                  '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                  '      <p> X' + value.Amount + '</p>' +
                  '     </div>' +
                  '    </div>';
              }
            }
          } else {
            if (!hidecraft) {
				if (String(names[key]).toUpperCase() != "UNDEFINED") {
					var title = String(names[key]).toUpperCase()
				}else{
					var title = String(key).toUpperCase()
					title = title.replace("WEAPON_", ""); 
					title = title.replace("_", " "); 
					
				}
              second = second + '    <div class="clearfix colelem recipe" data-item="' + key + '" onclick="inspect(this)" style="opacity: 0.5;" id="pu212"><!-- group -->' +
                '     <div class="gradient grpelem" id="u212" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="clearfix grpelem" id="u225-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + title + '</p>' +
                '     </div>' +
                '     <div class="museBGSize grpelem" id="u264" style="background: url(nui://ox_inventory/web/images/' + key + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- simple frame --></div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u270-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + timeString + '</p>' +
                '     </div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u413-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p>' + value.Level + ' LVL</p>' +
                '     </div>' +
                '     <div class="rounded-corners clearfix grpelem" id="u417-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu212"><!-- content -->' +
                '      <p> X' + value.Amount + '</p>' +
                '     </div>' +
                '    </div>';
            }
          }

        }

      }

    }
  }

  base = base + first + second + '</div>' +


    '   </div>' +

    '   <div class="verticalspacer" data-offset-top="0" data-content-above-spacer="1060" data-content-below-spacer="0" data-sizePolicy="fixed" data-pintopage="page_fixedLeft"></div>' +
    '   <div class="grpelem" id="u559"><!-- simple frame --></div>' +
    '  </div>';


  $("#main_container").append(base);

  $(".recipe").hover(function () {
    playClickSound();
  });

  $("#u139-4").text(Level + ' LEVEL');
  setProgress((rawlevel % 100));


}

$(document).keyup(function (e) {
  if (e.keyCode === 27) {

    closeMenu();

  }

});

function addToQueue(item, time, id) {

  var date = new Date(0);
  date.setSeconds(time);
  var timeString = date.toISOString().substr(14, 5);

  if ($("#" + id).length) {


    $("#" + id).find("#u547-2").text(timeString);

    if (time == 0) {
      $("#" + id).fadeOut();
      setTimeout(function () {
        $("#" + id).remove();
      }, 3000);
    }

  } else {
		if (String(names[item]).toUpperCase() != "UNDEFINED") {
              var title = String(names[item]).toUpperCase()
          }else{
              var title = String(item).toUpperCase()
			  title = title.replace("WEAPON_", ""); 
			  title = title.replace("_", " "); 
			  
          }
    var base = '    <div class="slide-left queue" id="' + id + '"><!-- group -->' +
      '     <div class="gradient grpelem" id="u544" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- simple frame --></div>' +
      '     <div class="clearfix grpelem" id="u545-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- content -->' +
      '      <p>' + title + '</p>' +
      '     </div>' +
      '     <div class="museBGSize grpelem" style="background: url(nui://ox_inventory/web/images/' + item + '.png) no-repeat center; background-size: 120%; " id="u546" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- simple frame --></div>' +
      '     <div class="rounded-corners clearfix grpelem" id="u547-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu544"><!-- content -->' +
      '      <p id="u547-2">' + timeString + '</p>' +
      '     </div>' +
      '    </div>';

    $("#ppu586").append(base);
  }

}

function craft(t) {
  var item = t.dataset.item;
  $.post('https://uniquecafejobs/craft', JSON.stringify({
    item: item
  }));


}

function setProgress(p) {
  var prog = (398 / 100) * p;

  $("#u136").animate({
    width: prog
  }, 500, function () {

  });

}

function inspect(t) {

  if (opened != t) {
    opened = t

    $("#pu386").remove();


    var item = recipes[t.dataset.item]
    var ingredients = item.Ingredients

    var date = new Date(0);
    date.setSeconds(item.Time);
    var timeString = date.toISOString().substr(14, 5);
	if (String(names[t.dataset.item]).toUpperCase() != "UNDEFINED") {
		  var title = String(names[t.dataset.item]).toUpperCase()
	  }else{
		  var title = String(t.dataset.item).toUpperCase()
		  title = title.replace("WEAPON_", ""); 
		  title = title.replace("_", " "); 
		  
	  }
    var base = '   <div class="slide-bottom " id="pu386"><!-- group -->' +
      '    <div class="gradient grpelem" id="u386" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- simple frame --></div>' +
      '    <div class="museBGSize grpelem" id="u389" style="background: url(nui://ox_inventory/web/images/' + t.dataset.item + '.png) no-repeat center; background-size: 120%; " data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- simple frame --></div>' +

      '     <button class="ripple" id="u407-4" data-item="' + t.dataset.item + '" onclick="craft(this)" data-sizePolicy="fixed" data-pintopage="page_fixedCenter"><!-- content -->' +
      '      <p>CRAFT</p>' +
      '     </button>' +

      '    <div class="clearfix grpelem" id="u457-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>' + title + '</p>' +
      '    </div>' +
      '    <div class="rounded-corners clearfix grpelem" id="u535-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>' + timeString + '</p>' +
      '    </div>' +
      '    <div class="rounded-corners clearfix grpelem" id="u538-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>' + item.Level + ' LVL</p>' +
      '    </div>' +
      '    <div class="rounded-corners clearfix grpelem" id="u523-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>X' + item.Amount + '</p>' +
      '    </div>' +
      '    <div class="clearfix grpelem" id="u541-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter" data-leftAdjustmentDoneBy="pu386"><!-- content -->' +
      '     <p>INGREDIENTS</p>' +
      '    </div>' +

      '<div id="ingredients">';

    var first = '';
    var second = '';


    
  
    for (const [key, value] of Object.entries(ingredients)) {
      let formattedValue = formatPrice(value); 
      let opacity = inventory[key] >= value ? 1 : 0.5;
      
      
      let valueText = key.toLowerCase() === "eskenas" ? formattedValue : formattedValue + "X";
    
      let ingredientHTML = `
          <div class="ingredient" id="${key}" style="opacity:${opacity};">
              <div id="ingredient-text">${names[key]}</div>
              <div id="ingredient-x">${valueText}</div>
              <div id="ingredient-logo" 
                   style="background: url(nui://ox_inventory/web/images/${key}.png) 
                          no-repeat center; background-size: 120%;">
              </div>
          </div>
      `;
    
      if (inventory[key] >= value) {
          first += ingredientHTML;
      } else {
          second += ingredientHTML;
      }
    }
  


    base = base + first + second + '</div>' +

      '   </div>';

    $("#page").append(base);
  }


}

function formatPrice(price) {
  if (price >= 1_000_000) {
      return (price / 1_000_000).toFixed(1).replace(/\.0$/, '') + 'M';
  } else if (price >= 1_000) {
      return (price / 1_000).toFixed(1).replace(/\.0$/, '') + 'K';
  }
  return price.toString();
}






function playClickSound() {
  var audio = document.getElementById("clickaudio");
  audio.volume = 0.05;
  audio.play();
}


window.addEventListener('message', function (event) {


  var edata = event.data;

  if (edata.type == "addqueue") {
    addToQueue(edata.item, edata.time, edata.id);
  }
  if (edata.type == "crafting") {
    for (const [key, value] of Object.entries(recipes[edata.item].Ingredients)) {
      if (inventory[key] >= value) {
        inventory[key] = inventory[key] - value;
      }


      if (inventory[key] < value) {
        $(document).find("#" + key).css("opacity", "0.5");
      }
    }
  }

  if (edata.type == "open") {
	
    level = (edata.level - (edata.level % 100)) / 100;
    rawlevel = edata.level;
	  Level = edata.Level;
    recipes = edata.recipes;
    inventory = edata.inventory;
    names = edata.names;
    job = edata.job;
    hidecraft = edata.hidecraft;
    grade = edata.grade;
    categories = edata.categories
    openCategory(edata.opencategory);


  }


});