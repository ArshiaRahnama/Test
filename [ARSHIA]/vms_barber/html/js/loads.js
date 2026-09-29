const formatDate = (timestamp) => {
    const date = new Date((Number(timestamp) * 1000));
    let hour = date.getHours();
    let minute = date.getMinutes();
    let day = date.getDate();
    let month = date.getMonth() + 1;
    let year = date.getFullYear();
    if (hour < 10) hour = '0' + hour
    if (minute < 10) minute = '0' + minute
    if (day < 10) day = '0' + day
    if (month < 10) month = '0' + month
    
    return day + '.' + month + '.' + year + ' ' + hour + ':' + minute
};

loadAnnoucements = (announcements) => {
    let announcementsData = ''
    for (const [k, v] of Object.entries(announcements)) {
        if (v) {
            announcementsData = announcementsData + `
                <div>
                    <div class="user">
                        <div class="avatar"><i class="fa-solid fa-user"></i></div>
                        <div class="name">${v.name}</div>
                    </div>
                    <div class="message">${v.message}</div>
                </div>
            `
        }
    }
    return announcementsData;
}

loadEmployees = (employees) => {
    let employeesData = ''
    for (const [k, v] of Object.entries(employees)) {
        employeesData = employeesData + `
            <tr>
                <td class="table-first">${v.name}</td>
                <td>${v.job ? v.job.grade_label : v.grade.name}</td>
                <td class="table-last"><div onclick="manageEmployee('${v.name}', '${v.identifier || v.empSource}')">${translation.management_menu.management.menu_employees_btn_manage}</div></td>
            </tr>
        `
    }
    return employeesData;
}

loadBalance = (balance) => {
    if (useBuildInBalance) {
        $('.management-menu div[data-type="boss-management"] div[data-type="balance"] .title').html(`${translation.currency} ${number.format(balance)}`);
    } else {
        if (!balanceAlreadyRemoved && removeBalanceFromMenu) {
            var element = document.querySelector('.management-menu div[data-type="boss-management"] div[data-type="balance"]');
            if (element) element.remove();

            $('.management-menu div[data-type="boss-management"] .header-buttons').css({'grid-template-columns': 'auto'})
            $('.management-menu div[data-type="boss-management"] div[data-type="employees-count"]').css({'width': '100%'})

            
            balanceAlreadyRemoved = true;
        }
        if (!removeBalanceFromMenu) {
            $('.management-menu div[data-type="boss-management"] div[data-type="balance"] .title').html(`${translation.currency} ${number.format(balance)}`);

        }
    }
}