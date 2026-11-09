-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

DocumentsConfig = {}

DocumentsConfig.Logo = 'img/doj-seal.png'
DocumentsConfig.WatermarkText = 'DEPARTMENT OF JUSTICE'
DocumentsConfig.OpenKey = 'f9'
DocumentsConfig.Command = 'documents'
DocumentsConfig.GiveRadius = 5.0
DocumentsConfig.AdminMinPermission = 8
DocumentsConfig.ModelEditorMinGrade = 12

DocumentsConfig.Blacklist = {
    Enabled = true,
    AdminCommand = 'dojblacklist',
    AdminMinPermission = 8,
    StorageKey = 'dojBlacklist',
}

DocumentsConfig.JusticeChiefGrade = 10
DocumentsConfig.PageSize = 25
DocumentsConfig.MaxArchivePages = 5

DocumentsConfig.JusticeJob = 'justice'
DocumentsConfig.PublicTemplateJob = 'public'
DocumentsConfig.JusticeMinGrade = 0

DocumentsConfig.LogChannel = 'doj_blacklist'

DocumentsConfig.GiveRequest = {
    AcceptCommand = 'acceptdoc',
    Timeout = 30,
}

DocumentsConfig.Limits = {
    Title       = 250,
    Name        = 150,
    Date        = 40,
    NameCreator = 150,
    Scope       = 60000,
    MaxImages   = 25,
    MaxSignatures = 40,
    MaxImageUrl       = 2048,
    MaxSignatureField = 256,
}

DocumentsConfig.Jobs = {
    OpenMenu       = { 'police', 'sheriff', 'detective', 'judge', 'lawyer', 'justice' },
    SaveTemplate   = { 'police', 'sheriff', 'judge', 'justice' },
    CreateDocument = { 'police', 'sheriff', 'detective', 'judge', 'lawyer', 'justice' },
    DeleteDocument = { 'police', 'sheriff', 'judge', 'justice' },
    CloseDocument  = { 'police', 'sheriff', 'judge', 'justice' },
    CopyDocument   = { 'police', 'sheriff', 'judge', 'lawyer', 'justice' },
}

DocumentsConfig.Translate = {
    TR_TITLE            = 'اسناد رسمی DOJ',
    TR_HEADER           = 'Department of Justice',
    TR_SUBHEADER        = 'Official Legal Document',
    TR_EXIT             = 'خروج',
    TR_CREATE           = 'ساختن',
    TR_SAVE             = 'ذخیره',
    TR_CANCEL           = 'لغو',
    TR_ADD              = 'اضافه کردن امضا',
    TR_REMOVE           = 'حذف امضا',
    TR_INSERT           = 'ضمیمه کردن عکس',
    TR_BUTTON_INSERT    = 'افزودن',
    TR_EXAMPLE_NAME     = 'نام شما',
    TR_EXAMPLE_INFO     = 'مقام شما',
    TR_PLACEHOLDER_TITLE = 'عنوان سند',
    TR_PLACEHOLDER_DATE  = 'تاریخ',
    TR_PLACEHOLDER_BODY  = 'متن کامل سند را اینجا وارد کنید...',
    TR_PLACEHOLDER_IMAGE = 'آدرس عکس را وارد کنید',

    TR_LOADING          = 'در حال بارگذاری',
    TR_LOADING2         = 'لطفاً صبر کنید',
    TR_VIEW_MODELS      = 'الگوها',
    TR_VIEW_MODELS2     = 'نمایش تمام الگوها',
    TR_VIEW_DOCUMENTS   = 'اسناد',
    TR_VIEW_DOCUMENTS2  = 'نمایش تمام اسناد شما',
    TR_CREATE2          = 'ساخت الگوی جدید',
    TR_CREATE3          = 'ساخت سند جدید',
    TR_CREATE4          = 'نام سند را وارد کنید',
    TR_BACK             = 'بازگشت',
    TR_BACK2            = 'منوی اصلی',
    TR_BACK3            = 'منوی الگوها',
    TR_BACK4            = 'منوی اصلی',
    TR_BACK5            = 'منوی اسناد',
    TR_EDIT             = 'ویرایش',
    TR_EDIT2            = 'ویرایش الگو ',
    TR_EDIT3            = 'ویرایش سند ',
    TR_DELETE           = 'حذف',
    TR_DELETE2          = 'حذف الگو ',
    TR_DELETE3          = 'حذف سند ',
    TR_CLOSE            = 'بستن',
    TR_CLOSE2           = 'بستن سند ',
    TR_OPEN             = 'نمایش',
    TR_OPEN2            = 'نمایش سند ',
    TR_COPY             = 'کپی',
    TR_COPY2            = 'ساخت کپی برابر اصل ',
    TR_COPY3            = '(کپی برابر اصل) ',
    TR_GIVE             = 'اشتراک',
    TR_GIVE2            = 'دادن سند به افراد نزدیک ',
    TR_RECEIVE          = 'شما یک سند دریافت کردید',
    TR_NOONE            = 'فردی نزدیک شما نیست',
    TR_SEARCH           = 'جستجو',
    TR_SEARCH2          = 'جستجوی سند',

    TR_NOT_DOCUMENTS    = 'شما سندی ندارید',
    TR_NOT_PERMISSION   = 'شما دسترسی این کار را ندارید',
    TR_COOLDOWN         = 'لطفاً کمی صبر کنید',
    TR_CREATED_DOCUMENT = 'سند ساخته شد',
    TR_UPDATED_DOCUMENT = 'سند ویرایش شد',
    TR_CREATED_TEMPLATE = 'الگو ساخته شد',
    TR_UPDATED_TEMPLATE = 'الگو ویرایش شد',
    TR_CLOSED_DOCUMENT  = 'سند بسته شد',
    TR_GIVE_DOCUMENT    = 'سند ارسال شد',
    TR_COPIED_DOCUMENT  = 'کپی ساخته شد',
    TR_DELETED_DOCUMENT = 'سند با موفقیت حذف شد',

    TR_MENU_MAIN        = 'منوی اصلی',
    TR_MENU_MODELS      = 'الگوهای سند',
    TR_MENU_DOCUMENTS   = 'اسناد شما',
    TR_MENU_TEMPLATES   = 'انتخاب الگو',
    TR_MENU_OPTIONS     = 'گزینه ها',
    TR_MENU_PLAYERS     = 'انتخاب گیرنده',
    TR_MENU_SEARCH      = 'نتایج جستجو',
    TR_SEARCH_PLACEHOLDER = 'نام سند را تایپ کنید...',
    TR_NEW_BADGE        = 'جدید',
    TR_NO_RESULTS       = 'موردی یافت نشد',
    TR_NEARBY_DISTANCE  = 'فاصله',
    TR_ID_LABEL         = 'شناسه',

    TR_BLACKLISTED      = 'شما از خدمات قضایی محروم میباشید',
    TR_MENU_BLACKLIST   = 'دسترسی محدود',

    TR_TEMPLATE_TYPE_CHOOSE   = 'انتخاب نوع الگو',
    TR_TEMPLATE_TYPE_SUBTITLE = 'یک نوع برای الگوی جدید انتخاب کنید',
    TR_TEMPLATE_FORMAL_TITLE  = 'الگوی رسمی',
    TR_TEMPLATE_FORMAL_DESC   = 'دارای آرم، تاریخ، تیتر و مهر رسمی DOJ به صورت پیش‌فرض',
    TR_TEMPLATE_BLANK_TITLE   = 'الگوی سفید',
    TR_TEMPLATE_BLANK_DESC    = 'برگه خالی - تمام بخش‌ها قابل تنظیم توسط شما',

    TR_BLACKLIST_USAGE        = 'دستور: /%s <playerId> <0|1> [دلیل]',
    TR_BLACKLIST_NOT_ONLINE   = 'بازیکن آنلاین نیست یا ID نامعتبر است',
    TR_BLACKLIST_ADDED        = '%s به بلک‌لیست DOJ اضافه شد',
    TR_BLACKLIST_REMOVED      = '%s از بلک‌لیست DOJ حذف شد',
    TR_BLACKLIST_NOT_FOUND    = 'این فرد در بلک‌لیست نیست',

    TR_MENU_BLACKLIST_MGMT       = 'مدیریت بلک‌لیست',
    TR_MENU_BLACKLIST_MGMT_DESC  = 'مشاهده و حذف بازیکنان بلک‌لیست شده',
    TR_MENU_BLACKLIST_TITLE      = 'فهرست بلک‌لیست DOJ',
    TR_BLACKLIST_EMPTY           = 'هیچ بازیکنی بلک‌لیست نشده است',
    TR_BLACKLIST_REMOVE_CONFIRM  = 'حذف از بلک‌لیست',
    TR_BLACKLIST_REASON_LABEL    = 'دلیل',
    TR_BLACKLIST_BY_LABEL        = 'توسط',
    TR_BLACKLIST_DATE_LABEL      = 'تاریخ',

    TR_MENU_ARCHIVE        = 'بایگانی',
    TR_MENU_ARCHIVE_DESC   = 'پرونده‌های بسته‌شده شغل شما',
    TR_MENU_ARCHIVE_TITLE  = 'بایگانی پرونده‌ها',
    TR_ARCHIVE_EMPTY       = 'پرونده بسته‌شده‌ای موجود نیست',
    TR_REOPEN              = 'باز کردن مجدد',
    TR_REOPEN2             = 'باز کردن مجدد سند ',
    TR_REOPENED_DOCUMENT   = 'سند مجدداً باز شد',
    TR_CHIEF_ONLY          = 'فقط رئیس شغل دسترسی دارد',

    TR_PAGE                = 'صفحه',
    TR_OF                  = 'از',
    TR_NEXT_PAGE           = 'صفحه بعد',
    TR_PREV_PAGE           = 'صفحه قبل',
    TR_TOTAL_ITEMS         = 'تعداد کل',
    TR_LOAD_MORE           = 'بارگذاری بیشتر',

    TR_BLACKLIST_ADD          = 'افزودن بازیکن جدید',
    TR_BLACKLIST_ADD_DESC     = 'ثبت بازیکن جدید در بلک‌لیست',
    TR_BLACKLIST_ENTER_ID     = 'شناسه بازیکن یا استیم هکس',
    TR_BLACKLIST_ENTER_REASON = 'دلیل ممنوعیت',
    TR_BLACKLIST_GIVE_BLOCKED = 'این بازیکن در بلک‌لیست DOJ است و امکان دریافت سند را ندارد',
    TR_BLACKLIST_ADD_MODAL    = 'افزودن به بلک‌لیست',
    TR_BLACKLIST_BAN_BTN      = 'بن کردن',
    TR_BLACKLIST_FILL_FIELDS  = 'لطفاً تمامی فیلدها را پر کنید',

    TR_BLACKLISTED_HELP   = 'جهت رفع محرومیت به اداره دادگستری مراجعه فرمایید',

    TR_GIVE_PROMPT_TITLE  = 'اشتراک سند',
    TR_GIVE_PROMPT_LABEL  = 'شناسه بازیکن یا اسم استیم گیرنده',
    TR_GIVE_PROMPT_PH     = 'مثلاً: 12 یا Steam Name',
    TR_GIVE_NOT_FOUND     = 'بازیکن مورد نظر پیدا نشد',
    TR_GIVE_SELF          = 'نمی‌توانید سند را به خودتان بدهید',
    TR_GIVE_RECEIVED      = '%s yek sanad (%s) be shoma dad',
    TR_GIVE_SENT          = 'Sanad (%s) ra be bazikon %s dadid',
    TR_GIVE_REQUEST_SENT  = 'درخواست اشتراک ارسال شد؛ منتظر تأیید گیرنده باشید',
    TR_GIVE_REQUEST_CHAT  = 'Shoma tavasote %s jahate daryafte yek sanad (%s) davat shodid; jahate taeed /%s ra bezanid',
    TR_GIVE_NO_REQUEST    = 'شما درخواست سند فعالی ندارید',
    TR_GIVE_EXPIRED       = 'درخواست سند منقضی شده است',
    TR_GIVE_EXPIRED_GIVER = 'زمان درخواست اشتراک به پایان رسید؛ می‌توانید دوباره تلاش کنید',
    TR_GIVE_ACCEPTED_BY   = 'Sanad (%s) tavasote %s daryaft shod',
    TR_GIVE_DECLINED_INFO = 'درخواست سند رد شد',
    TR_GIVE_DOC_PENDING   = 'این سند هم‌اکنون برای فرد دیگری در انتظار تأیید است',
    TR_GIVE_TARGET_BUSY   = 'این بازیکن یک درخواست سند در انتظار دارد؛ لطفاً صبر کنید',
    TR_GIVE_TOO_FAR       = 'برای دریافت سند باید به فرستنده نزدیک باشید',

    TR_CONFIRM_TITLE      = 'تأیید عملیات',
    TR_CONFIRM_CLOSE      = 'آیا از بستن این سند مطمئن هستید؟',
    TR_CONFIRM_DELETE     = 'آیا از حذف این مورد مطمئن هستید؟ این عمل قابل بازگشت نیست',
    TR_CONFIRM_GIVE       = 'آیا از اشتراک‌گذاری این سند مطمئن هستید؟',
    TR_CONFIRM_VOID       = 'آیا از باطل کردن این پرونده مطمئن هستید؟ پس از باطل شدن، ارزش قانونی خود را از دست می‌دهد',
    TR_CONFIRM_YES        = 'بله، مطمئنم',
    TR_CONFIRM_NO         = 'لغو',

    TR_VOID               = 'باطل کردن',
    TR_VOID2              = 'باطل کردن پرونده ',
    TR_VOIDED_DOCUMENT    = 'پرونده باطل شد',
    TR_VOID_STAMP         = 'باطل شد',
    TR_ALREADY_VOIDED     = 'این پرونده قبلاً باطل شده است',

    TR_PUBLIC_CREATE      = 'ساخت سند از الگوی عمومی',
    TR_PUBLIC_CREATE_DESC = 'استفاده از الگوهای منتشرشده دادگستری',
    TR_PUBLIC_EMPTY       = 'الگوی عمومی موجود نیست',
    TR_PUBLIC_MENU_TITLE  = 'الگوهای عمومی',
    TR_PUBLISH_LABEL      = 'انتشار عمومی الگو (همه شغل‌ها)',
    TR_PUBLISH_HINT       = 'خاموش = خصوصی (فقط دادگستری می‌بیند) | روشن = عمومی (همه بازیکنان با هر شغلی می‌توانند استفاده کنند)',
    TR_MANAGE_MODELS      = 'مدیریت الگوها',
    TR_MANAGE_MODELS_DESC = 'ویرایش و حذف الگوهای شغل شما',

    TR_BLOCK_SEAL         = 'مهر رسمی دادگستری',
    TR_BLOCK_SEAL_DESC    = 'مهر رسمی که به سند ارزش قانونی می‌دهد',
    TR_SEAL_CAPTION       = 'مهر رسمی دادگستری',

    TR_JUSTICE_SEAL        = 'مهر تأیید دادگستری',
    TR_JUSTICE_SEAL_TITLE  = 'تأیید رسمی دادگستری',
    TR_JUSTICE_SEAL_BY     = 'تأیید‌کننده',
    TR_JUSTICE_SEAL_APPLIED = 'مهر تأیید دادگستری ثبت شد',
    TR_JUSTICE_SEAL_NEED_SAVE = 'ابتدا باید سند ذخیره شده باشد',
    TR_JUSTICE_SEAL_DONE   = 'این سند قبلاً مهر تأیید خورده است',

    TR_BLOCK_LOCK         = 'نقل قول',
    TR_BLOCK_LOCKED_BADGE = 'نقل قول',

    TR_SIG_SIGN           = 'امضا کردن',
    TR_SIG_ALREADY        = 'شما قبلاً این سند را امضا کرده‌اید',
    TR_SIG_REMOVE_OWN     = 'حذف امضای من',

    TR_EDITOR_BACK        = 'بازگشت به منو',
}
