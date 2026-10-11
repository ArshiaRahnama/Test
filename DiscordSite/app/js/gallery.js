function setUpGalleryData(Images){
    $(".gallery-images").html("");
    if (Images != null) {
        $.each(Images, function(i, image){
            const imageUrl = image.url || image.image_url || image.proxy_url || image.image;
            var Element = '<div class="gallery-image"><img src="'+imageUrl+'" alt="'+image.id+'" class="tumbnail"></div>';
            
            $(".gallery-images").append(Element);
            $("#image-"+i).data('ImageData', image);
        });
    }
}

$(document).on('click', '.tumbnail', function(e){
    e.preventDefault();
    let source = $(this).attr('src')
    //MI.Screen.popUp(source)
    $(".gallery-homescreen").animate({
        left: 30+"vh"
    }, 200);
    $(".gallery-detailscreen").animate({
        left: 0+"vh"
    }, 200);
    SetupImageDetails(source);
});

$(document).on('click', '.image', function(e){
    e.preventDefault();
    let source = $(this).attr('src')
   MI.Screen.popUp(source)
});


$(document).on('click', '#delete-button', function(e){
    e.preventDefault();
    let source = $('.image').attr('src')

    setTimeout(() => {
        $.post('https://Unique_Phone/DeleteImage', JSON.stringify({image:source}), function(Hashtags){
            setTimeout(()=>{
                $('#return-button').click()
                $.post('https://Unique_Phone/GetGalleryData', JSON.stringify({}), function(data){
                    setTimeout(()=>{
                            setUpGalleryData(data);
                        
                    },200)
                });
            },200)
        })
        
    }, 200);
});

$(document).on('click', '#copy-button', function(e){
    e.preventDefault();
    let source = $('.image').attr('src')

    setTimeout(() => {
        CopyClipBoard(source);
       MI.Phone.Notifications.Add("fas fa-clipboard", "", "Link axs copy shod!", "#ff9100", 3000);
    }, 200);
});

function CopyClipBoard(text) {
    var node = document.createElement('textarea');
    node.textContent = text;
    document.body.appendChild(node);
    node.select();
    document.execCommand('copy');
    document.body.removeChild(node);
    $("#CopyDone").slideDown()
    setTimeout(() => {
        $("#CopyDone").slideUp()
    }, 5000)
}

function SetupImageDetails(Image){
    $('#imagedata').attr("src", Image);
}
let postImageUrl="";
function SetupPostDetails(){
}


$(document).on('click', '#make-post-button', function(e){
    e.preventDefault();
    let source = $('#imagedata').attr('src')
    postImageUrl=source

    //MI.Screen.popUp(source)
    $(".gallery-detailscreen").animate({
        left: 30+"vh"
    }, 200);
    $(".gallery-postscreen").animate({
        left: 0+"vh"
    }, 200);
    SetupPostDetails();
});


$(document).on('click', '#return-button', function(e){
    e.preventDefault();

    $(".gallery-homescreen").animate({
        left: 00+"vh"
    }, 200);
    $(".gallery-detailscreen").animate({
        left: -30+"vh"
    }, 200);
});

$(document).on('click', '#returndetail-button', function(e){
    e.preventDefault();
    returnDetail();
    
});

function returnDetail(){
    $(".gallery-detailscreen").animate({
        left: 00+"vh"
    }, 200);
    $(".gallery-postscreen").animate({
        left: -30+"vh"
    }, 200);
}


$(document).on('click', '#tweet-button', function(e){
    e.preventDefault();
    var TweetMessage = $("#new-textarea").val();
    var imageURL = postImageUrl
    if (TweetMessage != "") {
        var CurrentDate = new Date();
        $.post('https://Unique_Phone/PostNewTweet', JSON.stringify({
            Message: TweetMessage,
            Date: CurrentDate,
            Picture:MI.Phone.Data.MetaData.profilepicture,
            url: imageURL
        }), function(Tweets){
           MI.Phone.Notifications.LoadTweets(Tweets);
        });
        var TweetMessage = $("#new-textarea").val(' ');
        $.post('https://Unique_Phone/GetHashtags', JSON.stringify({}), function(Hashtags){
           MI.Phone.Notifications.LoadHashtags(Hashtags)
        })
        //MI.Phone.Animations.TopSlideUp(".twitter-new-tweet-tab", 450, -120);
        returnDetail()
    } else {
       MI.Phone.Notifications.Add("fab fa-twitter", "Twitter", "Fill a message!", "#1DA1F2");
    };
    $('#tweet-new-url').val("");
    $("#tweet-new-message").val("");
});


$(document).on('click', '#advert-button', function(e){
    e.preventDefault();
    var Advert = $("#new-textarea").val();
    let picture = postImageUrl;

    if (Advert !== "") {
        $(".advert-home").animate({
            left: 0+"vh"
        });
        $(".new-advert").animate({
            left: -30+"vh"
        });
        if (!picture){
            $.post('https://Unique_Phone/PostAdvert', JSON.stringify({
                message: Advert,
                url: null
            }));
            returnDetail()
        }else {
            $.post('https://Unique_Phone/PostAdvert', JSON.stringify({
                message: Advert,
                url: picture
            }));
            returnDetail()
        }
        $("#new-textarea").val(' ');
    } else {
       MI.Phone.Notifications.Add("fas fa-ad", "Advertisement", "You can\'t post an empty ad!", "#ff8f1a", 2000);
    }
});

