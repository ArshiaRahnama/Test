var price = 0
var disabledValues = {}
var currentValue = {}
var isSelectingPayType = false
var direction = ""
var handsUpKey = null

String.prototype.format = function() {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp('\\{'+i+'\\}', 'gi');
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};

window.addEventListener('message', function(event) {
    var item = event.data;
    if (item.action == "openClothestore") {
        $('.categories').empty()
        $("body").fadeIn(100)
        document.getElementById("rotate-input").value = (item.currentRotate).toString()
        document.getElementById("distance-input").value = (item.currentDistance).toString()

        $('#headerName').text(translate.create_character);
        $('#headerCategory').text(translate.select_category);

        $(".accept-skin").show()
        $(".pay-cash").hide()
        $(".pay-bank").hide()

        $('#rotate-text').text(translate.rotate);
        $('#distance-text').text(translate.distance);
        $('#buy').text((translate.buy).format(item.price));
        $('#cancel').text(translate.cancel);
        price = item.price
        handsUpKey = item.handsUpKey
        disabledValues = item.disabledValues

        
        if (!item.enableHandsUpButton) {
            $('.hands-up').hide()
        }

        if (item.categories) {
            if (item.categories['hats']) {
                $('.categories').append(`
                    <div class="hats categoryBtn" data-type="hats">
                        <img class="itemIcon" width="55" height="55" src="icons/hats.svg">
                    </div>
                `)
            }
            if (item.categories['masks']) {
                $('.categories').append(`
                    <div class="masks categoryBtn" data-type="masks">
                        <img class="itemIcon" width="55" height="55" src="icons/masks.svg">
                    </div>
                `)
            }
            if (item.categories['torsos']) {
                $('.categories').append(`
                    <div class="torsos categoryBtn" data-type="torsos">
                        <img class="itemIcon" width="55" height="55" src="icons/torsos.svg">
                    </div>
                `)
            }
            if (item.categories['bproofs']) {
                $('.categories').append(`
                    <div class="bproofs categoryBtn" data-type="bproofs">
                        <img class="itemIcon" width="55" height="55" src="icons/bproofs.svg">
                    </div>
                `)
            }
            if (item.categories['pants']) {
                $('.categories').append(`
                    <div class="pants categoryBtn" data-type="pants">
                        <img class="itemIcon" width="55" height="55" src="icons/pants.svg">
                    </div>
                `)
            }
            if (item.categories['shoes']) {
                $('.categories').append(`
                    <div class="shoes categoryBtn" data-type="shoes">
                        <img class="itemIcon" width="55" height="55" src="icons/shoes.svg">
                    </div>
                `)
            }
            if (item.categories['chains']) {
                $('.categories').append(`
                    <div class="chains categoryBtn" data-type="chains">
                        <img class="itemIcon" width="55" height="55" src="icons/chains.svg">
                    </div>
                `)
            }
            if (item.categories['glasses']) {
                $('.categories').append(`
                    <div class="glasses categoryBtn" data-type="glasses">
                        <img class="itemIcon" width="55" height="55" src="icons/glasses.svg">
                    </div>
                `)
            }
            if (item.categories['watches']) {
                $('.categories').append(`
                    <div class="watches categoryBtn" data-type="watches">
                        <img class="itemIcon" width="55" height="55" src="icons/watches.svg">
                    </div>
                `)
            }
            if (item.categories['ears']) {
                $('.categories').append(`
                    <div class="ears categoryBtn" data-type="ears">
                        <img class="itemIcon" width="55" height="55" src="icons/ears.svg">
                    </div>
                `)
            }
            if (item.categories['bags']) {
                $('.categories').append(`
                    <div class="bags categoryBtn" data-type="bags">
                        <img class="itemIcon" width="55" height="55" src="icons/bags.svg">
                    </div>
                `)
            }
        }

        for (const [key, value] of Object.entries(item.data)) {
            currentValue[key] = {min: value.min, value: value.value, max: value.max, excluded: []}
        }

        for (const [k, v] of Object.entries(currentValue)) {
            if (disabledValues[k]) {
                for (const [_k, _v] of Object.entries(disabledValues[k])) {
                    v.excluded.push(_v)
                }
            }
        }
    }
    if (item.action == 'updateInputs') {
        document.getElementById("distance-input").value = (item.fov).toString()
    }
    if (item.action == 'updateSecondValue') {
        document.getElementById(`${item.secondItem}-range`).max = item.secondValue
        document.getElementById(`${item.secondItem}-range`).value = 0
        $(`#${item.secondItem}-value`).html(0)
        $(`#${item.secondItem}-max`).html(item.secondValue)
    }
    if (item.action == 'close') {
        $("body").css("display", "none")
        $('.panel').empty()
    }
});

$(document).on('click', '.accept-skin', function(e) {
    $(".accept-skin").hide()
    $(".pay-cash").show()
    $(".pay-bank").show()
    isSelectingPayType = true
})

$(document).on('click', '.pay-cash', function(e) {
    $.post('https://unique_clothestore/buyClothes', JSON.stringify({price: price, type: "cash"}));
})

$(document).on('click', '.pay-bank', function(e) {
    $.post('https://unique_clothestore/buyClothes', JSON.stringify({price: price, type: "bank"}));
})

$(document).on('click', '.cancel-skin', function(e) {
    $.post('https://unique_clothestore/cancelClothes');
})

$(document).on('click', '.hands-up', function(e) {
    $.post('https://unique_clothestore/hands_up');
})

$(document).on('click', '.categoryBtn', function(e) {
    $('.panel').empty()
    $('#headerCategory').html(translate.category[$(this).data("type")])
    changeCamera($(this).data("type"))
    if (isSelectingPayType) {
        $(".accept-skin").show()
        $(".pay-cash").hide()
        $(".pay-bank").hide()
    }
    switch ($(this).data("type")) {
        case "hats":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_helmet}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_helmet_1}</p>
                                    <p class="item-value">
                                        <span id="helmet_1-value">${currentValue['helmet_1'].value}</span>/<span id="helmet_1-max">${currentValue['helmet_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['helmet_1'].min}" max="${currentValue['helmet_1'].max}" value="${currentValue['helmet_1'].value}" data-excluded="${currentValue['helmet_1'].excluded}" class="input-value-radius" id="helmet_1-range" oninput="changeRange('helmet_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_helmet_2}</p>
                                    <p class="item-value">
                                        <span id="helmet_2-value">${currentValue['helmet_2'].value}</span>/<span id="helmet_2-max">${currentValue['helmet_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['helmet_2'].min}" max="${currentValue['helmet_2'].max}" value="${currentValue['helmet_2'].value}" class="input-value-radius" id="helmet_2-range" oninput="changeRange('helmet_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break;
        case "masks":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_mask}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_mask_1}</p>
                                    <p class="item-value">
                                        <span id="mask_1-value">${currentValue['mask_1'].value}</span>/<span id="mask_1-max">${currentValue['mask_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['mask_1'].min}" max="${currentValue['mask_1'].max}" value="${currentValue['mask_1'].value}" data-excluded="${currentValue['mask_1'].excluded}" class="input-value-radius" id="mask_1-range" oninput="changeRange('mask_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_mask_2}</p>
                                    <p class="item-value">
                                        <span id="mask_2-value">${currentValue['mask_2'].value}</span>/<span id="mask_2-max">${currentValue['mask_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['mask_2'].min}" max="${currentValue['mask_2'].max}" value="${currentValue['mask_2'].value}" class="input-value-radius" id="mask_2-range" oninput="changeRange('mask_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break;
        case "torsos":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_tshirt}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_tshirt_1}</p>
                                    <p class="item-value">
                                        <span id="tshirt_1-value">${currentValue['tshirt_1'].value}</span>/<span id="tshirt_1-max">${currentValue['tshirt_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['tshirt_1'].min}" max="${currentValue['tshirt_1'].max}" value="${currentValue['tshirt_1'].value}" data-excluded="${currentValue['tshirt_1'].excluded}" class="input-value-radius" id="tshirt_1-range" oninput="changeRange('tshirt_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_tshirt_2}</p>
                                    <p class="item-value">
                                        <span id="tshirt_2-value">${currentValue['tshirt_2'].value}</span>/<span id="tshirt_2-max">${currentValue['tshirt_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['tshirt_2'].min}" max="${currentValue['tshirt_2'].max}" value="${currentValue['tshirt_2'].value}" class="input-value-radius" id="tshirt_2-range" oninput="changeRange('tshirt_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="item-block">
                    <p class="item-title">${translate.title_torso}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_torso_1}</p>
                                    <p class="item-value">
                                        <span id="torso_1-value">${currentValue['torso_1'].value}</span>/<span id="torso_1-max">${currentValue['torso_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['torso_1'].min}" max="${currentValue['torso_1'].max}" value="${currentValue['torso_1'].value}" data-excluded="${currentValue['torso_1'].excluded}" class="input-value-radius" id="torso_1-range" oninput="changeRange('torso_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_torso_2}</p>
                                    <p class="item-value">
                                        <span id="torso_2-value">${currentValue['torso_2'].value}</span>/<span id="torso_2-max">${currentValue['torso_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['torso_2'].min}" max="${currentValue['torso_2'].max}" value="${currentValue['torso_2'].value}" class="input-value-radius" id="torso_2-range" oninput="changeRange('torso_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="item-block">
                    <p class="item-title">${translate.title_arms}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_arms}</p>
                                    <p class="item-value">
                                        <span id="arms-value">${currentValue['arms'].value}</span>/<span id="arms-max">${currentValue['arms'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['arms'].min}" max="${currentValue['arms'].max}" value="${currentValue['arms'].value}" data-excluded="${currentValue['arms'].excluded}" class="input-value-radius" id="arms-range" oninput="changeRange('arms')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_arms_2}</p>
                                    <p class="item-value">
                                        <span id="arms_2-value">${currentValue['arms_2'].value}</span>/<span id="arms_2-max">${currentValue['arms_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['arms_2'].min}" max="${currentValue['arms_2'].max}" value="${currentValue['arms_2'].value}" class="input-value-radius" id="arms_2-range" oninput="changeRange('arms_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="item-block">
                    <p class="item-title">${translate.title_decals}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_decals_1}</p>
                                    <p class="item-value">
                                        <span id="decals_1-value">${currentValue['decals_1'].value}</span>/<span id="decals_1-max">${currentValue['decals_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['decals_1'].min}" max="${currentValue['decals_1'].max}" value="${currentValue['decals_1'].value}" data-excluded="${currentValue['decals_1'].excluded}" class="input-value-radius" id="decals_1-range" oninput="changeRange('decals_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_decals_2}</p>
                                    <p class="item-value">
                                        <span id="decals_2-value">${currentValue['decals_2'].value}</span>/<span id="decals_2-max">${currentValue['decals_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['decals_2'].min}" max="${currentValue['decals_2'].max}" value="${currentValue['decals_2'].value}" class="input-value-radius" id="decals_2-range" oninput="changeRange('decals_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break;
        case "bproofs":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_bproof}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_bproof_1}</p>
                                    <p class="item-value">
                                        <span id="bproof_1-value">${currentValue['bproof_1'].value}</span>/<span id="bproof_1-max">${currentValue['bproof_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['bproof_1'].min}" max="${currentValue['bproof_1'].max}" value="${currentValue['bproof_1'].value}" data-excluded="${currentValue['bproof_1'].excluded}" class="input-value-radius" id="bproof_1-range" oninput="changeRange('bproof_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_bproof_2}</p>
                                    <p class="item-value">
                                        <span id="bproof_2-value">${currentValue['bproof_2'].value}</span>/<span id="bproof_2-max">${currentValue['bproof_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['bproof_2'].min}" max="${currentValue['bproof_2'].max}" value="${currentValue['bproof_2'].value}" class="input-value-radius" id="bproof_2-range" oninput="changeRange('bproof_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break;
        case "pants":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_pants}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_pants_1}</p>
                                    <p class="item-value">
                                        <span id="pants_1-value">${currentValue['pants_1'].value}</span>/<span id="pants_1-max">${currentValue['pants_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['pants_1'].min}" max="${currentValue['pants_1'].max}" value="${currentValue['pants_1'].value}" data-excluded="${currentValue['pants_1'].excluded}" class="input-value-radius" id="pants_1-range" oninput="changeRange('pants_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_pants_2}</p>
                                    <p class="item-value">
                                        <span id="pants_2-value">${currentValue['pants_2'].value}</span>/<span id="pants_2-max">${currentValue['pants_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['pants_2'].min}" max="${currentValue['pants_2'].max}" value="${currentValue['pants_2'].value}" class="input-value-radius" id="pants_2-range" oninput="changeRange('pants_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break;
        case "shoes":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_shoes}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_shoes_1}</p>
                                    <p class="item-value">
                                        <span id="shoes_1-value">${currentValue['shoes_1'].value}</span>/<span id="shoes_1-max">${currentValue['shoes_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['shoes_1'].min}" max="${currentValue['shoes_1'].max}" value="${currentValue['shoes_1'].value}" data-excluded="${currentValue['shoes_1'].excluded}" class="input-value-radius" id="shoes_1-range" oninput="changeRange('shoes_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_shoes_2}</p>
                                    <p class="item-value">
                                        <span id="shoes_2-value">${currentValue['shoes_2'].value}</span>/<span id="shoes_2-max">${currentValue['shoes_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['shoes_2'].min}" max="${currentValue['shoes_2'].max}" value="${currentValue['shoes_2'].value}" class="input-value-radius" id="shoes_2-range" oninput="changeRange('shoes_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break;
        case "chains":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_chain}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_chain_1}</p>
                                    <p class="item-value">
                                        <span id="chain_1-value">${currentValue['chain_1'].value}</span>/<span id="chain_1-max">${currentValue['chain_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['chain_1'].min}" max="${currentValue['chain_1'].max}" value="${currentValue['chain_1'].value}" data-excluded="${currentValue['chain_1'].excluded}" class="input-value-radius" id="chain_1-range" oninput="changeRange('chain_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_chain_2}</p>
                                    <p class="item-value">
                                        <span id="chain_2-value">${currentValue['chain_2'].value}</span>/<span id="chain_2-max">${currentValue['chain_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['chain_2'].min}" max="${currentValue['chain_2'].max}" value="${currentValue['chain_2'].value}" class="input-value-radius" id="chain_2-range" oninput="changeRange('chain_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break
        case "glasses":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_glasses}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_glasses_1}</p>
                                    <p class="item-value">
                                        <span id="glasses_1-value">${currentValue['glasses_1'].value}</span>/<span id="glasses_1-max">${currentValue['glasses_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['glasses_1'].min}" max="${currentValue['glasses_1'].max}" value="${currentValue['glasses_1'].value}" data-excluded="${currentValue['glasses_1'].excluded}" class="input-value-radius" id="glasses_1-range" oninput="changeRange('glasses_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_glasses_2}</p>
                                    <p class="item-value">
                                        <span id="glasses_2-value">${currentValue['glasses_2'].value}</span>/<span id="glasses_2-max">${currentValue['glasses_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['glasses_2'].min}" max="${currentValue['glasses_2'].max}" value="${currentValue['glasses_2'].value}" class="input-value-radius" id="glasses_2-range" oninput="changeRange('glasses_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break
        case "watches":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_watches}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_watches_1}</p>
                                    <p class="item-value">
                                        <span id="watches_1-value">${currentValue['watches_1'].value}</span>/<span id="watches_1-max">${currentValue['watches_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['watches_1'].min}" max="${currentValue['watches_1'].max}" value="${currentValue['watches_1'].value}" data-excluded="${currentValue['watches_1'].excluded}" class="input-value-radius" id="watches_1-range" oninput="changeRange('watches_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_watches_2}</p>
                                    <p class="item-value">
                                        <span id="watches_2-value">${currentValue['watches_2'].value}</span>/<span id="watches_2-max">${currentValue['watches_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['watches_2'].min}" max="${currentValue['watches_2'].max}" value="${currentValue['watches_2'].value}" class="input-value-radius" id="watches_2-range" oninput="changeRange('watches_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="item-block">
                    <p class="item-title">${translate.title_bracelets}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_bracelets_1}</p>
                                    <p class="item-value">
                                        <span id="bracelets_1-value">${currentValue['bracelets_1'].value}</span>/<span id="bracelets_1-max">${currentValue['bracelets_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['bracelets_1'].min}" max="${currentValue['bracelets_1'].max}" value="${currentValue['bracelets_1'].value}" data-excluded="${currentValue['bracelets_1'].excluded}" class="input-value-radius" id="bracelets_1-range" oninput="changeRange('bracelets_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_bracelets_2}</p>
                                    <p class="item-value">
                                        <span id="bracelets_2-value">${currentValue['bracelets_2'].value}</span>/<span id="bracelets_2-max">${currentValue['bracelets_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['bracelets_2'].min}" max="${currentValue['bracelets_2'].max}" value="${currentValue['bracelets_2'].value}" class="input-value-radius" id="bracelets_2-range" oninput="changeRange('bracelets_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break
        case "ears":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_ears}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_ears_1}</p>
                                    <p class="item-value">
                                        <span id="ears_1-value">${currentValue['ears_1'].value}</span>/<span id="ears_1-max">${currentValue['ears_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['ears_1'].min}" max="${currentValue['ears_1'].max}" value="${currentValue['ears_1'].value}" data-excluded="${currentValue['ears_1'].excluded}" class="input-value-radius" id="ears_1-range" oninput="changeRange('ears_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_ears_2}</p>
                                    <p class="item-value">
                                        <span id="ears_2-value">${currentValue['ears_2'].value}</span>/<span id="ears_2-max">${currentValue['ears_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['ears_2'].min}" max="${currentValue['ears_2'].max}" value="${currentValue['ears_2'].value}" class="input-value-radius" id="ears_2-range" oninput="changeRange('ears_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break
        case "bags":
            $('.panel').html(`
                <div class="item-block">
                    <p class="item-title">${translate.title_bags}</p>
                    <div class="item-bar">
                        <div class="second-item-bar">
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_bags_1}</p>
                                    <p class="item-value">
                                        <span id="bags_1-value">${currentValue['bags_1'].value}</span>/<span id="bags_1-max">${currentValue['bags_1'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['bags_1'].min}" max="${currentValue['bags_1'].max}" value="${currentValue['bags_1'].value}" data-excluded="${currentValue['bags_1'].excluded}" class="input-value-radius" id="bags_1-range" oninput="changeRange('bags_1')">
                                </div>
                            </div>
                            <div class="item-option">
                                <div class="item-values">
                                    <p class="item-subname">${translate.sub_bags_2}</p>
                                    <p class="item-value">
                                        <span id="bags_2-value">${currentValue['bags_2'].value}</span>/<span id="bags_2-max">${currentValue['bags_2'].max}</span>
                                    </p>
                                </div>
                                <div class="item-suboptions">
                                    <input type="range" min="${currentValue['bags_2'].min}" max="${currentValue['bags_2'].max}" value="${currentValue['bags_2'].value}" class="input-value-radius" id="bags_2-range" oninput="changeRange('bags_2')">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `)
            break
    }
});

function changeRotate() {
    var changedRotate = document.getElementById('rotate-input').value
    $.post('https://unique_clothestore/change_rotate', JSON.stringify({rotate: changedRotate}));
}

function changeDistance() {
    var changedDistance = document.getElementById('distance-input').value
    $.post('https://unique_clothestore/change_distance', JSON.stringify({distance: changedDistance}));
}

function changeCamera(type) {
    $.post('https://unique_clothestore/change_camera', JSON.stringify({type: type}));
}

function changeRange(item) {
    if (isSelectingPayType) {
        $(".accept-skin").show()
        $(".pay-cash").hide()
        $(".pay-bank").hide()
    }

    let inputValue = parseInt($(`#${item}-range`).val())
    let result = inputValue
    if ($(`#${item}-range`).data('excluded')) {
        var excludedValues = $(`#${item}-range`).data('excluded').split(',').map(Number)
        if (excludedValues.includes(inputValue)) {
            result = findClosestValue(inputValue, excludedValues);
            $(`#${item}-range`).val(result);
        }
    }
    if (result != currentValue[item].value) {
        currentValue[item].value = result
        $.post('https://unique_clothestore/change', JSON.stringify({
            type: item,
            new: Number(result)
        }));
        $(`#${item}-value`).html(currentValue[item].value)
    }
}

function findClosestValue(value, excludedValues) {
    var closestValue = value;
    while (excludedValues.includes(closestValue)) {
        if (direction == "left") {
            closestValue--;
        } else {
            closestValue++;
        }
    }
    return closestValue;
}

$(document).on("keydown", function (event) {
    if (event.keyCode == 37) {
        direction = "left"
    } else if (event.keyCode == 39) {
        direction = "right"
    } else if (event.key == handsUpKey) {
        $.post('https://unique_clothestore/hands_up')
    }
});