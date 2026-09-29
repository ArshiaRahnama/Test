let translation = [];

var number = Intl.NumberFormat('en-US', {minimumFractionDigits: 0});

String.prototype.format = function() {
    var formatted = this;
    for (var i = 0; i < arguments.length; i++) {
        var regexp = new RegExp('\\{'+i+'\\}', 'gi');
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};

let currentMenu = null;
let selectedOption = null;

let useBuildInBalance = true;
let removeBalanceFromMenu = false;
let balanceAlreadyRemoved = false;

var isEmployee = false;
var isManager = false;
var isBoss = false;
var cityhallGrades = false;

let useCityHall = false;
let useCityHallResumes = false;
let useCityHallTaxes = false;
let taxBusinessAllowMakeDelayedDeclarations = false;
let taxBusinessPercentagePerMonthForDelay = false;

let isPreview = false;

let hairFades = null;
let tempTattoos = [];
let useTattooshopFade = null;

var skinManager = null
var clientId
var currentItem
var prices
var CustomNames = {}
var isChangingHairStyle = false
var currentValue = {
    ["hair_1"]: { min: 0, value: 0, max: 0},
    ["hair_2"]: { min: 0, value: 0, max: 0},
    ["hair_color_1"]: { min: 0, value: 0, max: 0},
    ["hair_color_2"]: { min: 0, value: 0, max: 0},
    ["beard_1"]: { min: 0, value: 0, max: 0},
    ["beard_2"]: { min: 0, value: 0, max: 0},
    ["beard_3"]: { min: 0, value: 0, max: 0},
    ["eye_color"]: { min: 0, value: 0, max: 0},
    ["eyebrows_1"]: { min: 0, value: 0, max: 0},
    ["eyebrows_2"]: { min: 0, value: 0, max: 0},
    ["eyebrows_3"]: { min: 0, value: 0, max: 0},
    ["makeup_1"]: { min: 0, value: 0, max: 0},
    ["makeup_2"]: { min: 0, value: 0, max: 0},
    ["makeup_3"]: { min: 0, value: 0, max: 0},
    ["makeup_4"]: { min: 0, value: 0, max: 0},
    ["lipstick_1"]: { min: 0, value: 0, max: 0},
    ["lipstick_2"]: { min: 0, value: 0, max: 0},
    ["lipstick_3"]: { min: 0, value: 0, max: 0},
    ["blush_1"]: { min: 0, value: 0, max: 0},
    ["blush_2"]: { min: 0, value: 0, max: 0},
    ["blush_3"]: { min: 0, value: 0, max: 0},
}

var currentTattoos = []

window.addEventListener("load", function () {
    $.post(`https://${GetParentResourceName()}/loaded`)
});

window.addEventListener('message', function (event) {
    var item = event.data;
    switch (item.action) {
        case 'loaded':
            let lang = item.lang;
            
            useBuildInBalance = item.useBuildInBalance;
            removeBalanceFromMenu = item.removeBalanceFromMenu;
            
            useTattooshopFade = item.useTattooshopFade;

            useCityHall = item.useCityHall;
            useCityHallResumes = item.useCityHallResumes;
            useCityHallTaxes = item.useCityHallTaxes;
            useCityHallIncludedTaxes = item.useCityHallIncludedTaxes;

            taxBusinessAllowMakeDelayedDeclarations = item.taxBusinessAllowMakeDelayedDeclarations;
            taxBusinessPercentagePerMonthForDelay = item.taxBusinessPercentagePerMonthForDelay;

            $.ajax({
                url: '../config/translation.json',
                type: 'GET',
                dataType: 'json',
                success: function (code, statut) {
                    if (!code[lang]) {
                        translation = code["EN"];
                        console.warn(`^7Selected language ^1"${lang}"^7 not found, changed to ^2"EN"^7, configure your language in translation.json.`);
                    } else {
                        translation = code[lang];
                    }
                    
                    $('#payment > div > div[data-type="cash"] > p').text(translation.payments.cash);
                    $('#payment > div > div[data-type="bank"] > p').text(translation.payments.bank);
                    $('#payment > div > div[data-type="receipt"] > p').text(translation.payments.receipt);

                    $("#barber .header > p").html(translation.menu_header);
                    $("#barber .itemCircle.camrotate_circle > p").html(translation.rotate_help);
                    $("#barber #buy > p").html(translation.proceed_to_finalization);


                    $('.receipt > .receipt-texts > .header-label').text(translation.receipt.header)
                    $('.receipt > .receipt-texts .item').text(translation.receipt.item)
                    $('.receipt > .receipt-texts .amount').text(translation.receipt.amount)
                    $('.receipt > .receipt-texts .total > div:first-child').text(translation.receipt.total)
                    $('.receipt > .receipt-texts .pay_cash').text(translation.receipt.pay_cash)
                    $('.receipt > .receipt-texts .pay_bank').text(translation.receipt.pay_bank)
                    $('.receipt > .receipt-texts .cancel').text(translation.receipt.cancel)
                    
                    currentValue["hair_1"].name = translation.hair.name;
                    currentValue["hair_1"].label = translation.hair.style;

                    currentValue["hair_color_1"].name = translation.hair.name;
                    currentValue["hair_color_1"].label = translation.hair.color;

                    currentValue["hair_2"].name = translation.hair.name2;
                    currentValue["hair_2"].label = translation.hair.style2;
                    
                    currentValue["hair_color_2"].name = translation.hair.name2;
                    currentValue["hair_color_2"].label = translation.hair.color2;
                    
                    currentValue["beard_1"].name = translation.beard.name;
                    currentValue["beard_1"].label = translation.beard.style;
                    
                    currentValue["beard_2"].name = translation.beard.name;
                    currentValue["beard_2"].label = translation.beard.opacity;
                    
                    currentValue["beard_3"].label = translation.beard.name;
                    currentValue["beard_3"].name = translation.beard.color;
                    
                    currentValue["eye_color"].name = translation.eyes.name;
                    currentValue["eye_color"].label = translation.eyes.color;
                    
                    currentValue["eyebrows_1"].name = translation.eyebrows.name;
                    currentValue["eyebrows_1"].label = translation.eyebrows.style;

                    currentValue["eyebrows_2"].name = translation.eyebrows.name;
                    currentValue["eyebrows_2"].label = translation.eyebrows.opacity;
                    
                    currentValue["eyebrows_3"].name = translation.eyebrows.name;
                    currentValue["eyebrows_3"].label = translation.eyebrows.color;

                    currentValue["makeup_1"].name = translation.makeup.name;
                    currentValue["makeup_1"].label = translation.makeup.style;

                    currentValue["makeup_2"].name = translation.makeup.name;
                    currentValue["makeup_2"].label = translation.makeup.opacity;

                    currentValue["makeup_3"].name = translation.makeup.name;
                    currentValue["makeup_3"].label = translation.makeup.color;

                    currentValue["makeup_4"].name = translation.makeup.name;
                    currentValue["makeup_4"].label = translation.makeup.color2;

                    currentValue["lipstick_1"].name = translation.lipstick.name;
                    currentValue["lipstick_1"].label = translation.lipstick.style;
                    
                    currentValue["lipstick_2"].name = translation.lipstick.name;
                    currentValue["lipstick_2"].label = translation.lipstick.opacity;
                    
                    currentValue["lipstick_3"].name = translation.lipstick.name;
                    currentValue["lipstick_3"].label = translation.lipstick.color;
                    
                    currentValue["blush_1"].name = translation.blush.name;
                    currentValue["blush_1"].label = translation.blush.style;
                    
                    currentValue["blush_2"].name = translation.blush.name;
                    currentValue["blush_2"].label = translation.blush.opacity;
                    
                    currentValue["blush_3"].name = translation.blush.name;
                    currentValue["blush_3"].label = translation.blush.color;

                    
                    // Management Translation:
                    $('.management-menu .side-bar div[data-href="main"] .title').text(translation.management_menu.sidebar.main_title);
                    $('.management-menu .side-bar div[data-href="main"] .description').text(translation.management_menu.sidebar.main_description);
                    $('.management-menu .side-bar div[data-href="employees"] .title').text(translation.management_menu.sidebar.employees_title);
                    $('.management-menu .side-bar div[data-href="employees"] .description').text(translation.management_menu.sidebar.employees_description);
                    $('.management-menu .side-bar div[data-href="boss-management"] .title').text(translation.management_menu.sidebar.boss_management_title);
                    $('.management-menu .side-bar div[data-href="boss-management"] .description').text(translation.management_menu.sidebar.boss_management_description);
                    
                    // Main:
                    $('.management-menu div[data-type="main"] div[data-type="announcements"] .header').text(translation.management_menu.main.menu_announcements_header);
                    $('.management-menu div[data-type="main"] div[data-type="announcements"] .title').text(translation.management_menu.main.menu_announcements_title);
                    $('.management-menu div[data-type="main"] div[data-type="total-customers"] .header').text(translation.management_menu.main.menu_total_customers_header);
                    $('.management-menu div[data-type="main"] div[data-type="total-earned"] .header').text(translation.management_menu.main.menu_total_earned_header);
                    $('.management-menu div[data-type="main"] div[data-type="best-sellers"] .header').text(translation.management_menu.main.menu_best_sellers_header);

                    // Employees:
                    $('.management-menu div[data-type="employees"] .header').text(translation.management_menu.employees.menu_employees_header);
                    $('.management-menu div[data-type="employees"] .title').text(translation.management_menu.employees.menu_employees_title);
                    $('.management-menu div[data-type="employees"] .btn[data-option="get_closest_players"] p').text(translation.management_menu.employees.menu_employees_btn);
                    $('.management-menu div[data-type="employees"] .employees-list #employees-table thead tr th span#employee').text(translation.management_menu.employees.table_employee);
                    $('.management-menu div[data-type="employees"] .employees-list #employees-table thead tr th span#grade').text(translation.management_menu.employees.table_grade);
                    $('.management-menu div[data-type="employees"] .employees-list #employees-table thead tr th span#option').text(translation.management_menu.employees.table_option);

                    // Management:
                    $('.management-menu div[data-type="boss-management"] div[data-type="balance"] .header').text(translation.management_menu.management.menu_balance_header);
                    $('.management-menu div[data-type="boss-management"] div[data-type="balance"] div[data-option="withdraw"] p').text(translation.management_menu.management.menu_balance_btn_withdraw);
                    $('.management-menu div[data-type="boss-management"] div[data-type="balance"] div[data-option="deposit"] p').text(translation.management_menu.management.menu_balance_btn_deposit);
                    $('.management-menu div[data-type="boss-management"] div[data-type="employees-count"] .header').text(translation.management_menu.management.menu_employees_header);
                    $('.management-menu div[data-type="boss-management"] div[data-option="employees"] p').text(translation.management_menu.management.menu_employees_btn_manage);
                    $('.management-menu div[data-type="boss-management"] div[data-type="send-announcement"] .header').text(translation.management_menu.management.menu_announcement_header);
                    $('.management-menu div[data-type="boss-management"] div[data-type="send-announcement"] .title').text(translation.management_menu.management.menu_announcement_title);
                    $('.management-menu div[data-type="boss-management"] div[data-type="send-announcement"] .btn p').text(translation.management_menu.management.menu_announcement_btn_send);

                    if (useCityHall) {
                        let { CityHall_SideBars, CityHall_Menus } = window.mySharedFunction();
                        
                        $('.management-menu > .menu > .side-bar').append(`
                            ${useCityHallResumes ? (CityHall_SideBars.resumes).format(translation.management_menu.sidebar.resumes_title, translation.management_menu.sidebar.resumes_description) : ''}
                            ${useCityHallTaxes ? (CityHall_SideBars.taxes).format(translation.management_menu.sidebar.taxes_title, translation.management_menu.sidebar.taxes_description) : ''}
                        `)
        
                        $('.management-menu > .menu > .main').append(`
                            ${useCityHallResumes ? (CityHall_Menus.resumes).format(
                                translation.management_menu.resumes.list_header,
                                translation.management_menu.resumes.list_title,
        
                                translation.management_menu.resumes.table_citizen,
                                translation.management_menu.resumes.table_date,
                                translation.management_menu.resumes.table_option,
        
                                translation.management_menu.resumes.manage_header,
                                translation.management_menu.resumes.manage_title,
        
                                translation.management_menu.resumes.manage_description,
                                translation.management_menu.resumes.manage_toggle_btn,
                            ) : ''}
    
                            ${useCityHallTaxes ? (CityHall_Menus.taxes).format(
                                translation.management_menu.taxes.taxes_header,
                                translation.management_menu.taxes.taxes_title
                            ) : ''}
                        `)
                    }
                }
            })
            break
        case 'showBarberMenu':
            $("#barber").css('display', 'flex');
            for (const [key, value] of Object.entries(item.data)) {
                if (currentValue[key]) {
                    currentValue[key].default = value.value
                    currentValue[key].value = value.value
                    currentValue[key].min = value.min
                    currentValue[key].max = value.max
                }
            }
            currentMenu = 'barber';
            skinManager = item.skinManager;
            if (item.clientId) {
                clientId = item.clientId;
            }
            if (item.prices) {
                prices = item.prices;
            }
            if (item.hairFades) {
                hairFades = item.hairFades
                tempTattoos = item.tempTattoos
            }
            CustomNames = item.CustomNames;
            selectSection('hair')
            break
        case 'hideBarberMenu':
            currentMenu = null;
            $('#barber').addClass('hide');
			$('#barber').fadeOut(150, function() {
				$(this).removeClass('hide');
			});
            // $("#barber").fadeOut(180);
            break
        case 'openAgain':
            currentMenu = 'barber';

            if (currentValue) {
                for (const [key, value] of Object.entries(currentValue)) {
                    currentValue[key].default = value.value
                }
            }

            currentTattoos = []

            selectSection('basket')
            $('#barber').css({'pointer-events': 'all', 'opacity': '1.0', 'display': 'flex'})
            // $("#barber").css('display', 'flex');
            // $("#barber").fadeIn(180);
            break
        case 'updateCurrentFades':
            if (!useTattooshopFade) return;

            currentTattoos = item.currentTattoos;
            tempTattoos = item.tempTattoos;

            $('.fades>.fades-list>.fade-selection').removeClass('active');
            for (const [id, val] of Object.entries(tempTattoos)) {
                if (val) {
                    $(`.fades>.fades-list>.fade-selection[data-fadeid="${id}"]`).addClass('active');
                }
            };

            break
        case 'openBarberPreview':
            currentMenu = 'barber';
            isPreview = true;
            break
        case 'closeBarberPreview':
            currentMenu = null;
            isPreview = false;
            break
        case 'openManagementMenu':
            isEmployee = item.isEmployee;
            isManager = item.isManager;
            isBoss = item.isBoss;
            cityhallGrades = item.cityhallGrades;
            
            storeCfg = item.storeCfg;
            storeData = item.storeData;
            employees = item.employees;

            // Main Menu - loader:
            $('.management-menu .header .store-name').html(`${translation.management_menu.menu_title}`)

            if (item.isManager || item.isBoss) {
                $('.management-menu .menu .side-bar div[data-href="employees"]').show();
                $('.management-menu .menu .side-bar div[data-href="boss-management"]').show();
                $('.management-menu').addClass(item.isManager && 'isManager' || '').removeClass(item.isBoss && 'isManager' || '').removeClass('isEmployee');
            } else {
                $('.management-menu .menu .side-bar div[data-href="employees"]').hide();
                $('.management-menu .menu .side-bar div[data-href="boss-management"]').hide();
                $('.management-menu').addClass('isEmployee');
            }



            // Announcements - loader:
            let announcementsData = loadAnnoucements(storeData.announcements);
            $('.management-menu div[data-type="main"] div[data-type="announcements"] .announcements-messages').html(announcementsData);

            // Total Customers - loader:
            $('.management-menu div[data-type="main"] div[data-type="total-customers"] .title').html(`${storeData.data.totalCustomers}`);

            // Total Earned - loader:
            $('.management-menu div[data-type="main"] div[data-type="total-earned"] .title').html(`${translation.currency} ${number.format(storeData.data.totalEarned)}`);

            // Employees - loader:
            let employeesData = loadEmployees(employees);
            $('.management-menu div[data-type="employees"] .box .data').html("");
            $('.management-menu div[data-type="employees"] tbody').html(employeesData);

            // Balance - loader:
            if (useBuildInBalance) {
                loadBalance(storeData.data.balance);
            }

            // Employees Count - loader:
            $('.management-menu div[data-type="boss-management"] div[data-type="employees-count"] .title').html(`${item.employeesCount}`)

            // CityHall Resume's - loader:
            let isResumesAllowed = item.isResumesAllowed;
            if (isResumesAllowed != undefined) {
                if (item.isResumesAllowed) {
                    $('.management-menu div[data-type="resumes"] div[data-type="manage"] > .description > span').addClass('active')
                } else {
                    $('.management-menu div[data-type="resumes"] div[data-type="manage"] > .description > span').removeClass('active')
                }
                if (item.resumes) {
                    let resumesList = ``
                    let { CityHall_ResumesElement } = window.mySharedFunction();
                    for (const [_, data] of Object.entries(item.resumes)) {
                        let element = CityHall_ResumesElement;
                        resumesList += element.format(data.sender_name, formatDate(data.date), data.sender)
                    }
                    $('div[data-type="resumes"] .side-boxes > div[data-type="list"] > .resumes-list > table > tbody').html(resumesList);
                }
                $('.management-menu div[data-type="resumes"] div[data-type="manage"] > .description > span').html(isResumesAllowed ? translation.management_menu.resumes.manage_description_active : translation.management_menu.resumes.manage_description_not_active);
            }

            // CityHall Taxes - loader:
            let isTaxesAllowed = item.isTaxesAllowed;
            if (isTaxesAllowed != undefined) {
                if (item.taxes) {
                    let { LoadTaxesMenu } = window.mySharedFunction();
                    $('div[data-type="taxes"] .side-boxes > div[data-type="list"] > .taxes-list').html(LoadTaxesMenu(item.taxes, 'vms_barber'));
                }
            }

            if (cityhallGrades) {
                $('.management-menu .menu .side-bar div[data-href="resumes"]').hide();
                if (cityhallGrades['resumes']) {
                    $('.management-menu .menu .side-bar div[data-href="resumes"]').show();
                }
    
                $('.management-menu .menu .side-bar div[data-href="taxes"]').hide();
                if (cityhallGrades['taxes']) {
                    $('.management-menu .menu .side-bar div[data-href="taxes"]').show();
                }
            }

            currentMenu = 'management';
            updateManagement('main', `.management-menu .side-bar div[data-href="main"]`);
            $('.management-menu').fadeIn(120);
            $('body').fadeIn(150);

            let announcementsChat = document.getElementById("announcements-chat");
            announcementsChat.scrollTop = announcementsChat.scrollHeight;
            break
        case 'closeManagementMenu':
            $('.management-menu').fadeOut(120);
        
            $(`div[data-type="main"]`).fadeOut(120);
            $(`div[data-type="employees"]`).fadeOut(120);
            $(`div[data-type="boss-management"]`).fadeOut(120);
            $(`div[data-type="resumes"]`).fadeOut(120);
            $(`div[data-type="taxes"]`).fadeOut(120);
            
            $('.btn[data-option="deposit"]').show();
            $('.btn[data-option="withdraw"]').show();
            
            $('input[data-input="withdraw"]').val('').hide();
            $('input[data-input="deposit"]').val('').hide();

            $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal').removeClass('isVisible');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');
            break
        case 'updateManagementMenu':
            if (!currentMenu) return;
            if (item.storeData) storeData = item.storeData;

            $('.management-menu div[data-type="main"] div[data-type="announcements"] .announcements-messages').html(loadAnnoucements(storeData.announcements));
            let announcementsChatElement = document.getElementById("announcements-chat");
            announcementsChatElement.scrollTop = announcementsChatElement.scrollHeight;
            
            // Balance - loader:
            if (useBuildInBalance) {
                loadBalance(storeData.data.balance);
            }

            if (item.societyBalance) {
                loadBalance(Number(item.societyBalance));
            };

            if (item.employees) {
                employees = item.employees
                let employeesData = loadEmployees(employees);
                $('.management-menu div[data-type="employees"] tbody').html(employeesData)
            }

            if (item.taxes != undefined) {
                let { LoadTaxesMenu } = window.mySharedFunction();
                $('div[data-type="taxes"] .side-boxes > div[data-type="list"] > .taxes-list').html(LoadTaxesMenu(item.taxes, 'vms_barber'));
            }

            if (item.isResumesAllowed != undefined) {
                if (item.isResumesAllowed) {
                    $('.management-menu div[data-type="resumes"] div[data-type="manage"] > .description > span').addClass('active')
                } else {
                    $('.management-menu div[data-type="resumes"] div[data-type="manage"] > .description > span').removeClass('active')
                }
                $('.management-menu div[data-type="resumes"] div[data-type="manage"] > .description > span').html(item.isResumesAllowed ? translation.management_menu.resumes.manage_description_active : translation.management_menu.resumes.manage_description_not_active);
            }

            if (currentMenu == "employees" && item.players) {
                let players = item.players
                let hireData = ''
                $('.management-menu .main div[data-type="employees"] .box-right .data').html(`<div class="hire-list">${translation.management_menu.employees.menu_employees_no_players}</div>`);
                for (const [k, v] of Object.entries(players)) {
                    hireData += `
                        <div class="hire-player" data-playerid="${v}">
                            <div>${(translation.management_menu.employees.citizen).format(v)}</div>
                            <div class="hire_btn" onclick="hireEmployee(${v})">${translation.management_menu.employees.menu_option_hire_btn}</div>
                        </div>
                    `;
                };
                $('.management-menu .main div[data-type="employees"] .box-right .data .hire-list').html(hireData);
            }
            break
        case 'openReceipt':
            currentMenu = 'receipt';
            
            for (const [key, value] of Object.entries(item.values)) {
                if (key.includes("fade:")) {
                    const extractedValue = key.split("fade:")[1];
                    $('.receipt > .receipt-texts .list').append(`
                        <div class="product">
                            <div>${translation.hair.name3} ${extractedValue}</div>
                            <div>
                                <span>${translation.currency}${value}</span>
                            </div>
                        </div>
                    `);
                } else {
                    $('.receipt > .receipt-texts .list').append(`
                        <div class="product">
                            <div>${currentValue[key].name} ${currentValue[key].label}</div>
                            <div>
                                <span>${translation.currency}${value}</span>
                            </div>
                        </div>
                    `);
                }
            }

            $('.receipt > .receipt-texts .total > div:nth-child(2)').html(`
                <span>${item.totalPrice}${translation.currency}</span>
            `)

            $('.receipt').fadeIn(150);
            break
        case 'closeReceipt':
            // currentMenu = null;
            currentMenu = 'barber';
            isPreview = true;
            $('.receipt').fadeOut(150);
            $('.receipt > .receipt-texts .list').empty()
            break
        case 'billFeedback':
            if (item.status == 1) {
                $('#barber').css({'pointer-events': 'none', 'opacity': '.7'})
            } else {
                $('#barber').css({'pointer-events': 'all', 'opacity': '1.0'})
            }
            break
    }
});

const selectSection = (id) => {
    $.post(`https://${GetParentResourceName()}/clicked`)

    $('#buy').show();
    $('#total').hide();
    $('#payment').hide();

    let data = '';
    if (id == 'hair') {
        data = `
            <div>
                <div>
                    <div>
                        <div class="main">
                            <span class="name">${translation.hair.name}</span>
                            <p>${translation.hair.style}<span class="itemLabel" id="name-hair_1">ㅤ</span> <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["hair_1"].totalAmount || prices["hair_1"].price}</span></p>
                            <div>
                                <button onclick="previous('hair_1')" id="minus">
                                    <i class="fa-solid fa-caret-left"></i>
                                </button>
                                <p class="buttons-text oneButton" id="current-hair_1">${currentValue["hair_1"].value}</p>
                                <button onclick="next('hair_1')" id="plus">
                                    <i class="fa-solid fa-caret-right"></i>
                                </button>
                            </div>
                        </div>
                        <div class="colors">
                            <p>${translation.hair.color} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["hair_color_1"].totalAmount || prices["hair_color_1"].price}</span></p>
                            <div class="colors-list">
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 0)" style="background: #060606;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 1)" style="background: #131313;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 2)" style="background: #303230;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 3)" style="background: #1e0f0a;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 4)" style="background: #4e2a1d;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 5)" style="background: #90543d;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 6)" style="background: #EDC87D;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 7)" style="background: #F5D38F;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 8)" style="background: #F7D99D;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 9)" style="background: #FCE3B2;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 10)" style="background: #c5b495;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 11)" style="background: #dfcdac;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 12)" style="background: #F9E5BF;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 13)" style="background: #e3c48a;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 14)" style="background: #ebd09d;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 15)" style="background: #f6e3c0;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 16)" style="background: #8e8370;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 17)" style="background: #A4530B;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 18)" style="background: #EA3C11;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 19)" style="background: #620000;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 20)" style="background: #8d0000;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 21)" style="background: #ff0505;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 22)" style="background: #ff4242;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 23)" style="background: #ff5c26;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 24)" style="background: #F58159;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 25)" style="background: #ac5c41;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 26)" style="background: #AFABAA;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 27)" style="background: #BCB9B8;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 28)" style="background: #E6E6E6;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 29)" style="background: #FFFFFF;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 30)" style="background: #533c67;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 31)" style="background: #82619f;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 32)" style="background: #7f3286;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 33)" style="background: #ff0ae7;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 34)" style="background: #ff0357;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 35)" style="background: #ff9bcb;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 36)" style="background: #22b1a1;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 37)" style="background: #1e7590;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 38)" style="background: #2231ff;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 39)" style="background: #1def55;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 40)" style="background: #068d60;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 41)" style="background: #154e60;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 42)" style="background: #a0f742;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 43)" style="background: #47F225;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 44)" style="background: #0c9d2c;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 45)" style="background: #CAE57B;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 46)" style="background: #f5bc22;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 47)" style="background: #e2940f;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 48)" style="background: #ff8001;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 49)" style="background: #ff5e00;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 51)" style="background: #d13809;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 56)" style="background: #1b1411;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 57)" style="background: #261d19;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 58)" style="background: #42332d;"></div>
                                <div class="colour-selection" onclick="changeColor('hair_color_1', 61)" style="background: #000;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                ${skinManager != "qb-clothing" && `
                    <div>
                        <div >
                            <div class="main">
                                <span class="name">${translation.hair.name2}</span>
                                <p>${translation.hair.style2} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["hair_2"].totalAmount || prices["hair_2"].price}</span></p>
                                <div>
                                    <button onclick="previous('hair_2')" id="minus">
                                        <i class="fa-solid fa-caret-left"></i>
                                    </button>
                                    <p class="buttons-text oneButton" id="current-hair_2">${currentValue["hair_2"].value}</p>
                                    <button onclick="next('hair_2')" id="plus">
                                        <i class="fa-solid fa-caret-right"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="colors">
                                <p>${translation.hair.color2}<span class="itemLabel" id="name-hair_2">ㅤ</span> <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["hair_color_2"].totalAmount || prices["hair_color_2"].price}</span></p>
                                <div class="colors-list">
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 0)" style="background: #060606;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 1)" style="background: #131313;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 2)" style="background: #303230;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 3)" style="background: #1e0f0a;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 4)" style="background: #4e2a1d;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 5)" style="background: #90543d;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 6)" style="background: #EDC87D;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 7)" style="background: #F5D38F;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 8)" style="background: #F7D99D;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 9)" style="background: #FCE3B2;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 10)" style="background: #c5b495;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 11)" style="background: #dfcdac;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 12)" style="background: #F9E5BF;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 13)" style="background: #e3c48a;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 14)" style="background: #ebd09d;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 15)" style="background: #f6e3c0;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 16)" style="background: #8e8370;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 17)" style="background: #A4530B;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 18)" style="background: #EA3C11;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 19)" style="background: #620000;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 20)" style="background: #8d0000;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 21)" style="background: #ff0505;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 22)" style="background: #ff4242;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 23)" style="background: #ff5c26;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 24)" style="background: #F58159;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 25)" style="background: #ac5c41;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 26)" style="background: #AFABAA;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 27)" style="background: #BCB9B8;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 28)" style="background: #E6E6E6;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 29)" style="background: #FFFFFF;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 30)" style="background: #533c67;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 31)" style="background: #82619f;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 32)" style="background: #7f3286;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 33)" style="background: #ff0ae7;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 34)" style="background: #ff0357;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 35)" style="background: #ff9bcb;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 36)" style="background: #22b1a1;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 37)" style="background: #1e7590;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 38)" style="background: #2231ff;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 39)" style="background: #1def55;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 40)" style="background: #068d60;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 41)" style="background: #154e60;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 42)" style="background: #a0f742;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 43)" style="background: #47F225;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 44)" style="background: #0c9d2c;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 45)" style="background: #CAE57B;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 46)" style="background: #f5bc22;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 47)" style="background: #e2940f;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 48)" style="background: #ff8001;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 49)" style="background: #ff5e00;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 51)" style="background: #d13809;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 56)" style="background: #1b1411;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 57)" style="background: #261d19;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 58)" style="background: #42332d;"></div>
                                    <div class="colour-selection" onclick="changeColor('hair_color_2', 61)" style="background: #000;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                ` || ``}
            `
            if (useTattooshopFade) {
                data += `
                    <div>
                        <div>
                            <div class="main">
                                <span class="name">${translation.hair.name3}</span>
                            </div>
                            <div class="fades">
                                <div class="fades-list">
                `
                
                for (const [id, val] of Object.entries(hairFades)) {
                    data += `
                        <div class="fade-selection ${tempTattoos[String(Number(id) + 1)] && 'active'}" data-fadeid="${Number(id) + 1}" onclick="changeFade(${Number(id) + 1})">${Number(id) + 1}</div>
                    `
                };
                
                data += `
                                </div>
                            </div>
                        </div>
                    </div>
                `
                
            }
        data += `</div>`
    } else if (id == 'eye') {
        data = `
            <div>
                <div>
                    <div>
                        <div class="colors colors2">
                            <span class="name">${translation.eyes.name}</span>
                            <p>${translation.eyes.color} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["eye_color"].totalAmount || prices["eye_color"].price}</span></p>
                            <div class="colors-list">
                                <div class="colour-selection" onclick="changeColor('eye_color', 0)" style="background: #0d3b14;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 1)" style="background: #196e26;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 2)" style="background: #4e7c8a;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 3)" style="background: #154775;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 4)" style="background: #735139;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 5)" style="background: #2e1f14;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 6)" style="background: #915f3a;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 7)" style="background: #454545;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 8)" style="background: #7d7d7d;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 9)" style="background: #a74cb5;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 10)" style="background: #c2ae2b;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 11)" style="background: #772bc2;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 12)" style="background: #09080a;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 13)" style="background: #615e63;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 14)" style="background: #cfca4c;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 15)" style="background: linear-gradient(45deg, #fff608 50%, #080808 50%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 16)" style="background: linear-gradient(45deg, #fff 10%, #000 20%, #000 30%, #fff 30%, #fff 40%, #000 40%, #000 50%, #fff 50%, #fff 60%, #000 60%, #000 70%, #fff 70%, #fff 80%, #000 90%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 17)" style="background: #fff"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 18)" style="background: linear-gradient(45deg, #47bef5 45%, #ff8a14 55%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 19)" style="background: linear-gradient(90deg, #fff, #000 40%, #000 60%, #fff);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 20)" style="background: radial-gradient(black 30%, white 40%, red 50%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 21)" style="background: linear-gradient(90deg, #12db15 30%, #000 33%, #000 66%, #12db15 70%"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 22)" style="background: linear-gradient(90deg, #db5512 30%, #000 33%, #000 66%, #db5512 70%"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 23)" style="background: linear-gradient(90deg, #126cdb 30%, #000 33%, #000 66%, #126cdb 70%"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 24)" style="background: linear-gradient(0deg, #dbae32 30%, #000 33%, #000 66%, #dbae32 70%"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 25)" style="background: radial-gradient(black 30%, #ffdf0d 35%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 26)" style="background: black;"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 27)" style="background: radial-gradient(black 30%, red 35%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 28)" style="background: radial-gradient(#0daeff 30%, red 35%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 29)" style="background: radial-gradient(black 30%, #0daeff 35%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 30)" style="background: radial-gradient(black 30%, white 35%, red 120%);"></div>
                                <div class="colour-selection" onclick="changeColor('eye_color', 31)" style="background: radial-gradient(#d6d6d6 30%, white 35%);"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div>
                        <div class="main-two-sections">
                            <div>
                                <span class="name">${translation.eyebrows.name}</span>
                                <p>${translation.eyebrows.style}<span class="itemLabel" id="name-eyebrows_1">ㅤ</span> <span class="itemPrice" style="margin-right: 1.2em;">${translation.currency}${!useCityHallIncludedTaxes && prices["eyebrows_1"].totalAmount || prices["eyebrows_1"].price}</span></p>
                                <div>
                                    <button onclick="previous('eyebrows_1')" id="minus">
                                        <i class="fa-solid fa-caret-left"></i>
                                    </button>
                                    <p class="buttons-text ${skinManager == "qb-clothing" ? 'oneButton' : ''}" id="current-eyebrows_1">${currentValue["eyebrows_1"].value}</p>
                                    <button onclick="next('eyebrows_1')" id="plus">
                                        <i class="fa-solid fa-caret-right"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="sliders-menu">
                                ${skinManager != "qb-clothing" && `
                                    <p>${translation.eyebrows.opacity} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["eyebrows_2"].totalAmount || prices["eyebrows_2"].price}</span></p>
                                    <input type="range" min="0" max="10" value="${currentValue["eyebrows_2"].value}" class="slider" id="eyebrows_2" onmousemove="changeRange('eyebrows_2')">
                                ` || ``}
                            </div>
                        </div>
                        <div class="colors">
                            <p >${translation.eyebrows.color} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["eyebrows_3"].totalAmount || prices["eyebrows_3"].price}</span></p>
                            <div class="colors-list">
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 0)" style="background: #060606;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 1)" style="background: #131313;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 2)" style="background: #303230;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 3)" style="background: #1e0f0a;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 4)" style="background: #4e2a1d;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 5)" style="background: #90543d;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 6)" style="background: #EDC87D;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 7)" style="background: #F5D38F;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 8)" style="background: #F7D99D;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 9)" style="background: #FCE3B2;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 10)" style="background: #c5b495;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 11)" style="background: #dfcdac;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 12)" style="background: #F9E5BF;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 13)" style="background: #e3c48a;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 14)" style="background: #ebd09d;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 15)" style="background: #f6e3c0;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 16)" style="background: #8e8370;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 17)" style="background: #A4530B;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 18)" style="background: #EA3C11;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 19)" style="background: #620000;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 20)" style="background: #8d0000;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 21)" style="background: #ff0505;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 22)" style="background: #ff4242;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 23)" style="background: #ff5c26;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 24)" style="background: #F58159;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 25)" style="background: #ac5c41;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 26)" style="background: #AFABAA;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 27)" style="background: #BCB9B8;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 28)" style="background: #E6E6E6;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 29)" style="background: #FFFFFF;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 30)" style="background: #533c67;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 31)" style="background: #82619f;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 32)" style="background: #7f3286;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 33)" style="background: #ff0ae7;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 34)" style="background: #ff0357;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 35)" style="background: #ff9bcb;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 36)" style="background: #22b1a1;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 37)" style="background: #1e7590;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 38)" style="background: #2231ff;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 39)" style="background: #1def55;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 40)" style="background: #068d60;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 41)" style="background: #154e60;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 42)" style="background: #a0f742;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 43)" style="background: #47F225;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 44)" style="background: #0c9d2c;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 45)" style="background: #CAE57B;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 46)" style="background: #f5bc22;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 47)" style="background: #e2940f;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 48)" style="background: #ff8001;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 49)" style="background: #ff5e00;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 51)" style="background: #d13809;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 56)" style="background: #1b1411;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 57)" style="background: #261d19;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 58)" style="background: #42332d;"></div>
                                <div class="colour-selection" onclick="changeColor('eyebrows_3', 61)" style="background: #000;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `
    } else if (id == 'beard') {
        data = `
            <div>
                <div >
                    <div>
                        <div class="main-two-sections">
                            <div>
                                <span class="name">${translation.beard.name}</span>
                                <p>${translation.beard.style}<span class="itemLabel" id="name-beard_1">ㅤ</span> <span class="itemPrice" style="margin-right: 1.2em;">${translation.currency}${!useCityHallIncludedTaxes && prices["beard_1"].totalAmount || prices["beard_1"].price}</span></p>
                                <div>
                                    <button onclick="previous('beard_1')" id="minus">
                                        <i class="fa-solid fa-caret-left"></i>
                                    </button>
                                    <p class="buttons-text ${skinManager == "qb-clothing" ? 'oneButton' : ''}" id="current-beard_1">${currentValue["beard_1"].value}</p>
                                    <button onclick="next('beard_1')" id="plus">
                                        <i class="fa-solid fa-caret-right"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="sliders-menu">
                                ${skinManager != "qb-clothing" && `
                                    <p>${translation.beard.opacity} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["beard_2"].totalAmount || prices["beard_2"].price}</span></p>
                                    <input type="range" min="0" max="10" value="${currentValue["beard_2"].value}"  class="slider" id="beard_2" onmousemove="changeRange('beard_2')">
                                ` || ``}
                            </div>
                        </div>
                        <div class="colors">
                            <p>${translation.beard.color} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["beard_3"].totalAmount || prices["beard_3"].price}</span></p>
                            <div class="colors-list">
                                <div class="colour-selection" onclick="changeColor('beard_3', 0)" style="background: #060606;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 1)" style="background: #131313;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 2)" style="background: #303230;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 3)" style="background: #1e0f0a;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 4)" style="background: #4e2a1d;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 5)" style="background: #90543d;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 6)" style="background: #EDC87D;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 7)" style="background: #F5D38F;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 8)" style="background: #F7D99D;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 9)" style="background: #FCE3B2;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 10)" style="background: #c5b495;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 11)" style="background: #dfcdac;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 12)" style="background: #F9E5BF;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 13)" style="background: #e3c48a;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 14)" style="background: #ebd09d;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 15)" style="background: #f6e3c0;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 16)" style="background: #8e8370;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 17)" style="background: #A4530B;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 18)" style="background: #EA3C11;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 19)" style="background: #620000;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 20)" style="background: #8d0000;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 21)" style="background: #ff0505;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 22)" style="background: #ff4242;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 23)" style="background: #ff5c26;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 24)" style="background: #F58159;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 25)" style="background: #ac5c41;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 26)" style="background: #AFABAA;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 27)" style="background: #BCB9B8;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 28)" style="background: #E6E6E6;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 29)" style="background: #FFFFFF;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 30)" style="background: #533c67;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 31)" style="background: #82619f;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 32)" style="background: #7f3286;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 33)" style="background: #ff0ae7;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 34)" style="background: #ff0357;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 35)" style="background: #ff9bcb;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 36)" style="background: #22b1a1;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 37)" style="background: #1e7590;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 38)" style="background: #2231ff;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 39)" style="background: #1def55;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 40)" style="background: #068d60;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 41)" style="background: #154e60;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 42)" style="background: #a0f742;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 43)" style="background: #47F225;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 44)" style="background: #0c9d2c;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 45)" style="background: #CAE57B;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 46)" style="background: #f5bc22;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 47)" style="background: #e2940f;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 48)" style="background: #ff8001;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 49)" style="background: #ff5e00;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 51)" style="background: #d13809;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 56)" style="background: #1b1411;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 57)" style="background: #261d19;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 58)" style="background: #42332d;"></div>
                                <div class="colour-selection" onclick="changeColor('beard_3', 61)" style="background: #000;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `
    } else if (id == 'makeup') {
        data = `
            <div>
                <div >
                    <div >
                        <div class="main-two-sections">
                            <div>
                                <span class="name">${translation.makeup.name}</span>
                                <p>${translation.makeup.style}<span class="itemLabel" id="name-makeup_1">ㅤ</span> <span class="itemPrice" style="margin-right: 1.2em;">${translation.currency}${!useCityHallIncludedTaxes && prices["makeup_1"].totalAmount || prices["makeup_1"].price}</span></p>
                                <div>
                                    <button onclick="previous('makeup_1')" id="minus">
                                        <i class="fa-solid fa-caret-left"></i>
                                    </button>
                                    <p class="buttons-text ${skinManager == "qb-clothing" ? 'oneButton' : ''}" id="current-makeup_1">${currentValue["makeup_1"].value}</p>
                                    <button onclick="next('makeup_1')" id="plus">
                                        <i class="fa-solid fa-caret-right"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="sliders-menu">
                                ${skinManager != "qb-clothing" && `
                                    <p>${translation.makeup.opacity} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["makeup_2"].totalAmount || prices["makeup_2"].price}</span></p>
                                    <input type="range" min="0" max="10" value="${currentValue["makeup_2"].value}" class="slider" id="makeup_2" onmousemove="changeRange('makeup_2')">
                                ` || ``}
                            </div>
                        </div>
                        <div class="colors">
                            <p >${translation.makeup.color} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["makeup_3"].totalAmount || prices["makeup_3"].price}</span></p>
                            <div class="colors-list">
                                <div class="colour-selection" onclick="changeColor('makeup_3', 0)" style="background: #a7081f;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 1)" style="background: #e31549;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 2)" style="background: #ff1a6a;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 3)" style="background: #57213f;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 4)" style="background: #6b234d;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 5)" style="background: #781923;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 6)" style="background: #391216;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 7)" style="background: #6b3035;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 8)" style="background: #7b4c40;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 9)" style="background: #79635e;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 10)" style="background: #9d7c8c;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 11)" style="background: #6e3635;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 12)" style="background: #78312b;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 13)" style="background: #54180f;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 14)" style="background: #733139;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 15)" style="background: #834160;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 16)" style="background: #a8639e;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 17)" style="background: #842c5c;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 18)" style="background: #6b0b2c;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 19)" style="background: #671835;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 20)" style="background: #170408;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 21)" style="background: #1b0610;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 22)" style="background: #5e0e14;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 23)" style="background: #7c0b13;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 24)" style="background: #280304;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 25)" style="background: #891833;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 26)" style="background: #922894;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 27)" style="background: #530360;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 28)" style="background: #3c0053;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 29)" style="background: #34174e;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 30)" style="background: #1c0725;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 31)" style="background: #1c0420;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 32)" style="background: #1e0050;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 33)" style="background: #121131;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 34)" style="background: #0d1a5b;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 35)" style="background: #193586;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 36)" style="background: #073e7a;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 37)" style="background: #004f73;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 38)" style="background: #007a5b;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 39)" style="background: #007238;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 40)" style="background: #004a19;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 41)" style="background: #19350b;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 42)" style="background: #157500;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 43)" style="background: #548900;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 44)" style="background: #828f01;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 45)" style="background: #5d5700;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 46)" style="background: #8a6900;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 47)" style="background: #944301;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 48)" style="background: #871a00;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 49)" style="background: #40160c;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 50)" style="background: #72561f;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 51)" style="background: #928679;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 52)" style="background: #61677a;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 53)" style="background: #545966;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 54)" style="background: #252d37;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 55)" style="background: #181820;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 56)" style="background: #090909;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 57)" style="background: #0b2c3c;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 58)" style="background: #171f3b;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 59)" style="background: #0b0a10;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 60)" style="background: #403832;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 61)" style="background: #403232;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 62)" style="background: #1c1414;"></div>
                                <div class="colour-selection" onclick="changeColor('makeup_3', 63)" style="background: #22201a;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                ${(skinManager != "qb-clothing" && skinManager != "fivem-appearance") && `
                    <div >
                        <div >
                            <div class="colors">
                                <p>${translation.makeup.color2} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["makeup_4"].totalAmount || prices["makeup_4"].price}</span></p>
                                <div class="colors-list">
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 0)" style="background: #a25667;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 1)" style="background: #b16380;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 2)" style="background: #ac6f8a;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 3)" style="background: #9f7089;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 4)" style="background: #a17289;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 5)" style="background: #a26370;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 6)" style="background: #966067;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 7)" style="background: #835a64;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 8)" style="background: #94797b;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 9)" style="background: #927b7d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 10)" style="background: #9e8391;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 11)" style="background: #916e78;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 12)" style="background: #95686f;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 13)" style="background: #905750;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 14)" style="background: #977b8d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 15)" style="background: #9a798c;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 16)" style="background: #a583a8;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 17)" style="background: #a77192;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 18)" style="background: #a35b88;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 19)" style="background: #98637e;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 20)" style="background: #75445d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 21)" style="background: #633f4c;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 22)" style="background: #823845;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 23)" style="background: #a33948;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 24)" style="background: #982430;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 25)" style="background: #a86382;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 26)" style="background: #9f54a3;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 27)" style="background: #9c489f;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 28)" style="background: #8a409d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 29)" style="background: #743e7d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 30)" style="background: #7b3c7d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 31)" style="background: #6c4278;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 32)" style="background: #713990;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 33)" style="background: #4b5580;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 34)" style="background: #47609c;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 35)" style="background: #4272a1;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 36)" style="background: #3a80a2;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 37)" style="background: #4594a6;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 38)" style="background: #3e9187;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 39)" style="background: #4b9c86;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 40)" style="background: #337a32;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 41)" style="background: #2f7a0f;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 42)" style="background: #67944c;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 43)" style="background: #99ac56;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 44)" style="background: #a4a94f;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 45)" style="background: #a09940;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 46)" style="background: #a89a4a;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 47)" style="background: #966934;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 48)" style="background: #af633c;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 49)" style="background: #a06f0f;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 50)" style="background: #a99b83;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 51)" style="background: #a9a7a9;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 52)" style="background: #a9b0be;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 53)" style="background: #817f8d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 54)" style="background: #888993;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 55)" style="background: #685c63;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 56)" style="background: #45302c;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 57)" style="background: #607f8d;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 58)" style="background: #465167;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 59)" style="background: #4b4d69;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 60)" style="background: #7a6062;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 61)" style="background: #7b6567;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 62)" style="background: #6c5351;"></div>
                                    <div class="colour-selection" onclick="changeColor('makeup_4', 63)" style="background: #413029;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                ` || ``}
                <div >
                    <div >
                        <div class="main-two-sections">
                            <div>
                                <span class="name">${translation.lipstick.name}</span>
                                <p>${translation.lipstick.style}<span class="itemLabel" id="name-lipstick_1">ㅤ</span> <span class="itemPrice" style="margin-right: 1.2em;">${translation.currency}${!useCityHallIncludedTaxes && prices["lipstick_1"].totalAmount || prices["lipstick_1"].price}</span></p>
                                <div>
                                    <button onclick="previous('lipstick_1')" id="minus">
                                        <i class="fa-solid fa-caret-left"></i>
                                    </button>
                                    <p class="buttons-text ${skinManager == "qb-clothing" ? 'oneButton' : ''}" id="current-lipstick_1">${currentValue["lipstick_1"].value}</p>
                                    <button onclick="next('lipstick_1')" id="plus">
                                        <i class="fa-solid fa-caret-right"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="sliders-menu">
                                ${skinManager != "qb-clothing" && `
                                    <p>${translation.lipstick.opacity} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["lipstick_2"].totalAmount || prices["lipstick_2"].price}</span></p>
                                    <input type="range" min="0" max="10" value="${currentValue["lipstick_2"].value}" class="slider" id="lipstick_2" onmousemove="changeRange('lipstick_2')">
                                ` || ``}
                            </div>
                        </div>
                        <div class="colors">
                            <p >${translation.lipstick.color} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["lipstick_3"].totalAmount || prices["lipstick_3"].price}</span></p>
                        <div class="colors-list">
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 0)" style="background: #060606;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 1)" style="background: #131313;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 2)" style="background: #303230;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 3)" style="background: #1e0f0a;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 4)" style="background: #4e2a1d;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 5)" style="background: #90543d;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 6)" style="background: #EDC87D;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 7)" style="background: #F5D38F;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 8)" style="background: #F7D99D;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 9)" style="background: #FCE3B2;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 10)" style="background: #c5b495;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 11)" style="background: #dfcdac;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 12)" style="background: #F9E5BF;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 13)" style="background: #e3c48a;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 14)" style="background: #ebd09d;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 15)" style="background: #f6e3c0;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 16)" style="background: #8e8370;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 17)" style="background: #A4530B;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 18)" style="background: #EA3C11;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 19)" style="background: #620000;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 20)" style="background: #8d0000;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 21)" style="background: #ff0505;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 22)" style="background: #ff4242;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 23)" style="background: #ff5c26;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 24)" style="background: #F58159;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 25)" style="background: #ac5c41;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 26)" style="background: #AFABAA;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 27)" style="background: #BCB9B8;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 28)" style="background: #E6E6E6;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 29)" style="background: #FFFFFF;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 30)" style="background: #533c67;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 31)" style="background: #82619f;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 32)" style="background: #7f3286;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 33)" style="background: #ff0ae7;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 34)" style="background: #ff0357;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 35)" style="background: #ff9bcb;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 36)" style="background: #22b1a1;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 37)" style="background: #1e7590;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 38)" style="background: #2231ff;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 39)" style="background: #1def55;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 40)" style="background: #068d60;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 41)" style="background: #154e60;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 42)" style="background: #a0f742;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 43)" style="background: #47F225;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 44)" style="background: #0c9d2c;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 45)" style="background: #CAE57B;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 46)" style="background: #f5bc22;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 47)" style="background: #e2940f;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 48)" style="background: #ff8001;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 49)" style="background: #ff5e00;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 51)" style="background: #d13809;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 56)" style="background: #1b1411;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 57)" style="background: #261d19;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 58)" style="background: #42332d;"></div>
                            <div class="colour-selection" onclick="changeColor('lipstick_3', 61)" style="background: #000;"></div>
                        </div>
                    </div>
                </div>
            </div>
                
            <div >
                <div >
                    <div class="main-two-sections">
                        <div>
                            <span class="name">${translation.blush.name}</span>
                            <p>${translation.blush.style}<span class="itemLabel" id="name-blush_1">ㅤ</span> <span class="itemPrice" style="margin-right: 1.2em;">${translation.currency}${!useCityHallIncludedTaxes && prices["blush_1"].totalAmount || prices["blush_1"].price}</span></p>
                            <div>
                                <button onclick="previous('blush_1')" id="minus">
                                    <i class="fa-solid fa-caret-left"></i>
                                </button>
                                <p class="buttons-text ${skinManager == "qb-clothing" ? 'oneButton' : ''}" id="current-blush_1">${currentValue["blush_1"].value}</p>
                                <button onclick="next('blush_1')" id="plus">
                                    <i class="fa-solid fa-caret-right"></i>
                                </button>
                            </div>
                        </div>
                        <div class="sliders-menu">
                            ${skinManager != "qb-clothing" && `
                                <p>${translation.blush.opacity} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["blush_2"].totalAmount || prices["blush_2"].price}</span></p>
                                <input type="range" min="0" max="10" value="${currentValue["blush_2"].value}" class="slider" id="blush_2" onmousemove="changeRange('blush_2')">
                            ` || ``}
                        </div>
                    </div>
                    <div class="colors">
                        <p>${translation.blush.color} <span class="itemPrice">${translation.currency}${!useCityHallIncludedTaxes && prices["blush_3"].totalAmount || prices["blush_3"].price}</span></p>
                        <div class="colors-list">
                            <div class="colour-selection" onclick="changeColor('blush_3', 0)" style="background: #d60a22;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 1)" style="background: #ee3a64;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 2)" style="background: #ee6982;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 3)" style="background: #ff7489;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 4)" style="background: #cf566e;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 5)" style="background: #ff414b;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 6)" style="background: #b92b2b;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 7)" style="background: #ff7e6a;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 8)" style="background: #ffc190;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 9)" style="background: #ffd3ad;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 10)" style="background: #ffb798;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 11)" style="background: #ff8e6e;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 12)" style="background: #ff8c55;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 13)" style="background: #dc471f;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 14)" style="background: #ce766f;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 15)" style="background: #ed9da2;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 16)" style="background: #f8b3c3;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 17)" style="background: #f773a5;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 18)" style="background: #ff2f85;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 19)" style="background: #f44f71;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 20)" style="background: #84212d;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 21)" style="background: #711826;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 22)" style="background: #bc171f;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 23)" style="background: #f41034;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 24)" style="background: #e90000;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 25)" style="background: #ed506a;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 26)" style="background: #ec44b1;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 27)" style="background: #d918b3;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 28)" style="background: #cc0fb1;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 29)" style="background: #911879;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 30)" style="background: #a2016a;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 31)" style="background: #66164c;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 32)" style="background: #9314a4;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 33)" style="background: #29387e;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 34)" style="background: #3049a6;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 35)" style="background: #4cb2ff;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 36)" style="background: #23e2ff;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 37)" style="background: #28cfcf;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 38)" style="background: #25d7aa;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 39)" style="background: #18ca7e;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 40)" style="background: #0df036;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 41)" style="background: #249400;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 42)" style="background: #95dc17;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 43)" style="background: #e5f000;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 44)" style="background: #e9e000;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 45)" style="background: #ffed04;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 46)" style="background: #f9cf00;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 47)" style="background: #df7f01;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 48)" style="background: #fe6c00;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 49)" style="background: #cc6400;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 51)" style="background: #ffedc6;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 56)" style="background: #2d1b1b;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 57)" style="background: #d1fff3;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 58)" style="background: #8799aa;"></div>
                            <div class="colour-selection" onclick="changeColor('blush_3', 61)" style="background: #b1795a;"></div>
                        </div>
                    </div>
                </div>
            </div>
        `
    } else if (id == 'basket') {
        data = `<div id="basket">`;
        totalPrice = 0;
        
        for (const [key, value] of Object.entries(currentValue)) {
            if (Number(value.value) != Number(value.default)) {
                totalPrice += !useCityHallIncludedTaxes && prices[key].totalAmount || prices[key].price
                data += `
                    <div>
                        <span class="label">${value.name} ${value.label}</span>
                        <span class="price">${translation.currency}${!useCityHallIncludedTaxes && prices[key].totalAmount || prices[key].price}</span>
                        ${!useCityHallIncludedTaxes && prices[key].totalAmount && `<span class="tax-info">${translation.included_tax}</span>` || ``}
                        <div class="remove-from-basket" onclick="removeFromBasket('${key}')"><i class="fa-solid fa-xmark" ></i></div>
                    </div>
                `
            }
        }

        for (const [key, value] of Object.entries(currentTattoos)) {
            if (value) {
                totalPrice += !useCityHallIncludedTaxes && prices['hair_fade'].totalAmount || prices['hair_fade'].price
                data += `
                    <div>
                        <span class="label">${translation.hair.name3} ${key}</span>
                        <span class="price">${translation.currency}${!useCityHallIncludedTaxes && prices['hair_fade'].totalAmount || prices['hair_fade'].price}</span>
                        ${!useCityHallIncludedTaxes && prices['hair_fade'].totalAmount && `<span class="tax-info">${translation.included_tax}</span>` || ``}
                        <div class="remove-from-basket" onclick="removeFromBasket('${key}', true)"><i class="fa-solid fa-xmark"></i></div>
                    </div>
                `
            }    
        }

        data += '</div>'

        $('#total > p').text((translation.total).format(translation.currency, totalPrice))
        $('#total').show();
        $('#buy').hide();
    }

    $("#panel").html(data)
}

const paymentSelection = () => {
    $.post(`https://${GetParentResourceName()}/clicked`)

    $('#total, #buy').hide();

    $('#payment > div > div[data-type="back"]').show();
    $('#payment > div > div[data-type="cash"]').hide();
    $('#payment > div > div[data-type="bank"]').hide();
    $('#payment > div > div[data-type="receipt"]').hide();
    if (clientId) {
        $('#payment > div > div[data-type="receipt"]').show();
    } else {
        $('#payment > div > div[data-type="cash"]').show();
        $('#payment > div > div[data-type="bank"]').show();
    }
    $('#payment').show();

}

$(".hair_circle").click(function () {
    selectSection('hair')
})

$(".eye_circle").click(function () {
    selectSection('eye')
})

$(".beard_circle").click(function () {
    selectSection('beard')
})

$(".makeup_circle").click(function () {
    selectSection('makeup')
})

$(".basket_circle").click(function () {
    selectSection('basket')
})

$("#hide").click(function () {
    if (clientId) {
        $.post(`https://${GetParentResourceName()}/hide`, JSON.stringify({ clientId: clientId }));
        clientId = undefined
    } else {
        $.post(`https://${GetParentResourceName()}/hide`);
    }
})

$("#buy").click(function () {
    selectSection('basket')
})

$("#payment > div > div").click(function () {
    let type = $(this).data('type');
    if (type == 'back') {
        selectSection('basket')
    } else {
        $.post(`https://${GetParentResourceName()}/payment`, JSON.stringify({ type: type, currentValues: currentValue, isChangingHairStyle: isChangingHairStyle }));
    }
})

$("#total").click(function () {
    paymentSelection();
})

const removeFromBasket = (name, isTattoo) => {
    if (!isTattoo && !currentValue[name]) return;
    
    if (clientId) {
        if (isTattoo) {
            currentTattoos[String(name)] = null;
            $.post(`https://${GetParentResourceName()}/removeFade`, JSON.stringify({
                id: name,
                clientId: clientId,
            }));
        } else {
            currentValue[name].value = currentValue[name].default;
            $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
                type: name,
                new: currentValue[name].value,
                clientId: clientId,
            }));
        }
    } else {
        if (isTattoo) {
            currentTattoos[String(name)] = null;
            $.post(`https://${GetParentResourceName()}/removeFade`, JSON.stringify({
                id: name,
            }));
        } else {
            currentValue[name].value = currentValue[name].default;
            $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
                type: name,
                new: currentValue[name].value
            }));
        }
    }
    selectSection('basket');
}

$(document).on('click', '.receipt .buttons .pay_cash', function(e) {
    $.post(`https://${GetParentResourceName()}/bill`, JSON.stringify({
        action: 'pay',
        type: 'cash',
    }));
})

$(document).on('click', '.receipt .buttons .pay_bank', function(e) {
    $.post(`https://${GetParentResourceName()}/bill`, JSON.stringify({
        action: 'pay',
        type: 'bank',
    }));
})

$(document).on('click', '.receipt .buttons .cancel', function(e) {
    $.post(`https://${GetParentResourceName()}/bill`, JSON.stringify({
        action: 'cancel'
    }));
})

function previous(item) {
    if (currentValue[item].value > currentValue[item].min) {
        currentValue[item].value = currentValue[item].value - 1
    }
    $(`#current-${item}`).html(currentValue[item].value)
    if (CustomNames[item] && CustomNames[item][currentValue[item].value]) {
        $(`#name-${item}`).html(CustomNames[item][currentValue[item].value])
    } else {
        $(`#name-${item}`).html("ㅤ")
    }
    if (clientId) {
        if (item != 'makeup_1' && item != 'lipstick_1' && item != 'blush_1') {
            isChangingHairStyle = true
        }
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            type: item,
            new: currentValue[item].value,
            clientId: clientId,
        }));
    } else {
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            type: item,
            new: currentValue[item].value
        }));
    }
}

function next(item) {
    if (currentValue[item].value < currentValue[item].max) {
        currentValue[item].value = currentValue[item].value + 1
    }
    $(`#current-${item}`).html(currentValue[item].value)
    if (CustomNames[item] && CustomNames[item][currentValue[item].value]) {
        $(`#name-${item}`).html(CustomNames[item][currentValue[item].value])
    } else {
        $(`#name-${item}`).html("ㅤ")
    }
    if (clientId) {
        if (item != 'makeup_1' && item != 'lipstick_1' && item != 'blush_1') {
            isChangingHairStyle = true
        }
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            type: item,
            new: currentValue[item].value,
            clientId: clientId,
        }));
    } else {
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            type: item,
            new: currentValue[item].value
        }));
    }
}

function changeColor(item, dataId) {
    if (clientId) {
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            type: item,
            new: dataId,
            clientId: clientId
        }));
    } else {
        $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
            type: item,
            new: dataId
        }));
    }
    currentValue[item].value = dataId
}

function changeFade(id) {
    // hair_fade
    if (clientId) {
        $.post(`https://${GetParentResourceName()}/changeFade`, JSON.stringify({
            id: id,
            clientId: clientId
        }));
    } else {
        $.post(`https://${GetParentResourceName()}/changeFade`, JSON.stringify({
            id: id,
        }));
    }
    // currentValue[item].value = dataId
}

function changeRange(item) {
    let inputValue = $("#" + item).val()
    let result = inputValue
    if (result != currentValue[item].value) {
        if (clientId) {
            $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
                type: item,
                new: result,
                clientId: clientId,
            }));
        } else {
            $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
                type: item,
                new: result
            }));
        }
        currentValue[item].value = result
    }
}

var holdingRightButton = false

var oldx = 0;
var oldy = 0;

document.addEventListener('mousedown', function(event) {
    if (currentMenu == 'barber') {
        if (event.button == 2) {
            if ($('#barber>.menu').is(':hover')) return;
            oldx = event.clientX
            oldy = event.clientY
            holdingRightButton = true;
        }
    }
});

document.addEventListener('mouseup', function(event) {
    if (holdingRightButton && event.button == 2) {
        holdingRightButton = false;
    }
});

document.addEventListener('mousemove', function (event) {
    if (holdingRightButton) {
        var deltaX = event.clientX - oldx;
        var deltaY = event.clientY - oldy;
        if (deltaX !== 0 || deltaY !== 0) {
            var direction = '';
            var absDeltaX = Math.abs(deltaX);
            var absDeltaY = Math.abs(deltaY);

            if (absDeltaX > absDeltaY) {
                if (deltaX > 0) {
                    direction = 'right';
                } else {
                    direction = 'left';
                }
            } else {
                if (deltaY > 0) {
                    direction = 'bottom';
                } else {
                    direction = 'top';
                }
            }

            oldx = event.clientX;
            oldy = event.clientY;

            $.post(`https://${GetParentResourceName()}/updateCamera`, JSON.stringify({
                deltaX: deltaX,
                deltaY: deltaY
            }));
        }
    }
});

document.addEventListener("wheel", (e) => {
    if ($('#barber>.menu').is(':hover')) return;
    var zoom = e.deltaY > 1 && 'minus' || 'plus'
    $.post(`https://${GetParentResourceName()}/updateCameraZoom`, JSON.stringify({type: zoom}));
})


// 
//  MANAGEMENT MENU
// 

$(document).on('keydown', 'body', function(e) {
    if (e.which == 27) {
        if (currentMenu != 'barber' && currentMenu != 'receipt') {
            $.post(`https://${GetParentResourceName()}/closeManagementMenu`);
            isMenuOpened = false;
            currentMenu = null
        }
        if (isPreview && currentMenu != 'receipt') {
            currentMenu = null;
            isPreview = false;
            $.post(`https://${GetParentResourceName()}/closeByClient`);
        }
    }
})

$(".close").click(function() {
    $.post(`https://${GetParentResourceName()}/closeManagementMenu`, JSON.stringify({menu: currentMenu}));
    isMenuOpened = false;
})

$(document).on('click', '.management-menu .side-bar .button', function(e) {
    let newMenu = $(this).data('href')
    updateManagement(newMenu, this)
})

function updateManagementSub(newMenu, _this) {
    if (newMenu == currentMenu) return;
    
    if (_this != selectedOption) {
        if (selectedOption) {
            $(selectedOption).removeClass("selected");
        }
        selectedOption = _this
        $(selectedOption).addClass("selected");
    }

    $(`div[data-type="${currentMenu}"]`).hide();

    currentMenu = newMenu
    $(`div[data-type="${currentMenu}"]`).show();

}

function updateManagement(newMenu, _this) {
    if (newMenu == currentMenu) return;

    if (newMenu != "employees") {
        $('.management-menu .main div[data-type="employees"] .box-right .data').empty();
    }

    if (_this != selectedOption) {
        if (selectedOption) {
            $(selectedOption).removeClass("selected");
        }
        selectedOption = _this
        $(selectedOption).addClass("selected");
    }
    
    $(`div[data-type="${currentMenu}"]`).hide();
    currentMenu = newMenu
    $(`div[data-type="${currentMenu}"]`).show();
}

function hireEmployee(playerId) {
    if (playerId) {
        $.post(`https://${GetParentResourceName()}/hireEmployee`, JSON.stringify({playerId: playerId}));
    }
}

function bonusEmployee(identifier) {
    let bonusMoney = $("#bonus-money").val();
    if (identifier && bonusMoney && bonusMoney >= 1) {
        $.post(`https://${GetParentResourceName()}/bonusEmployee`, JSON.stringify({identifier: identifier, bonusMoney: bonusMoney}));
        $("#bonus-money").val('');
    }
}

function changeGradeEmployee(identifier, grade) {
    if (identifier && grade) {
        $.post(`https://${GetParentResourceName()}/changeGradeEmployee`, JSON.stringify({identifier: identifier, grade: grade}));
    }
}

function fireEmployee(identifier) {
    if (identifier) {
        $.post(`https://${GetParentResourceName()}/fireEmployee`, JSON.stringify({identifier: identifier}));
        $('.management-menu .main div[data-type="employees"] .box-right .data').empty();
    }
}

function manageEmployee(name, identifier) {
    let jobsToSet = ``
    for (const [key, job] of Object.entries(storeCfg.jobGradesToSet)) {
        if (job) {
            jobsToSet += `
                <div>
                    <div class="changegrade" onclick='changeGradeEmployee("${identifier}", ${
                        JSON.stringify(job)
                    })'>${translation.management_menu.employees.menu_option_setjob_btn + job.label}</div>
                </div>
            `
        }
    }
    
    $('.management-menu .main div[data-type="employees"] .box-right .data').html(`
        <div class="employee-manage">
            <div class="player">
                <div class="player-name">${name}</div>
                <div class="bonus-bar">
                    <input type="number" id="bonus-money">
                    <div class="bonus" onclick="bonusEmployee('${identifier}')">${translation.management_menu.employees.menu_option_bonus_btn}</div>
                </div>
                ${jobsToSet}
                <div>
                    <div class="fire" onclick="fireEmployee('${identifier}')">${translation.management_menu.employees.menu_option_fire_btn}</div>
                </div>
                
            </div>
        </div>
    `);
}

$(".btn").click(function() {
    let option = $(this).data('option')
    if (option == 'send-announce') {
        let text = $('textarea[data-type="announcement"]').val();
        message = text.trim();
        if (message !== "") {
            $.post(`https://${GetParentResourceName()}/sendAnnouncement`, JSON.stringify({text: text}));
            $('textarea[data-type="announcement"]').val("")
        }
    } else if (option == "withdraw") {
        $('.box[data-type="balance"] .close-balance').addClass('isVisible');
        $('input[data-input="withdraw"]').show();
        $('.btn[data-option="deposit"]').hide();
        $('.btn[data-option="withdraw"]').hide();
    } else if (option == "deposit") {
        $('.box[data-type="balance"] .close-balance').addClass('isVisible');
        $('input[data-input="deposit"]').show();
        $('.btn[data-option="deposit"]').hide();
        $('.btn[data-option="withdraw"]').hide();
    } else if (option == "get_closest_players") {
        $.post(`https://${GetParentResourceName()}/getClosestPlayers`);
    } else if (option == "employees") {
        updateManagementSub(option, `div[data-href="employees"]`)
    }
})

function balanceButton() {
    if ($('input[data-input="withdraw"]').val() >= 1) {
        let money = $('input[data-input="withdraw"]').val()
        $.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({money: money}));
        $('input[data-input="withdraw"]').val('').hide();
        $('.btn[data-option="deposit"]').show();
        $('.btn[data-option="withdraw"]').show();
        $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
        $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');
        $('.box[data-type="balance"] .close-balance').removeClass('isVisible');
    } else if ($('input[data-input="deposit"]').val() >= 1) {
        let money = $('input[data-input="deposit"]').val()
        $.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify({money: money}));
        $('input[data-input="deposit"]').val('').hide();
        $('.btn[data-option="deposit"]').show();
        $('.btn[data-option="withdraw"]').show();
        $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
        $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');
        $('.box[data-type="balance"] .close-balance').removeClass('isVisible');
    } else {
        $('.btn[data-option="deposit"]').show();
        $('.btn[data-option="withdraw"]').show();
        $('input[data-input="withdraw"]').val('').hide();
        $('input[data-input="deposit"]').val('').hide();
        $('.box[data-type="balance"] .close-balance').removeClass('isVisible');
    }
}

function onInputBalance(type) {
    let value = $(`input[data-input="${type}"]`).val();
    if (type == 'withdraw') {
        if (value >= 1) {
            $('.box[data-type="balance"] .close-balance').addClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-close').addClass('fa-check');
            
        } else {
            $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');

        }
    } else if (type == 'deposit') {
        if (value >= 1) {
            $('.box[data-type="balance"] .close-balance').addClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-close').addClass('fa-check');
            
        } else {
            $('.box[data-type="balance"] .close-balance').removeClass('isAnyVal');
            $('.box[data-type="balance"] .close-balance > i').removeClass('fa-check').addClass('fa-close');

        }
    }
}