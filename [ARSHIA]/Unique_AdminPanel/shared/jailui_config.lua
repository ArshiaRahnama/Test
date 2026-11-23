JailUIConfig = {}

-- Presets per job: { label, time(min) }.  maxTime = سقف زمان دستی (دقیقه).
-- police/sheriff/mt/fbi از لیست Sunset. cid<-detective ، judge/doa<-justice ، marshal<-sheriff ، cia<-fbi (کپی؛ ویرایش کن)
JailUIConfig.suggestionjail = {

    ['police'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'Store Robbery',           		time = 12 },
			{ label = 'Mini Bank Robbery',     			time = 17 },
			{ label = 'Mini Jaw Robbery',           	time = 12 },
			{ label = 'Gun Shop Robbery',  				time = 12 },
			{ label = 'Jav City Robbery',       		time = 20 },
			{ label = 'Jav Sandy Robbery',      		time = 20 },
			{ label = 'Maze Bank Robbery',           	time = 25 },
        },
    },

    ['sheriff'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'Ranandegi Dar Halat Masti',           	time = 10 },
			{ label = 'Mosabeghe Khiyabani',           			time = 20 },
			{ label = 'Tasadof Va Farar Kardan',           		time = 20 },
			{ label = 'Farar Az Mamor Sheriff',           		time = 10 },
			{ label = 'Farar az Mamor Sheriff Sarneshin',     	time = 10 },
			{ label = 'Ranandeghi Khatarnak',           		time = 20 },
			{ label = 'Hamle Kardan Be Shahrvandan',        	time = 20 },
			{ label = 'Dozdi Az Shahrvandan',           		time = 20 },
			{ label = 'Ensedad Dar Ejra Edaalat',           	time = 15 },
			{ label = 'Hamle Ashyaee Gheyre Mojaz',          	time = 10 },
			{ label = 'Yaghi Gari',           					time = 10 },
			{ label = 'Mozahemat Baraye Organ Dolati',        	time = 15 },
			{ label = 'Hamle Mavad Mokhader',           		time = 15 },
			{ label = 'Forosh Daroo Haye Gheyr Ghanooni',     	time = 15 },
			{ label = 'Ghachagh Mavad Mokhader',           		time = 20 },
			{ label = 'Dargiri Khiyabani',           			time = 20 },
			{ label = 'Ghatl',           						time = 30 },
			{ label = 'Tirandazi be Mamoran Nezami',        	time = 30 },
			{ label = 'Gerogan Giri',           				time = 25 },
			{ label = 'Serghat Khane',           				time = 15 },
			{ label = 'Serghat Mashin',           				time = 20 },
			{ label = 'Haml Selahe Garm Gheyr Mojaz',        	time = 20 },
			{ label = 'Hamle Vest Bedone Mojavez',           	time = 10 },
			{ label = 'Hamle Kolah Ballestic Bedone Mojavez', 	time = 10 },
			{ label = 'Hamle Selah Sard Bedone Mojavez',     	time = 10 },
			{ label = 'Hamle Aslahe Mojaz Bedone Mojavez',   	time = 10 },
			{ label = 'Tir Andazi Ba Selahe Garm',          	time = 15 },
			{ label = 'Enteghal Gheyre Ghanooni Selah Garm',	time = 10 },
			{ label = 'Tozi Selah Garm Ya Mohemat',     		time = 20 },

        },
    },

    ['mt'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'Store Robbery',           		time = 12 },
			{ label = 'Mini Bank Robbery',     			time = 17 },
			{ label = 'Mini Jaw Robbery',           	time = 12 },
			{ label = 'Gun Shop Robbery',  				time = 12 },
			{ label = 'Jav City Robbery',       		time = 20 },
			{ label = 'Jav Sandy Robbery',      		time = 20 },
			{ label = 'Maze Bank Robbery',           	time = 25 },
        },
    },

    ['fbi'] = {
        allowManual = true,
        maxTime     = 60,
        list = {
			{ label = 'Store Robbery',           		time = 12 },
			{ label = 'Mini Bank Robbery',     			time = 17 },
			{ label = 'Mini Jaw Robbery',           	time = 12 },
			{ label = 'Gun Shop Robbery',  				time = 12 },
			{ label = 'Jav City Robbery',       		time = 20 },
			{ label = 'Jav Sandy Robbery',      		time = 20 },
			{ label = 'Maze Bank Robbery',           	time = 25 },
        },
    },

    ['cid'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },

    ['judge'] = {
        allowManual = true,
        maxTime     = 60,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },

    ['doa'] = {
        allowManual = true,
        maxTime     = 60,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },

    ['marshal'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'Ranandegi Dar Halat Masti',           	time = 10 },
			{ label = 'Mosabeghe Khiyabani',           			time = 20 },
			{ label = 'Tasadof Va Farar Kardan',           		time = 20 },
			{ label = 'Farar Az Mamor Sheriff',           		time = 10 },
			{ label = 'Farar az Mamor Sheriff Sarneshin',     	time = 10 },
			{ label = 'Ranandeghi Khatarnak',           		time = 20 },
			{ label = 'Hamle Kardan Be Shahrvandan',        	time = 20 },
			{ label = 'Dozdi Az Shahrvandan',           		time = 20 },
			{ label = 'Ensedad Dar Ejra Edaalat',           	time = 15 },
			{ label = 'Hamle Ashyaee Gheyre Mojaz',          	time = 10 },
			{ label = 'Yaghi Gari',           					time = 10 },
			{ label = 'Mozahemat Baraye Organ Dolati',        	time = 15 },
			{ label = 'Hamle Mavad Mokhader',           		time = 15 },
			{ label = 'Forosh Daroo Haye Gheyr Ghanooni',     	time = 15 },
			{ label = 'Ghachagh Mavad Mokhader',           		time = 20 },
			{ label = 'Dargiri Khiyabani',           			time = 20 },
			{ label = 'Ghatl',           						time = 30 },
			{ label = 'Tirandazi be Mamoran Nezami',        	time = 30 },
			{ label = 'Gerogan Giri',           				time = 25 },
			{ label = 'Serghat Khane',           				time = 15 },
			{ label = 'Serghat Mashin',           				time = 20 },
			{ label = 'Haml Selahe Garm Gheyr Mojaz',        	time = 20 },
			{ label = 'Hamle Vest Bedone Mojavez',           	time = 10 },
			{ label = 'Hamle Kolah Ballestic Bedone Mojavez', 	time = 10 },
			{ label = 'Hamle Selah Sard Bedone Mojavez',     	time = 10 },
			{ label = 'Hamle Aslahe Mojaz Bedone Mojavez',   	time = 10 },
			{ label = 'Tir Andazi Ba Selahe Garm',          	time = 15 },
			{ label = 'Enteghal Gheyre Ghanooni Selah Garm',	time = 10 },
			{ label = 'Tozi Selah Garm Ya Mohemat',     		time = 20 },

        },
    },

    ['cia'] = {
        allowManual = true,
        maxTime     = 60,
        list = {
			{ label = 'Store Robbery',           		time = 12 },
			{ label = 'Mini Bank Robbery',     			time = 17 },
			{ label = 'Mini Jaw Robbery',           	time = 12 },
			{ label = 'Gun Shop Robbery',  				time = 12 },
			{ label = 'Jav City Robbery',       		time = 20 },
			{ label = 'Jav Sandy Robbery',      		time = 20 },
			{ label = 'Maze Bank Robbery',           	time = 25 },
        },
    },

    -- حکومت و هر جاب بدون لیست: لیست پیش‌فرض Sunset
    ['government'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },

    ['default'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },
}
