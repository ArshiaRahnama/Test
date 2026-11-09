$(document).ready(function(){
    $(".container").hide();
    $(".info-box").hide();
    window.addEventListener("message", function(event){
      if(event.data == true){
		  $(".container").hide();
	  }
	  else{
		  $(".container").show();
	  }
    });
	
	var last = false;
    setInterval(()=>{
        //var ImageObject = new Image();
        //ImageObject.src = "https://www.google.com/favicon.ico";
        let online = window.navigator.onLine;
        if (online != last){
            last = online
            if (online) {
                $(".container").hide();
                $.post('https://lan/lan', JSON.stringify({connection: true}));
            } else {
                $(".container").show();
                $.post('https://lan/lan', JSON.stringify({connection: false}));
            }
        }
        
		request_image("https://google.com/favicon.ico")
		.then(function(){
			
		})
		.catch(function(){
			
		});
	
		
    }, 500);
	
	
	var request_image = function(url) {
		return new Promise(function(resolve, reject) {
			var img = new Image();
			img.onload = function() { resolve(img); };
			img.onerror = function() { reject(url); };
			img.src = url + '?random-no-cache=' + Math.floor((1 + Math.random()) * 0x10000).toString(16);
		});
	};
	
})