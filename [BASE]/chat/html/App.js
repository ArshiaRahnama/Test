window.APP = {
  template: '#app_template',
  name: 'app',
  data() {
    return {
      showInput: false,
      showWindow: false,
      suggestions: [],
      templates: CONFIG.templates,
      message: '',
      messages: [],
      oldMessages: [],
      oldMessagesIndex: -1,
      tabs: [
        { id: 'live', label: 'LIVE', icon: '💬' },
        { id: 'system', label: 'SYSTEM', icon: '⚙' },
        { id: 'event', label: 'EVENT', icon: '🎉' },
        { id: 'tabligh', label: 'TABLIGH', icon: '📢' },
        { id: 'job', label: 'JOB', icon: '💼' },
        { id: 'gang', label: 'GANG', icon: '🕶' },
        { id: 'staff', label: 'STAFF', icon: '🛡' },
      ],
      tabColors: { staff: '#ffd166', job: '#4fa8ff', gang: '#ff6b6b' },
      indicatorStyle: { left: '0px', width: '0px', backgroundColor: '#0577dd' },
      activeTab: 'live',
      unread: { live: false, system: false, event: false, tabligh: false, job: false, gang: false, staff: false },
      // these tabs stay hidden until the player actually receives a message
      // in that channel (i.e. they're a member of that job/gang, or staff)
      dynamicTabs: ['job', 'gang', 'staff'],
      revealed: { job: false, gang: false, staff: false },
      pinned: null,
      showSettings: false,
      settingsTab: 'chat', // 'chat' | 'live'
      sizeWidth: 41,   // percent, matches CONFIG.style.width default
      sizeHeight: 240, // px, matches CONFIG.style.height default
      opacity: 62,     // percent, used when bgEnabled is true
      bgEnabled: true, // background plate on by default
      autoShowOnMessage: true, // pop the chat open when a new message arrives
      lockPosition: false,     // disable the drag handle
      soundEnabled: true,      // play a notification tone for messages in tabs you're not on
      fontScale: 100,  // percent, message font size (85/100/115 = S/M/L)
      msgFont: 'inter',
      fontPresets: [
        { id: 'lato', label: 'Lato', family: "'Lato', sans-serif" },
        { id: 'inter', label: 'Inter', family: "'Inter', sans-serif" },
        { id: 'rajdhani', label: 'Rajdhani', family: "'Rajdhani', sans-serif" },
        { id: 'orbitron', label: 'Orbitron', family: "'Orbitron', sans-serif" },
        { id: 'chakra', label: 'Chakra Petch', family: "'Chakra Petch', sans-serif" },
        { id: 'mono', label: 'JetBrains Mono', family: "'JetBrains Mono', monospace" },
      ],
      accent: '#0577dd',
      accentPresets: ['#0577dd', '#00d8d8', '#1dd1a1', '#a970ff', '#ff6b6b', '#ffd166'],
      // whether each non-live channel's messages also show up under LIVE
      liveInclude: { system: true, event: true, tabligh: true, job: true, gang: true, staff: true },
      posX: 20,  // px from left
      posY: 60,  // px from top
      dragging: false,
      _snapshot: null,
      msgIdCounter: 0,
      showStarred: false,
      starred: [], // [{ id, text, ts }]
      // Hard cap on how many chat lines we keep in memory/DOM at once.
      // Without this, a long play session builds up thousands of live
      // <message> components (each with its own Vue instance + text-shadow
      // heavy DOM node) that never get removed, which is what causes the
      // chat to gradually lag the longer the server stays up. Pinned and
      // starred messages are stored separately, so trimming old scrollback
      // here never touches them.
      maxMessages: 300,
      maxOldMessages: 50,
    };
  },
  computed: {
    visibleTabs() {
      return this.tabs.filter((t) => !this.dynamicTabs.includes(t.id) || this.revealed[t.id]);
    },
    filteredMessages() {
      if (this.activeTab === 'live') {
        return this.messages.filter((m) => {
          const ch = m.channel || 'live';
          return ch === 'live' || this.liveInclude[ch] !== false;
        });
      }
      return this.messages.filter((m) => (m.channel || 'live') === this.activeTab);
    },
    fontFamily() {
      const preset = this.fontPresets.find((f) => f.id === this.msgFont);
      return preset ? preset.family : "'Lato', sans-serif";
    },
    appStyle() {
      return {
        width: `${this.sizeWidth}%`,
        height: `${this.sizeHeight}px`,
        top: `${this.posY}px`,
        left: `${this.posX}px`,
        '--accent': this.accent,
        '--font-scale': this.fontScale / 100,
        '--msg-font': this.fontFamily,
      };
    },
    windowStyle() {
      return {
        backgroundColor: this.bgEnabled
          ? `rgba(12, 13, 16, ${this.opacity / 100})`
          : 'transparent',
      };
    },
    inputStyle() {
      return {
        top: `${this.sizeHeight + 8}px`,
      };
    },
  },
  destroyed() {
    clearInterval(this.focusTimer);
    window.removeEventListener('message', this._onMessage);
    window.removeEventListener('mousemove', this._onDragMove);
    window.removeEventListener('mouseup', this._onDragEnd);
  },
  mounted() {
    post('http://chat/loaded', JSON.stringify({}));
    this._onDragMove = (e) => this.onDrag(e);
    this._onDragEnd = () => this.stopDrag();
    this._onMessage = (event) => {
      const item = event.data || event.detail; //'detail' is for debuging via browsers
      if (item && this[item.type]) {
        this[item.type](item);
      }
    };
    this.$nextTick(() => this.updateIndicator());
    window.addEventListener('message', this._onMessage);
  },
  watch: {
    messages() {
      if (!this.autoShowOnMessage) return;
      if (this.showWindowTimer) {
        clearTimeout(this.showWindowTimer);
      }
      this.showWindow = true;
      this.resetShowWindowTimer();
      this.scrollToBottom();
    },
    activeTab() {
      this.scrollToBottom();
      this.updateIndicator();
    },
    accent() {
      this.updateIndicator();
    },
    fontScale() {
      this.updateIndicator();
    },
    msgFont() {
      this.updateIndicator();
    },
  },
  methods: {
    scrollToBottom() {
      const messagesObj = this.$refs.messages;
      this.$nextTick(() => {
        if (messagesObj) {
          messagesObj.scrollTop = messagesObj.scrollHeight;
        }
      });
    },
    selectTab(tabId) {
      this.activeTab = tabId;
      this.unread[tabId] = false;
    },
    updateIndicator() {
      this.$nextTick(() => {
        const refEl = this.$refs['tabref-' + this.activeTab];
        const tabEl = Array.isArray(refEl) ? refEl[0] : refEl;
        if (tabEl) {
          this.indicatorStyle = {
            left: `${tabEl.offsetLeft}px`,
            width: `${tabEl.offsetWidth}px`,
            backgroundColor: this.tabColors[this.activeTab] || this.accent,
          };
        }
      });
    },
    playSound(channel) {
      if (!this.soundEnabled) return;
      const AC = window.AudioContext || window.webkitAudioContext;
      if (!AC) return;

      // a short, distinct tone pattern per channel — no audio files needed
      const patterns = {
        live:    { freqs: [520], dur: 0.09, type: 'sine' },
        system:  { freqs: [720, 520], dur: 0.08, type: 'square' },
        event:   { freqs: [523, 659, 784], dur: 0.07, type: 'sine' },   // cheerful ascending
        tabligh: { freqs: [440, 440], dur: 0.07, type: 'sine' },        // soft double beep
        job:     { freqs: [350], dur: 0.12, type: 'triangle' },
        gang:    { freqs: [220, 180], dur: 0.09, type: 'sawtooth' },    // lower, grittier
        staff:   { freqs: [900, 900, 900], dur: 0.055, type: 'square' }, // urgent triple beep
      };
      const pattern = patterns[channel] || patterns.live;

      try {
        if (!this._audioCtx) {
          this._audioCtx = new AC();
        }
        const ctx = this._audioCtx;
        if (ctx.state === 'suspended') {
          ctx.resume().catch(() => {});
        }
        let t = ctx.currentTime;
        pattern.freqs.forEach((freq) => {
          const osc = ctx.createOscillator();
          const gain = ctx.createGain();
          osc.type = pattern.type;
          osc.frequency.value = freq;
          gain.gain.setValueAtTime(0, t);
          gain.gain.linearRampToValueAtTime(0.16, t + 0.008);
          gain.gain.linearRampToValueAtTime(0, t + pattern.dur);
          osc.connect(gain);
          gain.connect(ctx.destination);
          osc.start(t);
          osc.stop(t + pattern.dur + 0.02);
          t += pattern.dur + 0.03;
        });
      } catch (e) { /* audio not available, fail silently */ }
    },
    toggleStarredPanel() {
      this.showStarred = !this.showStarred;
      if (this.showStarred) {
        this.showSettings = false;
      }
    },
    isStarred(id) {
      if (id === null || id === undefined) return false;
      return this.starred.some((s) => s.id === id);
    },
    toggleStar(id, text) {
      if (id === null || id === undefined) return;
      const idx = this.starred.findIndex((s) => s.id === id);
      if (idx >= 0) {
        this.starred.splice(idx, 1);
      } else {
        this.starred.push({ id, text, ts: Date.now() });
        if (this.starred.length > 200) {
          this.starred.shift();
        }
      }
      this.saveStarred();
    },
    removeStar(id) {
      const idx = this.starred.findIndex((s) => s.id === id);
      if (idx >= 0) {
        this.starred.splice(idx, 1);
        this.saveStarred();
      }
    },
    clearStarred() {
      this.starred = [];
      this.saveStarred();
    },
    saveStarred() {
      post('http://chat/saveStarred', JSON.stringify({ starred: this.starred }));
    },
    quoteMessage(text) {
      post('http://chat/openInput', JSON.stringify({}));
      this.message = `"${text}" `;
      this.$nextTick(() => {
        if (this.$refs.input) {
          this.$refs.input.focus();
        }
      });
    },
    toggleSettings() {
      // note: position (posX/posY) is deliberately excluded here — dragging
      // auto-saves immediately on release (see stopDrag), independent of
      // this dialog, so Cancel shouldn't fight that by reverting a drag
      // you already let go of.
      if (!this.showSettings) {
        this.showStarred = false;
        this._snapshot = {
          sizeWidth: this.sizeWidth,
          sizeHeight: this.sizeHeight,
          opacity: this.opacity,
          bgEnabled: this.bgEnabled,
          autoShowOnMessage: this.autoShowOnMessage,
          lockPosition: this.lockPosition,
          soundEnabled: this.soundEnabled,
          fontScale: this.fontScale,
          msgFont: this.msgFont,
          accent: this.accent,
          liveInclude: { ...this.liveInclude },
        };
      }
      this.showSettings = !this.showSettings;
    },
    cancelSettings() {
      if (this._snapshot) {
        Object.assign(this, this._snapshot);
        this.liveInclude = { ...this._snapshot.liveInclude };
      }
      this.showSettings = false;
    },
    startDrag(e) {
      if (this.lockPosition) return;
      this.dragging = true;
      this._dragMouseX = e.clientX;
      this._dragMouseY = e.clientY;
      this._dragStartX = this.posX;
      this._dragStartY = this.posY;
      window.addEventListener('mousemove', this._onDragMove);
      window.addEventListener('mouseup', this._onDragEnd);
      e.preventDefault();
    },
    onDrag(e) {
      const dx = e.clientX - this._dragMouseX;
      const dy = e.clientY - this._dragMouseY;
      const maxX = Math.max(0, window.innerWidth - 120);
      const maxY = Math.max(0, window.innerHeight - 60);
      this.posX = Math.min(maxX, Math.max(0, this._dragStartX + dx));
      this.posY = Math.min(maxY, Math.max(0, this._dragStartY + dy));
    },
    stopDrag() {
      this.dragging = false;
      window.removeEventListener('mousemove', this._onDragMove);
      window.removeEventListener('mouseup', this._onDragEnd);
      // position changes are meaningful the moment you let go of the drag,
      // so this saves immediately rather than waiting for the settings panel's Save button
      this.saveSettings(true);
    },
    sliderFill(value, min, max) {
      const pct = ((value - min) / (max - min)) * 100;
      return {
        background: `linear-gradient(to right, var(--accent) ${pct}%, rgba(255,255,255,0.12) ${pct}%)`,
      };
    },
    saveSettings(keepOpen = false) {
      post('http://chat/saveSettings', JSON.stringify({
        width: this.sizeWidth,
        height: this.sizeHeight,
        opacity: this.opacity,
        bgEnabled: this.bgEnabled,
        autoShowOnMessage: this.autoShowOnMessage,
        lockPosition: this.lockPosition,
        soundEnabled: this.soundEnabled,
        fontScale: this.fontScale,
        msgFont: this.msgFont,
        accent: this.accent,
        posX: this.posX,
        posY: this.posY,
        liveInclude: this.liveInclude,
      }));
      if (!keepOpen) {
        this.showSettings = false;
      }
    },
    resetSettings() {
      this.sizeWidth = 41;
      this.sizeHeight = 240;
      this.opacity = 62;
      this.bgEnabled = true;
      this.autoShowOnMessage = true;
      this.lockPosition = false;
      this.soundEnabled = true;
      this.fontScale = 100;
      this.msgFont = 'inter';
      this.accent = '#0577dd';
      this.posX = 20;
      this.posY = 60;
      this.liveInclude = { system: true, event: true, tabligh: true, job: true, gang: true, staff: true };
    },
	On_Tab(){
		const escaped = this.message.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
		const re = new RegExp(escaped);
		for (const [key, value] of Object.entries(this.suggestions)) {
			const suc = JSON.stringify(value.name);
			 if(suc.match(re)){
				 this.message = suc.substring( 1, suc.length - 1 ) + " ";
				 break;
			 }
			}
	},  
    ON_OPEN() {
      this.showInput = true;
      this.showWindow = true;
      if (this.showWindowTimer) {
        clearTimeout(this.showWindowTimer);
      }
      this.focusTimer = setInterval(() => {
        if (this.$refs.input) {
          this.$refs.input.focus();
        } else {
          clearInterval(this.focusTimer);
        }
      }, 100);
    },
    ON_MESSAGE({ message }) {
      const channel = message.channel || 'live';
      message._id = ++this.msgIdCounter;
      if (this.dynamicTabs.includes(channel)) {
        const wasHidden = !this.revealed[channel];
        this.revealed[channel] = true;
        if (wasHidden) {
          this.updateIndicator();
        }
      }
      this.messages.push(message);
      // Trim from the front once we're over the cap. splice() on a Vue 2
      // reactive array is itself a reactive (patched) method, so this stays
      // fully reactive - it just keeps the live list (and therefore the
      // DOM/scrollbar) from growing forever over a long session.
      if (this.messages.length > this.maxMessages) {
        this.messages.splice(0, this.messages.length - this.maxMessages);
      }
      if (channel !== this.activeTab) {
        this.unread[channel] = true;
        this.playSound(channel);
      }
    },
    ON_PIN({ pinned }) {
      this.pinned = pinned;
    },
    ON_STARRED({ starred }) {
      if (Array.isArray(starred)) {
        this.starred = starred;
      }
    },
    ON_OPEN_SETTINGS() {
      if (!this.showSettings) {
        this.toggleSettings();
      }
    },
    ON_SETTINGS({ settings }) {
      if (!settings) return;
      if (settings.width) this.sizeWidth = settings.width;
      if (settings.height) this.sizeHeight = settings.height;
      if (settings.opacity !== undefined) this.opacity = settings.opacity;
      if (settings.bgEnabled !== undefined) this.bgEnabled = settings.bgEnabled;
      if (settings.autoShowOnMessage !== undefined) this.autoShowOnMessage = settings.autoShowOnMessage;
      if (settings.lockPosition !== undefined) this.lockPosition = settings.lockPosition;
      if (settings.soundEnabled !== undefined) this.soundEnabled = settings.soundEnabled;
      if (settings.fontScale) {
        const allowedSizes = [85, 100, 115];
        this.fontScale = allowedSizes.includes(settings.fontScale) ? settings.fontScale : 100;
      }
      if (settings.msgFont) this.msgFont = settings.msgFont;
      if (settings.accent) this.accent = settings.accent;
      if (settings.posX !== undefined) this.posX = settings.posX;
      if (settings.posY !== undefined) this.posY = settings.posY;
      if (settings.liveInclude) this.liveInclude = { ...this.liveInclude, ...settings.liveInclude };
    },
    ON_CLEAR() {
      this.messages = [];
      this.oldMessages = [];
      this.oldMessagesIndex = -1;
      this.pinned = null;
      this.revealed = { job: false, gang: false, staff: false };
      this.unread = { live: false, system: false, event: false, tabligh: false, job: false, gang: false, staff: false };
    },
    ON_SUGGESTION_ADD({ suggestion }) {
      if (!suggestion.params) {
        suggestion.params = []; //TODO Move somewhere else
      }
      this.suggestions.push(suggestion);
    },
    ON_SUGGESTION_REMOVE({ name }) {
      this.suggestions = this.suggestions.filter((sug) => sug.name !== name)
    },
    ON_TEMPLATE_ADD({ template }) {
      if (this.templates[template.id]) {
        this.warn(`Tried to add duplicate template '${template.id}'`)
      } else {
        this.templates[template.id] = template.html;
      }
    },
    warn(msg) {
      this.messages.push({
        args: [msg],
        template: '^3<b>CHAT-WARN</b>: ^0{0}',
      });
    },
    clearShowWindowTimer() {
      clearTimeout(this.showWindowTimer);
    },
    resetShowWindowTimer() {
      this.clearShowWindowTimer();
      this.showWindowTimer = setTimeout(() => {
        if (!this.showInput) {
          this.showWindow = false;
        }
      }, CONFIG.fadeTimeout);
    },
    keyUp() {
      this.resize();
    },
    
 keyDown(e) {
      if (e.which === 38 || e.which === 40) {
        e.preventDefault();
        this.moveOldMessageIndex(e.which === 38);
      } else if (e.which === 33) {
        var buf = document.getElementsByClassName('chat-messages')[0];
        buf.scrollTop = buf.scrollTop - 100;
      } else if (e.which === 34) {
        var buf = document.getElementsByClassName('chat-messages')[0];
        buf.scrollTop = buf.scrollTop + 100;
      }
    },
    
    
    moveOldMessageIndex(up) {
      if (up && this.oldMessages.length > this.oldMessagesIndex + 1) {
        this.oldMessagesIndex += 1;
        this.message = this.oldMessages[this.oldMessagesIndex];
      } else if (!up && this.oldMessagesIndex - 1 >= 0) {
        this.oldMessagesIndex -= 1;
        this.message = this.oldMessages[this.oldMessagesIndex];
      } else if (!up && this.oldMessagesIndex - 1 === -1) {
        this.oldMessagesIndex = -1;
        this.message = '';
      }
    },
    resize() {
      const input = this.$refs.input;
      input.style.height = '5px';
      input.style.height = `${input.scrollHeight + 2}px`;
    },
    send(e) {
      if(this.message !== '') {
        post('http://chat/chatResult', JSON.stringify({
          message: this.message,
        }));
        this.oldMessages.unshift(this.message);
        if (this.oldMessages.length > this.maxOldMessages) {
          this.oldMessages.length = this.maxOldMessages;
        }
        this.oldMessagesIndex = -1;
        this.hideInput();
      } else {
        this.hideInput(true);
      }
    },
    hideInput(canceled = false) {
      if (canceled) {
        post('http://chat/chatResult', JSON.stringify({ canceled }));
      }
      this.message = '';
      this.showInput = false;
      clearInterval(this.focusTimer);
      this.resetShowWindowTimer();
    },
  },
};
