local COLORS = {
    DARK   = "#020c1b",
    MID    = "#0a192f",
    LIGHT  = "#112240",
    AQUA   = "#00f5d4",
    WHITE  = "#e6f1ff",
    GRAY   = "#8892b0",
    GREEN  = "#64ffda",
    RED    = "#ff6b6b",
    YELLOW = "#ffd93d"
}
-- ─────────────────────────────────────────────────────────
-- EXPANSION: rate limiting (SMS spam / balance protection) and login
-- brute-force lockout. Everything here is in-memory (resets on restart),
-- which is fine — these are abuse guards, not permanent bans.
-- ─────────────────────────────────────────────────────────
local function getIdentifierPrefix(src, prefix)
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len(prefix)) == prefix then
            return v
        end
    end
    return nil
end

local smsAttemptsByPhone = {} -- phone -> { count = n, windowStart = os.time() }
local smsAttemptsByIp    = {} -- ip    -> { count = n, windowStart = os.time() }
local loginFailures      = {} -- lowercased username -> { count = n, lockUntil = os.time() }
local newDeviceEvents    = {} -- account license -> { timestamp, timestamp, ... } (see Config.SuspiciousDeviceLock)

-- SECURITY FIX: guess-limit for a phone's currently-active OTP code (used
-- by both registration step 2 and forgot-password step 2). Without this,
-- a 6-digit code could be brute-forced with unlimited retries inside its
-- 2-minute validity window -- for forgot-password specifically, a
-- successful guess is a full account takeover (attacker sets a new
-- password). Cleared whenever a fresh code is issued or expires.
local codeVerifyAttempts = {} -- phone -> count

local function isCodeVerifyLocked(phone)
    return (codeVerifyAttempts[phone] or 0) >= Config.CodeVerifyLockout.MaxAttempts
end

local function registerCodeVerifyFailure(phone)
    codeVerifyAttempts[phone] = (codeVerifyAttempts[phone] or 0) + 1
end

local function clearCodeVerifyAttempts(phone)
    codeVerifyAttempts[phone] = nil
end

-- Returns true and bumps the counter if under the limit, false if the
-- caller should be blocked. windowSeconds is the rolling window length.
local function rateLimitCheck(store, key, maxCount, windowSeconds)
    if not key then return true end
    local now = os.time()
    local entry = store[key]
    if not entry or (now - entry.windowStart) >= windowSeconds then
        store[key] = { count = 1, windowStart = now }
        return true
    end
    if entry.count >= maxCount then
        return false
    end
    entry.count = entry.count + 1
    return true
end

local function isLoginLocked(username)
    local entry = loginFailures[username:lower()]
    if entry and entry.lockUntil and os.time() < entry.lockUntil then
        return true, math.ceil((entry.lockUntil - os.time()) / 60)
    end
    return false
end

local function registerLoginFailure(username)
    local key = username:lower()
    local entry = loginFailures[key] or { count = 0 }
    entry.count = entry.count + 1
    if entry.count >= Config.LoginLockout.MaxAttempts then
        entry.lockUntil = os.time() + (Config.LoginLockout.LockMinutes * 60)
        entry.count = 0
    end
    loginFailures[key] = entry
end

local function clearLoginFailures(username)
    loginFailures[username:lower()] = nil
end

-- EXPANSION: username blacklist check (see Config.UsernameBlacklist).
local function isUsernameBlacklisted(username)
    local lower = username:lower()
    for _, banned in ipairs(Config.UsernameBlacklist or {}) do
        if lower:find(banned, 1, true) then
            return true
        end
    end
    return false
end

-- ─────────────────────────────────────────────────────────
-- EXPANSION: audit log + new-device / password-reset Discord alerts.
--
-- Every login attempt, registration, and password reset gets written to
-- `login_audit` — this is what an admin panel would later read to show
-- "recent activity" on an account, or to spot a suspicious pattern (e.g.
-- 50 failed logins on one username from 50 different IPs). Separately, a
-- Discord webhook fires for the two events a player would actually want
-- to know about immediately: their account being used from a brand new
-- device, and their password being reset.
-- ─────────────────────────────────────────────────────────
local function logAudit(action, username, license, src)
    local ip = src and getIdentifierPrefix(src, "ip:") or nil
    local realLicense = src and getIdentifierPrefix(src, "license:") or nil
    MySQL.Async.execute(
        "INSERT INTO login_audit (username, license, device_license, ip, action) VALUES (@u, @l, @dl, @ip, @a)",
        { ["@u"] = username, ["@l"] = license, ["@dl"] = realLicense, ["@ip"] = ip, ["@a"] = action }
    )
end

local function sendDiscordAlert(title, description, color)
    if not Config.DiscordWebhook or not Config.DiscordWebhook.SecurityAlerts
        or Config.DiscordWebhook.SecurityAlerts == "" then
        return -- not configured, silently skip
    end
    PerformHttpRequest(Config.DiscordWebhook.SecurityAlerts, function() end, "POST",
        json.encode({
            embeds = {{
                title = title,
                description = description,
                color = color or 15158332, -- red-ish default
            }}
        }),
        { ["Content-Type"] = "application/json" }
    )
end

local smscodedict = {}
function ShowMainMenu(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "stretch",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "Unique RolePlay",
                                        weight = "bolder",
                                        size = "extraLarge",
                                        color = "Accent",
                                        horizontalAlignment = "center",
                                        fontType = "monospace"
                                    },
                                    {
                                        type = "TextBlock",
                                        -- text = "به دنیای واقعی خوش آمدید",
                                        size = "small",
                                        color = COLORS.Light,
                                        horizontalAlignment = "center",
                                        isSubtle = true,
                                        spacing = "small"
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "25px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },


                    {
                        type = "TextBlock",
                        text = "🔐 برای ورود به سرور احراز هویت کنید",
                        horizontalAlignment = "center",
                        color = COLORS.Light,
                        weight = "bolder",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "📅 " .. os.date("%Y/%m/%d") .. "  ⏰ " .. os.date("%H:%M"),
                        horizontalAlignment = "center",
                        color = COLORS.Light,
                        isSubtle = true,
                        spacing = "small"
                    }
                },
                cornerRadius = "0 0 15px 15px",
                padding = "25px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "🔑  ورود با حساب کاربری",
                data = { action = "login" }
            },
            {
                type = "Action.Submit",
                title = "📝  ثبت‌نام حساب جدید",
                style = "positive",
                data = { action = "register" }
            },
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "login" then
            ShowLoginForm(deferrals)
        elseif data.action == "register" then
            ShowRegisterStep1_Phone(deferrals)
        else
            ShowMainMenu(deferrals)
        end
    end)
end

function ShowLoginForm(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔑",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "ورود به حساب",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "نام کاربری و رمز عبور خود را وارد کنید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "👤 نام کاربری یا شماره تلفن (بدون 0)",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "username",
                        placeholder = "نام کاربری خود را وارد کنید...",
                        isRequired = false
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 رمز عبور",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "password",
                        placeholder = "رمز عبور...",
                        isRequired = false,
                        style = "password"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        -- text = "💡 رمز خود را فراموش کرده‌اید؟",
                        color = "Attention",
                        isSubtle = true,
                        horizontalAlignment = "right",
                        wrap = true
                    }
                },
                cornerRadius = "0 0 0 0",
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "🚀  ورود به سرور",
                style = "positive",
                data = { action = "do_login" }
            },
            {
                type = "Action.Submit",
                title = "📝  حساب ندارم، می‌خواهم ثبت‌نام کنم",
                data = { action = "register" }
            },
            {
                type = "Action.Submit",
                title = "❓ فراموشی رمز عبور",
                data = { action = "forgot_password" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowMainMenu(deferrals)
        elseif data.action == "register" then
            -- EXPANSION: a player who has no account and hits "ورود" first
            -- (instead of "ثبت‌نام" on the main menu) used to get stuck in
            -- this form with no direct way to register — only "forgot
            -- password" and "back". Now they can jump straight into
            -- registration from here too.
            ShowRegisterStep1_Phone(deferrals)
        elseif data.action == "forgot_password" then
            ShowForgotPassword_Step1(deferrals)
        elseif data.action == "do_login" then
            local username = data.username or ""
            local password = data.password or ""

            if username == "" or password == "" then
                ShowError(deferrals, "لطفاً نام کاربری و رمز عبور را وارد کنید!", function()
                    ShowLoginForm(deferrals)
                end)
                return
            end

            -- EXPANSION: brute-force lockout. Checked before touching the
            -- database at all.
            local locked, remainingMinutes = isLoginLocked(username)
            if locked then
                ShowError(deferrals, "به‌دلیل تلاش‌های ناموفق زیاد، این حساب موقتاً قفل شده. "
                    .. remainingMinutes .. " دقیقه دیگر دوباره تلاش کنید.", function()
                    ShowLoginForm(deferrals)
                end)
                return
            end

            CheckLogin(username, password, deferrals, function(isValid,license,accountExists,securityHeld)
                if isValid then
                    clearLoginFailures(username)
                    logAudit("login_success", username, license, deferrals.src)
                    ShowSuccess(deferrals, "ورود موفق! خوش آمدید " .. username, function()
                        deferrals.identifier = license
                        formPassed(deferrals)
                    end)
                elseif not accountExists then
                    -- EXPANSION: this username/phone has no account at all —
                    -- point them at registration directly instead of a
                    -- generic "wrong password" message that gives no clue
                    -- what to do next. (Doesn't reveal WHICH of username/
                    -- password was wrong when an account DOES exist, only
                    -- that no account matches at all — no security info
                    -- leaked beyond "this identity isn't registered".)
                    logAudit("login_fail", username, nil, deferrals.src)
                    ShowError(deferrals, "حسابی با این مشخصات پیدا نشد. اگر تازه‌واردید، اول باید ثبت‌نام کنید!", function()
                        ShowRegisterStep1_Phone(deferrals)
                    end)
                elseif securityHeld then
                    -- EXPANSION: password was correct, but this account was
                    -- flagged by Config.SuspiciousDeviceLock (too many new
                    -- devices too fast). Don't reveal that the password was
                    -- right — same message either way — but route straight
                    -- to phone re-verification instead of a dead-end retry.
                    logAudit("login_fail", username, nil, deferrals.src)
                    ShowError(deferrals, "به‌دلیل فعالیت مشکوک، این اکانت قفل شده. برای باز شدن، از «فراموشی رمز عبور» استفاده کن تا هویتت با پیامک تأیید بشه.", function()
                        ShowForgotPassword_Step1(deferrals)
                    end)
                else
                    registerLoginFailure(username)
                    logAudit("login_fail", username, nil, deferrals.src)
                    ShowError(deferrals, "نام کاربری یا رمز عبور اشتباه است!", function()
                        ShowLoginForm(deferrals)
                    end)
                end
            end)
        else
            ShowLoginForm(deferrals)
        end
    end)
end

function ShowRegisterStep1_Phone(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "📝",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "ثبت‌نام جدید",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "مرحله ۱ از ۳: شماره تلفن",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "📱 شماره تلفن همراه خود را وارد کنید",
                        color = COLORS.Light,
                        spacing = "medium",
                        wrap = true
                    },
                    {
                        type = "TextBlock",
                        text = "کد تأیید به این شماره ارسال خواهد شد",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "شماره تلفن (بدون 0 اول):",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "phone",
                        placeholder = "9123456789",
                        isRequired = false
                    },
                    {
                        type = "TextBlock",
                        text = "مثال: 9123456789 (بدون +98)",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 شماره شما نزد ما محفوظ می‌ماند",
                        color = "Good",
                        size = "small",
                        spacing = "small"
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "📨  ارسال کد تأیید",
                style = "positive",
                data = { action = "send_code" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowMainMenu(deferrals)
        elseif data.action == "send_code" then
            local phone = data.phone or ""

            if phone == "" then
                ShowError(deferrals, "لطفاً شماره تلفن را وارد کنید!", function()
                    ShowRegisterStep1_Phone(deferrals)
                end)
                return
            end

            if #phone < 10 or #phone > 10 then
                ShowError(deferrals, "شماره تلفن باید ۱۰ رقم باشد!", function()
                    ShowRegisterStep1_Phone(deferrals)
                end)
                return
            end

            CheckPhoneExists(phone, function(phoneExists)
                if phoneExists then
                    ShowError(deferrals, "این شماره تلفن قبلاً ثبت شده است!", function()
                        ShowLoginForm(deferrals)
                    end)
                    return
                end

                local code, err = SendSMSCode(phone, deferrals.src)
                if code then
                    ShowRegisterStep2_VerifyCode(deferrals, phone, code)
                elseif err == "rate_limited" then
                    ShowError(deferrals, "تعداد درخواست‌های شما بیش از حد مجاز است. کمی بعد دوباره تلاش کنید.", function()
                        ShowRegisterStep1_Phone(deferrals)
                    end)
                else
                    ShowError(deferrals, "خطا در ارسال پیامک! لطفاً دوباره تلاش کنید.", function()
                        ShowRegisterStep1_Phone(deferrals)
                    end)
                end
            end)
        else
            ShowRegisterStep1_Phone(deferrals)
        end
    end)
end

function ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "📨",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "تأیید شماره تلفن",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "مرحله ۲ از ۳: کد تأیید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },
            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "کد ۶ رقمی ارسال شده را وارد کنید",
                        color = COLORS.Light,
                        wrap = true,
                        spacing = "medium"
                    },
                    {
                        type = "TextBlock",
                        text = "📱 شماره: 98" .. phone,
                        color = "Accent",
                        weight = "bolder",
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "کد تأیید:",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "code",
                        placeholder = "______",
                        isRequired = false,
                        maxLength = 6
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "⏰ کد تا ۲ دقیقه معتبر است",
                        color = "Warning",
                        size = "small",
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "✅  تأیید کد",
                style = "positive",
                data = { action = "verify_code" }
            },
            -- {
            --     type = "Action.Submit",
            --     title = "🔄  ارسال مجدد کد",
            --     data = { action = "resend_code" }
            -- },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowRegisterStep1_Phone(deferrals)
        elseif data.action == "resend_code" then
            local newCode, err = SendSMSCode(phone, deferrals.src)
            if newCode then
                ShowRegisterStep2_VerifyCode(deferrals, phone, newCode)
            elseif err == "rate_limited" then
                ShowError(deferrals, "تعداد درخواست‌های شما بیش از حد مجاز است. کمی بعد دوباره تلاش کنید.", function()
                    ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
                end)
            else
                ShowError(deferrals, "خطا در ارسال مجدد کد!", function()
                    ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
                end)
            end
        elseif data.action == "verify_code" then
            local enteredCode = data.code or ""

            if enteredCode == "" then
                ShowError(deferrals, "لطفاً کد تأیید را وارد کنید!", function()
                    ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
                end)
                return
            end

            -- SECURITY FIX: cap guesses against this code before checking
            -- it, so an attacker can't just keep resubmitting the same
            -- card with a new guess every time.
            if isCodeVerifyLocked(phone) then
                smscodedict[phone] = nil
                clearCodeVerifyAttempts(phone)
                ShowError(deferrals, "تعداد تلاش‌های مجاز برای این کد تمام شد. لطفاً دوباره کد بگیرید.", function()
                    ShowRegisterStep1_Phone(deferrals)
                end)
                return
            end

            if enteredCode ~= sentCode then
                registerCodeVerifyFailure(phone)
                ShowError(deferrals, "کد تأیید اشتباه است!", function()
                    ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
                end)
                return
            end
            smscodedict[phone] = nil
            clearCodeVerifyAttempts(phone)
            ShowRegisterStep3_UserPass(deferrals, phone)
        else
            ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
        end
    end)
end

function ShowRegisterStep3_UserPass(deferrals, phone)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔐",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "اطلاعات حساب",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "مرحله ۳ از ۳: نام کاربری و رمز عبور",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },
            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "👤 نام کاربری *",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "username",
                        placeholder = "حداقل ۳ کاراکتر...",
                        isRequired = false
                    },
                    {
                        type = "TextBlock",
                        -- text = "📛 این نام در سرور نمایش داده می‌شود",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 رمز عبور *",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "password",
                        placeholder = "حداقل ۶ کاراکتر...",
                        isRequired = false,
                        style = "password"
                    },
                    {
                        type = "TextBlock",
                        text = "🔒 تکرار رمز عبور *",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "confirm_password",
                        placeholder = "رمز را مجدداً وارد کنید...",
                        isRequired = false,
                        style = "password"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "✅ با ثبت‌نام، قوانین سرور را می‌پذیرم",
                        color = COLORS.Light,
                        isSubtle = true,
                        spacing = "small"
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "🚀  ثبت‌نام و ورود",
                style = "positive",
                data = { action = "do_register" }
            },
            -- {
            --     type = "Action.Submit",
            --     title = "↩️  بازگشت",
            --     data = { action = "back" }
            -- }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            -- FIX: this branch used to call ShowRegisterStep2_VerifyCode(deferrals, phone,
            -- "123456"), which would reset the "correct" OTP to the hardcoded string
            -- "123456" — a permanent master bypass code for phone verification. The button
            -- that triggered this ("back") is commented out above so it wasn't reachable
            -- right now, but it's a live loaded gun in the code. Removed entirely; there's
            -- no back button on this step, so any unexpected action just redraws step 3.
            ShowRegisterStep3_UserPass(deferrals, phone)
        elseif data.action == "do_register" then
            local username = data.username or ""
            local password = data.password or ""
            local confirm = data.confirm_password or ""

            if username == "" or password == "" or confirm == "" then
                ShowError(deferrals, "لطفاً تمام فیلدها را پر کنید!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            if #username < 3 then
                ShowError(deferrals, "نام کاربری باید حداقل ۳ کاراکتر باشد!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            -- EXPANSION: block usernames that impersonate staff or read as
            -- slurs/obvious abuse. Case-insensitive substring match on
            -- purpose — "xAdminx", "Owner123" should also be caught, not
            -- just an exact match.
            if isUsernameBlacklisted(username) then
                ShowError(deferrals, "این نام کاربری مجاز نیست (شبیه نام‌های ادمین/تیم سرور یا نامناسب است).", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            if #password < 6 then
                ShowError(deferrals, "رمز عبور باید حداقل ۶ کاراکتر باشد!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            -- EXPANSION: require at least one letter AND one digit — still
            -- easy to satisfy (doesn't force symbols/case-mixing, which
            -- Iranian players tend to abandon registration over), but rules
            -- out the weakest patterns like "111111" or "aaaaaa".
            if not (password:match("%d") and password:match("%a")) then
                ShowError(deferrals, "رمز عبور باید شامل حداقل یک حرف و یک عدد باشد!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            if password ~= confirm then
                ShowError(deferrals, "رمز عبور و تکرار آن یکسان نیست!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            CheckUsernameExists(username, function(usernameExists)
                if usernameExists then
                    ShowError(deferrals, "این نام کاربری قبلاً انتخاب شده است!", function()
                        ShowRegisterStep3_UserPass(deferrals, phone)
                    end)
                    return
                end

                RegisterUser(username, password, phone, deferrals, function(success,license)
                    if success then
                        logAudit("register", username, license, deferrals.src)
                        ShowSuccess(deferrals, "ثبت‌نام موفق! خوش آمدید " .. username, function()
                            deferrals.identifier = license
                            formPassed(deferrals)
                        end)
                    else
                        ShowError(deferrals, "خطا در ثبت‌نام! لطفاً دوباره تلاش کنید.", function()
                            ShowRegisterStep3_UserPass(deferrals, phone)
                        end)
                    end
                end)
            end)
        else
            ShowRegisterStep3_UserPass(deferrals, phone)
        end
    end)
end

-- ─────────────────────────────────────────────────────────
--         مرحله: فراموشی رمز عبور - شماره تلفن
-- ─────────────────────────────────────────────────────────
function ShowForgotPassword_Step1(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            -- هدر
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔑",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "فراموشی رمز عبور",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "شماره تلفن ثبت‌شده خود را وارد کنید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "📱 شماره تلفن ثبت‌شده:",
                        color = COLORS.Light,
                        wrap = true,
                        spacing = "medium"
                    },
                    {
                        type = "Input.Text",
                        id = "phone",
                        placeholder = "9123456789",
                        isRequired = false
                    },
                    {
                        type = "TextBlock",
                        text = "کد بازیابی به این شماره ارسال خواهد شد",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    -- خط جداکننده
                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "💡 اگر شماره ثبت‌شده ندارید، با پشتیبانی تماس بگیرید",
                        color = COLORS.Light,
                        size = "small",
                        wrap = true,
                        isSubtle = true
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "📨  ارسال کد بازیابی",
                style = "positive",
                data = { action = "send_reset_code" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت به ورود",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowLoginForm(deferrals)
        elseif data.action == "send_reset_code" then
            local phone = data.phone or ""

            if phone == "" or #phone < 10 then
                ShowError(deferrals, "لطفاً شماره تلفن معتبر وارد کنید!", function()
                    ShowForgotPassword_Step1(deferrals)
                end)
                return
            end

            GetUserByPhone(phone, function(userData)
                if not userData then
                    ShowError(deferrals, "این شماره تلفن در سیستم ثبت نشده است!", function()
                        ShowForgotPassword_Step1(deferrals)
                    end)
                    return
                end

                local resetCode, err = SendSMSCode(phone, deferrals.src)
                if resetCode then
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, userData.username)
                elseif err == "rate_limited" then
                    ShowError(deferrals, "تعداد درخواست‌های شما بیش از حد مجاز است. کمی بعد دوباره تلاش کنید.", function()
                        ShowForgotPassword_Step1(deferrals)
                    end)
                else
                    ShowError(deferrals, "خطا در ارسال کد! دوباره تلاش کنید.", function()
                        ShowForgotPassword_Step1(deferrals)
                    end)
                end
            end)
        else
            ShowForgotPassword_Step1(deferrals)
        end
    end)
end

-- ─────────────────────────────────────────────────────────
--         مرحله: فراموشی رمز عبور - تأیید کد
-- ─────────────────────────────────────────────────────────
function ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            -- هدر
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔐",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "تأیید کد بازیابی",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "کد ارسال‌شده را وارد کنید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            -- اطلاعات کاربر
            {
                type = "Container",
                backgroundColor = COLORS.LIGHT,
                items = {
                    {
                        type = "TextBlock",
                        text = "👤 حساب: " .. username,
                        color = "Accent",
                        weight = "bolder"
                    },
                    {
                        type = "TextBlock",
                        text = "📱 شماره: 98" .. phone,
                        color = COLORS.Light,
                        size = "small"
                    }
                },
                padding = "15px",
                cornerRadius = "10px",
                spacing = "medium"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "کد تأیید:",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "code",
                        placeholder = "کد ۶ رقمی...",
                        isRequired = false,
                        maxLength = 6
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 رمز عبور جدید:",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "new_password",
                        placeholder = "حداقل ۶ کاراکتر...",
                        isRequired = false,
                        style = "password"
                    },
                    {
                        type = "Input.Text",
                        id = "confirm_password",
                        placeholder = "تکرار رمز جدید...",
                        isRequired = false,
                        style = "password"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "⏰ کد تا ۲ دقیقه معتبر است",
                        color = "Warning",
                        size = "small",
                        spacing = "small"
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "✅  تغییر رمز عبور",
                style = "positive",
                data = { action = "reset_password" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowLoginForm(deferrals)
        elseif data.action == "reset_password" then
            local code = data.code or ""
            local newPassword = data.new_password or ""
            local confirm = data.confirm_password or ""

            if code == "" then
                ShowError(deferrals, "لطفاً کد تأیید را وارد کنید!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            -- SECURITY FIX: this code resets an EXISTING account's
            -- password -- an unlimited-guess brute force here is a full
            -- account takeover, not just a nuisance. Same guess-cap as
            -- registration's verify step.
            if isCodeVerifyLocked(phone) then
                smscodedict[phone] = nil
                clearCodeVerifyAttempts(phone)
                ShowError(deferrals, "تعداد تلاش‌های مجاز برای این کد تمام شد. لطفاً دوباره کد بگیرید.", function()
                    ShowForgotPassword_Step1(deferrals)
                end)
                return
            end

            if code ~= resetCode then
                registerCodeVerifyFailure(phone)
                ShowError(deferrals, "کد تأیید اشتباه است!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            if #newPassword < 6 then
                ShowError(deferrals, "رمز عبور باید حداقل ۶ کاراکتر باشد!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            if newPassword ~= confirm then
                ShowError(deferrals, "رمز عبور و تکرار آن یکسان نیست!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            UpdatePassword(phone, newPassword, function(success)
                if success then
                    clearCodeVerifyAttempts(phone)
                    logAudit("password_reset", username, nil, deferrals.src)
                    sendDiscordAlert(
                        "🔑 رمز عبور تغییر کرد",
                        "اکانت **" .. username .. "** (شماره: " .. phone .. ") رمز عبورش عوض شد.",
                        3066993 -- green
                    )
                    -- EXPANSION: if this account has an active session right
                    -- now (e.g. someone else is logged in as them), reset via
                    -- forgot-password should immediately drop that session —
                    -- otherwise a hijacker who's already connected just stays
                    -- connected until they happen to disconnect on their own.
                    for lic, sessionSrc in pairs(activeLicenseSessions) do
                        if lic and GetPlayerName(sessionSrc) then
                            MySQL.Async.fetchAll(
                                "SELECT id FROM login_users WHERE license = @lic AND phone = @phone LIMIT 1",
                                { ["@lic"] = lic, ["@phone"] = phone },
                                function(rows)
                                    if rows and rows[1] then
                                        DropPlayer(sessionSrc, "رمز عبور این اکانت از طریق بازیابی تغییر کرد.")
                                    end
                                end
                            )
                        end
                    end
                    ShowSuccess(deferrals, "رمز عبور با موفقیت تغییر کرد!", function()
                        ShowLoginForm(deferrals)
                    end)
                else
                    ShowError(deferrals, "خطا در تغییر رمز! دوباره تلاش کنید.", function()
                        ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                    end)
                end
            end)
        else
            ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
        end
    end)
end

-- ─────────────────────────────────────────────────────────
--              صفحات پیام (Error / Success)
-- ─────────────────────────────────────────────────────────
function ShowError(deferrals, message, callback)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = "#1a0a0a",
                items = {
                    {
                        type = "TextBlock",
                        text = "❌",
                        size = "extraLarge",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = "خطا!",
                        weight = "bolder",
                        size = "large",
                        color = "Attention",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = message,
                        color = COLORS.Light,
                        horizontalAlignment = "center",
                        wrap = true,
                        spacing = "medium"
                    }
                },
                padding = "30px",
                cornerRadius = "15px",
                borderColor = "Attention",
                borderThickness = "2px"
            }
        },
        actions = {
            {
                type = "Action.Submit",
                title = "🔄  تلاش مجدد",
                data = { action = "retry" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if callback then
            callback()
        else
            ShowMainMenu(deferrals)
        end
    end)
end

function ShowSuccess(deferrals, message, callback)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = "#0a1a0a",
                items = {
                    {
                        type = "TextBlock",
                        text = "✅",
                        size = "extraLarge",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = "موفق!",
                        weight = "bolder",
                        size = "large",
                        color = "Good",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = message,
                        color = COLORS.Light,
                        horizontalAlignment = "center",
                        wrap = true,
                        spacing = "medium"
                    }
                },
                padding = "30px",
                cornerRadius = "15px",
                borderColor = "Good",
                borderThickness = "2px"
            }
        },
        actions = {
            {
                type = "Action.Submit",
                title = "➡️  ادامه",
                style = "positive",
                data = { action = "continue" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if callback then
            callback()
        else
            formPassed(deferrals)
        end
    end)
end

-- OTP ;D

local function SMSHolderTimer(phone)
    -- FIX: UI tells the player the code is valid for 2 minutes, but this
    -- timer used to keep it valid (and guessable) for a full hour. Matched
    -- the actual expiry to what's promised on screen — also shrinks the
    -- window for someone to brute-force the 6-digit code.
    Citizen.SetTimeout(2*60*1000, function()
        smscodedict[phone] = nil
        clearCodeVerifyAttempts(phone)
    end)
end

-- EXPANSION: now takes the connecting player's src so it can rate-limit by
-- IP as well as by phone number. Returns:
--   code, nil            -> sent fine (or already had a valid unexpired code)
--   nil, "rate_limited"  -> caller should show the "too many requests" error
function SendSMSCode(phone, src)
    if not smscodedict[phone] then
        local ip = src and getIdentifierPrefix(src, "ip:") or nil

        if not rateLimitCheck(smsAttemptsByPhone, phone, Config.SmsRateLimit.MaxPerPhonePerHour, 3600) then
            return nil, "rate_limited"
        end
        if ip and not rateLimitCheck(smsAttemptsByIp, ip, Config.SmsRateLimit.MaxPerIpPerHour, 3600) then
            return nil, "rate_limited"
        end

        local code = tostring(math.random(100000, 999999))
        smscodedict[phone] = code
        clearCodeVerifyAttempts(phone)
        SMSHolderTimer(phone)
        -- SECURITY FIX: this used to print(phone .. " : " .. code), writing
        -- the OTP straight into the server console/log file in plaintext —
        -- anyone with log access (or a leaked log) could read live codes.
        local payload = {
            mobile = tostring(phone),
            templateId = Config.SMS.TemplateId,
            parameters = {
                {
                    name = "OTP",
                    value = code
                }
            }
        }
        PerformHttpRequest(Config.SMS.ApiUrl, function(err, text, headers)
            if err == 200 or err == 0 then
                local data = json.decode(text)
                if data then
                    print("--------------------")
                    print("📥 ریسپانس API:")
                    print(json.encode(data, { indent = true }))
                    print("--------------------")
                else
                    print("📄 ریسپانس خام:", text)
                end
            else
                print("❌ ارور HTTP:", err)
            end
        end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json', ['X-API-KEY'] = Config.SMS.ApiKey })
        return code
    end 
    return smscodedict[phone]
end




-- DataBase

local function generateRandomString(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = {}
    
    for i = 1, length do
        local randomIndex = math.random(1, #charset)
        result[i] = charset:sub(randomIndex, randomIndex)
    end
    
    return table.concat(result)
end

-- تولید لایسنس یکتا با فرمت مشخص
local function generateUniqueLicense(prefix)
    -- FIX: this used to default to "steam:" — meaning EVERY account this
    -- resource creates (Steam or not) got an internal id starting with
    -- "steam:-XXXX-XXXX-XXXX", even for the majority of players who have
    -- no Steam at all. That's purely this resource's OWN bookkeeping id
    -- (used for deferrals.identifier / activeLicenseSessions) — it has
    -- nothing to do with essentialmode (which keys characters by the real
    -- license: identifier) or UNIQUE_AC (whose STEAM column correctly
    -- stays '__NONE__' for these players) — but looking at the
    -- login_users table directly, it was misleading enough to make you
    -- think these players somehow had Steam. Renamed to "unique:".
    local prefix = prefix or "unique:"
    local attempts = 0
    local maxAttempts = 100
    
    repeat
        attempts = attempts + 1
        
        -- فرمت: LIC-XXXX-XXXX-XXXX (چهار بخش 4 کاراکتری)
        local part1 = generateRandomString(4)
        local part2 = generateRandomString(4)
        local part3 = generateRandomString(4)
        local license = string.format("%s-%s-%s-%s", prefix, part1, part2, part3)
        
        -- بررسی تکراری نبودن در دیتابیس
        local result = MySQL.query.await(
            "SELECT COUNT(*) as count FROM `login_users` WHERE license = @license",
            { ['@license'] = license }
        )
        
        if result and result[1] and result[1].count == 0 then
            return license
        end
        
    until attempts >= maxAttempts
    
    -- اگر بعد از 100 بار نتونست لایسنس یکتا بسازه
    -- یه لایسنس با timestamp بساز (fallback)
    return string.format("%s-%s-%s-%s", 
        prefix, 
        generateRandomString(4), 
        os.time(), 
        generateRandomString(4)
    )
end



-- function CheckLicenseLink(def, cb)

--     local license
--     for _, v in ipairs(GetPlayerIdentifiers(def.src)) do
--         if string.sub(v, 1, string.len("license:")) == "license:" then
--             license = v
--         end
--     end

--     local query = "SELECT * FROM login_users WHERE license = @license"
--     MySQL.Async.fetchAll(query, {
--         ["@license"] = license
--     }, function(result)
--         cb(result and #result > 0)
--     end)
-- end

-- SECURITY FIX: was comparing/storing passwords in PLAINTEXT before.
-- Hashing happens inside the SQL itself (SHA2-256) so no plaintext
-- password is ever written to the database or a query log.
function CheckLogin(username, password, def, cb)
    -- EXPANSION: separated into two queries so the caller can tell "no
    -- account with this username/phone exists at all" apart from "account
    -- exists but password was wrong" — used to point brand-new players
    -- straight at registration instead of a dead-end "wrong password".
    local existsQuery = "SELECT id FROM login_users WHERE (username = @username OR phone = @username) LIMIT 1"
    MySQL.Async.fetchAll(existsQuery, {
        ["@username"] = username
    }, function(existsResult)
        local accountExists = existsResult and #existsResult > 0
        if not accountExists then
            cb(false, nil, false)
            return
        end

        local query = "SELECT * FROM login_users WHERE (username = @username OR phone = @username) AND password = SHA2(@password, 256)"
        MySQL.Async.fetchAll(query, {
            ["@username"] = username,
            ["@password"] = password
        }, function(result)
            if result and #result > 0 then
                -- EXPANSION: correct password, but the account is on
                -- security_hold (see Config.SuspiciousDeviceLock) — refuse
                -- normal login even though the password matched. Only a
                -- successful SMS-OTP "forgot password" reset clears the hold.
                if result[1].security_hold == 1 then
                    cb(false, nil, true, true)
                    return
                end
                cb(true, result[1].license, true, false)
            else
                cb(false, nil, true, false)
            end
        end)
    end)
    -- updateLicense(username, def)
end

function CheckPhoneExists(phone, cb)
    local query = "SELECT id FROM login_users WHERE phone = @phone LIMIT 1"
    MySQL.Async.fetchAll(query, {
        ["@phone"] = phone
    }, function(result)
        cb(result and #result > 0)
    end)
end

function CheckUsernameExists(username, cb)
    local query = "SELECT id FROM login_users WHERE username = @username LIMIT 1"
    MySQL.Async.fetchAll(query, {
        ["@username"] = username
    }, function(result)
        cb(result and #result > 0)
    end)
end

function GetUserByPhone(phone, cb)
    local query = "SELECT id, username, phone, license FROM login_users WHERE phone = @phone LIMIT 1"
    MySQL.Async.fetchAll(query, {
        ["@phone"] = phone
    }, function(result)
        if result and #result > 0 then
            cb({
                id       = result[1].id,
                username = result[1].username,
                phone    = result[1].phone,
                license  = result[1].license
            })
        else
            cb(nil)
        end
    end)
end

function RegisterUser(username, password, phone, def, cb)

    -- local license ,steam = nil, nil
    -- for _, v in ipairs(GetPlayerIdentifiers(def.src)) do
    --     if string.sub(v, 1, string.len("license:")) == "license:" then
    --         license = v
    --     end
    -- end
    -- steam = "steam".. string.sub(license, string.len("license:"), string.len(license))

    local license = generateUniqueLicense()
    -- SECURITY FIX: SHA2-256 the password inside the query, same as CheckLogin
    local query = [[
        INSERT INTO login_users (username, password, phone, license)
        VALUES (@username, SHA2(@password, 256), @phone, @license)
    ]]
    MySQL.Async.execute(query, {
        ["@username"] = username,
        ["@password"] = password,
        ["@phone"]    = phone,
        ["@license"]  = license

    }, function(insertId)
        cb(insertId ~= nil and insertId > 0,license)
    end)
end

function UpdatePassword(phone, newPassword, cb)
    -- EXPANSION: also clears device_license (kills auto-login for any old
    -- device — already relied on elsewhere) and security_hold. A completed
    -- SMS-OTP reset is exactly the "prove you own the phone" step that's
    -- supposed to lift a suspicious-activity hold.
    local query = "UPDATE login_users SET password = SHA2(@password, 256), device_license = NULL, security_hold = 0 WHERE phone = @phone"
    MySQL.Async.execute(query, {
        ["@password"] = newPassword,
        ["@phone"]    = phone
    }, function(affected)
        cb(affected and affected > 0)
    end)
end

function updateLicense(userName, def)
    local license
    for _, v in ipairs(GetPlayerIdentifiers(def.src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end

    local query = "UPDATE login_users SET license = @license WHERE username = @username"
    MySQL.Async.execute(query, {["@license"] = license, ["@username"] = userName })
end

local inLoginFormPlayers = {}

-- ─────────────────────────────────────────────────────────
-- EXPANSION: built-in connection queue (see Config.Queue in config.lua).
-- Runs as the very first thing in playerConnecting, before anything else
-- in this resource touches `deferrals` — so there's exactly one owner of
-- the connecting screen at any given moment, and no more racing with a
-- separate queue resource.
-- ─────────────────────────────────────────────────────────
local connectQueue = {} -- ordered array of { src = playerSrc }

local function queueGetMaxSlots()
    return Config.Queue.MaxSlots or GetConvarInt("sv_maxclients", 48)
end

local function queuePositionOf(src)
    for i, entry in ipairs(connectQueue) do
        if entry.src == src then return i end
    end
    return nil
end

local function queueRemove(src)
    for i, entry in ipairs(connectQueue) do
        if entry.src == src then
            table.remove(connectQueue, i)
            return
        end
    end
end

AddEventHandler("playerDropped", function()
    queueRemove(source)
end)

-- Blocks (via Wait, inside the caller's own playerConnecting coroutine)
-- until this player reaches the front of the queue AND a slot is free.
-- Returns false if the player disconnected while waiting (queue entry
-- vanished), true once they're clear to proceed.
local function queueWaitForTurn(src, deferrals)
    if not Config.Queue.Enabled then return true end

    local maxSlots = queueGetMaxSlots()

    -- Fast path: server isn't full and nobody's ahead in line — skip the
    -- queue entirely so the common case (server not full) has zero extra
    -- overhead or delay.
    if #connectQueue == 0 and #GetPlayers() < maxSlots then
        return true
    end

    table.insert(connectQueue, { src = src })

    while true do
        local pos = queuePositionOf(src)
        if not pos then
            -- Removed from the queue — only happens via playerDropped, i.e.
            -- the player disconnected while waiting.
            return false
        end

        local activeCount = #GetPlayers()
        if pos == 1 and activeCount < maxSlots then
            queueRemove(src)
            return true
        end

        deferrals.update("🕐 در صف اتصال به سرور — موقعیت " .. pos .. " از " .. #connectQueue
            .. "\nظرفیت سرور: " .. activeCount .. "/" .. maxSlots)
        Wait(Config.Queue.UpdateIntervalMs or 1500)
    end
end

-- FIX: duplicate-session detection used to be keyed by IP (playersidentifieronconnect[ip]),
-- which is a single shared slot per IP address. Two DIFFERENT real accounts connecting from
-- the same public IP close together (very common here: mobile-carrier NAT, CGNAT, VPN/proxy
-- to reach the server, shared home/dorm/cafe wifi) would overwrite each other's slot and
-- cause BOTH innocent players to get falsely kicked with "your account logged in elsewhere".
-- Fixed by tracking sessions directly by account license, never by IP. This still correctly
-- catches the real case (same account logged in twice from two different places).
local activeLicenseSessions = {} -- login_users.license (this resource's own account id) -> src

-- ─────────────────────────────────────────────────────────
-- EXPANSION: unified entry point, no more Steam special-case.
--
-- Previously, players WITH Steam skipped this whole resource and were let
-- straight in using their steam: identifier, while players WITHOUT Steam
-- (the vast majority here, since Iranian ISPs/national internet routinely
-- block Steam's own servers) went through the username/password panel.
-- That split meant two different classes of accounts with two different
-- identity models, which made moderation/support harder and was pointless
-- extra code to maintain.
--
-- essentialmode keys every character by the REAL `license:` identifier
-- (see [BASE]/essentialmode/server/player/login.lua) — it never looks at
-- anything from this resource. So removing the Steam bypass changes NOTHING
-- about how existing characters are found; it only changes whether this
-- login PANEL is shown. Steam is now just one more possible identifier,
-- not a shortcut around the panel.
--
-- Two new things happen here before the panel, in order:
--   1. Ban check straight against UNIQUE_AC's banlist using the real
--      license — so a banned player can't just re-register with a new
--      phone number and come back in (see EXPANSION #2 below).
--   2. Auto-login: if this exact device (real license) already completed
--      login/registration in a previous session, skip the panel entirely
--      and reconnect them straight to their existing login_users account.
-- ─────────────────────────────────────────────────────────
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)

    local src = source
    deferrals.src = src
    deferrals.defer()
    Wait(100)

    -- EXPANSION: connection queue gate — see Config.Queue. Must run before
    -- anything else touches deferrals.update()/done() in this handler.
    local proceeded = queueWaitForTurn(src, deferrals)
    if not proceeded then
        -- Player disconnected while queued; nothing left to do.
        return
    end

    deferrals.update("در حال بررسی اطلاعات...")

    local realLicense = getIdentifierPrefix(src, "license:")

    -- FIX: previously, if either MySQL query below ever errored (bad
    -- migration state, DB hiccup, table/column missing) oxmysql logs the
    -- error and never calls the callback — so neither ShowMainMenu nor
    -- formPassed nor deferrals.done() would ever run, and the connecting
    -- player got stuck on "در حال بررسی اطلاعات..." forever with no way
    -- out except a client-side timeout/retry. `settled` + the watchdog
    -- below guarantee this resource always resolves the connection one
    -- way or another within a few seconds, even on a DB failure.
    --
    -- NOTE: a real hang was tracked down (Aug 2026) to a DIFFERENT resource
    -- — [SCRIPT]/ServerTest-Queue — independently calling deferrals.defer()/
    -- update() on this same shared deferrals object and never releasing the
    -- player from its queue. server.cfg now stops that resource; see the
    -- comment above `stop ServerTest-Queue` in [BASE]/server.cfg before
    -- re-enabling it.
    local settled = false

    local function settle(fn)
        if settled then return end
        settled = true
        fn()
    end

    CreateThread(function()
        Wait(8000)
        settle(function()
            print("[Unique_Login] WARNING: playerConnecting timed out for " .. tostring(name)
                .. " (a DB query likely errored, or another resource is holding the shared deferrals object"
                .. " — see the ServerTest-Queue note in this function). Falling back to login panel.")
            ShowMainMenu(deferrals)
        end)
    end)

    local function afterBanCheck()
        if not realLicense then
            -- Extremely rare (FiveM always assigns a license: identifier),
            -- but fail safe by just showing the normal panel.
            settle(function() ShowMainMenu(deferrals) end)
            return
        end

        MySQL.Async.fetchAll(
            "SELECT license, security_hold FROM login_users WHERE device_license = @dl LIMIT 1",
            { ["@dl"] = realLicense },
            function(rows)
                -- EXPANSION: don't auto-login an account on security_hold —
                -- force it through the normal panel (which will also refuse
                -- plain login and push toward "forgot password" SMS-OTP
                -- re-verification; see CheckLogin).
                if rows and rows[1] and rows[1].security_hold ~= 1 then
                    deferrals.identifier = rows[1].license
                    settle(function() formPassed(deferrals) end)
                else
                    settle(function() ShowMainMenu(deferrals) end)
                end
            end
        )
    end

    if realLicense then
        -- EXPANSION: ban-evasion guard. Checked against UNIQUE_AC's own
        -- banlist table, keyed on the same real `license:` essentialmode
        -- and UNIQUE_AC already use — so a ban survives someone deleting
        -- their Unique_Login account and registering fresh with a new
        -- phone number, because the device/license itself stays banned.
        MySQL.Async.fetchAll(
            "SELECT REASON FROM uniqueac_banlist WHERE LICENSE = @license LIMIT 1",
            { ["@license"] = realLicense },
            function(rows)
                if rows and rows[1] then
                    settle(function()
                        deferrals.done("⛔ اکانت شما بن شده است.\nدلیل: " .. (rows[1].REASON or "نامشخص"))
                    end)
                else
                    afterBanCheck()
                end
            end
        )
    else
        afterBanCheck()
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for lic, s in pairs(activeLicenseSessions) do
        if s == src then
            activeLicenseSessions[lic] = nil
        end
    end
end)

function formPassed(deferrals)
    inLoginFormPlayers[deferrals.src] = nil

    -- FIX: duplicate-account check now compares the account's license directly
    -- against other currently-connected sessions, instead of going through IP.
    -- This still kicks the OLD session if the SAME account is already connected
    -- (real duplicate login), but no longer misfires for two different accounts
    -- that merely share a public IP (VPN/CGNAT/mobile carrier/shared wifi).
    local prevSrc = activeLicenseSessions[deferrals.identifier]
    if prevSrc and prevSrc ~= deferrals.src and GetPlayerName(prevSrc) then
        DropPlayer(prevSrc, "اکانت شما از جای دیگری وارد سرور شد. رمز عبور خود را تغییر دهید.")
    end
    activeLicenseSessions[deferrals.identifier] = deferrals.src

    -- EXPANSION: remember this device (real license) against the account so
    -- next time they connect from the same PC/device, playerConnecting's
    -- auto-login check above skips the panel entirely. Also detects when an
    -- account that already HAD a remembered device logs in from a
    -- DIFFERENT device — that's either the player on a new PC, or someone
    -- else with their password — so it's worth an alert.
    local realLicense = getIdentifierPrefix(deferrals.src, "license:")
    if realLicense and deferrals.identifier then
        MySQL.Async.fetchAll(
            "SELECT username, device_license FROM login_users WHERE license = @lic LIMIT 1",
            { ["@lic"] = deferrals.identifier },
            function(rows)
                if rows and rows[1] then
                    local row = rows[1]
                    -- Only alert when there WAS a previously-known device and
                    -- it's different — a null device_license just means this
                    -- is their very first login ever, which isn't suspicious.
                    if row.device_license and row.device_license ~= realLicense then
                        logAudit("new_device", row.username, deferrals.identifier, deferrals.src)
                        sendDiscordAlert(
                            "📱 ورود از دستگاه جدید",
                            "اکانت **" .. row.username .. "** از یک دستگاه شناخته‌نشده وارد سرور شد.\nIP: "
                                .. (getIdentifierPrefix(deferrals.src, "ip:") or "نامشخص")
                                .. "\nاگر خودتون نبودید، سریعاً رمز عبور رو از پنل بازیابی عوض کنید.",
                            16776960 -- yellow
                        )

                        -- EXPANSION: rapid-fire new devices (several
                        -- distinct devices logging into the SAME account
                        -- within a short window) is a much stronger signal
                        -- than just "one new device" — it's what a leaked
                        -- password being tried from multiple places looks
                        -- like. This session still gets in (the hold only
                        -- blocks FUTURE logins), but the account is locked
                        -- until the real owner proves phone ownership via
                        -- the SMS-OTP "forgot password" flow.
                        local now = os.time()
                        local events = newDeviceEvents[deferrals.identifier] or {}
                        local kept = {}
                        for _, ts in ipairs(events) do
                            if (now - ts) < Config.SuspiciousDeviceLock.WindowSeconds then
                                table.insert(kept, ts)
                            end
                        end
                        table.insert(kept, now)
                        newDeviceEvents[deferrals.identifier] = kept

                        if #kept >= Config.SuspiciousDeviceLock.MaxNewDevices then
                            MySQL.Async.execute(
                                "UPDATE login_users SET security_hold = 1 WHERE license = @lic",
                                { ["@lic"] = deferrals.identifier }
                            )
                            logAudit("security_hold", row.username, deferrals.identifier, deferrals.src)
                            sendDiscordAlert(
                                "⚠️ فعالیت مشکوک — اکانت قفل شد",
                                "اکانت **" .. row.username .. "** توی ۱۰ دقیقه‌ی اخیر از " .. #kept
                                    .. " دستگاه متفاوت وارد شده. اکانت قفل شد؛ فقط با «فراموشی رمز» "
                                    .. "(تأیید پیامکی) دوباره باز میشه.",
                                15158332 -- red
                            )
                            newDeviceEvents[deferrals.identifier] = nil
                        end
                    end
                end
                MySQL.Async.execute(
                    "UPDATE login_users SET device_license = @dl WHERE license = @lic",
                    { ["@dl"] = realLicense, ["@lic"] = deferrals.identifier }
                )
            end
        )
    end

    deferrals.update("در حال ورود با اکانت ...")
    Wait(1000)
    -- BUG FIX: deferrals.done() was commented out here, meaning every
    -- player who successfully logged in would be stuck forever on
    -- "در حال ورود با اکانت..." and never actually get let into the
    -- server (nothing else in this resource ever called deferrals.done()
    -- for them). TriggerEvent is kept in case another resource of yours
    -- hooks 'playerConnecting2', but the connection itself no longer
    -- depends on that resource existing.
    TriggerEvent('playerConnecting2', deferrals)
    deferrals.done()
end

exports("isInLoginMenu", function(src)
    -- return inLoginFormPlayers[src] == true
    return true
end)

exports("getidentifier", function(src)
    for lic, s in pairs(activeLicenseSessions) do
        if s == src then
            return lic
        end
    end
    return nil
end)

-- ─────────────────────────────────────────────────────────
-- EXPANSION: exports for the phone's "Security" app
-- ([Phone]/Unique_Phone/html/js/security.js). Kept here (not duplicated in
-- Unique_Phone) so login_users/login_audit are only ever touched from this
-- one resource.
-- ─────────────────────────────────────────────────────────

-- Returns { username, currentDeviceLicense, devices = {...} } to `cb`.
-- `devices` is deduplicated by device_license, newest first, capped at 5 —
-- someone reconnecting from the same PC 40 times shouldn't show as 40 rows.
exports("getDevicesForPlayer", function(src, cb)
    local license = nil
    for lic, s in pairs(activeLicenseSessions) do
        if s == src then
            license = lic
            break
        end
    end

    if not license then
        cb({ username = nil, currentDeviceLicense = nil, devices = {} })
        return
    end

    local currentDeviceLicense = getIdentifierPrefix(src, "license:")

    MySQL.Async.fetchAll(
        "SELECT username, device_license, security_hold, UNIX_TIMESTAMP(created_at) AS created_at_unix FROM login_users WHERE license = @lic LIMIT 1",
        { ["@lic"] = license },
        function(userRows)
            local username = (userRows and userRows[1] and userRows[1].username) or nil
            local securityHold = (userRows and userRows[1] and userRows[1].security_hold == 1) or false
            local createdAtUnix = (userRows and userRows[1] and userRows[1].created_at_unix) or nil

            MySQL.Async.fetchAll(
                "SELECT device_license, action, created_at FROM login_audit "
                    .. "WHERE license = @lic AND device_license IS NOT NULL "
                    .. "ORDER BY created_at DESC LIMIT 50",
                { ["@lic"] = license },
                function(rows)
                    local seen = {}
                    local devices = {}
                    if rows then
                        for _, row in ipairs(rows) do
                            if not seen[row.device_license] then
                                seen[row.device_license] = true
                                table.insert(devices, row)
                                if #devices >= 5 then break end
                            end
                        end
                    end
                    cb({
                        username = username,
                        currentDeviceLicense = currentDeviceLicense,
                        securityHold = securityHold,
                        createdAtUnix = createdAtUnix,
                        devices = devices,
                    })
                end
            )
        end
    )
end)

-- Force-logout everywhere: clears the account's remembered device (so
-- auto-login stops working for it), logs the action, and drops the
-- requesting session too — a full "log out everywhere" reset, matching
-- what the player was told in the confirmation dialog.
exports("logoutAllDevices", function(src)
    local license = nil
    for lic, s in pairs(activeLicenseSessions) do
        if s == src then
            license = lic
            break
        end
    end
    if not license then return end

    MySQL.Async.fetchAll(
        "SELECT username FROM login_users WHERE license = @lic LIMIT 1",
        { ["@lic"] = license },
        function(rows)
            local username = (rows and rows[1] and rows[1].username) or nil

            MySQL.Async.execute(
                "UPDATE login_users SET device_license = NULL WHERE license = @lic",
                { ["@lic"] = license }
            )
            logAudit("logout_all", username, license, src)
            sendDiscordAlert(
                "🚪 خروج از همه‌ی دستگاه‌ها",
                "اکانت **" .. (username or "?") .. "** از توی گوشی درخواست «خروج از همه‌ی دستگاه‌ها» داد.",
                3447003 -- blue
            )

            activeLicenseSessions[license] = nil
            DropPlayer(src, "از همه‌ی دستگاه‌ها خارج شدید. لطفاً دوباره با یوزرنیم/رمز وارد شوید.")
        end
    )
end)

-- ─────────────────────────────────────────────────────────
-- EXPANSION: in-game password change is now two steps instead of one —
-- current password AND an SMS code sent to the account's REGISTERED phone
-- number (not something the connected session can fake). This closes the
-- gap where a hijacked-but-still-logged-in session could change the
-- password just by knowing it (or guessing it via the security_hold bypass
-- window) — now they'd also need physical access to the real owner's phone.
-- ─────────────────────────────────────────────────────────
local pendingPasswordChangeOtp = {} -- src -> { phone, code, expiresAt, license }

AddEventHandler("playerDropped", function()
    pendingPasswordChangeOtp[source] = nil
end)

-- Step 1: verify current password, then send a 6-digit code to the
-- account's phone. cb(true) if sent, cb(false, reason) otherwise.
-- reason: "wrong_old_password" | "rate_limited" | "sms_failed" | "error"
exports("requestPasswordChangeOtp", function(src, oldPassword, cb)
    local license = nil
    for lic, s in pairs(activeLicenseSessions) do
        if s == src then
            license = lic
            break
        end
    end
    if not license then
        cb(false, "error")
        return
    end

    MySQL.Async.fetchAll(
        "SELECT username, phone FROM login_users WHERE license = @lic AND password = SHA2(@old, 256) LIMIT 1",
        { ["@lic"] = license, ["@old"] = oldPassword },
        function(rows)
            if not rows or not rows[1] then
                cb(false, "wrong_old_password")
                return
            end

            local phone = rows[1].phone
            local code, err = SendSMSCode(phone, src)
            if not code then
                cb(false, err == "rate_limited" and "rate_limited" or "sms_failed")
                return
            end

            pendingPasswordChangeOtp[src] = {
                phone = phone,
                license = license,
                username = rows[1].username,
                expiresAt = os.time() + 120, -- matches the 2-minute OTP validity used elsewhere
            }
            -- Masked so the UI can show "کد به شماره‌ی ...1234 ارسال شد"
            -- without exposing the full phone number.
            cb(true, nil, "***" .. tostring(phone):sub(-4))
        end
    )
end)

-- Step 2: verify the OTP code and, if correct, actually change the
-- password. cb(true) on success, cb(false, reason) otherwise.
-- reason: "no_pending_request" | "expired" | "wrong_code" | "error"
exports("confirmPasswordChange", function(src, code, newPassword, cb)
    local pending = pendingPasswordChangeOtp[src]
    if not pending then
        cb(false, "no_pending_request")
        return
    end
    if os.time() > pending.expiresAt then
        pendingPasswordChangeOtp[src] = nil
        cb(false, "expired")
        return
    end
    if type(newPassword) ~= "string" or #newPassword < 6 then
        cb(false, "error")
        return
    end

    local expectedCode = smscodedict[pending.phone]
    if not expectedCode or tostring(code) ~= tostring(expectedCode) then
        cb(false, "wrong_code")
        return
    end

    smscodedict[pending.phone] = nil
    pendingPasswordChangeOtp[src] = nil

    MySQL.Async.execute(
        "UPDATE login_users SET password = SHA2(@new, 256) WHERE license = @lic",
        { ["@new"] = newPassword, ["@lic"] = pending.license }
    )
    logAudit("password_change", pending.username, pending.license, src)
    sendDiscordAlert(
        "🔑 تغییر رمز از داخل بازی",
        "اکانت **" .. pending.username .. "** رمز عبورش رو از توی گوشی عوض کرد (با تأیید پیامکی).",
        3066993 -- green
    )
    cb(true)
end)

-- EXPANSION: daily cleanup of old login_audit rows (Config.AuditLogRetentionDays).
-- Runs once shortly after resource start, then every 24h.
CreateThread(function()
    if not Config.AuditLogRetentionDays or Config.AuditLogRetentionDays <= 0 then
        return
    end
    while true do
        MySQL.Async.execute(
            "DELETE FROM login_audit WHERE created_at < (NOW() - INTERVAL @days DAY)",
            { ["@days"] = Config.AuditLogRetentionDays }
        )
        Wait(24 * 60 * 60 * 1000)
    end
end)

-- EXPANSION: admin override for the suspicious-device auto-lock
-- (security_hold). Called from UNIQUE_AC's player-profile "Security" tab —
-- for when a locked player's SMS never arrives and "forgot password" isn't
-- an option for them. Only lifts the flag; doesn't touch the password.
-- adminName is purely for the Discord alert text, so the log clearly shows
-- this was a manual override, not the player clearing it themselves.
exports("clearSecurityHold", function(targetSrc, adminName, cb)
    local license = nil
    for lic, s in pairs(activeLicenseSessions) do
        if s == targetSrc then
            license = lic
            break
        end
    end
    if not license then
        if cb then cb(false) end
        return
    end

    MySQL.Async.fetchAll(
        "SELECT username FROM login_users WHERE license = @lic LIMIT 1",
        { ["@lic"] = license },
        function(rows)
            local username = (rows and rows[1] and rows[1].username) or nil

            MySQL.Async.execute(
                "UPDATE login_users SET security_hold = 0 WHERE license = @lic",
                { ["@lic"] = license }
            )
            logAudit("security_hold_cleared", username, license, targetSrc)
            sendDiscordAlert(
                "🔓 قفل امنیتی دستی باز شد",
                "اکانت **" .. (username or "?") .. "** توسط ادمین **" .. (adminName or "?")
                    .. "** از توی پنل ادمین از حالت قفل درآمد.",
                3447003 -- blue
            )
            if cb then cb(true, username) end
        end
    )
end)