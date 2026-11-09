$(document).ready(function(){
    $(".container").hide();
    $(".info-box").hide();
    window.addEventListener("message", function(event){
      if(event.data.data == true){
		    $(".container").show();
	    }
	    else{
		    $(".container").hide();
	    }
    });
})