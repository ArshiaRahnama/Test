(function() {
    'use strict';

    var audioPlayers = [];

    var boomboxContainer = document.getElementById('boombox');
    var songNameEl = document.getElementById('songName');
    var progressFill = document.getElementById('progressFill');
    var currentTimeEl = document.getElementById('currentTime');
    var totalTimeEl = document.getElementById('totalTime');
    var playPauseBtn = document.getElementById('playPauseBtn');
    var shuffleBtn = document.getElementById('shuffleBtn');
    var addToPlaylistBtn = document.getElementById('addToPlaylistBtn');
    var playlistItemsEl = document.getElementById('playlistItems');
    var volumeSlider = document.getElementById('volumeSlider');
    var rangeSlider = document.getElementById('rangeSlider');
    var volumeValueEl = document.getElementById('volumeValue');
    var rangeValueEl = document.getElementById('rangeValue');
    var urlInput = document.getElementById('urlInput');
    var notification = document.getElementById('notification');
    var volumeCard = document.getElementById('volumeCard');
    var rangeCard = document.getElementById('rangeCard');
    var volumeCooldown = document.getElementById('volumeCooldown');
    var rangeCooldown = document.getElementById('rangeCooldown');
    var progressBar = document.getElementById('progressBar');
    var carryHint = document.getElementById('carryHint');

    var state = {
        isOpen: false,
        isPlaying: false,
        currentUrl: null,
        currentSongName: null,
        volume: 25,
        range: 50,
        shuffle: false,
        playlist: [],
        currentPlaylistIndex: -1,
        currentTime: 0,
        duration: 0,
        volumeCooldownEnd: 0,
        rangeCooldownEnd: 0,
        seekCooldownEnd: 0,
        playbackCooldownEnd: 0,
        myBoomboxId: null
    };

    var STORAGE_KEY = 'sunset_boombox_data';
    var VOLUME_COOLDOWN = 5000;
    var RANGE_COOLDOWN = 10000;
    var SEEK_COOLDOWN = 30000;
    var PLAYBACK_COOLDOWN = 5000;
    var progressTimer = null;

    function init() {
        loadFromStorage();
        renderPlaylist();
        updateUI();
        startProgressTimer();
    }

    function startProgressTimer() {
        if (progressTimer) clearInterval(progressTimer);
        progressTimer = setInterval(function() {
            if (state.isPlaying && state.duration > 0) {
                state.currentTime++;
                if (state.currentTime >= state.duration) {
                    state.currentTime = 0;
                }
                updateProgressUI();
            }
        }, 1000);
    }

    function updateProgressUI() {
        var percent = state.duration > 0 ? (state.currentTime / state.duration) * 100 : 0;
        progressFill.style.width = percent + '%';
        currentTimeEl.textContent = formatTime(state.currentTime);
        totalTimeEl.textContent = formatTime(state.duration);
    }

    function startCooldown(type) {
        var now = Date.now();
        if (type === 'volume') {
            state.volumeCooldownEnd = now + VOLUME_COOLDOWN;
            volumeCard.classList.add('on-cooldown');
            volumeCooldown.style.animation = 'none';
            volumeCooldown.offsetHeight;
            volumeCooldown.style.animation = 'cooldownShrink ' + (VOLUME_COOLDOWN / 1000) + 's linear forwards';
            setTimeout(function() {
                volumeCard.classList.remove('on-cooldown');
            }, VOLUME_COOLDOWN);
        } else if (type === 'range') {
            state.rangeCooldownEnd = now + RANGE_COOLDOWN;
            rangeCard.classList.add('on-cooldown');
            rangeCooldown.style.animation = 'none';
            rangeCooldown.offsetHeight;
            rangeCooldown.style.animation = 'cooldownShrink ' + (RANGE_COOLDOWN / 1000) + 's linear forwards';
            setTimeout(function() {
                rangeCard.classList.remove('on-cooldown');
            }, RANGE_COOLDOWN);
        } else if (type === 'seek') {
            state.seekCooldownEnd = now + SEEK_COOLDOWN;
            var seekCooldownEl = document.getElementById('seekCooldown');
            var progressContainer = document.querySelector('.progress-container');
            if (progressContainer) progressContainer.classList.add('on-cooldown');
            if (seekCooldownEl) {
                seekCooldownEl.style.animation = 'none';
                seekCooldownEl.offsetHeight;
                seekCooldownEl.style.animation = 'cooldownShrink ' + (SEEK_COOLDOWN / 1000) + 's linear forwards';
            }
            setTimeout(function() {
                if (progressContainer) progressContainer.classList.remove('on-cooldown');
            }, SEEK_COOLDOWN);
        } else if (type === 'playback') {
            state.playbackCooldownEnd = now + PLAYBACK_COOLDOWN;
            var playbackCooldownEl = document.getElementById('playbackCooldown');
            var playbackControls = document.querySelector('.playback-controls');
            if (playbackControls) playbackControls.classList.add('on-cooldown');
            if (playbackCooldownEl) {
                playbackCooldownEl.style.animation = 'none';
                playbackCooldownEl.offsetHeight;
                playbackCooldownEl.style.animation = 'cooldownShrink ' + (PLAYBACK_COOLDOWN / 1000) + 's linear forwards';
            }
            setTimeout(function() {
                if (playbackControls) playbackControls.classList.remove('on-cooldown');
            }, PLAYBACK_COOLDOWN);
        }
        saveToStorage();
    }

    function isOnCooldown(type) {
        var now = Date.now();
        if (type === 'volume') {
            return now < state.volumeCooldownEnd;
        } else if (type === 'range') {
            return now < state.rangeCooldownEnd;
        } else if (type === 'seek') {
            return now < state.seekCooldownEnd;
        } else if (type === 'playback') {
            return now < state.playbackCooldownEnd;
        }
        return false;
    }

    function generateUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0;
            var v = c === 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    function extractSongName(url) {
        try {
            var parts = url.split('/');
            var filename = parts[parts.length - 1];
            filename = filename.split('?')[0];
            filename = decodeURIComponent(filename);
            filename = filename.replace(/\.(mp3|wav|ogg|m4a)$/i, '');
            filename = filename.replace(/[-_]/g, ' ');
            return filename || 'Unknown Song';
        } catch (e) {
            return 'Unknown Song';
        }
    }

    function formatTime(seconds) {
        if (!seconds || isNaN(seconds)) return '0:00';
        var mins = Math.floor(seconds / 60);
        var secs = Math.floor(seconds % 60);
        return mins + ':' + (secs < 10 ? '0' : '') + secs;
    }

    function saveToStorage() {
        var data = {
            playlist: state.playlist,
            settings: {
                shuffle: state.shuffle,
                lastVolume: state.volume,
                lastRange: state.range
            },
            cooldowns: {
                volumeCooldownEnd: state.volumeCooldownEnd,
                rangeCooldownEnd: state.rangeCooldownEnd,
                seekCooldownEnd: state.seekCooldownEnd,
                playbackCooldownEnd: state.playbackCooldownEnd
            }
        };
        localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    }

    function loadFromStorage() {
        try {
            var saved = localStorage.getItem(STORAGE_KEY);
            if (saved) {
                var data = JSON.parse(saved);
                state.playlist = data.playlist || [];
                if (data.settings) {
                    state.shuffle = data.settings.shuffle || false;
                    state.volume = data.settings.lastVolume || 25;
                    state.range = data.settings.lastRange || 50;
                }
                if (data.cooldowns) {
                    state.volumeCooldownEnd = data.cooldowns.volumeCooldownEnd || 0;
                    state.rangeCooldownEnd = data.cooldowns.rangeCooldownEnd || 0;
                    state.seekCooldownEnd = data.cooldowns.seekCooldownEnd || 0;
                    state.playbackCooldownEnd = data.cooldowns.playbackCooldownEnd || 0;
                }
            }
        } catch (e) {
            console.error('Error loading from storage:', e);
        }
    }

    function restoreCooldownUI() {
        var now = Date.now();

        volumeCard.classList.remove('on-cooldown');
        rangeCard.classList.remove('on-cooldown');
        volumeCooldown.style.animation = 'none';
        rangeCooldown.style.animation = 'none';

        var seekCooldownEl = document.getElementById('seekCooldown');
        var progressContainer = document.querySelector('.progress-container');
        var playbackCooldownEl = document.getElementById('playbackCooldown');
        var playbackControls = document.querySelector('.playback-controls');

        if (progressContainer) progressContainer.classList.remove('on-cooldown');
        if (seekCooldownEl) seekCooldownEl.style.animation = 'none';
        if (playbackControls) playbackControls.classList.remove('on-cooldown');
        if (playbackCooldownEl) playbackCooldownEl.style.animation = 'none';

        if (state.volumeCooldownEnd > now) {
            var remaining = state.volumeCooldownEnd - now;
            volumeCard.classList.add('on-cooldown');
            volumeCooldown.offsetHeight;
            volumeCooldown.style.animation = 'cooldownShrink ' + (remaining / 1000) + 's linear forwards';
            setTimeout(function() {
                volumeCard.classList.remove('on-cooldown');
            }, remaining);
        }

        if (state.rangeCooldownEnd > now) {
            var remaining = state.rangeCooldownEnd - now;
            rangeCard.classList.add('on-cooldown');
            rangeCooldown.offsetHeight;
            rangeCooldown.style.animation = 'cooldownShrink ' + (remaining / 1000) + 's linear forwards';
            setTimeout(function() {
                rangeCard.classList.remove('on-cooldown');
            }, remaining);
        }

        if (state.seekCooldownEnd > now) {
            var remaining = state.seekCooldownEnd - now;
            if (progressContainer) progressContainer.classList.add('on-cooldown');
            if (seekCooldownEl) {
                seekCooldownEl.offsetHeight;
                seekCooldownEl.style.animation = 'cooldownShrink ' + (remaining / 1000) + 's linear forwards';
            }
            setTimeout(function() {
                if (progressContainer) progressContainer.classList.remove('on-cooldown');
            }, remaining);
        }

        if (state.playbackCooldownEnd > now) {
            var remaining = state.playbackCooldownEnd - now;
            if (playbackControls) playbackControls.classList.add('on-cooldown');
            if (playbackCooldownEl) {
                playbackCooldownEl.offsetHeight;
                playbackCooldownEl.style.animation = 'cooldownShrink ' + (remaining / 1000) + 's linear forwards';
            }
            setTimeout(function() {
                if (playbackControls) playbackControls.classList.remove('on-cooldown');
            }, remaining);
        }
    }

    function updateUI() {
        volumeSlider.value = state.volume;
        volumeValueEl.textContent = state.volume + '%';
        rangeSlider.value = state.range;
        rangeValueEl.textContent = state.range + 'm';

        if (state.shuffle) {
            shuffleBtn.classList.add('active');
        } else {
            shuffleBtn.classList.remove('active');
        }

        if (state.isPlaying) {
            playPauseBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/></svg>';
        } else {
            playPauseBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>';
        }

        if (state.currentUrl) {
            songNameEl.textContent = state.currentSongName || extractSongName(state.currentUrl);
            addToPlaylistBtn.disabled = false;
        } else {
            songNameEl.textContent = 'No song playing';
            addToPlaylistBtn.disabled = true;
        }

        updateProgressUI();
    }

    function renderPlaylist() {
        if (state.playlist.length === 0) {
            playlistItemsEl.innerHTML = '<div class="playlist-empty">Playlist khali ast</div>';
            return;
        }

        var sortedPlaylist = state.playlist.map(function(item, index) {
            return { item: item, originalIndex: index };
        }).sort(function(a, b) {
            if (a.item.favorite && !b.item.favorite) return -1;
            if (!a.item.favorite && b.item.favorite) return 1;
            return 0;
        });

        var html = '';
        sortedPlaylist.forEach(function(entry) {
            var item = entry.item;
            var index = entry.originalIndex;
            var isActive = index === state.currentPlaylistIndex;
            html += '<div class="playlist-item' + (isActive ? ' active' : '') + (item.favorite ? ' favorite' : '') + '" data-index="' + index + '">';
            html += '<button class="fav-btn' + (item.favorite ? ' active' : '') + '" onclick="toggleFavorite(' + index + ')">' + (item.favorite ? '⭐' : '☆') + '</button>';
            html += '<span class="song-info" onclick="playFromPlaylist(' + index + ')">' + escapeHtml(item.name) + '</span>';
            html += '<button class="remove-btn" onclick="removeFromPlaylist(' + index + ')">🗑️</button>';
            html += '</div>';
        });
        playlistItemsEl.innerHTML = html;
    }

    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function showNotification(message, isError) {
        if (!state.isOpen) return;
        notification.textContent = message;
        notification.className = 'notification' + (isError ? ' error' : '');
        notification.style.display = 'block';
        setTimeout(function() {
            notification.style.display = 'none';
        }, 1500);
    }

    window.addEventListener('message', function(event) {
        var data = event.data;

        if (!audioPlayers[data.id]) {
            audioPlayers[data.id] = new Audio();
            audioPlayers[data.id].autoplay = true;
            audioPlayers[data.id].controls = false;
            audioPlayers[data.id].preload = 'none';
        }

        if (data.type === 'play') {
            playAudio(data.id, data.url, data.volume, data.time);
        }
        if (data.type === 'stop') {
            stopAudio(data.id);
            audioPlayers[data.id] = null;
        }
        if (data.type === 'pause') {
            pauseAudio(data.id);
        }
        if (data.type === 'volume') {
            setAudioVolume(data.id, data.volume);
        }
        if (data.type === 'time') {
            setAudioTime(data.id, data.time);
        }

        if (data.action === 'open') {
            openBoombox(data);
            restoreCooldownUI();
            carryHint.style.display = 'none';
        }
        if (data.action === 'close') {
            hideBoombox();
        }
        if (data.action === 'showHint') {
            carryHint.style.display = 'flex';
        }
        if (data.action === 'hideHint') {
            carryHint.style.display = 'none';
        }
        if (data.action === 'updateState') {
            if (data.url) {
                state.currentUrl = data.url;
                state.currentSongName = extractSongName(data.url);
                state.isPlaying = data.isPlaying !== false;
            }
            if (data.volume !== undefined) state.volume = data.volume;
            if (data.range !== undefined) state.range = data.range;
            if (data.currentTime !== undefined) state.currentTime = data.currentTime;
            if (data.duration !== undefined) state.duration = data.duration;
            updateUI();
        }
    });

    function playAudio(id, url, volume, time) {
        audioPlayers[id].loop = false;
        audioPlayers[id].src = url;
        audioPlayers[id].volume = volume;
        audioPlayers[id].onloadedmetadata = function() {
            if (audioPlayers[id].duration > 30 * 60) {
                stopAudio(id);
            } else if (state.myBoomboxId === id) {
                state.duration = Math.floor(audioPlayers[id].duration);
                state.currentTime = Math.floor(time % audioPlayers[id].duration);
                setAudioTime(id, state.currentTime);
                updateProgressUI();
            }
        };
        audioPlayers[id].ontimeupdate = function() {
            if (audioPlayers[id] && state.myBoomboxId === id) {
                state.currentTime = Math.floor(audioPlayers[id].currentTime);
                updateProgressUI();
            }
        };
        audioPlayers[id].onended = function() {
            if (state.myBoomboxId === id) {
                handleSongEnd(id);
            }
        };
    }

    function handleSongEnd() {
        if (state.playlist.length > 0) {
            var newIndex;
            if (state.shuffle) {
                newIndex = Math.floor(Math.random() * state.playlist.length);
            } else {
                newIndex = state.currentPlaylistIndex + 1;
                if (newIndex >= state.playlist.length) {
                    newIndex = 0;
                }
            }
            var item = state.playlist[newIndex];
            state.currentUrl = item.url;
            state.currentSongName = item.name;
            state.currentPlaylistIndex = newIndex;
            state.isPlaying = true;
            state.currentTime = 0;
            $.post('https://sunset_boombox/play', JSON.stringify({ url: item.url }));
            updateUI();
            renderPlaylist();
        } else if (state.currentUrl) {
            state.currentTime = 0;
            $.post('https://sunset_boombox/play', JSON.stringify({ url: state.currentUrl }));
            updateUI();
        }
    }

    function stopAudio(id) {
        if (audioPlayers[id]) {
            audioPlayers[id].loop = false;
            audioPlayers[id].onloadedmetadata = null;
            audioPlayers[id].onended = null;
            audioPlayers[id].src = 'data:audio/wav;base64,UklGRiQAAABXQVZFZm10IBAAAAABAAEAVFYAAFRWAAABAAgAZGF0YQAAAAA=';
        }
    }

    function pauseAudio(id) {
        if (audioPlayers[id]) {
            audioPlayers[id].pause();
        }
    }

    function setAudioVolume(id, volume) {
        if (audioPlayers[id]) {
            audioPlayers[id].volume = volume;
        }
    }

    function setAudioTime(id, time) {
        if (audioPlayers[id]) {
            audioPlayers[id].currentTime = time;
        }
    }

    function openBoombox(data) {
        state.isOpen = true;
        state.myBoomboxId = data.boomboxId || null;
        if (data.volume !== undefined) {
            state.volume = data.volume;
        }
        if (data.range !== undefined) {
            state.range = data.range;
        }
        if (data.url) {
            state.currentUrl = data.url;
            state.currentSongName = extractSongName(data.url);
            state.isPlaying = true;
        }
        boomboxContainer.style.display = 'block';
        updateUI();
        renderPlaylist();
    }

    function hideBoombox() {
        state.isOpen = false;
        boomboxContainer.style.display = 'none';
        notification.style.display = 'none';
    }

    window.closeBoombox = function() {
        $.post('https://sunset_boombox/previewRange', JSON.stringify({ range: 0, show: false }));
        hideBoombox();
        $.post('https://sunset_boombox/close', JSON.stringify({}));
    };

    window.togglePlayPause = function() {
        if (isOnCooldown('playback')) {
            showNotification('Bayad 5 sanie sabr koni', true);
            return;
        }
        if (state.isPlaying) {
            $.post('https://sunset_boombox/pause', JSON.stringify({}));
            state.isPlaying = false;
        } else if (state.currentUrl) {
            $.post('https://sunset_boombox/resume', JSON.stringify({ url: state.currentUrl, time: state.currentTime }));
            state.isPlaying = true;
        }
        startCooldown('playback');
        updateUI();
    };

    window.prevSong = function() {
        if (state.playlist.length === 0) return;
        if (isOnCooldown('playback')) {
            showNotification('Bayad 5 sanie sabr koni', true);
            return;
        }

        var newIndex;
        if (state.shuffle) {
            newIndex = Math.floor(Math.random() * state.playlist.length);
        } else {
            newIndex = state.currentPlaylistIndex - 1;
            if (newIndex < 0) newIndex = state.playlist.length - 1;
        }
        playFromPlaylist(newIndex);
    };

    window.nextSong = function() {
        if (state.playlist.length === 0) return;
        if (isOnCooldown('playback')) {
            showNotification('Bayad 5 sanie sabr koni', true);
            return;
        }

        var newIndex;
        if (state.shuffle) {
            newIndex = Math.floor(Math.random() * state.playlist.length);
        } else {
            newIndex = state.currentPlaylistIndex + 1;
            if (newIndex >= state.playlist.length) newIndex = 0;
        }
        playFromPlaylist(newIndex);
    };

    window.toggleShuffle = function() {
        state.shuffle = !state.shuffle;
        saveToStorage();
        updateUI();
    };

    window.seekTo = function(event) {
        if (!state.duration || state.duration <= 0) return;
        if (isOnCooldown('seek')) {
            showNotification('Bayad 30 sanie sabr koni', true);
            return;
        }
        var rect = progressBar.getBoundingClientRect();
        var clickX = event.clientX - rect.left;
        var percent = clickX / rect.width;
        var newTime = Math.floor(percent * state.duration);
        state.currentTime = Math.max(0, Math.min(newTime, state.duration));
        updateProgressUI();
        $.post('https://sunset_boombox/seek', JSON.stringify({ time: state.currentTime }));
        startCooldown('seek');
    };

    window.previewVolume = function(value) {
        if (isOnCooldown('volume')) {
            volumeSlider.value = state.volume;
            return;
        }
        volumeValueEl.textContent = parseInt(value) + '%';
    };

    window.applyVolume = function(value) {
        if (isOnCooldown('volume')) {
            volumeSlider.value = state.volume;
            return;
        }
        state.volume = parseInt(value);
        volumeValueEl.textContent = state.volume + '%';
        $.post('https://sunset_boombox/setVolume', JSON.stringify({ volume: state.volume }));
        startCooldown('volume');
        saveToStorage();
    };

    window.previewRange = function(value) {
        if (isOnCooldown('range')) {
            rangeSlider.value = state.range;
            return;
        }
        rangeValueEl.textContent = parseInt(value) + 'm';
        $.post('https://sunset_boombox/previewRange', JSON.stringify({ range: parseInt(value), show: true }));
    };

    window.applyRange = function(value) {
        if (isOnCooldown('range')) {
            rangeSlider.value = state.range;
            return;
        }
        state.range = parseInt(value);
        rangeValueEl.textContent = state.range + 'm';
        $.post('https://sunset_boombox/previewRange', JSON.stringify({ range: 0, show: false }));
        $.post('https://sunset_boombox/setRange', JSON.stringify({ range: state.range }));
        startCooldown('range');
        saveToStorage();
    };

    window.playFromUrl = function() {
        if (isOnCooldown('playback')) {
            showNotification('Bayad 5 sanie sabr koni', true);
            return;
        }

        var url = urlInput.value.trim();
        if (!url) {
            showNotification('Link ahang ra vared konid', true);
            return;
        }

        if (!isValidAudioUrl(url)) {
            showNotification('Link bayad http bashe va mp3 ya wav', true);
            return;
        }

        showNotification('Dar hal barresi link ahang...', false);
        validateAudioUrl(url, function(isValid) {
            if (isValid) {
                state.currentUrl = url;
                state.currentSongName = extractSongName(url);
                state.isPlaying = true;
                urlInput.value = '';

                $.post('https://sunset_boombox/play', JSON.stringify({ url: url }));
                startCooldown('playback');
                updateUI();
                showNotification('Link ahang motabar ast', false);
            } else {
                showNotification('Link ahang namotabar ast ya file vojood nadare', true);
            }
        });
    };

    function isValidAudioUrl(url) {
        var pattern = /^https?:\/\/[^\s<>"{}|\\^`\[\]]+\.(mp3|wav)(\?[^\s]*)?$/i;
        if (!pattern.test(url)) {
            return false;
        }
        var dangerous = /[<>"'`]|javascript:|data:|file:/i;
        if (dangerous.test(url)) {
            return false;
        }
        return true;
    }

    function validateAudioUrl(url, callback) {
        var audio = new Audio();
        var called = false;

        function done(result) {
            if (called) return;
            called = true;
            audio.onloadedmetadata = null;
            audio.onerror = null;
            audio.src = '';
            callback(result);
        }

        var timeout = setTimeout(function() {
            done(false);
        }, 5000);

        audio.onloadedmetadata = function() {
            clearTimeout(timeout);
            done(true);
        };

        audio.onerror = function() {
            clearTimeout(timeout);
            done(false);
        };

        audio.src = url;
    }

    window.addToPlaylist = function() {
        if (!state.currentUrl) return;

        var exists = state.playlist.some(function(item) {
            return item.url === state.currentUrl;
        });

        if (exists) {
            showNotification('In ahang dar playlist hast', true);
            return;
        }

        var newItem = {
            id: generateUUID(),
            name: state.currentSongName || extractSongName(state.currentUrl),
            url: state.currentUrl,
            favorite: false,
            addedAt: Date.now()
        };

        state.playlist.push(newItem);
        state.currentPlaylistIndex = state.playlist.length - 1;
        saveToStorage();
        renderPlaylist();
        showNotification('Be playlist ezafe shod');
    };

    window.playFromPlaylist = function(index) {
        if (index < 0 || index >= state.playlist.length) return;
        if (isOnCooldown('playback')) {
            showNotification('Bayad 5 sanie sabr koni', true);
            return;
        }

        var item = state.playlist[index];
        state.currentUrl = item.url;
        state.currentSongName = item.name;
        state.currentPlaylistIndex = index;
        state.isPlaying = true;

        $.post('https://sunset_boombox/play', JSON.stringify({ url: item.url }));
        startCooldown('playback');
        updateUI();
        renderPlaylist();
    };

    window.removeFromPlaylist = function(index) {
        state.playlist.splice(index, 1);
        if (state.currentPlaylistIndex === index) {
            state.currentPlaylistIndex = -1;
        } else if (state.currentPlaylistIndex > index) {
            state.currentPlaylistIndex--;
        }
        saveToStorage();
        renderPlaylist();
    };

    window.toggleFavorite = function(index) {
        state.playlist[index].favorite = !state.playlist[index].favorite;
        saveToStorage();
        renderPlaylist();
    };

    window.pickupBoombox = function() {
        hideBoombox();
        $.post('https://sunset_boombox/pickup', JSON.stringify({}));
    };

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && state.isOpen) {
            closeBoombox();
        }
    });

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
