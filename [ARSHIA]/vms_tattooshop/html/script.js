var clientId = null
var tattooList = {}
var catNumber = 0
var selectedCategory = null
var selectedTattoo = null

window.addEventListener('message', function(event){
    var item = event.data;
    if (item.action == "show") {
        $("body").css("display", "block")
        if (item.clientId) {
            clientId = item.clientId
        }
        tattooList = item.TattooList
    }
    if (item.action == "hide") {
        $("body").css("display", "none")
    }
    if (item.action == "openAgain") {
        $("body").css("display", "block")
    }
    if (item.action == "updateui") {
        tattooList = item.TattooList
        loadCategory(item.collection, catNumber)
    }
});

$(".itemCircle").click(function() {
    if (selectedCategory) {
        $(selectedCategory).removeClass("category-selected");
    }
    selectedCategory = $(this)
    $(selectedCategory).addClass("category-selected");
    var type = $(this).data("type")
    catNumber = $(this).data("number")
    loadCategory(type, catNumber)
})

$("#hide").click(function() {
    if (clientId) {
        $.post('https://vms_tattooshop/hide', JSON.stringify({clientId: clientId}));
        clientId = undefined
    } else {
        $.post('https://vms_tattooshop/hide', JSON.stringify({}));
    }
})
$(document).on('click', '#remove', function(e){
    var collection = $(this).data("collection")
    var id = $(this).data("tattooid")
    if (clientId) {
        $.post('https://vms_tattooshop/remove', JSON.stringify({
            clientId: clientId,
            collection: collection,
            id: id
        }));
    } else {
        $.post('https://vms_tattooshop/remove', JSON.stringify({
            collection: collection,
            id: id
        }));
    }
})
$(document).on('click', '#buy', function(e){
    var collection = $(this).data("collection")
    var id = $(this).data("tattooid")
    if (clientId) {
        $.post('https://vms_tattooshop/buy', JSON.stringify({
            clientId: clientId,
            collection: collection,
            id: id
        }));
    } else {
        $.post('https://vms_tattooshop/buy', JSON.stringify({
            collection: collection,
            id: id
        }));
    }
})

$(document).on('click', '#show', function(e){
    if (selectedTattoo) {
        $(selectedTattoo).removeClass("tattoo-selected");
    }
    selectedTattoo = $(this)
    var collection = $(this).data("collection")
    var id = $(this).data("tattooid")
    $(selectedTattoo).addClass("tattoo-selected");
    if (clientId) {
        $.post('https://vms_tattooshop/change', JSON.stringify({
            item: id,
            collection: collection,
            clientId: clientId,
        }));
    } else {
        $.post('https://vms_tattooshop/change', JSON.stringify({
            item: id,
            collection: collection
        }));
    }
})

function loadCategory(typeDlc, numberOfSelected) {
    var type = typeDlc
    var catNumber = numberOfSelected
    if (clientId) {
        $.post('https://vms_tattooshop/switchCategory', JSON.stringify({clientId: clientId}));
    } else {
        $.post('https://vms_tattooshop/switchCategory', JSON.stringify({}))
    }
    $("#panelInside").empty()
    $("#panelInside").html(`
        <div>
            <div style="width: 92%;margin-left: auto;margin-right: auto;margin-top: 5%;height: 45%;background-color: rgb(25, 25, 25);border-radius: 12px;">
                <div style="display: inline-flex;margin: 10px;width: 100%;">
                    <div style="margin-right: 15px;width: 100%;">
                        <p style="font-family: 'Montserrat', sans-serif;text-align:left;color: #dededef9;font-size:15px">${translate.category}<b>${catNumber}</b></p>
                        <div class="tattoosCategories">

                        </div>
                    </div>
                </div>
            </div>
        </div>
    `)
    for (const [key, value] of Object.entries(tattooList[`${type}`])) {
        var itemPrice = (value.hasTattoo && value.removePrice || value.price)
        var baseTattoosMenu = `
            <div style="width: 100%;height: 2vw;">
                <div style="display: flex;width: 100%;">
                    <p style="font-family: 'Montserrat', sans-serif;font-weight: bold;color: white;width: inherit;margin-block: 5px;">${value.label}</p>
                <div>
                <div style="display: flex;">
                    <div style="color: white;padding-inline: 22px;height: 30px;background: #ffffff17;border-radius: 5px;margin-inline: 4px;">
                        <p style="font-family: 'Montserrat', sans-serif;color: white;margin-block: 4px;color: greenyellow;text-shadow: 0px 0px 5px rgba(172, 255, 47, 0.543);">${itemPrice}€</p>
                    </div>`
        if (value.hasTattoo) {
            baseTattoosMenu = baseTattoosMenu + `
                <div id="remove" data-tattooid="${key}" data-collection="${type}" style="width: 30px;height: 30px;background: #ff3b48;border-radius: 5px;text-align: center;margin-inline: 4px;">
                    <i style="color: white;margin-block: 7px" class="fa-solid fa-trash"></i>
                </div>
            `
        } else {
            baseTattoosMenu = baseTattoosMenu + `
                <div id="buy" data-tattooid="${key}" data-collection="${type}" style="width: 30px;height: 30px;background: #4fff2fb0;border-radius: 5px;text-align: center;margin-inline: 4px;">
                    <i style="color: white;margin-block: 7px" class="fa-solid fa-dollar-sign"></i>
                </div>
            `
        }
        baseTattoosMenu = baseTattoosMenu + `
                    <div id="show" data-tattooid="${key}" data-collection="${type}" style="width: 30px;height: 30px;background: #d91b1bb0;border-radius: 5px;text-align: center;margin-inline: 4px;"">
                        <i style="color: white;margin-block: 7px;" class="fa-solid fa-eye"></i>
                    </div>
                </div>
            </div>
        `
        $(".tattoosCategories").append(baseTattoosMenu)
    }
    if (selectedTattoo) {
        $(selectedTattoo).addClass("tattoo-selected");
    }
}