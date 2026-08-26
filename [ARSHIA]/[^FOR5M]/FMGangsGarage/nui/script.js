$(document).ready(function() {
	$(".car-box-details").fadeOut(0);
	$(".car-wrapper-motor").fadeOut(0);
	$(".car-wrapper-favorite").fadeOut(0);
	$(".car-wrapper-bikes").fadeOut(0);
	$(".car-wrapper-heli").fadeOut(0);
	$(".car-wrapper-boat").fadeOut(0);
	$(".carbox-transfer").fadeOut(0);
	$(".compenents").fadeOut(0);
	$(".carbox-sell").fadeOut(0);
	$(".out").fadeOut(0);
	$(".vale").fadeOut(0);
	$("#sell").fadeOut(0);
	$("#transfer").fadeOut(0);

	window.addEventListener("message", function(event) {
		event.preventDefault();
		var data = event.data;
		var name = data.name;
		var avatar = data.avatar;
		var carname = data.carname;
		var plate = data.plate;
		var mileageformat = data.mileageFormat;
		var garage = data.jobgarage;
		var garage2 = data.garage;
		var vhclass = data.vhclass;
		var stored = data.stored;
		var vehprice = data.vehprice;
		var job = data.job;
		var favorite = data.favorite;
		var fuel = data.fuel;
		var logo = data.ganglogo;
		var carlogo = data.logo;
		var text = data.text;
		var cardlogocheck = checkFileExist(`./images/cars/${carname}.png`);
		var weight = data.weight;
		var acceleratiosn = data.acce;
		var acceleration = acceleratiosn.toFixed(2);
		var repair = data.repair;
		if (cardlogocheck == true) {
			var cardlogo = (`./images/cars/${carname}.png`);
		} else {
			cardlogo = (`./images/cars/noimage.png`);
		}
		if (data.action == true) {
			$(".car-wrapper-favorite").fadeOut(0);
			$('#app').css('display', 'block');
			if (mileageformat == 'KM'){
				var maxspeed = parseInt(data.max) + ' KM/H'; 
			}else{
				var maxspeed = parseInt(data.max) + ' MP/H'; 
			}
			if (garage == "jobgarage") {
				$('#sell').css('display', 'none')
				$('#transfer').css('display', 'none')
				$('#headlogo').attr('src', logo);
			} else {
				$('#headlogo').attr('src', logo);
			}
			if (garage == "jobgarage") {
				$('#compenents').css('display', 'block');
			} else {
				$('#compenents').css('display', 'none');
			}
			if (garage == "normal") {
				$('.cars').css('display', 'block')
				$('.bikes').css('display', 'block')
				$('.motor').css('display', 'block')
				$('.boat').css('display', 'none')
				$('.air').css('display', 'none')
				$('.compenents').css('display', 'none')
				if (vhclass != 15 && vhclass != 14 && vhclass != 21 && vhclass != 18 && vhclass != 16 && vhclass != 17) {
					if (favorite == 1) {

						$(".car-wrapper-favorite").append(` 
                  <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}" data-stored="${stored}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
                    <div class="car-wrapper-car">
                    
                    <p class="carnameee">${carname.toUpperCase()}</p>
                    <div id="Favorite2">Remove from favourites <i class="far fa-star " id="star2"></i></div>
                        <img data-plate="${carname}" src="${cardlogo}" alt="">
                    </div>
                  </div>
                `);
					}
				}

			}

			if (garage == "boat") {
				$('.motor').css('display', 'none')
				$('.bikes').css('display', 'none')
				$('.air').css('display', 'none')
				$('.cars').css('display', 'none')
				$('.car-wrapper').css('display', 'none')
				$('.boat').css('display', 'block')
				if (vhclass == 14) {
					$(".car-wrapper-boat").append(` 
            <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-stored="${stored}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
              <div class="car-wrapper-car">
              
              <p class="carnameee">${carname.toUpperCase()}</p>
              <div id="Favorite">Add to favourites <i class="far fa-star" id="star"></i></div>
                <img data-plate="${carname}" src="${cardlogo}" alt="">
              </div>
          </div>
          `)
					if (favorite == 1) {

						$(".car-wrapper-favorite").append(` 
            <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}" data-stored="${stored}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
              <div class="car-wrapper-car">
              
              <p class="carnameee">${carname.toUpperCase()}</p>
              <div id="Favorite2">Remove from favourites <i class="far fa-star " id="star2"></i></div>
                  <img data-plate="${carname}" src="${cardlogo}" alt="">
              </div>
            </div>
          `);
					}
				}
			}
			if (garage == "aircraft") {
				$('.motor').css('display', 'none')
				$('.bikes').css('display', 'none')
				$('.boat').css('display', 'none')
				$('.cars').css('display', 'none')
				$('.car-wrapper').css('display', 'none')
				$('.air').css('display', 'block')
				if (vhclass == 15 || vhclass == 16) {
					$(".car-wrapper-heli").append(` 
          <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-stored="${stored}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
            <div class="car-wrapper-car">
            
            <p class="carnameee">${carname.toUpperCase()}</p>
            <div id="Favorite">Add to favourites <i class="far fa-star" id="star"></i></div>
              <img data-plate="${carname}" src="${cardlogo}" alt="">
            </div>
        </div>
        `)
					if (favorite == 1) {

						$(".car-wrapper-favorite").append(` 
         <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}" data-stored="${stored}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
           <div class="car-wrapper-car">
           
           <p class="carnameee">${carname.toUpperCase()}</p>
           <div id="Favorite2">Remove from favourites <i class="far fa-star " id="star2"></i></div>
               <img data-plate="${carname}" src="${cardlogo}" alt="">
           </div>
         </div>
       `);
					}
				}
			}

			if (garage == "jobgarage") {
				$('#headlogo').attr('src', logo);
				if (vhclass == 15 || vhclass == 16) {
					$('.bikes').css('display', 'none');
					$('.air').css('display', 'block');
					$(".car-wrapper-heli").append(` 
					<div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-stored="${stored}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
					<div class="car-wrapper-car">
               
               <p class="carnameee">${carname.toUpperCase()}</p>
					<div id="Favorite">Add to favourites <i class="far fa-star" id="star"></i></div>
					  <img data-plate="${carname}" src="${cardlogo}" alt="">
					</div>
				</div>
			`)
				}
			}
			if (data.sellcar == true) {
				$('#sell').css('display', 'block')
			}
			if (data.transferCar == true) {
				$('#transfer').css('display', 'block')
			}
			if (data.repair == true) {
				$('.repairbutton').css('display', 'flex')
			}
			document.getElementById("name").innerHTML = name;
			document.getElementById("plate2").innerHTML = plate;
			$('#avatar').attr('src', avatar);


			if (vhclass != 8 && vhclass != 13 && vhclass != 15 && vhclass != 14 && vhclass != 16) {
				$(".car-wrapper").append(` 
            <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-stored="${stored}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
              <div class="car-wrapper-car">
              
              <p class="carnameee">${carname.toUpperCase()}</p>
              <div id="Favorite">Add to favourites <i class="far fa-star" id="star"></i></div>
                  <img data-plate="${carname}" src="${cardlogo}" alt="">
              </div>
            </div>
          `);

			}
			if (vhclass == 8) {
				$(".car-wrapper-motor").append(` 
              <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-stored="${stored}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
                <div class="car-wrapper-car">
                
                <p class="carnameee">${carname.toUpperCase()}</p>
                <div id="Favorite">Add to favourites <i class="far fa-star" id="star"> </i></div>
                  <img data-plate="${carname}" src="${cardlogo}" alt="">
                </div>
            </div>
          `);
			}
			if (vhclass == 13) {
				$(".car-wrapper-bikes").append(` 
              <div class="vehiclemodel" data-carname="${carname.toUpperCase()}" data-logo="${carlogo}"  data-fuel="${fuel}" data-text="${text}"  data-acce="${acceleration}" data-stored="${stored}" data-price="${vehprice}" data-plate="${plate}" data-max="${maxspeed}" data-weight="${weight}" data-garage="${garage2}"data-vhclass="${vhclass}">
                <div class="car-wrapper-car">
                
                <p class="carnameee">${carname.toUpperCase()}</p>
                <div id="Favorite">Add to favourites <i class="far fa-star" id="star"></i></div>
                  <img data-plate="${carname}" src="${cardlogo}" alt="">
                </div>
            </div>
          `);
			}
		} else if (data.action == false) {
			close();
		}
	});

	function checkFileExist(urlToFile) {
		var xhr = new XMLHttpRequest();
		xhr.open('HEAD', urlToFile, false);
		xhr.send();

		if (xhr.status == "404") {
			return false;
		} else {
			return true;
		}
	}
	
	spawned = false;
	$(document).on("click", ".car-wrapper-car", function() {
		if (spawned == false){
			spawned = true
			$(".car-box-details").css('display', 'flex');
			var carnamee = $(this).parent().find('.carnameee');
			var carlogoo = $(this).parent().attr("data-logo");
			var text = $(this).parent().attr("data-text");
	
			var logo = (`./images/logo/${carlogoo}.png`);
			var defaultlogo = (`./images/logo/unmarked.png`);
			if (carlogoo == "undefined" || carlogoo == "NULL") {
				$('#crlogo').attr('src', defaultlogo);
			} else {
				$('#crlogo').attr('src', logo);
			}
			$('.car-wrapper-car').removeClass('selected');
			$(this).addClass('selected');
			$('.carnameee').removeClass('selected');
			$(carnamee).addClass('selected');
			let carname = $(this).parent().attr("data-carname");
			if (carname == undefined){
				spawned = false
			}
			let plate = $(this).parent().attr("data-plate");
			let max = $(this).parent().attr("data-max");
			let weight = $(this).parent().attr("data-weight");
			let acce = $(this).parent().attr("data-acce");
			let stored = $(this).parent().attr("data-stored");
			let price = $(this).parent().attr("data-price");
			let garage = $('.car-wrapper-car').parent().attr("data-garage");
			document.getElementById("stored2").innerHTML = stored;
			document.getElementById("svehicle").innerHTML = carname.toUpperCase();
			document.getElementById("splate").innerHTML = plate;
			document.getElementById("text3").innerHTML = text;
			document.getElementById("tvehicle").innerHTML = carname.toUpperCase();
			document.getElementById("tplate").innerHTML = plate;
			if (stored == -1) {
				$(".out").fadeIn(0);
				$(".spawnbutton").fadeOut(0);
				$(".vale").fadeOut(0);
			} else if (stored == 1) {
				$(".out").fadeOut(0);
				$(".spawnbutton").fadeIn(0);
				$(".vale").fadeOut(0);
			}else if (stored == 0) {
				$(".out").fadeOut(0);
				$(".spawnbutton").fadeOut(0);
				$(".vale").fadeIn(0);
			}
			document.getElementById("acce").innerHTML = acce;
			document.getElementById("prices").innerHTML = price;
			document.getElementById("weight").innerHTML = weight;
			document.getElementById("plate").innerHTML = plate;
			document.getElementById("model").innerHTML = carname;
			document.getElementById("max").innerHTML = max;
			$.post('https://FMGangsGarage/spawnlocalvehicle', JSON.stringify ({
				carname: carname,
				plate: plate,
				garage: garage
			}),function(cs){
				spawnlanancar = cs
				spawned = false
			});
		}
	})

	$(document).on("click", ".spawnbutton", function() {
		var carname = document.getElementById("model").innerHTML;
		var plate = document.getElementById("plate").innerHTML;
		let garage = $('.car-wrapper-car').parent().attr("data-garage");
		let fuel = $('.car-wrapper-car').parent().attr("data-fuel");
		$.post('https://FMGangsGarage/spawnvehicle', JSON.stringify({
			carname: carname,
			plate: plate,
			garage: garage,
			fuel: fuel
		}));
		close();
	})
	var livnumber = document.getElementById("livnumber");
	clivnumber = 0;

	$(document).on("click", ".livery #ileri", function() {
		if (clivnumber <= 13) {
			clivnumber += 1;
			livnumber.innerHTML = clivnumber;
		}
		$.post('https://FMGangsGarage/mods', JSON.stringify({
			mod: "livery",
			count:clivnumber
		}));
	})

	$(document).on("click", ".livery #geri", function() {
		if (clivnumber >= 1) {
			clivnumber -= 1;
			livnumber.innerHTML = clivnumber;
		}
		$.post('https://FMGangsGarage/mods', JSON.stringify({
			mod: "livery",
			count:clivnumber
		}));
	})

	var number = document.getElementById("number");
	count = 0;
	
	$(document).on("click", ".extras #ileri", function() {
		if (count <= 13) {
			count += 1;
			number.innerHTML = count;
		}
		$.post('https://FMGangsGarage/mods', JSON.stringify({
			mod: "extras",
			count:count
		}));
	})

	$(document).on("click", ".extras #geri", function() {
		if(count >= 1){
			count -= 1;
			number.innerHTML = count;
		}
		$.post('https://FMGangsGarage/mods', JSON.stringify({
			mod: "extras",
			count:count
		}));
	})

	$(document).on("click", ".aply", function() {
		var count = document.getElementById("number").innerHTML;
		$.post('https://FMGangsGarage/apply', JSON.stringify({
			count:count
		}));
	})

	$(document).on("click", ".vale", function() {
		var carname = document.getElementById("model").innerHTML;
		var plate = document.getElementById("plate").innerHTML;
		let garage = $('.car-wrapper-car').parent().attr("data-garage");
		let fuel = $('.car-wrapper-car').parent().attr("data-fuel");
		$.post('https://FMGangsGarage/spawnvehiclevale', JSON.stringify({
			carname: carname,
			plate: plate,
			garage: garage,
			fuel: fuel
		}));
		close();
	})

	$(document).on("click", "#star", function() {
		var plate = document.getElementById("plate").innerHTML;
		spawned = false
		$.post('https://FMGangsGarage/addfavorite', JSON.stringify({
			plate: plate,
			bool: 1
		}));
		close();
	})

	$(document).on("click", "#star2", function() {
		var plate = document.getElementById("plate").innerHTML;
		spawned = false
		$.post('https://FMGangsGarage/addfavorite', JSON.stringify({
			plate: plate,
			bool: 0
		}));
		close();
	})

	$(document).on("click", ".motor", function() {
		$(".car-wrapper").fadeOut(0);
		$(".car-wrapper-bikes").fadeOut(0);
		$(".car-wrapper-motor").fadeIn(0);
		$(".car-wrapper-favorite").fadeOut(0);
		$(".car-wrapper-heli").fadeOut(0);
		$('.motor').css('color', 'white');
		$('.bikes').css('color', 'rgb(144, 144, 144)');
		$('.air').css('color', 'rgb(144, 144, 144)');
		$('.cars').css('color', 'rgb(144, 144, 144)');
		$('.category-image').css('color', '#5f5f5f');
	});

	$(document).on("click", ".boat", function() {
		$(".car-wrapper").fadeOut(0);
		$(".car-wrapper-bikes").fadeOut(0);
		$(".car-wrapper-boat").fadeIn(0);
		$(".car-wrapper-favorite").fadeOut(0);
		$(".car-wrapper-heli").fadeOut(0);
		$('.boat').css('color', 'white');
		$('.bikes').css('color', 'rgb(144, 144, 144)');
		$('.air').css('color', 'rgb(144, 144, 144)');
		$('.cars').css('color', 'rgb(144, 144, 144)');
		$('.category-image').css('color', '#5f5f5f');
	});

	$(document).on("click", ".cars", function() {
		$(".car-wrapper").fadeOut(0);
		$(".car-wrapper-motor").fadeOut(0);
		$(".car-wrapper-bikes").fadeOut(0);
		$(".car-wrapper-favorite").fadeOut(0);
		$(".car-wrapper").fadeIn(0);
		$('.cars').css('color', 'white');
		$('.bikes').css('color', 'rgb(144, 144, 144)');
		$('.motor').css('color', 'rgb(144, 144, 144)');
		$('.air').css('color', 'rgb(144, 144, 144)');
		$('.category-image').css('color', '#5f5f5f');
	});

	$(document).on("click", ".bikes", function() {
		$(".car-wrapper").fadeOut(0);
		$(".car-wrapper-favorite").fadeOut(0);
		$(".car-wrapper-motor").fadeOut(0);
		$(".car-wrapper-heli").fadeOut(0);
		$(".car-wrapper-bikes").fadeIn(0);
		$('.bikes').css('color', 'white');
		$('.air').css('color', 'rgb(144, 144, 144)');
		$('.motor').css('color', 'rgb(144, 144, 144)');
		$('.cars').css('color', 'rgb(144, 144, 144)');
		$('.category-image').css('color', '#5f5f5f');
	});

	$(document).on("click", ".air", function() {
		$(".car-wrapper").fadeOut(0);
		$(".car-wrapper-favorite").fadeOut(0);
		$(".car-wrapper-motor").fadeOut(0);
		$(".car-wrapper-heli").fadeIn(0);
		$('.air').css('color', 'white');
		$('.motor').css('color', 'rgb(144, 144, 144)');
		$('.cars').css('color', 'rgb(144, 144, 144)');
		$('.category-image').css('color', '#5f5f5f');
	});

	$(document).on("click", ".category-image", function() {
		$(".car-wrapper").fadeOut(0);
		$(".car-wrapper-bikes").fadeOut(0);
		$(".car-wrapper-heli").fadeOut(0);
		$(".car-wrapper-motor").fadeOut(0);
		$(".car-wrapper-boat").fadeOut(0);
		$(".car-wrapper-favorite").fadeIn(0);
		$('.bikes').css('color', 'rgb(144, 144, 144)');
		$('.air').css('color', 'rgb(144, 144, 144)');
		$('.motor').css('color', 'rgb(144, 144, 144)');
		$('.cars').css('color', 'rgb(144, 144, 144)');
		$('.boat').css('color', 'rgb(144, 144, 144)');
		$('.category-image').css('color', 'white');
	});

	$(document).on("click", "#compenents", function() {
		$(".carbox-transfer").fadeOut(0);
		$(".carbox-sell").fadeOut(0);
		$(".carbox-maxdetails").fadeOut(0);
		$('#transfer').css('color', 'rgb(144, 144, 144)');
		$('#specs').css('color', 'rgb(144, 144, 144)');
		$('.compenents').css('display', 'flex');
		$('#compenents').css('color', 'rgba(255, 255, 255, 0.885)');
		$('#sell').css('color', 'rgb(144, 144, 144)');
		$(".compenents").fadeIn(0)
		$('.spawnbutton').css('display', 'flex');
		$(".vale").css('display', 'none');
		$(".out").css('display', 'none');
		$('.sellbutton').css('display', 'none');
		$('.transferbutton').css('display', 'none');
	});

	$(document).on("click", "#specs", function() {
		var stored = document.getElementById("stored2").innerHTML;
		if (stored == -1) {
			$(".out").fadeIn(0);
			$(".spawnbutton").fadeOut(0);
			$(".vale").fadeOut(0);
		} else if (stored == 1) {
			$(".out").fadeOut(0);
			$(".spawnbutton").fadeIn(0);
			$(".vale").fadeOut(0);
		}else if (stored == 0) {
			$(".out").fadeOut(0);
			$(".spawnbutton").fadeOut(0);
			$(".vale").fadeIn(0);
		}
		$(".carbox-transfer").fadeOut(0);
		$(".carbox-maxdetails").fadeOut(0);
		$(".compenents").fadeOut(0);
		$(".carbox-sell").fadeOut(0);
		$(".transferbutton").css('display', 'none');
		$(".sellbutton").css('display', 'none');
		$('#transfer').css('color', 'rgb(144, 144, 144)');
		$('#compenents').css('color', 'rgb(144, 144, 144)');
		$('#specs').css('color', 'rgba(255, 255, 255, 0.885)');
		$('#sell').css('color', 'rgb(144, 144, 144)');
		$(".carbox-maxdetails").fadeIn(0)
	});

	$(document).on("click", "#transfer", function() {
		$(".carbox-sell").fadeOut(0);
		$(".carbox-maxdetails").fadeOut(0);
		$(".compenents").fadeOut(0);
		$(".spawnbutton").fadeOut(0);
		$(".vale").css('display', 'none');
		$(".out").css('display', 'none');
		$('#transfer').css('color', 'rgba(255, 255, 255, 0.885)');
		$('#specs').css('color', 'rgb(144, 144, 144)');
		$('#sell').css('color', 'rgb(144, 144, 144)');
		$('.carbox-transfer').css('display', 'flex');
		$('.transferbutton').css('display', 'flex');
		$('.sellbutton').css('display', 'none');
	});

	$(document).on("click", "#sell", function() {
		$(".carbox-maxdetails").fadeOut(0);
		$(".carbox-transfer").fadeOut(0);
		$(".compenents").fadeOut(0);
		$(".spawnbutton").css('display', 'none');
		$(".vale").css('display', 'none');
		$(".out").css('display', 'none');
		$('#transfer').css('color', 'rgb(144, 144, 144)');
		$('#specs').css('color', 'rgb(144, 144, 144)');
		$('#sell').css('color', 'rgba(255, 255, 255, 0.885)');
		$('.carbox-sell').css('display', 'flex');
		$('.sellbutton').css('display', 'flex');
		$('.transferbutton').css('display', 'none');
	});

	$(document).on("click", ".repairbutton", function() {
		$.post('https://FMGangsGarage/repairvehicle', JSON.stringify({}));
	});

	$(document).on("click", ".sellbutton", function() {
		var plate = document.getElementById("plate").innerHTML;
		var price = document.getElementById("prices").innerHTML;
		$.post('https://FMGangsGarage/sellvehicle', JSON.stringify({
			plate: plate,
			price: price
		}));
		close();
	});


	$(document).on("click", ".transferbutton", function() {
		var plate = document.getElementById("plate").innerHTML;
		var id = $("#identifier").val();
		$.post('https://FMGangsGarage/transfervehicle', JSON.stringify({
			id: id,
			plate: plate
		}));
		close();
	});

	function close() {
		$('#app').css('display', 'none');
		$('.car-box-details').fadeOut(0);
		let garage = $('.car-wrapper-car').parent().attr("data-garage");
		spawned = false
		$.post('https://FMGangsGarage/close', JSON.stringify({
			display: false,
			garage: garage

		}));
		document.querySelectorAll(".car-wrapper-car").forEach(function(a) {
			a.remove()
		});

	}

	$(document).on("click", ".garage-top-close-button", function() {
		close()
	});

	document.addEventListener('keyup', function(data) {
		if (data.which == 27) {
			close();
		}
	});

	let holding = false;
	document.addEventListener("mousedown", function(e) {
		holding = true;
	});
	document.addEventListener("mouseup", function(e) {
		holding = false;
	});

	var direction = "",
		oldx = 0,
		mousemovemethod = function(e) {
			if (e.pageX < oldx) {
				direction = "left";
			} else if (e.pageX > oldx) {
				direction = "right";
			}
			oldx = e.pageX;
			if (direction == "left" && holding) {
				if (e.target.classList.contains("mouse-move")) {
					$.post('https://FMGangsGarage/rotateleft');
				}
			}
			if (direction == "right" && holding) {
				if (e.target.classList.contains("mouse-move")) {
					$.post('https://FMGangsGarage/rotateright');
				}
			}
		};

	document.addEventListener("mousemove", mousemovemethod);

	const element = document.querySelector(".car-wrapper");
	const element2 = document.querySelector(".car-wrapper-heli");
	const element3 = document.querySelector(".car-wrapper-favorite");
	const element4 = document.querySelector(".car-wrapper-bikes");
	const element5 = document.querySelector(".car-wrapper-boat");
	const element6 = document.querySelector(".car-wrapper-motor");
	element.addEventListener('wheel', (event) => {
		event.preventDefault();
		element.scrollBy({
			left: event.deltaY < 0 ? -30 : 30,

		});
	});
	element2.addEventListener('wheel', (event) => {
		event.preventDefault();
		element2.scrollBy({
			left: event.deltaY < 0 ? -30 : 30,

		});
	});
	element3.addEventListener('wheel', (event) => {
		event.preventDefault();
		element3.scrollBy({
			left: event.deltaY < 0 ? -30 : 30,

		});
	});
	element4.addEventListener('wheel', (event) => {
		event.preventDefault();
		element4.scrollBy({
			left: event.deltaY < 0 ? -30 : 30,

		});
	});
	element5.addEventListener('wheel', (event) => {
		event.preventDefault();
		element5.scrollBy({
			left: event.deltaY < 0 ? -30 : 30,

		});
	});
	element5.addEventListener('wheel', (event) => {
		event.preventDefault();
		element5.scrollBy({
			left: event.deltaY < 0 ? -30 : 30,

		});
	});
	element6.addEventListener('wheel', (event) => {
		event.preventDefault();
		element5.scrollBy({
			left: event.deltaY < 0 ? -30 : 30,

		});
	});
})