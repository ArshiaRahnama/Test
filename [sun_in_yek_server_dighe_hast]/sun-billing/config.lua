-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}

Config.EnableJobLogs = false
Config.Locale        = 'en'

Config.suggestionghabz = {

	['police'] = {
		account     = 'society_police',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Store Robbery',           		amount = 12000 },
			{ label = 'Mini Bank Robbery',     			amount = 17000 },
			{ label = 'Mini Jaw Robbery',           	amount = 12000 },
			{ label = 'Gun Shop Robbery',  				amount = 12000 },
			{ label = 'Jav City Robbery',       		amount = 20000 },
			{ label = 'Jav Sandy Robbery',      		amount = 20000 },
			{ label = 'Maze Bank Robbery',           	amount = 25000 },
		},
	},

	['sheriff'] = {
		account     = 'society_sheriff',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Ranandegi Dar Halat Masti',           	amount = 15000 },
			{ label = 'Mosabeghe Khiyabani',           			amount = 15000 },
			{ label = 'Tasadof Va Farar Kardan',           		amount = 15000 },
			{ label = 'Farar Az Mamor Sheriff',           		amount = 15000 },
			{ label = 'Farar az Mamor Sheriff Sarneshin',     	amount = 10000 },
			{ label = 'Ranandeghi Khatarnak',           		amount = 15000 },
			{ label = 'Hamle Kardan Be Shahrvandan',        	amount = 20000 },
			{ label = 'Dozdi Az Shahrvandan',           		amount = 20000 },
			{ label = 'Ensedad Dar Ejra Edaalat',           	amount = 15000 },
			{ label = 'Hamle Ashyaee Gheyre Mojaz',          	amount = 10000 },
			{ label = 'Yaghi Gari',           					amount = 10000 },
			{ label = 'Mozahemat Baraye Organ Dolati',        	amount = 15000 },
			{ label = 'Hamle Mavad Mokhader',           		amount = 15000 },
			{ label = 'Forosh Daroo Haye Gheyr Ghanooni',     	amount = 15000 },
			{ label = 'Ghachagh Mavad Mokhader',           		amount = 15000 },
			{ label = 'Dargiri Khiyabani',           			amount = 30000 },
			{ label = 'Ghatl',           						amount = 35000 },
			{ label = 'Tirandazi be Mamoran Nezami',        	amount = 25000 },
			{ label = 'Gerogan Giri',           				amount = 25000 },
			{ label = 'Serghat Khane',           				amount = 15000 },
			{ label = 'Serghat Mashin',           				amount = 15000 },
			{ label = 'Haml Selahe Garm Gheyr Mojaz',        	amount = 10000 },
			{ label = 'Hamle Vest Bedone Mojavez',           	amount = 10000 },
			{ label = 'Hamle Kolah Ballestic Bedone Mojavez', 	amount = 10000 },
			{ label = 'Hamle Selah Sard Bedone Mojavez',     	amount = 10000 },
			{ label = 'Hamle Aslahe Mojaz Bedone Mojavez',   	amount = 20000 },
			{ label = 'Tir Andazi Ba Selahe Garm',          	amount = 15000 },
			{ label = 'Enteghal Gheyre Ghanooni Selah Garm',	amount = 10000 },
			{ label = 'Tozi Selah Garm Ya Mohemat',     		amount = 15000 },
		},
	},

	['mt'] = {
		account     = 'society_mt',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Store Robbery',           		amount = 12000 },
			{ label = 'Mini Bank Robbery',     			amount = 17000 },
			{ label = 'Mini Jaw Robbery',           	amount = 12000 },
			{ label = 'Gun Shop Robbery',  				amount = 12000 },
			{ label = 'Jav City Robbery',       		amount = 20000 },
			{ label = 'Jav Sandy Robbery',      		amount = 20000 },
			{ label = 'Maze Bank Robbery',           	amount = 25000 },
		},
	},

	['fbi'] = {
		account     = 'society_fbi',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Store Robbery',           		amount = 12000 },
			{ label = 'Mini Bank Robbery',     			amount = 17000 },
			{ label = 'Mini Jaw Robbery',           	amount = 12000 },
			{ label = 'Gun Shop Robbery',  				amount = 12000 },
			{ label = 'Jav City Robbery',       		amount = 20000 },
			{ label = 'Jav Sandy Robbery',      		amount = 20000 },
			{ label = 'Maze Bank Robbery',           	amount = 25000 },
		},
	},

	['detective'] = {
		account     = 'society_detective',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Store Robbery',           		amount = 12000 },
		},
	},

	['justice'] = {
		account     = 'society_justice',
		maxAmount   = 100000,
		allowManual = true,
		list = {
			{ label = 'License',              			amount = 20000 },
			{ label = 'DYS',                       		amount = 50000 },
			{ label = 'License',     					amount = 50000 },
		},
	},

	['ambulance'] = {
		account     = '',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Darman',              			amount = 10000 },
			{ label = 'Jarahi',              			amount = 50000 },
			{ label = 'License',                      	amount = 40000 },
			{ label = 'Tamdid License',             	amount = 20000 },
			{ label = 'Visite Ravanshenas',          	amount = 40000 },
		},
	},

	['mechanic'] = {
		account     = '',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Repair Ezam',               		amount = 15000  },
			{ label = 'Repair Jaygah',                 	amount = 10000  },
			{ label = 'Custom',                			amount = 50000  },
			{ label = 'Nasbe GPS',                    	amount = 20000  },
			{ label = 'Nasbe Engin',               		amount = 20000  },
			{ label = 'Nasbe Engin Va Felatbed',     	amount = 50000  },
			{ label = 'Hazine Ezam',     				amount = 10000  },
		},
	},

	['taxi'] = {
		account     = '',
		maxAmount   = 50000,
		allowManual = true,
		list = {
			{ label = 'Delivery',      					amount = 10000  },
			{ label = 'Delivery',      					amount = 15000  },
			{ label = 'Ayiname',                 		amount = 25000  },
			{ label = 'Tamdid Ayiname',      			amount = 15000  },
		},
	},
}
