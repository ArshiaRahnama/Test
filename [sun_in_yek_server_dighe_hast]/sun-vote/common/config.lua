-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

VoteConfig = {}

VoteConfig.Debug = true

VoteConfig.AdminPermissionLevel = 20

VoteConfig.DB_Elections    = 'sunsetElections'
VoteConfig.DB_VoteData     = 'sunsetVoteData'
VoteConfig.DB_VoterRecords = 'sunsetVoterRecords'

VoteConfig.JobDolati = {
    'police',
    'sheriff',
    'mt',
    'detective',
    'fbi',
    'justice',
    'ambulance',
    'taxi',
    'mechanic',
    'weazel',
}

VoteConfig.Notify = {
    noElection       = 'در حال حاضر هیچ انتخاباتی در حال برگزاری نیست',
    alreadyVoted     = 'شما قبلا رأی خود را ثبت کرده‌اید',
    voteSuccess      = 'رأی شما با موفقیت ثبت شد',
    noCandidates     = 'هیچ کاندیدایی برای شما موجود نیست',
    electionCreated  = 'انتخابات با موفقیت ایجاد شد',
    electionEnded    = 'انتخابات به پایان رسید',
    noPermission     = 'شما دسترسی به این بخش را ندارید',
    invalidTime      = 'زمان وارد شده نامعتبر است',
    candidateAdded   = 'کاندیدا با موفقیت اضافه شد',
    noActiveStats    = 'هیچ آمار انتخاباتی موجود نیست',
    electionEnabled  = 'انتخابات فعال شد',
    electionDisabled = 'انتخابات غیرفعال شد',
    electionWiped    = 'انتخابات به طور کامل حذف شد',
    noCandidateFirst = 'ابتدا باید کاندیدا اضافه کنید',
    noElectionId     = 'شناسه انتخابات نامعتبر است',
    timeUpdated      = 'زمان انتخابات بروزرسانی شد',
    selectElection   = 'یک انتخابات را انتخاب کنید',
    logSent          = 'لاگ انتخابات با موفقیت ارسال شد',
}

VoteConfig.Jobs = {
    { name = 'police',       label = 'پلیس' },
    { name = 'offpolice',    label = 'پلیس (آف دیوتی)' },
    { name = 'sheriff',      label = 'شریف' },
    { name = 'offsheriff',   label = 'شریف (آف دیوتی)' },
    { name = 'mt',           label = 'ام تی' },
    { name = 'offmt',        label = 'ام تی (آف دیوتی)' },
    { name = 'detective',    label = 'کارآگاه' },
    { name = 'offdetective', label = 'کارآگاه (آف دیوتی)' },
    { name = 'fbi',          label = 'اف بی آی' },
    { name = 'offfbi',       label = 'اف بی آی (آف دیوتی)' },
    { name = 'justice',      label = 'دادگستری' },
    { name = 'offjustice',   label = 'دادگستری (آف دیوتی)' },
    { name = 'ambulance',    label = 'اورژانس' },
    { name = 'taxi',         label = 'تاکسی' },
    { name = 'mechanic',     label = 'مکانیک' },
    { name = 'weazel',       label = 'ویزل نیوز' },
    { name = 'wash',         label = 'کارواش' },
    { name = 'carbimeh',     label = 'بیمه خودرو' },
    { name = 'resturan',     label = 'رستوران' },
}
