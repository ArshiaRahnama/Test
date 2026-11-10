-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

helpConfig = {
    menu = {
        { id = "train1",    title = "آموزش‌های مقدماتی",     contentType = "train1",   allowed = { } }, -- allowed = { "sheriff", "taxi" } 
        { id = "job",       title = "شغل‌های عمومی",         contentType = "jobs",     allowed = { } },
        { id = "train2",    title = "اطلاعات عمومی",         contentType = "train2",   allowed = { } },
        { id = "drug",      title = "راهنمای داروسازی",     contentType = "drugs",    allowed = { } },
        { id = "robbery",   title = "راهنمای رابری‌ها",      contentType = "robbery",  allowed = { } },
        { id = "mechanic1", title = "راهنمای مکانیکی",      contentType = "mechanic1", allowed = { "mechanic", "offmechanic" } },
        { id = "akkbar",    title = "اطلاعیه‌ها",             contentType = "akkbar",  allowed = { } },

    },
    content = {
        train1 = {
            { -- auctionhouse
                id = "auctionhouse", title = "اکشن هوس", search = "اکشن هوس ah auctionhouse خرید فروش",
                shortDis = "خرید و فروش آیتم",
                icon = "https://cdn.sunrp.ir/helpcenter/auctionhouse/logo.png",
                video = false,
                audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/auctionhouse/ah000.png" },
                    { text = "برای خرید و فروش آیتم می‌توانید از اکشن هوس استفاده کنید. جهت استفاده از اکشن هوس به مکان ستاره‌های سبز رنگ، بر روی نقشه مراجعه کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/auctionhouse/ah001.png" },
                    { text = "پس از باز کردن اکشن هوس لیست آیتم های موجود جهت فروش نمایش داده می‌شود. اگر به دنبال آیتم خاصی هستید می‌توانید اسم آن را سرچ کنید و آیتم‌هایی که دیگران برای فروش قرار داده‌اند را به تعداد مورد نیاز خریداری کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/auctionhouse/ah002.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/auctionhouse/ah003.png" },
                    { text = "در صورتی که می خواهید آیتمی برای فروش قرار دهید گزینه Add Item را انتخاب کنید" },
                    { text = "در قسمت اول ، آیتم هایی که در جیب شما موجود است را می‌توانید انتخاب کنید" },
                    { text = "در قسمت دوم تعداد آیتمی که می خواهید برای فروش قرار دهید را وارد کنید" },
                    { text = "و در قسمت سوم مبلغ مورد نظر برای فروش هر کدام از آن آیتم‌ها را وارد کنید" },
                    { text = "و در انتها گزینه ADD را بزنید تا آیتم شما برای فروش در اکشن هوس قرار داده شود", url = "https://cdn.sunrp.ir/helpcenter/auctionhouse/ah004.png" },
                    { text = "زمانی که آیتم شما به فروش رسید. اسم ام اس فروش آن برای شما ارسال خواهد شد." },
                    { text = "در صورتی که آیتم شما به فروش نرود، پس از چند روز آیتم به میل باکس شما انتقال می‌یابد", btn = { text = "برای مشاهده توضیحات میل باکس کلیک کنید", id = "mailbox" } },

                    { text = "برای لغو آیتم هایی که به فروش نرفته. می‌توانید به قسمت My Items بروید و گزینه DELETE را بزنید. پس از لغو آیتم به جیب شما انتقال می یابد",
                    url = "https://cdn.sunrp.ir/helpcenter/auctionhouse/ah005.png" },
                }, allowed = {}
            },
            { -- mailbox
                id = "mailbox", title = "میل باکس", search = "میل باکس mailbox mail صندوق پستی",
                shortDis = "Mail Box",
                icon = "https://cdn.sunrp.ir/helpcenter/mailbox/logo.png",
                video = false,
                audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mailbox/mailbox000.png" },

                    { text = "برای دسترسی به صندوق پسی خود، باید به یکی از ستاره‌های سبز رنگ ( اکشن هوس ) روی نقشه مراجعه کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/mailbox/mailbox00.png" },

                    { text = "سپس نزدیک میل باکس شوید و دکمه { E } را فشار دهید و آیتم های خود را بردارید",
                    url = "https://cdn.sunrp.ir/helpcenter/mailbox/mailbox01.png" },

                    { text = "آیتم‌هایی که از سایت خریداری می کنید، به میل باکس منتقل می‌شود" },
                    { text = "آیتم‌هایی که در اکشن هوس می‌گذارید و به فروش نمی‌رود،" },
                    { text = "بعد از چند روز به میل باکس منتقل می‌شود" },
                    { text = "آیتم‌هایی که ادمین ریفاند می‌کند، به میل باکس منتقل می‌شود" },

                    { url = "https://cdn.sunrp.ir/helpcenter/mailbox/mailbox02.png" },

                    { text = "هر خانه شخصی یا هر واحد آپارتمان یک صندوق پستی دارد" },
                    { text = "شما می‌توانید برای دادن آیتم به دوستان خود در زمانی که به او دسترسی ندارید، از صندوق پستی خانه او استفاده کنید " },
                    { text = "برای این منظور کافیست به محل خانه او بروید و گزینه open post box را باز کنید و آیتم را داخل صندوق پستی قرار دهید",
                    url = "https://cdn.sunrp.ir/helpcenter/mailbox/mailbox03.png" },

                    { text = "برای گذاشتن آیتم در صندوق پستی آپارتمان ها، پس از باز کردن منو و انتخاب گزینه open post box شماره واحد مورد نظر را وارد کنید و آیتم را داخل صندوق پستی قرار دهید",
                    url = "https://cdn.sunrp.ir/helpcenter/mailbox/mailbox04.png" },

                    { text = "برای برداشتن آیتم از صندوق پستی منزل خود ، وارد خانه شوید و گزینه open post box را باز کنید و آیتم های صندوق پستی خود را بردارید",
                    url = "https://cdn.sunrp.ir/helpcenter/mailbox/mailbox05.png" },


                }, allowed = {}
            },
            { -- poolshoee
                id = "poolshoee", title = "پول کثیف", search = "پول کثیف پولشویی",
                shortDis = "پول کثیف و پول‌شویی",
                icon = "https://cdn.sunrp.ir/helpcenter/poolshoee/logo.png",
                video = false,
                audio = false,
                image = {

                    { url = "https://cdn.sunrp.ir/helpcenter/poolshoee/poolshoee00.png" },

                    { text = "زمانی که شما کار خلافی مانند دزدی از بانک و... انجام دهید. شما پول کثیف (پول سریال نشده) به دست می آورید" },

                    { text = "برای استفاده از این پول و واریز به بانک، شما باید طی فرایندی این پول را تمیز کنید ( به اصطلاح پول‌شویی انجام دهید )" },

                    { text = "به چهار روش می‌توانید این فرایند را انجام دهید" },

                    { text = "روش اول: شما می‌توانید با جاب باربری، پول‌شویی کنید، به ازای هر بسته‌ای که در جاب باربری تحویل می‌دهید، مقداری از پول کثیف داخل جیب شما به پول تمیز تبدیل می‌شود" },

                    { text = "در این روش پس از شست‌و‌شو، هفتاد درصد از پول کثیف را به عنوان پول تمیز به دست می‌آورید", btn = { text = "برای مشاهده آموزش ( بار بری ) کلیک کنید", id = "barbari" } },

                    { text = "روش دوم: در محل‌هایی که در بیرون شهر برای پولشویی تعبیه شده است، پول‌ها را تمیز کنید، چراغ قرمز کنار جاده به شما کمک می‌کند تا این مکان‌ها را پیدا کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/poolshoee/poolshoee01.png"},
                    { url = "https://cdn.sunrp.ir/helpcenter/poolshoee/poolshoee02.png"},
                    { text = "طی این روش به سرعت می‌توانید پول‌ها را تمیز کنید ولی در طول شب احتمال خفت شدن و در طول روز موقعیت شما برای پلیس ارسال می‌شود" },
                    { text = "اگر این فرآیند را در این مکان‌ها، در طول شب انجام دهید، شصت درصد از پول کثیف را به عنوان پول تمیز به دست می‌آورید" },
                    { text = "اگر این فرآیند را در این مکان‌ها، در طول روز انجام دهید، پنجاه درصد از پول کثیف را به عنوان پول تمیز به دست می‌آورید" },

                    { text = "روش سوم: با انجام بازی پک من و برنده شدن مرحله اول این بازی، مقداری از پول کثیف موجود در جیب شما به پول تمیز تبدیل می‌شود" },
                    { text = "در این روش پس از شست‌و‌شو هفتاد درصد از پول کثیف را به عنوان پول تمیز به دست می‌آورید", btn = { text = "برای مشاهده آموزش ( پک من ) کلیک کنید", id = "pacman" } },

                    { text = "روش چهارم: به وسیله پول‌شویی گنگ ، پول‌ها را تمیز کنید" },

                    { text = "اگر لول گنگ شما بالای 10 باشد با فعال کردن گزینه پول‌شویی در باس‌اکشن گنگ، به ازای تعداد نفرات آنلاین گنگ و لول گنگ ، هر 15 دقیقه مقداری از پول کثیف داخل لاکر گنگ شسته می‌شود و به پول باس‌اکشن گنگ اضافه می‌شود",
                    url = "https://cdn.sunrp.ir/helpcenter/poolshoee/poolshoee03.png" },

                    { text = "هرچقدر لول گنگ بالاتر باشد و تعداد نفرات بیشتری از اعضای گنگ در سرور حضور داشته باشند، مقدار پول کثیفی که شسته می‌شود بیشتر است" },
                    { text = "در این روش پس از شست‌و‌شو هفتاد درصد از پول کثیف را به عنوان پول تمیز به دست می‌آورید" },


                }, allowed = {}
            },
            { -- pacman
                id = "pacman", title = "پک من", search = "پک من",
                shortDis = "بازی پک من",
                icon = "https://cdn.sunrp.ir/helpcenter/pacman/logo.png",
                video = false,
                audio = false,
                image = {

                    { url = "https://cdn.sunrp.ir/helpcenter/pacman/pacman00.png" },

                    { text = "بازی پک من، یک بازی آرکید است که می توانید برای انجام کوئست وین در پک‌من یا پولشویی انجام دهید، برای انجام بازی باید به سراغ دستگاه بازی بروید و با دکمه { ALT } بازی را شروع کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/pacman/pacman01.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/pacman/pacman02.png" },

                    { text = "برای انجام این بازی باید همه نقطه‌های زرد رنک را تمام کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/pacman/pacman03.png" },

                    { text = "با انجام بازی پک من و برنده شدن مرحله اول این بازی، مقداری از پول کثیف موجود در جیب شما به پول تمیز تبدیل می‌شود", btn = { text = "برای مشاهده آموزش ( پول‌شویی ) کلیک کنید", id = "poolshoee" } },

                }, allowed = {}
            },
            { -- bank
                id = "bank", title = "بانک", search = "بانک atm",
                shortDis = "واریز، برداشت و انتقال پول",
                icon = "https://cdn.sunrp.ir/helpcenter/bank/logo.png",
                video = false,
                audio = false,
                image = {

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank00.png" },

                    { text = "برای واریز و برداشت پول از بانک، به یکی از ATM های سطح شهر مراجعه کنید" },
                    { text = "و با دکمه { ALT } منوی بانک را باز کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/bank/bank01.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank06.png" },

                    { text = "در صفحه داشبورد، می‌توانید موجودی حساب، مقدار پول داخل جیب، شماره کارت خود و نمودار تراکنش 30 روز اخیر را مشاهده کنید" },
                    { text = "اگر روی شماره کارت کلیک کنید، شماره کارت در کلیپ بورد شما ذخیره می‌شود" },

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank03.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank07.png" },

                    { text = "برای واریز و برداشت پول از حساب خود، به قسمت (واریز-برداشت) بروید" },
                    { text = "مقدار پول را در کادر بالا وارد کنید" },
                    { text = "سپس گزینه ( واریز ) جهت واریز پول از جیب به بانک" },
                    { text = "و گزینه ( برداشت ) جهت برداشت پول از بانک به جیب خود را انتخاب کنید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank02.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank08.png" },

                    { text = "در قسمت انتقال پول، شما می توانید پول موجود در حساب خود را به دیگران انتقال دهید" },

                    { text = "در قسمت سمت راست مقدار پول و در قسمت سمت چپ شماره کارت شخص را وارد کنید. سپس روی گزینه پایین جهت انتقال کلیک کنید" },

                    { text = "دقت کنید در زمان انتقال ، نام فرد به شما نمایش داده می شود. در صورت انتقال به شماره حساب اشتباه، تمامی مسئولیت برعهده شما می‌باشد" },

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank04.png" },

                    { text = "لازم به ذکر است عملیات کارت به کارت را با گوشی نیز می توانید انجام دهید ولی برای واریز و برداشت پول از حساب حتما باید به ATM مراجعه کنید " },

                    { url = "https://cdn.sunrp.ir/helpcenter/bank/bank05.png" },

                }, allowed = {}
            },
            { -- site
                id = "site", title = "سایت", search = "ورود سایت",
                shortDis = "ورود به سایت",
                icon = "https://cdn.sunrp.ir/helpcenter/site/logo.png",
                video = false,
                audio = false,
                image = {

                    { url = "https://cdn.sunrp.ir/helpcenter/site/site000.png" },


                    { text = "برای خرید ماشین، خرید اقلام مختلاف ، تبدیلات، حمایت ، مدیریت گروه خود و بسیاری از کارهای دیگر، شما باید وارد سایت مجموعه شوید"  },
                    { text = "آدرس سایت مجموعه خورشید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },

                    { text = "پس از باز شدن سایت، در قسمت بالای صفحه، بر روی گزینه ورود را کلیک کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/site/site001.png" },

                    { text = "در این مرحله شما نیاز به کد ورود دارید. برای دریافت کد ورود، وارد بازی شوید و در قسمت چت عبارت ( getcode/ ) را وارد کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/site/site003.png" },
                    { text = "کد داده شده را در کادر ورود به سایت وارد کنید. دقت کنید پس از گرفتن کد، 60 ثانیه فرصت دارید آن را در سایت وارد کنید. در صورت گذشت زمان مقرر کد جدید درخواست دهید" },
                    { text = "به هیچ عنوان این کد را در اختیار کسی قرار ندهید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site002.png" },

                    { text = "در زمانی که در سایت وارد شده‌اید، اگر بر روی گزینه کیف پول در بالای سایت کلیک کنید، مقدار تی‌سی، پول داخل بانک و تعداد توکن‌های خود را مشاهده می‌کنید. با این گزینه‌ها می‌توانید اقلام موجود در سایت را خریداری کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/site/site004.png" },

                    { text = "شما می‌توانید با گذاشتن پسورد برای اکانت خود، بدون حضور داخل گیم به سایت وارد شوید" },
                    { text = "برای این منظور پس از ورود به سایت بر روی اسم خود در قسمت بالای سایت کلیک کنید و گزینه حساب کاربری را انتخاب کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site006.png" },

                    { text = "در پنجره باز شده گزینه ویرایش را انتخاب کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site007.png" },

                    { text = "در پنجره باز شده کدی که بر روی شماره تلفن شما به صورت اس‌ام‌اس ارسال شده را در کادر مشخص شده وارد کنید. سپس رمز عبور دلخواه و تکرار آن را وارد کنید و ذخیره کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/site/site008.png" },

                    { text = "برای دسترسی به گزینه‌های بیشتر سایت وارد داشبورد شوید" },
                    { text = "برای این منظور پس از ورود به سایت بر روی اسم خود در قسمت بالای سایت کلیک کنید و گزینه داشبورد را انتخاب کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site005.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site009.png" },


                    { text = "در صورتی که لیدر گنگ باشید با انتخاب گزینه ویرایش صفحه گروه خود، بخش عضو گیری گنگ خود را در سایت فعال کنید یا آن را ویرایش کنید" },
                    { text = "در صورتی که استریمر هستید می توانید گزینه درخواست ثبت پخش زنده را انتخاب کنید و درخواست خود را ثبت کنید" },
                    { text = "جهت ارسال انتقادات و پیشنهادات خود جهت بهبود سرور می توانید این گزینه را انتخاب کنید" },
                    { text = "در بخش پانیشمنت، پانیشمنت های گروه خود را می‌توانید مشاهده کنید" },
                    { text = "در قسمت وسایل می توانید وسایل نقلیه خود داخل سرور را مشاهده کنید" },
                    { text = "اگر در شغل دولتی عضو باشید، در بخش شغل می‌توانید تایم‌پلی خود را مشاهده کنید" },
                    { text = "در بخش پیام‌ها، اگر پیام جدیدی برای شما ارسال شده باشد، مشاهده می کنید" },

                }, allowed = {}
            },
            { -- TC
                id = "tc", title = "تی‌سی", search = "تی سی",
                shortDis = "تایم کوین ( TC )",
                icon = "https://cdn.sunrp.ir/helpcenter/tc/logo.png",
                video = false,
                audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/tc/tc00.png" },
                    { text = "تی‌سی یک واحد پولی داخل بازی است که به دو روش می‌توانید به دست آورد" },
                    { text = "روش اول: به ازای هر یک ساعت که داخل بازی باشید یک عدد تی‌سی به دست می‌آورید" },
                    { text = "روش دوم: با انجام مأموریت‌ها ( کوئست ) می‌توانید تی‌سی به دست آورید" },
                    { text = "ارزش هر تی‌سی معادل بیست هزار دلار پول داخل بازی (آی‌سی) است که می‌توانید با آن ماشین و برخی از وسایل داخل سایت را خریداری کنید" },
                    { text = "مقدار تی‌سی‌های خود با فشردن کلید { i } می‌توانید مشاهده کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill01.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill02.png" },
                    { text = "یا وارد سایت شوید و در قسمت کیف پول مقدار تی‌سی‌های خود را مشاهده کنید", btn = { text = "برای مشاهده آموزش ورود به سایت کلیک کنید", id = "site" } },

                }, allowed = {}
            },
            { -- level
                id = "level", title = "لِوِل", search = "لول سطح تجربه",
                shortDis = "لول ( تجربه شخصی )",
                icon = "https://cdn.sunrp.ir/helpcenter/level/logo.png",
                video = false,
                audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/level/level00.png" },
                    { text = "زمانی که برای اولین بار وارد سرور می‌شوید ، لول شما ( یک ) است که با انجام مأموریت (کوئست) می‌توانید لول خود را بالا ببرید" },
                    { text = "برای رفتن به لول بالاتر شما نیاز به ایکس‌پی (experience) دارید، هر چقدر لول بالاتر برود مقدار ایکس‌پی بیشتری مورد نیاز است" },
                    { text = "لول و مقدار ایکس‌پی خود را با فشردن کلید { i } می‌توانید مشاهده کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill01.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill02.png" },

                    { text = "برای عضویت در گروه‌های خلافکار ( گنگ ) و یا عضویت در فکشن ( جاب ) شما باید حداقل به لول 3 برسید" },
                    { text = "برای استفاده از اسلحه، شما باید حداقل لول 3 باشید و عضو یک گروه خلافکار باشید" },
                    { text = "برای تیراندازی با اسلحه‌های مختلف، باید به لول خاصی برسید. اگر لول 6 یا بالاتر باشید با همه اسلحه‌ها می‌توانید شلیک کنید " },
                    { text = "در صورتی که لول 10 و بالاتر باشید، برای تیراندازی نیازی به عضویت در یگ گروه خلافکار ندارید" },
                    { text = "به ازای هر لول، یک هیل ( HP ) به شما اضافه می‌شود. با رسیدن به لول 50، هیل شما 150 می‌شود" },
                    { text = "از لول 25 تا 50 به ازای هر لول، دو عدد وست ( جلیقه ) به شما اضافه می‌شود. با رسیدن به لول 50، جلیقه شما 150 می‌شود" },
                    { text = "با رسیدن به لول 20 و بالاتر، انیمیشن گان دستی برای شما باز می‌شود. با کامند weaponanim/ می‌توانید از آن استفاده کنید" },

                }, allowed = {}
            },
            { -- skill
                id = "skill", title = "اسکیل و اچیومنت", search = "اسکیل اچیومنت",
                shortDis = "مهارت و تجربه",
                icon = "https://cdn.sunrp.ir/helpcenter/skill/logo.png",
                video = false,
                audio = false,
                image = {

                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill000.png" },


                    { text = "با فشردن کلید { i } می‌توانید اطلاعات شخصی، مهارت‌ها و دستاوردهای خود را ببینید" },
                    { text = "در قسمت بالا نام آی‌سی، مقدار تی‌سی، توکن سایت، لول، ایکس‌پی، مجموع تایم پلی، مجموع امتیاز دستاورد، اسم و رتبه گنگ خود را مشاهده می‌کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill01.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill02.png" },

                    { text = "در سربرگ ACHIEVEMENTS می‌توانید دستاورد‌های خود را مشاهده کنید. با کلیک بر روی هر دستاورد روش به دست آوردن آن را توضیح داده است. پس از به دست آوردن دستاورد به مقداری امتیازی که در پایین آن نشان داده به اچیونت پوینت کل اضافه می‌شود" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill03.png" },

                    { text = "در سربرگ SKILL می‌توانید مهارت‌های خود و میزان پیشرفت آن را مشاهده کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill04.png" },

                    { text = "در سربرگ WEAPON SKILL می‌توانید مهارت تیراندازی با هر اسلحه را مشاهده کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill07.png" },

                    { text = "و در قسمت COLLECTIONS می‌توانید وسیله‌های نقلیه و پت‌های خود را مشاهده کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill05.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill06.png" },

                    { text = "نحوه به دست آوردن و کاربرد اسکیل‌های مختلف" },

                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill008.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill009.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/skill/skill0100.png" },

                }, allowed = {}
            },
            { -- car control
                id = "carctl", title = "ماشین", search = "ماشین کمربند قفل",
                shortDis = "ماشین و نکته‌های پرکاربرد",
                icon = "https://cdn.sunrp.ir/helpcenter/carctl/logo.png",
                video = false,
                audio = false,
                image = {
                    -- { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl002.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl001.png" },
                    { text = "جهت باز کردن منوی کنترل درها و پنجره های ماشین دکمه page up را فشار دهید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl003.png" },
                    { text = "جهت کپی کردن پلاک ماشین، دکمه END کیبورد را فشار دهید و از منوی باز شده، بخش دسترسی سریع و سپس کپی پلاک ماشین را انتخاب کنید" },
                    { text = "توجه داشته باشید پلاک نزدیک ترین ماشین، داخل کلیپ بورد شما ذخیره می‌شود و می‌توانید آن را در جایی که نیاز دارید paste کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl004.png" },
                    { text = "جهت استفاده از صندوق عقب ماشین، با استفاده از دکمه ALT و نگاه کردن به سمت ماشین، منو را باز کنید" },
                    { text = "نکته مهم: اگر کلید ماشین را داشته باشید، زمانی که شخص یا اشخاصی سوار ماشین شما شوند، می توانید با دکمه ALT و بیرون انداختن سرنشینان، آنها را پیاده کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl006.png" },
                    { text = "جهت حفظ امنیت وسیله نقلیه، جلوگیری از باگ های احتمالی و بهبود اف‌پی‌اس خود و دیگران، وسیله نقلیه خود را در نزدیک ترین پارکینگ موقت، پارک کنید" },
                    { text = "پارکینگ های موقت با علامت P روی نقشه کوچک به شما نمایش داده می شوند" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl007.png" },
                    { text = "توجه داشته باشیدزمانی که ماشین در پارکینگ موقت قرار دارد، شما به صندوق آن دسترسی دارید و نیازی به خارج کردن ماشین از پارکینگ موقت نیست" },
                    { text = "برای این منظور با زدن دکمه ALT به محوطه زیر ماشین اشاره کنید (محوطه نارنجی داخلی عکس)" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl005.png" },
                    { text = "اگر در ماشینی قفل باشد و شما قصد دزدین آن ماشین را داشته باشید می توانید با ابزار سنجاق، درب آن را باز کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl0009.png" },
                    { text = "زمانی که درب ماشین باز باشد، با نشستن روی صندلی راننده و استفاده از ابزار پیچگوشتی می‌توانید آن را روشن ( hotwire ) کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl008.png" },
                    { text = "ابزار سنجاق و پیچگوشتی را می توانید از تمام شاپ های مکانیکی خریداری کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl011.png" },
                    { text = "ماشین دزدیده شده را می توانید به یکی از مکانی های چاپ‌شاپ ببرید و اوراق کنید" },
                    { text = "ماشینی که اوراق شود، لیمیت سرعت 60 کیلومتر بر روی آن اعمال می شود" },
                    { text = "برای برگشتن به حالت عادی، به مکانیکی مراجعه کنید و روی آن موتور نصب کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl012.png" },
                    { text = "توجه داشته باشید که در مناطق سیف زون، ان سی زد، شاپ ها، مناطق انجام شغل ها و مناطق شلوغ و... امکان سنجاق کردن یا hotwire کردن وجود ندارد" },
                    { text = "مثال هایی از مناطقی که در آن امکان دزدی وجود ندارد در عکس زیر نمایش داده شده" },
                    { text = "توجه داشته باشید که رم دادن به ماشین به منظور خارج کردن از مناطقی که پیچگوشتی و سنجاق عمل نمی کند به منظور دزدی ممنوع است و شدیدا برخورد خواهد شد" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl010.png" },
                    { text = "ابزار های شاپ مکانیکی را می توانید در عکس زیر مشاهده کنید" },
                    { text = "کیت ریپیر تایر: زمانی که ماشین شما پنچر شود، با داشتن این ابزار می توانید تایرهای ماشین را تعویض کنید" },
                    { text = "کیت ریپیر 50 درصد: زمانی که ماشین شما خراب شود، با این ابزار می توانید ماشین خود را تا 50 درصد تعمیر کنید" },
                    { text = "کیلنر: با این ابزار می توانید ماشین خود را تمیز کنید" },
                    { text = "جک: زمانی ماشین شما چپ کند، با این ابزار می توانید ماشین خود را به حالت اولیه برگردانید" },
                    { text = "کار ترکر: در صورتی که این ابزار را روی ماشین خود نصب کنید، موقعیت لحظه‌ای ماشین خود را روی نقشه مشاهده می‌کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl013.png" },
                    { text = "برای غیرفعال کردن کارترکر نیاز به انبردست دارید، انبردست را می توانید از گان شاپ ها تهیه کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/carctl/carctl014.png" },
                }, allowed = {}
            },
        },
        jobs = {
            { -- Minery
                id = "minery", title = "مدنچی ( ماینری )", search = "معدنچی معدن ماینر ماینری غربال سنگ",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/minery/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/minery/miner00.png" },
                    { text = "برای انجام شغل ماینری (معدنچی)، در ابتدا شما باید به مکان مشخص شده بروید و لباس شغل ماینری را بپوشید",
                    url = "https://cdn.sunrp.ir/helpcenter/minery/miner01.png" },
                    { text = "سپس می‌توانید از محل مشخص شده یک ماشین تحویل بگیرید ، دقت داشته باشید که زمانی که ماشین شغل را تحویل می گیرید 50000 دلار به عنوان بیعانه از شما گرفته می‌شود و پس از تحویل ماشین این مبلغ به شما پس داده خواهد شد",
                    url = "https://cdn.sunrp.ir/helpcenter/minery/miner02.png" },
                    { text = "برای انجام مرحله اول به محل جمع آوری سنگ بروید و از ماشین پیاده شوید، کنار سنگ های بزرگ رفته و دکمه { E } را بزنید. سپس برای جمع کردن سنگ چپ کلیک موس را بزنید. سنگ های جمع آوری شده به صندوق ماشین انتقال پیدا می کند",
                    url = "https://cdn.sunrp.ir/helpcenter/minery/miner03.png" },
                    { text = "سپس به مرحله دوم محل غربال سنگ بروید و سوارماشین در جایگاه غربال سنگ دکمه { E } را بزنید تا سنگ های داخل کامیون غربال شود." },
                    { text = "پس از غربال سنگ به مرحله سوم بروید و خرده آهن و خرده طلا و خرده آلومینیوم را به شمش آهن ، شمش طلا و آلومینیوم تبدیل کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/minery/miner04.png" },
                    { text = "پس از تبدیل ، با مراجعه مکان های مشخص شده می‌توانید محصولات بدست آمده را به بات خریدار بفروشید. یا در اکشن هوس به دیگران بفروشید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },
                    { url = "https://cdn.sunrp.ir/helpcenter/minery/miner03.png" },
                    { text = "برای فروش الماس و شمش طلا به پشت ساختمان جواهری مراجعه کنید" }
                }, allowed = { } -- allowed = { "sheriff", "taxi" }
            },
            { -- ghasabi
                id = "ghasabi", title = "قصابی", search = "قصابی مرغ بسته مرغ ذبح",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/ghasabi/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi00.png" },
                    { text = "برای انجام شغل قصابی، در ابتدا شما باید به مکان مشخص شده بروید و لباس شغل قصابی را بپوشید",
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi01.png" },
                    { text = "سپس میتوانید از محل مشخص شده یک ماشین تحویل بگیرید. دقت داشته باشید که زمانی که ماشین شغل را تحویل می گیرید 50000 دلار به عنوان بیعانه از شما گرفته می‌شود و پس از تحویل دادن ماشین این مبلغ به شما پس داده خواهد شد",
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi02.png" },
                    { text = "سپس برای جمع آوری ، ذبح و بسته بندی مرغ به مکان مشخص شده بروید",
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi03.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi04.png" },
                    { text = "مرحله اول جمع آوری مرغ زنده است. به محل مشخص شده بروید و دکمه { E } را جهت شروع فرآیند بزنید",
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi05.png" },
                    { text = "مرحله بعد باید مرغ های جمع آوری شده را ذبح کنید. مثل مرحله قبل به محل مشخص شده بروید و جهت شروع فرایند دکمه { E } را بزنید",
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi06.png" },
                    { text = "در مرحله بعد ،  مرغ ها را بسته بندی کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi07.png" },
                    { text = "پس از اتمام بسته بندی  شما میتوانید با مراجعه به یکی از این دو مکان، بسته های مرغ را بفروشید",
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi08.png" },
                    { text = "برای فروش باید دکمه {ALT } را روی بات نگه دارید یا در اکشن هوس به دیگران بفروشید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" },
                    url = "https://cdn.sunrp.ir/helpcenter/ghasabi/ghasabi09.png" }
                }, allowed = { }
            },
            { -- Palayeshgah
                id = "palayeshgah", title = "پالایشگاه", search = "پالایشگاه رافین بنزین اسانس",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/palayeshgah/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh00.png" },
                    { text = "برای انجام شغل پالایشگاه ، در ابتدا شما باید به مکان مشخص شده بروید و لباس شغل پالایشگاه را بپوشید",
                    url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh01.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh02.png" },
                    { text = "سپس می‌توانید از محل مشخص شده یک ماشین تحویل بگیرید. دقت داشته باشید که زمانی که ماشین شغل را تحویل می گیرید 50000 دلار به عنوان بیعانه از شما گرفته می‌شود و پس از تحویل ماشین این مبلغ به شما پس داده خواهد شد",
                    url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh03.png" },
                    { text = "سپس برای جمع آوری بنزین پالایشگاه به مکان مشخص شده بروید",
                    url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh04.png" },
                    { text = "مرحله اول جمع آوری بنزین پالایشگاه است به محل مشخص شده بروید ، از ماشین پیاده شوید و دکمه { E } را جهت شروع فرآیند بزنید",
                    url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh05.png" },
                    { text = "مرحله دوم باید بنزین پالایشگاه را به رافین تبدیل کنید. مثل مرحله قبل به محل مشخص شده بروید، از ماشین پیاده شوید و جهت شروع فرایند دکمه { E } را بزنید",
                    url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh06.png" },
                    { text = "در مرحله سوم باید رافین ها را به اسانس تبدیل کنید. مثل مراحل قبل به محل مشخص شده بروید، از ماشین پیاده شوید و جهت شروع فرایند دکمه { E } را بزنید.",
                    url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh07.png" },
                    { text = "پس از تبدیل رافین به اسانس شما میتوانید با مراجعه به مکان شروع شغل ، اسانس ها را بفروشید",
                    url = "https://cdn.sunrp.ir/helpcenter/palayeshgah/palayesh08.png" },
                    { text = "برای فروش باید دکمه {ALT } را روی بات نگه دارید یا در اکشن هوس به دیگران بفروشید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },
                }, allowed = {}
            },
            { -- Khayati
                id = "khayati", title = "خیاطی", search = "خیاطی پشم پارچه لباس دوخت",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/khayati/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati00.png" },
                    { text = "برای انجام شغل خیاطی ، در ابتدا شما باید به مکان مشخص شده بروید و لباس شغل خیاطی را بپوشید",
                    url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati01.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati03.png" },
                    { text = "سپس میتوانید از محل مشخص شده یک ماشین تحویل بگیرید ، دقت داشته باشید که زمانی که ماشین شغل را تحویل می گیرید 50000 دلار به عنوان بیعانه از شما گرفته می‌شود و پس از تحویل ماشین این مبلغ به شما پس داده خواهد شد",
                    url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati02.png" },
                    { text = "سپس برای جمع آوری پشم به مکان مشخص شده بروید، از ماشین پیاده شوید و دکمه { E } را جهت شروع فرآیند بزنید",
                    url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati04.png" },
                    { text = "در مرحله بعد ، به مکان اولیه برگردید و وارد ساختمان شوید و پشم را به پارچه و پارچه را به لباس تبدیل کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati05.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati06.png" },
                    { text = "پس از تبدیل پارچه ها به لباس با مراجعه به بات خریدار می‌توانید لباس ها را بفروشید یا در اکشن هوس به دیگران بفروشید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" },
                    url = "https://cdn.sunrp.ir/helpcenter/khayati/khayati07.png" },
                }, allowed = { }
            },
            { -- najari
                id = "najari", title = "نجاری", search = "نجاری چوب الوار بسته",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/najari/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/najari/najari00.png" },
                    { text = "برای انجام شغل نجاری، در ابتدا شما باید به مکان مشخص شده بروید و لباس شغل نجاری را بپوشید",
                    url = "https://cdn.sunrp.ir/helpcenter/najari/najari01.png" },
                    { text = "سپس میتوانید از محل مشخص شده یک ماشین تحویل بگیرید ، دقت داشته باشید که زمانی که ماشین شغل را تحویل می گیرید 50000 دلار به عنوان بیعانه از شما گرفته می‌شود و پس از تحویل ماشین این مبلغ به شما پس داده خواهد شد",
                    url = "https://cdn.sunrp.ir/helpcenter/najari/najari02.png" },
                    { text = "سپس به مکان مشخص شده بروید و چوب جمع آوری کنید ، در همان مکان می‌توانید چوب ها را به الوار و الوارها را به بسته الوار تبدیل کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/najari/najari03.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/najari/najari04.png" },
                    { text = "پس از تبدیل با مراجعه مکان اولیه شغل می‌توانید بسته الوار را به بات خریدار بفروشید . یا در اکشن هوس به دیگران بفروشید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },
                }, allowed = { }
            },
            { -- barbari
                id = "barbari", title = "بار بری", search = "باربری پولشویی",
                shortDis = "از شروع کار تا حرفه‌ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/barbari/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/barbari/barbari00.png" },
                    { text = "برای انجام شغل باربری، در ابتدا شما باید به مکان مشخص شده بروید و لباس شغل باربری را بپوشید",
                    url = "https://cdn.sunrp.ir/helpcenter/barbari/barbari01.png" },
                    { text = "سپس می‌توانید از محل مشخص شده یک موتور یا ماشین یا کامیون تحویل بگیرید ، دقت داشته باشید که زمانی که وسیله نقلیه شغل را تحویل می گیرید 50000 دلار به عنوان بیعانه از شما گرفته می‌شود و پس از تحویل وسیله این مبلغ به شما پس داده خواهد شد",
                    url = "https://cdn.sunrp.ir/helpcenter/barbari/barbari02.png" },
                    { text = "سپس یک مکان بر روی نقشه برای شما مارک می‌شود. شما باید با وسیله نقلیه جاب به مکان مشخص شده بروید و در آن مکان بسته را تحویل دهید.",
                    url = "https://cdn.sunrp.ir/helpcenter/barbari/barbari03.png" },
                    { text = "زمانی که به مکان مورد نظر رسیدید از ماشین پیاده شوید و بسته را از داخل ماشین بردارید و به مکان مشخص شده بروید و بسته را تحویل دهید",
                    url = "https://cdn.sunrp.ir/helpcenter/barbari/barbari04.png" },
                    { text = "توجه داشته باشید اگر در جیب شما پول کثیف وجود داشته باشد. در زمان تحویل بسته، مقداری از پول کثیف داخل جیب شما به پول تمیز تبدیل می‌شود (به اصلاح پول‌شویی انجام می‌شود)", btn = { text = "برای مشاهده آموزش پول‌شویی کلیک کنید", id = "poolshoee" } },
                }, allowed = {}
            },
            { -- shekar
                id = "shekar", title = "شکار", search = "شکار حیوان پوست لاشه",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/shekar/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar00.png" },
                    { text = "برای انجام شغل شکار، در ابتدا شما باید به مکان مشخص شده بروید و لباس شغل شکار را بپوشید",
                    url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar01.png" },
                    { text = "برای پوشیدن لباس و شروع شغل شکار شما نیاز به یک سلاح سرد چاقو ( dagger - knife - machete - switchblade ) دارید. می‌توانید از گان شاپ ها این وسیله را تهیه کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar02.png" },
                    { text = "دقت کنید سلاح سرد را در یکی از سه خانه مشخص شده داخل اینونتوری قرار دهید",
                    url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar03.png" },
                    { text = "پس از پوشیدن لباس، در محوطه نارنجی رنگ به دنبال حیوان برای شکار بگردید. دقت کنید اگر به یک حیوان نزدیک شوید داخل نقشه کوچک موقعیت آن حیوان به شما نمایش داده می‌شود",
                    url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar04.png" },
                    { text = "توجه داشته باشید که مادامی که لباس شکار را پوشیده باشید نمی‌توانید سوار وسیله نقلیه شوید. همچنین اگر از محوطه نارنجی خارج شوید شما آفدیوتی خواهید شد و مجدد باید به مکان اول برگردید و لباس شغل را بپوشید" },
                    { text = "در حین شکار حیوانات وحشی به شما حمله می کنند ( مراقب باشید )" },
                    { text = "پس از شکار حیوان جهت برداشتن دکمه { E } را بزنید. لازم به ذکر است حیوانات را فقط با گان ماسکت ( musket ) که به شما داده شده است شکار کنید. در صورتی که با گان دیگری شکار کنید نمی‌توانید آن را لوت کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar05.png" },
                    { text = "سپس به محل ذبح ( قصابی ) بروید و لاشه ها را ذبح کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar06.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar07.png" },
                    { text = "پس از انجام کار با مراجعه مکان مشخص شده ، می‌توانید آیتم های به دست آمده را به بات خریدار بفروشید یا در اکشن هوس به دیگران بفروشید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" },
                    url = "https://cdn.sunrp.ir/helpcenter/shekar/shekar09.png" },
                }, allowed = { }
            },
            { -- Mahigiri
                id = "mahigiri", title = "ماهیگیری", search = "ماهیگیری ماهی",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/mahigiri/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mahigiri/mahigiri01.png" },
                    { text = "برای شروع شغل ماهیگیری، نیاز به قلاب ماهیگیری دارید" },
                    { text = "برای تهیه قلاب ماهیگیری به یکی از گان شاپ های شهر مراجعه کنید و یک قلاب بخرید",
                    url = "https://cdn.sunrp.ir/helpcenter/mahigiri/mahigiri02.png" },
                    { text = "برای خرید دکمه { ALT } را روی بات نگه دارید",
                    url = "https://cdn.sunrp.ir/helpcenter/mahigiri/mahigiri03.png" },
                    { text = "سپس نزدیک آب شوید و برای شروع دکمه { E } را فشار دهید. (توجه داشته باشید برای خفت نشدن داخل مناطق سبز رنگ ماهیگیری کنید)",
                    url = "https://cdn.sunrp.ir/helpcenter/mahigiri/mahigiri05.png" },
                    { text = "ماهی های گرفته شده را می‌توانید در محل فروش محصولات شکار، به بات خریدار بفروشید . یا در اکشن هوس به دیگران بفروشید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" },
                    url = "https://cdn.sunrp.ir/helpcenter/mahigiri/mahigiri06.png" },
                }, allowed = { }
            },
            { -- farm
                id = "farm", title = "مزرعه ( کشاورزی، فارم )", search = "مزرعه فارم کشاورزی دانه",
                shortDis = "از شروع کار تا حرفه ای شدن",
                icon = "https://cdn.sunrp.ir/helpcenter/farm/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm00.png" },

                    { text = "برای انجام شغل کشاورزی، در ابتدای شما باید یک مزرعه خریداری کنید. یا کلید یک مزرعه را از دوستانتان قرض بگیرید. ( بلیپ F نشان دهنده زمین فارم می باشد )",
                    url = "https://cdn.sunrp.ir/helpcenter/farm/farm01.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm02.png" },

                    { text = "زمین یک میلیونی .. ظرفیت = 10 مکان جهت کاشت همزمان .. کلید اضافه = 1 عدد" },
                    { text = "زمین پنج میلیونی .. ظرفیت = 15 مکان جهت کاشت همزمان .. کلید اضافه = 1 عدد" },
                    { text = "زمین ده میلیونی .. ظرفیت = 20 مکان جهت کاشت همزمان .. کلید اضافه = 1 عدد" },
                    { text = "زمین بیست میلیونی .. ظرفیت = 30 مکان جهت کاشت همزمان .. کلید اضافه = 2 عدد" },
                    { text = "زمین پنجاه میلیونی .. ظرفیت = 50 مکان جهت کاشت همزمان .. کلید اضافه = 3 عدد" },

                    { text = "گزینه های منوی ورودی مزرعه" },

                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm03.png" },

                    { text = "بخش مدیریت کلید مزرعه خود ( Manage Key )" },
                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm04.png" },

                    { text = "جهت شروع کشاورزی ابتدا بذر گیاهی که تمایل به کاشت آن را دارید را از اکشن هوس یا بات خرید و فروش محصولات کشاورزی تهیه کنید",
                    url = "https://cdn.sunrp.ir/helpcenter/farm/farm05.png" },

                    { text = "پس از تهیه بذر و ورود به مزرعه ، دکمه { E } را فشار دهید" },

                    { text = "و بذر مورد نظر را با دکمه { Enter } بکارید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm06.png" },

                    { text = "پس از کاشت ، آبیاری و صد درصد شدن ، محصول آماده برداشت می‌باشد" },
                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm07.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm08.png" },

                    { text = "محصولات بعد از برداشت به انبار مزرعه منتقل می‌شود. برای برداشتن محصولات از مزرعه خارج شوید و گزینه Open Barn ( انبار ) را باز کنید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/farm/farm03.png" },

                    { text = "محصولات خود را می‌توانید به بات خرید و فروش محصولات کشاورزی یا اکشن هوس به فروش برسانید", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },

                }, allowed = { }
            },
        },
        train2 = {
            { -- ozvgirijob mechanic
                id = "ozvmechanic", title = "عضویت در مکانیکی", search = "عضو عضوگیری جاب مکانیکی مکانیک",
                shortDis = "روش عضو شدن در شغل مکانیکی",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/mechanic.png",
                audio = false,
                image = {
                    { text = "برای عضو شدن در مکانیکی ویدئوی بالا را تا انتها ببینید" },
                    { text = "آدرس سایت" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/mechanic.mp4", allowed = { }
            },
            { -- ozvgirijob taxi
                id = "ozvtaxi", title = "عضویت در تاکسی", search = "عضو عضوگیری جاب taxi تاکسی",
                shortDis = "روش عضو شدن در شغل تاکسیرانی",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/taxi.png",
                audio = false,
                image = {
                    { text = "برای عضو شدن در شغل تاکسیرانی ویدئوی بالا را تا انتها ببینید" },
                    { text = "آدرس سایت" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/taxi.mp4", allowed = { }
            },
            { -- ozvgirijob medic
                id = "ozvmedic", title = "عضویت در مدیک", search = "عضو عضوگیری بیمارستان جاب medic مدیک دکتر",
                shortDis = "روش عضو شدن در شغل مدیک",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/medic.png",
                audio = false,
                image = {
                    { text = "برای عضو شدن در شغل مدیک ویدئوی بالا را تا انتها ببینید" },
                    { text = "آدرس سایت" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/medic.mp4", allowed = { }
            },
            { -- ozvgirijob Police
                id = "ozvpolice", title = "عضویت در پلیس", search = "عضو عضوگیری جاب پلیس lspd",
                shortDis = "روش عضو شدن در شغل پلیس",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/police.png",
                audio = false,
                image = {
                    { text = "برای عضو شدن در پلیس (LSPD) ویدئوی بالا را تا انتها ببینید" },
                    { text = "آدرس سایت" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/police.mp4", allowed = { }
            },
            { -- ozvgirijob sheriff
                id = "ozvsheriff", title = "عضویت در شریف", search = "عضو عضوگیری جاب شریف lspd",
                shortDis = "روش عضو شدن در شغل شریف",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/sheriff.png",
                audio = false,
                image = {
                    { text = "برای عضو شدن در شریف ویدئوی بالا را تا انتها ببینید" },
                    { text = "آدرس سایت" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/sheriff.mp4", allowed = { }
            },
            { -- ozvgirijob mt
                id = "ozvmt", title = "عضویت در ام‌تی", search = "عضو عضوگیری جاب ام تی سوات متروپولیتن lspd",
                shortDis = "روش عضو شدن در شغل ام‌تی",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/mt.png",
                audio = false,
                image = {
                    { text = "برای عضو شدن در ام‌تی ویدئوی بالا را تا انتها ببینید" },
                    { text = "آدرس سایت" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/mt.mp4", allowed = { }
            },
            { -- ozvgirijob justice
                id = "ozvjustice", title = "عضویت در دادگستری", search = "دادگستری جاستیس عضویت عضوگیری justice",
                shortDis = "روش عضو شدن در شغل دادگستری",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/justice.png",
                audio = false,
                image = {
                    { text = "برای عضو شدن در دادگستری ویدئوی بالا را تا انتها ببینید" },
                    { text = "آدرس سایت" },
                    { url = "https://cdn.sunrp.ir/helpcenter/site/site0000.png" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/justice.mp4", allowed = { }
            },
            { -- aeenname
                id = "aeenname", title = "آئین نامه", search = "آئین نامه گواهینامه گواهی نامه",
                shortDis = "آموزش گرفتن آئین نامه رانندگی",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/aeenname.png",
                audio = false,
                image = {
                    { text = "برای گرفتن آئین نامه رانندگی ویدئوی بالا را تا انتها ببینید" },
                    { text = "مکان استیشن شماره یک تاکسی" }, { url = "https://cdn.sunrp.ir/helpcenter/train2/taxi1.png" },
                    { text = "بعد از دریافت آئین‌نامه رانندگی می‌توانید برای گرفتن گواهینامه به دادگستری مراجعه کنید", btn = { text = "آموزش گرفتن گواهینامه", id = "govahiname" } },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/aeenname.mp4", allowed = { }
            },
            { -- govahiname
                id = "govahiname", title = "گواهینامه", search = "گواهینامه گواهی نامه",
                shortDis = "آموزش گرفتن گواهینامه",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/govahiname.png",
                audio = false,
                image = {
                    { text = "برای گرفتن گواهینامه ویدئوی بالا را تا انتها ببینید" },

                    { text = "مکان دادگستری روی نقشه" }, { url = "https://cdn.sunrp.ir/helpcenter/train2/govahiname1.png" },
                    { text = "مراحل باز کردن داخل دیسکورد دادگستری" }, { url = "https://cdn.sunrp.ir/helpcenter/train2/govahiname2.png" },
                    { text = "قبل از گرفتن گواهینامه باید به تاکسیرانی مراجعه کنید و آئین نامه رانندگی دریافت کنید", btn = { text = "آموزش گرفتن آئین نامه", id = "aeenname" } },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/govahiname.mp4", allowed = { }
            },
            { -- bime mashin
                id = "carbimeh", title = "بیمه ماشین", search = "بیمه ماشین",
                shortDis = "آموزش بیمه ماشین",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/carbimeh.png",
                audio = false,
                image = {
                    { text = "برای بیمه کردن ماشین ویدئوی بالا را تا انتها ببینید" },
                    { text = "مزایای بیمه ماشین:" },
                    { text = "ایمپاند رایگان" },
                    { text = "کلینر رایگان بعد از ریپیر" },
                    { text = "تغییر زمان ایمپاند از 15 به 5 دقیقه" },
                    { text = "انتقال فوری بین پارکینگ‌ها" },
                    { text = "افزایش زمان چاپ شاپ" },
                }, video = "https://cdn.sunrp.ir/helpcenter/train2/carbimeh.mp4", allowed = { }
            },
            { -- koore
                id = "koore", title = "کوره آهنگری", search = "کوره آهنگری",
                shortDis = "راهنمای کامل استفاده از کوره آهنگری",
                icon = "https://cdn.sunrp.ir/helpcenter/koore/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/koore/koore00.png" },

                    { text = "کوره آهنگری وسیله‌ای است جهت ذوب کردن آیتم‌های مختلف از جمله وسایلی که از رابری خانه‌ها بدست می آید " },
                    { text = "فقط کسانی که در شغل آهنگری مشغول به کار هستند دسترسی به استفاده از این کوره را دارند" },

                    { text = "توضیحات منوی کوره" },
                    { url = "https://cdn.sunrp.ir/helpcenter/koore/koore01.png" },

                    { text = "در قسمت ورودی می توانید آیتم هایی که می خواهید ذوب شوند و همچنین سوخت را اضافه کنید" },
                    { text = "در قسمت برداشت ، می‌توانید متریال های ذوب شده را بردارید. دقت کنید در باس اکشن می‌توانید دسترسی اعضای گنگ به برداشت آیتم را مدیریت کنید" },
                    { text = "با گزینه روشن کردن کوره می‌توانید آیتم‌های موجود در ورودی را ذوب کنید" },
                    { text = "در قسمت وضعیت ، آیتمی که در حال ذوب شده است را نمایش می دهد" },
                    { text = "برای روشن شدن کوره نیاز به سوخت دارید، سوخت را در قسمت ورودی وارد کنید" },

                    { text = "آیتم‌هایی که می‌توانید به عنوان سوخت استفاده کنید " },
                    { url = "https://cdn.sunrp.ir/helpcenter/koore/koore02.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/koore/koore10.png" },

                }, allowed = { }
            },
        },
        drugs = {
            { -- marijuana
                id = "marijuana", title = "سیگار برگ", search = "سیگار برگ شاهدانه بسته",
                shortDis = "سیگار برگ و بسته‌بندی آن",
                icon = "https://cdn.sunrp.ir/helpcenter/marijuana/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/marijuana/marijuana00.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/marijuana/marijuana000.png" },

                    { text = "برای درست کردن سیگار برگ، در ابتدا باید شاهدانه تهیه کنید، به دو روش می‌توانید شاهدانه را به دست آورید" },
                    { text = "روش اول: خرید از اکشن هوس", btn = { text = "برای مشاهده آموزش اکشن هوس کلیک کنید", id = "auctionhouse" } },
                    { text = "روش دوم: خرید بذر شاهدانه ( دانه شاهدانه ) و کاشتن آن در مزرعه", btn = { text = "برای مشاهده آموزش مزرعه کلیک کنید", id = "farm" } },

                    { text = "پس از تهیه شاهدانه به مکان زیر بروید و شاهدانه را به سیگار برگ تبدیل کنید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/marijuana/marijuana01.png" },

                    { text = "پس از ساخت سیگار برگ، در صورت نیاز می‌توانید به مکان زیر بروید و سیگار‌های برگ را به بسته سیگار برگ تبدیل کنید" },
                    { text = "توجه داشته باشید برای تبدیل شما نیاز به قارچ دارید، برای به دست آوردن قارچ، می‌توانید مثل شاهدانه از اکشن هوس بخرید یا در مزرعه بکارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/marijuana/marijuana02.png" },

                    { text = "سیگار برگ و بسته سیگار برگ را می‌توانید در محل فروش به بات خریدار یا در اکشن هوس به دیگران بفروشید ", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },

                    { url = "https://cdn.sunrp.ir/helpcenter/marijuana/marijuana03.png" },

                }, allowed = { }
            },
            { -- crack
                id = "crack", title = "کتان", search = "کتان روغن تخم دانه پودر",
                shortDis = "پودر ، روغن و بسته کتان",
                icon = "https://cdn.sunrp.ir/helpcenter/crack/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/crack/crack00.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/crack/crack000.png" },

                    { text = "برای درست کردن، در ابتدا باید تخم کتان تهیه کنید. به دو روش می‌توانید تخم کتان را به دست آورید" },
                    { text = "روش اول: خرید از اکشن هوس", btn = { text = "برای مشاهده آموزش اکشن هوس کلیک کنید", id = "auctionhouse" } },
                    { text = "روش دوم: خرید بذر کتان ( دانه کتان ) و کاشتن آن در مزرعه", btn = { text = "برای مشاهده آموزش مزرعه کلیک کنید", id = "farm" } },

                    { text = "پس از تهیه تخم کتان به مکان زیر ( کشتی ) بروید و تخم کتان را به پودر کتان تبدیل کنید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/crack/crack01.png" },

                    { text = "پس از درست کردن پودر کتان در همان مکان می‌توانید پودر کتان را به روغن کتان تبدیل کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/crack/crack02.png" },

                    { text = "پس از درست کردن روغن کتان، در صورت نیاز می‌توانید به مکان زیر بروید و روغن کتان را به بسته کتان تبدیل کنید" },
                    { text = "توجه داشته باشید برای تبدیل شما نیاز به قارچ دارید، برای به دست آوردن قارچ، می‌توانید مثل تخم کتان از اکشن هوس بخرید یا در مزرعه بکارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/crack/crack03.png" },

                    { text = "پودر کتان، روغن کتان و بسته کتان را می‌توانید در محل فروش به بات خریدار یا در اکشن هوس به دیگران بفروشید ", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },

                    { url = "https://cdn.sunrp.ir/helpcenter/crack/crack04.png" },

                }, allowed = { }
            },
            { -- meth
                id = "meth", title = "افدراین", search = "افدرا پودر افدراین قرص ",
                shortDis = "افدرا، پودر افدرا و قرص افدراین",
                icon = "https://cdn.sunrp.ir/helpcenter/meth/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/meth/meth00.png" },

                    { url = "https://cdn.sunrp.ir/helpcenter/meth/meth000.png" },

                    { text = "برای درست کردن، در ابتدا باید افدرا تهیه کنید. به دو روش می‌توانید افدرا را به دست آورید" },
                    { text = "روش اول: خرید از اکشن هوس", btn = { text = "برای مشاهده آموزش اکشن هوس کلیک کنید", id = "auctionhouse" } },
                    { text = "روش دوم: خرید بذر افدرا ( دانه افدرا ) و کاشتن آن در مزرعه", btn = { text = "برای مشاهده آموزش مزرعه کلیک کنید", id = "farm" } },

                    { text = "پس از تهیه افدرا به مکان زیر بروید و افدرا را به پودر افدرا تبدیل کنید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/meth/meth01.png" },

                    { text = "پس از درست کردن پودر افدرا به مکان زیر بروید و پودر افدرا را به قرص افدراین تبدیل کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/meth/meth02.png" },

                    { text = "پس از درست کردن قرص افدراین، در صورت نیاز می‌توانید به مکان زیر بروید و قرص افدراین را به بسته افدراین تبدیل کنید" },
                    { text = "توجه داشته باشید برای تبدیل شما نیاز به قارچ دارید، برای به دست آوردن قارچ، می‌توانید مثل افدرا از اکشن هوس بخرید یا در مزرعه بکارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/meth/meth03.png" },

                    { text = "قرص افدراین و بسته افدراین را می‌توانید در محل فروش به بات خریدار یا در اکشن هوس به دیگران بفروشید ", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },

                    { url = "https://cdn.sunrp.ir/helpcenter/meth/meth04.png" },

                }, allowed = { }
            },
            { -- heroine
                id = "heroine", title = "زیره", search = "زیره سیاه پودر کپسول",
                shortDis = "زیره‌سیاه، پودر و کپسول زیره",
                icon = "https://cdn.sunrp.ir/helpcenter/heroine/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/heroine/heroine00.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/heroine/heroine000.png" },

                    { text = "برای درست کردن، در ابتدا باید زیره سیاه تهیه کنید. به دو روش می‌توانید زیره سیاه را به دست آورید" },
                    { text = "روش اول: خرید از اکشن هوس", btn = { text = "برای مشاهده آموزش اکشن هوس کلیک کنید", id = "auctionhouse" } },
                    { text = "روش دوم: خرید بذر زیره ( دانه زیره ) و کاشتن آن در مزرعه", btn = { text = "برای مشاهده آموزش مزرعه کلیک کنید", id = "farm" } },

                    { text = "پس از تهیه زیره سیاه به مکان زیر بروید و زیره سیاه را به پودر زیره تبدیل کنید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/heroine/heroine01.png" },

                    { text = "پس از درست کردن پودر زیره به مکان زیر بروید و پودر زیره را به کپسول زیره تبدیل کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/heroine/heroine02.png" },

                    { text = "پس از درست کردن کپسول زیره، در صورت نیاز می‌توانید به مکان زیر بروید و کپسول زیره را به بسته زیره تبدیل کنید" },
                    { text = "توجه داشته باشید برای تبدیل شما نیاز به قارچ دارید، برای به دست آوردن قارچ، می‌توانید مثل زیره سیاه از اکشن هوس بخرید یا در مزرعه بکارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/heroine/meth03.png" },

                    { text = "کپسول زیره و بسته زیره را می‌توانید در محل فروش به بات خریدار یا در اکشن هوس به دیگران بفروشید ", btn = { text = "برای مشاهده آموزش اکشن‌هوس، کلیک کنید", id = "auctionhouse" } },

                    { url = "https://cdn.sunrp.ir/helpcenter/heroine/heroine04.png" },

                }, allowed = { }
            },
            { -- adrenaline
                id = "adrenaline", title = "آدرنالین", search = "داروخانه آدرنالین ساخت",
                shortDis = "ساخت و فروش آدرنالین",
                icon = "https://cdn.sunrp.ir/helpcenter/medic/adrenaline.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/adrenaline.png" },
                    { text = "برای ساخت آدرنالین به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/adrenaline1.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = { "ambulance", "offambulance" }
            },
            { -- Erythropoietin
                id = "erythropoietin", title = "اریتروپویتین", search = "داروخانه اریتروپویتین ساخت",
                shortDis = "ساخت و فروش اریتروپویتین",
                icon = "https://cdn.sunrp.ir/helpcenter/medic/erythropoietin.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/erythropoietin.png" },
                    { text = "برای ساخت اریتروپویتین به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/erythropoietin1.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = { "ambulance", "offambulance" }
            },
            { -- Gelofen
                id = "gelofen", title = "ژلوفن", search = "داروخانه ژلوفن ساخت",
                shortDis = "ساخت و فروش ژلوفن",
                icon = "https://cdn.sunrp.ir/helpcenter/medic/gelofen.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/gelofen.png" },
                    { text = "برای ساخت ژلوفن به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/gelofen1.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = { "ambulance", "offambulance" }
            },
            { -- medikit
                id = "medikit", title = "مدکیت", search = "مدکیت ساخت",
                shortDis = "ساخت مدکیت",
                icon = "https://cdn.sunrp.ir/helpcenter/medic/medikit.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/medikit.png" },
                    { text = "برای ساخت مدکیت (کیت درمان) به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/medikit1.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = { "ambulance", "offambulance" }
            },
            { -- bandage
                id = "bandage", title = "بانداژ", search = "بانداژ ساخت",
                shortDis = "ساخت بانداژ",
                icon = "https://cdn.sunrp.ir/helpcenter/medic/bandage.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/bandage.png" },
                    { text = "برای ساخت بانداژ به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/medic/bandage1.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = { "ambulance", "offambulance" }
            },
        },
        robbery = {
            { -- houserobbery
                id = "houserobbery", title = "دزدی از خانه", search = "دزدی خانه",
                shortDis = "راهنمای دزدی از خانه",
                icon = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery0000.png" },

                    { text = "برای دزدی از خانه، شما نیاز به نقشه دزدی از خانه (HouseRob Plan) دارید" },
                    { text = "برای به دست آوردن نقشه به مکان زیر بروید و یک نقشه خریداری کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery00.png" },
                    { text = "پس از استفاده از نقشه دزدی، مکان خانه مورد نظر بر روی مپ نمایش داده می‌شود" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery01.png" },
                    { text = "پس از استفاده از نقشه شما ده دقیقه فرصت دارید وارد خانه شوید" },
                    { text = "و بیست دقیقه پس از وارد شدن به خانه دیگر امکان ادامه دزدی از آن خانه وجود ندارد و باید نقشه جدید تهیه کنید" },
                    { text = "پس از ورود به خانه مورد نظر، حسگر صدا فعال می‌شود، باید آهسته حرکت کنید. در صورت دویدن آلارم دزدی از خانه فعال می شود" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery05.png" },
                    { text = "زمانی که به وسایل قابل دزدی نزدیک شوید، با خط زرد به شما نمایش داده می شود" },
                    { text = "با دکمه { ALT } می‌توانید اقدام به سرقت کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery02.png" },
                    { text = "برای سرقت آنها حتما باید اسکیل چک را انجام دهید و در زمان مشخص اعداد نمایش داده شده را فشار دهید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery03.png" },
                    { text = "پس از برداشتن آیتم باید از خانه خارج شوید و وسیله را با دکمه { ALT } و گزینه بار زدن شیء آن را داخل ماشین بگذارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery04.png" },
                    { text = "داخل همه خانه‌ها یک گاوصندوق وجود دارد که با باز کردن قفل آن می توانید اشیاء داخل گاوصندوق را به دست آورید" },

                    { text = "درصورتی که اسکیل هوس رابری شما صد در صد باشد احتمال دارد از گاوصندوق بلک مموری دریافت کنید" },
                    { btn = { text = "برای آشنایی با بلک مموری کلیک کنید", id = "darktape" }  },

                    { text = "دقت کنید اگر موفق به بازکردن گاوصندوق نشوید، آلارم دزدی از خانه فعال می‌شود" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery006.png", btn = { text = "برای آشنایی با هک رابری کلیک کنید", id = "hack1" }  },

                    { text = "پس از دزدی وسایل داخل خانه می‌توانید به محل خرید نقشه برگردید و وسایل مسروقه را به لستر بفروشید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery000.png" },

                    { text = "یا با مراجعه به آهنگری‌های سطح شهر آنها را با آهنگری‌ها معامله کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/houserobbery/houserobbery07.png", btn = { text = "برای آشنایی با آهنگری کلیک کنید", id = "koore" } },

                }, allowed = { }
            },
            { -- pursuit
                id = "pursuit", title = "پرسوت رابری", search = "پرسوت رابری",
                shortDis = "راهنمای پرسوت رابری",
                icon = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/logo.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/pursuit00.png" },

                    { text = "برای شروع رابری(دزدی از ماشین حمل پول)، باید نقشه پرسوت رابری (CarRob Plan) را به دست آورید" },
                    { text = "نقشه پرسوت رابری فقط در گاوصندوق خانه‌ها بدست می‌آید", btn = { text = "برای آشنایی با دزدی از خانه کلیک کنید", id = "houserobbery" }  },
                    { text = "دقت کنید این نقشه با ری استارت سرور حذف خواهد شد (پس تا زمان ری استارت سرور فرصت دارید از آن استفاده کنید)" },
                    { text = "پس از استفاده، مکانی روی نقشه به شما نمایش داده می‌شود" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/pursuit01.png"},
                    { text = "پس از رسیدن به مکان مشخص شده، باید ماشین حمل پول را هک کنید و سوار ماشین شوید ( برای هک کردن نیاز به لپ تاپ هک دارید )" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/pursuit02.png"},
                    { text = "جهت سوار شدن ماشین ، ابتدا باید هک ماشین را انجام دهید", btn = { text = "برای آشنایی با هک رابری کلیک کنید", id = "hack1" }  },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/pursuit003.png"},
                    { text = "پس از سوار شدن ماشین حمل پول باید آن را به مقصد مشخص شده روی نقشه برسانید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/pursuit04.png"},
                    { text = "در محل مشخص شده ماشین را با دکمه { E } تحویل دهید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/pursuit05.png"},
                    { text = "لوت پرسوت یک جعبه است که با باز کردن آن، بسته به شانس شما آیتم‌های متفاوتی دریافت می کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/pursuit/pursuit06.png"},

                    { text = "درصورتی که اسکیل پرسوت رابری شما صد در صد باشد احتمال دارد بلک مموری دریافت کنید" },
                    { btn = { text = "برای آشنایی با بلک مموری کلیک کنید", id = "darktape" }  },

                    { text = "نکات قابل توجه:" },
                    { text = "زمانی که سوار ماشین حمل پول هستید، موقعیت ماشین برای پلیس ارسال می‌شود و تا رسیدن به مقصد شما را اسکورت می‌کنند" },
                    { text = "اگر در زمان تحویل ماشین، پلیس در محل حضور نداشته باشد، لوت کامل را دریافت نمی‌کنید" },
                    { text = "اگر در زمان مشخص شده ماشین را تحویل ندهید، ماشین حذف خواهد شد" },
                    { text = "در زمان تحویل ماشین، یکی از دوستان شما با وسیله نقلیه باید شما را سوار کند و از محل فرار کنید" },
                    { text = "قوانین تیراندازی به پلیس مطالعه شود" },
                    { text = "تا زمانی که پلیس به شما تیراندازی نکند، اجازه تیراندازی به پلیس را ندارید" },
                    { text = "در صورتی که سه بار یا بیشتر پلیس به ماشین شما رم دهند، فقط مجاز هستید که به لاستیک آن‌ها شلیک کنید" },
                }, allowed = { }
            },
            { -- hack
                id = "hack1", title = "آموزش هک رابری", search = "هک رابری",
                shortDis = "راهنمای هک رابری",
                icon = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/logo.png",
                audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack000.png" },

                    { text = "برای انجام این هک، ابتدا به چهار عدد( یا حروف ) بالا دقت کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack02.png"},
                    { text = "یک عدد (یا حرف یا کارکتر) را انتخاب کنید" },
                    { text = "و بیین اعداد یا حروف پایین مشابه آن را پیدا کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack03.png"},
                    { text = "پس از یافتن اعداد مشابه، به عدد یا حرف بعدی بالا دقت کنید و ببینید کدامیک از اعداد یا حروف پایین مشابه آن است" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack04.png"},
                    { text = "به همین ترتیب چهارکاراکتر را چک کنید و با کلید های فلش روی کیبورد به روی اعداد مشابه بروید" },

                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack05.png"},
                    { text = "در انتها با فشار دادن دکمه { ENTER } کیبورد، هک با موفقیت تمام می شود" },

                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack07.png"},

                    { text = "جهت تمرین می‌توانید به سایت زیر مراجعه کنید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack01.png"},
                }, video = "https://cdn.sunrp.ir/helpcenter/robbery/hack1/hack1.mp4",  allowed = { }
            },
            { -- darktape
                id = "darktape", title = "بلک مموری", search = "بلک مموری memory ",
                shortDis = "بلک مموری چیست و برای چه استفاده می شود",
                icon = "https://cdn.sunrp.ir/helpcenter/robbery/darktape/logo.png",
                video = false, audio = false,
                image = {
                    { text = "در صورتی که اسکیل هوس رابری و پرسوت رابری را صد در صد کرده باشید" },
                    { btn = { text = "برای آشنایی با هوس رابری کلیک کنید", id = "houserobbery" }  },
                    { btn = { text = "برای آشنایی با پرسوت رابری کلیک کنید", id = "pursuit" }  },
                    { text = "احتمال دارد آیتم بلک مموری را دریافت کنید" },
                    { text = "توجه داشته باشید این آیتم با ری استارت سرور از بین می رود" },
                    { text = "این آیتم برای انجام کوئست مورد استفاده قرار می گیرد" },
                    { url = "https://cdn.sunrp.ir/helpcenter/robbery/darktape/darktape1.png"},
                    { text = "این کوئست بینهایت است و پس از انجام آن می توانید مجدد آن را اکسپت کنید" },
                }, allowed = { }
            },
        },
        mechanic1 = {
            { -- kittire
                id = "mcrules", title = "قوانین مکانیکی", search = "قوانین مکانیکی مکانیک",
                shortDis = "قوانین مکانیکی",
                icon = "https://cdn.sunrp.ir/helpcenter/train2/mechanic.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc1.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc2.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc3.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc4.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc5.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc6.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc7.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc8.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc9.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc10.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc11.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc12.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc13.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc14.png" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/mc15.png" },
                }, allowed = {}
            },
            { -- kittire
                id = "kittiremc", title = "کیت تایر", search = "کیت تایر",
                shortDis = "ساخت و فروش کیت تایر",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/kittire.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/kittire.png" },
                    { text = "برای ساخت کیت تایر، به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/kittire2.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
            { -- kit50
                id = "kit50mc", title = "کیت تعمیر 50 درصد", search = "کیت تعمیر 50 کیت50",
                shortDis = "کیت تایر 50 درصد",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/kit50.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/kit50.png" },
                    { text = "برای ساخت کیت 50 ، به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/kit502.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
            { -- cleaner
                id = "cleanermc", title = "کلینر", search = "کلینر",
                shortDis = "کلینر (تمیز کننده ماشین)",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/cleaner.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/cleaner.png" },
                    { text = "برای ساخت کلینر به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/cleaner2.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
            { -- engine
                id = "enginemc", title = "موتور ماشین", search = "موتور ماشین اینجین",
                shortDis = "موتور ماشین",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/engine.png",
                video = false, audio = false,
                image = {
                    { text = "-----------------------------------------------------------------" },
                    { text = "برای ساخت موتور X1 به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/engine1a3.png" },
                    { text = "-----------------------------------------------------------------" },
                    { text = "برای ساخت موتور X2 به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/engine2a3.png" },
                    { text = "-----------------------------------------------------------------" },
                    { text = "برای ساخت موتور X3 به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/engine3a.png" },
                    { text = "-----------------------------------------------------------------" },
                    { text = "برای ساخت موتور X4 به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/engine4a.png" },
                    { text = "-----------------------------------------------------------------" },
                    { text = "برای ساخت موتور X5 به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/engine5a.png" },
                    { text = "-----------------------------------------------------------------" },
                    { text = "برای ساخت موتور X6 به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/engine6a.png" },

                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
            { -- pich
                id = "pichmc", title = "پیچگوشتی", search = "پیچ پیچگوشتی",
                shortDis = "پیچگوشتی",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/pich.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/pich.png" },
                    { text = "برای ساخت پیچگوشتی به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/pich2.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
            { -- jack
                id = "jackmc", title = "جک ماشین", search = "جک ماشین",
                shortDis = "جک ماشین",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/jack.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/jack.png" },
                    { text = "برای ساخت جک به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/jack2.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
            { -- lockpick
                id = "lockpickmc", title = "لاک پیک", search = "لاک پیک سنجاق",
                shortDis = "لاک پیک ( سنجاق )",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/lockpick.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/lockpick.png" },
                    { text = "برای ساخت سنجاق ( lock pick ) به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/lockpick2.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
            { -- kit100
                id = "kit100mc", title = "کیت 100", search = "کیت 100 تعمیر",
                shortDis = "کیت تعمیر 100 درصد",
                icon = "https://cdn.sunrp.ir/helpcenter/mechanic/kit100.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/kit100.png" },
                    { text = "برای ساخت کیت 100 به آیتم‌های زیر نیاز دارید" },
                    { url = "https://cdn.sunrp.ir/helpcenter/mechanic/kit100a.png" },
                    { text = "توجه داشته باشید که قبل از ساخت، کوئست مربوطه را اکسپت کنید" },
                    { text = "به دلیل محدودیت در ساخت، در صورتی که قبل از اکسپت کوئست، آیتم‌ها را بسازید، نمی‌توانید کوئست آن را به پایان برسانید" },
                }, allowed = {}
            },
        },

        akkbar = {
            { -- 
                id = "lsd2", title = "حذف کافئین", search = "lsd کافئین",
                shortDis = "LSD",
                icon = "https://cdn.sunrp.ir/helpcenter/akkbar/lsd2.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/akkbar/lsd2.png" },
                    { text = "با توجه به کاهش ریکویل گان‌های سرور،" },
                    { text = " آیتم‌ کاهنده ریکویل مانند LSD یا کافئین از چرخه مصرف خارج شد" },
                    { text = "بازیکنان می‌توانند با مراجعه به آهنگری‌ها" },
                    { text = "این آیتم را تحویل داده و متریال‌های خام مربوطه را دریافت کنند" },

                }, allowed = {}
            },
            { -- 
                id = "newcraft", title = "کرفت جدید", search = "craft gang",
                shortDis = "New Gang Craft",
                icon = "https://cdn.sunrp.ir/helpcenter/akkbar/craft.png",
                video = false, audio = false,
                image = {
                    { url = "https://cdn.sunrp.ir/helpcenter/akkbar/craft2.png" },
                    { text = "....coming soon" },
                }, allowed = {}
            },
        }
    }
}