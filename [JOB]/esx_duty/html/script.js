


window.addEventListener('message', (event) => {
    if (event.data.type === 'openMenu') {
        const menu = document.getElementById("menu");
        menu.classList.remove("hidden"); // نمایش منو

        const jobMemberSelect = document.getElementById("jobMember");
        jobMemberSelect.innerHTML = ''; // خالی کردن لیست قبل

        // نمایش اطلاعات شغل و درجه شغل بالای چت
        const jobInfo = document.getElementById("jobInfo");
        const jobInforank = document.getElementById("jobInforank");
        const player = event.data.players[0];  // فقط یک بازیکن در منو داریم

        // نمایش نام شغل و درجه شغل
        jobInfo.innerHTML = `
            <div>Job : ${player.JobName}    </div>
            
        `;

        jobInforank.innerHTML = `
            
            <div>Rank : ${player.jobGrade}</div>
        `;

        // افزودن بازیکنان به لیست
        event.data.players.forEach(player => {
            const option = document.createElement("option");
            option.value = player.identifier;
            option.textContent = player.name;
            jobMemberSelect.appendChild(option);
        });
    }

    if (event.data.type === 'dutyResult') {
        console.log('Received result:', event.data.result); // برای چک کردن داده‌های دریافتی
        const resultElement = document.getElementById("result");
        let resultHTML = '';

        if (!event.data.result || event.data.result.length === 0) {
            resultHTML = '<div class="no-data">هیچ داده‌ای برای این تاریخ‌ها یافت نشد.</div>';
        } else {
            let totalSeconds = 0; // جمع کل 
            let dailySeconds = 0; // جمع ثانیه‌های روزانه
            let weeklySeconds = 0; // جمع ثانیه‌های هفتگی

            const today = new Date().toISOString().split('T')[0]; // تاریخ امروز
            const oneWeekAgo = new Date(new Date().setDate(new Date().getDate() - 7)).toISOString().split('T')[0]; // تاریخ یک هفته قبل

            // پردازش داده‌های دریافتی و ساخت HTML
            let rowsHTML = '';
            event.data.result.forEach(record => {
                const timeInSeconds = (record.hours * 3600) + (record.minutes * 60) + record.seconds;
                totalSeconds += timeInSeconds; // جمع کل زمان
                        // محاسبه تایم روزانه
                if (record.date === today) {
                    dailySeconds += timeInSeconds;
                }

        // محاسبه تایم هفتگی
                if (record.date >= oneWeekAgo) {
                    weeklySeconds += timeInSeconds;
                }
                const pad = n => String(n).padStart(2, '0');
                rowsHTML += `
                <tr>
                    <td class="log-date">${record.date}</td>
                    <td class="log-duration">${pad(record.hours)}<span class="sep">:</span>${pad(record.minutes)}</td>
                </tr>
            `;
            });

            // محاسبه کل زمان به ساعت، دقیقه و ثانیه
            const totalHours = Math.floor(totalSeconds / 3600);
            const totalMinutes = Math.floor((totalSeconds % 3600) / 60);
        
            const dailyHours = Math.floor(dailySeconds / 3600);
            const dailyMinutes = Math.floor((dailySeconds % 3600) / 60);
        
            const weeklyHours = Math.floor(weeklySeconds / 3600);
            const weeklyMinutes = Math.floor((weeklySeconds % 3600) / 60);

            const pad = n => String(n).padStart(2, '0');
            resultHTML = `
                <table class="log-table">
                    <thead>
                        <tr>
                            <th>تاریخ</th>
                            <th>مدت زمان</th>
                        </tr>
                    </thead>
                    <tbody>${rowsHTML}</tbody>
                </table>
                <div class="stat-strip">
                    <div class="stat-pill">
                        <span class="stat-label">روزانه</span>
                        <span class="stat-value">${pad(dailyHours)}<span class="sep">:</span>${pad(dailyMinutes)}</span>
                    </div>
                    <div class="stat-pill">
                        <span class="stat-label">هفتگی</span>
                        <span class="stat-value">${pad(weeklyHours)}<span class="sep">:</span>${pad(weeklyMinutes)}</span>
                    </div>
                    <div class="stat-pill stat-pill-total">
                        <span class="stat-label">کل</span>
                        <span class="stat-value">${pad(totalHours)}<span class="sep">:</span>${pad(totalMinutes)}</span>
                    </div>
                </div>
            `;
        }

        // نمایش نتایج در بخش result
        resultElement.innerHTML = resultHTML;
    }
});

// تابع برای بستن منو
function closeMenu() {
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST'
    });
    document.getElementById("menu").classList.add("hidden"); // مخفی کردن منو
}

// ارسال درخواست به سرور برای دریافت تایم Duty
function checkDutyTime() {
    const steamHex = document.getElementById('jobMember').value;
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;

    if (!steamHex || !startDate || !endDate) {
        // alert("لطفا تمام فیلدها را پر کنید.");
        document.getElementById("result").innerText = "لطفا تمام فیلدها را پر کنید.";
        
        return;
    }

    fetch(`https://${GetParentResourceName()}/checkDutyTime`, { 
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            steamHex: steamHex,
            startDate: startDate,
            endDate: endDate
        })
    }).then(response => response.json())
      .then(data => {
        if (!data.result) {
            document.getElementById("result").innerText = `تایم پلی یافت نشد`;
            
            return;
        } else {
            let totalSeconds = 0;
            let dailySeconds = 0;
            let weeklySeconds = 0;

            const today = new Date().toISOString().split('T')[0];
            const oneWeekAgo = new Date(new Date().setDate(new Date().getDate() - 7)).toISOString().split('T')[0];
            data.result.forEach(record => {
                const timeInSeconds = (record.hours * 3600) + (record.minutes * 60) + record.seconds;
                totalSeconds += timeInSeconds;

                if (record.date === today) {
                    dailySeconds += timeInSeconds;
                }

                if (record.date >= oneWeekAgo) {
                    weeklySeconds += timeInSeconds;
                }
            });
            const totalHours = Math.floor(totalSeconds / 3600);
            const totalMinutes = Math.floor((totalSeconds % 3600) / 60);

            const dailyHours = Math.floor(dailySeconds / 3600);
            const dailyMinutes = Math.floor((dailySeconds % 3600) / 60);

            const weeklyHours = Math.floor(weeklySeconds / 3600);
            const weeklyMinutes = Math.floor((weeklySeconds % 3600) / 60);

            // document.getElementById("daily-time").innerHTML = `<strong>${dailyMinutes} : ${dailyHours} : مجموع تایم روزانه</strong>`;
            // document.getElementById("daily-time").classList.add("visible");

            // document.getElementById("weekly-time").innerHTML = `<strong>${weeklyMinutes} : ${weeklyHours} : مجموع تایم هفتگی</strong>`;
            // document.getElementById("weekly-time").classList.add("visible");

            // document.getElementById("total-time").innerHTML = `<strong>${totalMinutes} : ${totalHours} : مجموع مدت زمان کل</strong>`;
            // document.getElementById("total-time").classList.add("visible");


            // document.getElementById("result").innerText = `نتیجه: ${data.result}`;

            const resultBody = document.getElementById("result-body");
            resultBody.innerHTML = `
                <tr>
                    <td>${document.getElementById('jobMember').options[document.getElementById('jobMember').selectedIndex].text}</td>
                    <td>${dailyMinutes} : ${dailyHours}</td>
                    <td>${weeklyMinutes} : ${weeklyHours}</td>
                    <td>${totalMinutes} : ${totalHours}</td>
                </tr>
            `;

            document.getElementById("result").innerText = ``;
        }
          
        
      })
      .catch(error => console.error('Error:', error));
}

