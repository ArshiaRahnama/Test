// Sunset RP Scoreboard - Clean JavaScript
(function() {
    'use strict';

    // DOM Elements
    const scoreboard = document.getElementById('scoreboard');
    const siteViewer = document.getElementById('site-viewer');
    const siteIframe = document.getElementById('site-iframe');
    const clockElement = document.getElementById('clock');
    const notification = document.getElementById('copy-notification');
    const themeToggle = document.getElementById('theme-toggle');
    const themeLabel = document.getElementById('theme-label');
    const logoImg = document.getElementById('logo-img');

    // Logo paths (default)
    const LOGO_SILVER = 'images/Assets/silver_logo.png';
    const LOGO_GOLD = 'images/Assets/ss.png';

    // State
    let isSiteViewerOpen = false;
    let isDarkTheme = true;
    let logoSwapped = false;
    let logoClickCount = 0;
    let logoClickTimer = null;

    // Config
    const DISCORD_LINK = 'https://discord.gg/sunco';
    const WEBSITE_URL = 'https://sunrp.ir';

    // Initialize
    function init() {
        setupThemeToggle();
        setupMessageListener();
        setupLogoClick();
        loadSavedTheme();
        loadLogoSwap();
        startClock();
    }

    // Logo triple-click to swap
    function setupLogoClick() {
        if (logoImg) {
            logoImg.addEventListener('click', function() {
                logoClickCount++;

                if (logoClickTimer) {
                    clearTimeout(logoClickTimer);
                }

                logoClickTimer = setTimeout(function() {
                    logoClickCount = 0;
                }, 500);

                if (logoClickCount >= 3) {
                    logoClickCount = 0;
                    logoSwapped = !logoSwapped;
                    saveLogoSwap();
                    updateTheme();
                }
            });
        }
    }

    function saveLogoSwap() {
        localStorage.setItem('scoreboard-logo-swap', logoSwapped ? 'true' : 'false');
    }

    function loadLogoSwap() {
        const saved = localStorage.getItem('scoreboard-logo-swap');
        if (saved === 'true') {
            logoSwapped = true;
        }
    }

    // Get correct logo based on theme and swap state
    function getLogoDark() {
        return logoSwapped ? LOGO_GOLD : LOGO_SILVER;
    }

    function getLogoLight() {
        return logoSwapped ? LOGO_SILVER : LOGO_GOLD;
    }

    // Clock
    function startClock() {
        updateClock();
        setInterval(updateClock, 1000);
    }

    function updateClock() {
        const now = new Date();
        let hours = now.getHours();
        let minutes = now.getMinutes();
        const ampm = hours >= 12 ? 'PM' : 'AM';

        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;

        clockElement.textContent = hours + ':' + minutes + ' ' + ampm;
    }

    // Theme Toggle
    function setupThemeToggle() {
        themeToggle.addEventListener('change', function() {
            isDarkTheme = this.checked;
            updateTheme();
            saveTheme();
        });
    }

    function updateTheme() {
        if (isDarkTheme) {
            document.body.classList.remove('light-theme');
            themeLabel.textContent = 'Dark';
            if (logoImg) logoImg.src = getLogoDark();
        } else {
            document.body.classList.add('light-theme');
            themeLabel.textContent = 'Light';
            if (logoImg) logoImg.src = getLogoLight();
        }
    }

    function saveTheme() {
        localStorage.setItem('scoreboard-theme', isDarkTheme ? 'dark' : 'light');
    }

    function loadSavedTheme() {
        const saved = localStorage.getItem('scoreboard-theme');
        if (saved === 'light') {
            isDarkTheme = false;
            themeToggle.checked = false;
            updateTheme();
        }
    }

    // Message Listener (from Lua)
    function setupMessageListener() {
        window.addEventListener('message', function(event) {
            const data = event.data;

            switch(data.action) {
                case 'toggle':
                    toggleScoreboard();
                    break;
                case 'show':
                    showScoreboard();
                    break;
                case 'hide':
                    hideScoreboard();
                    break;
                case 'getdata':
                    updateStats(data.data);
                    break;
                case 'closeSiteViewer':
                    closeSiteViewer();
                    break;
            }
        });
    }

    // Toggle Scoreboard
    function toggleScoreboard() {
        if (scoreboard.style.display === 'none' || scoreboard.style.display === '') {
            showScoreboard();
        } else {
            hideScoreboard();
        }
    }

    // Show/Hide Scoreboard
    function showScoreboard() {
        scoreboard.style.display = 'block';
    }

    function hideScoreboard() {
        scoreboard.style.display = 'none';
        if (isSiteViewerOpen) {
            closeSiteViewer();
        }
    }

    // Update Stats
    function updateStats(counts) {
        if (!counts) return;

        updateJobCount('police', counts.police || 0);
        updateJobCount('ambulance', counts.ambulance || 0);
        updateJobCount('mt', counts.mt || 0);
        updateJobCount('mechanic', counts.mechanic || 0);
        updateJobCount('taxi', counts.taxi || 0);
        updateJobCount('justice', counts.justice || 0);
        updateJobCount('fbi', counts.fbi || 0);
        updateJobCount('admins', counts.admins || 0);

        // Military card back details
        updateElement('detail-police', counts.detail_police || 0);
        updateElement('detail-sheriff', counts.detail_sheriff || 0);
        updateElement('detail-mt', counts.mt_total || 0);

        // MT card back details
        updateElement('detail-mt-ready', counts.mt_ready || 0);
        updateElement('detail-mt-busy', counts.mt_busy || 0);

        // Total players
        const totalElement = document.getElementById('players-total');
        if (totalElement) {
            totalElement.textContent = counts.total || 0;
        }
    }

    function updateElement(id, value) {
        const el = document.getElementById(id);
        if (el) el.textContent = value;
    }

    function updateJobCount(job, count) {
        const countElement = document.getElementById(job + '-count');
        const card = document.querySelector('[data-job="' + job + '"]');

        if (countElement) {
            countElement.textContent = count || 0;
        }

        if (card) {
            if (count > 0) {
                card.classList.add('online');
            } else {
                card.classList.remove('online');
            }
        }
    }

    // Flip Card
    window.flipCard = function(card) {
        card.classList.toggle('flipped');
    };

    // Close Scoreboard (X button)
    window.closeScoreboard = function() {
        $.post('https://scoreboard/close', JSON.stringify({}));
    };

    // Copy Discord
    window.copyDiscord = function() {
        navigator.clipboard.writeText(DISCORD_LINK).then(function() {
            showNotification('Discord link copied!');
        }).catch(function() {
            // Fallback
            const textarea = document.createElement('textarea');
            textarea.value = DISCORD_LINK;
            document.body.appendChild(textarea);
            textarea.select();
            document.execCommand('copy');
            document.body.removeChild(textarea);
            showNotification('Discord link copied!');
        });
    };

    // Show Notification
    function showNotification(text) {
        notification.textContent = text;
        notification.style.display = 'block';
        setTimeout(function() {
            notification.style.display = 'none';
        }, 2000);
    }

    // Open Website
    window.openWebsite = function() {
        isSiteViewerOpen = true;
        scoreboard.style.display = 'none';
        siteViewer.style.display = 'block';

        var opened = false;
        function openWith(url) {
            if (opened) return;
            opened = true;
            siteIframe.src = url;
        }

        setTimeout(function() {
            openWith(WEBSITE_URL);
        }, 2500);

        $.post('https://scoreboard/requestSiteLogin', JSON.stringify({}), function(resp) {
            var data = resp;
            if (typeof resp === 'string') {
                try { data = JSON.parse(resp); } catch (e) { data = null; }
            }
            if (data && data.token) {
                openWith(WEBSITE_URL + '/?gtoken=' + encodeURIComponent(data.token));
            } else {
                openWith(WEBSITE_URL);
            }
        }).fail(function() {
            openWith(WEBSITE_URL);
        });

        $.post('https://scoreboard/siteViewerOpened', JSON.stringify({}));
    };

    // Close Site Viewer
    window.closeSiteViewer = function() {
        isSiteViewerOpen = false;
        siteViewer.style.display = 'none';
        siteIframe.src = '';
        scoreboard.style.display = 'block';

        // Tell Lua site viewer is closed
        $.post('https://scoreboard/siteViewerClosed', JSON.stringify({}));
    };

    // Initialize on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
