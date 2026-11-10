// Maximum messages per tab to prevent memory issues
const MAX_MESSAGES_PER_TAB = 50;

// Settings version - increment this to reset showInLive for all players
const SETTINGS_VERSION = 2;

// ===========================================
// CHAT CONFIGURATION
// ===========================================

// Tab Configuration - Define all tabs with permissions
const CHAT_TABS = {
  live:    { label: 'Live',    requiresPerm: null,            order: 1 },
  chat:    { label: 'System',  requiresPerm: null,            order: 2 },
  helper:  { label: 'Helper',  requiresPerm: 'canSeeHelper',  order: 3 },
  gang:    { label: 'Gang',    requiresPerm: 'hasGang',       order: 4 },
  job:     { label: 'Job',     requiresPerm: 'hasJob',        order: 5 },
  event:   { label: 'Event',   requiresPerm: null,            order: 6 },
  // admin:   { label: 'Admin',   requiresPerm: 'isAdmin',      order: 9 },
  staff:   { label: 'Staff',   requiresPerm: 'isAdmin',       order: 8 }
};

// Message Category Configuration - Define routing for message types
// If a type is not here, it will fallback to: tab with same name > 'live'
// group: Used for grouping in settings UI
const MESSAGE_CATEGORIES = {
  // Chat tab messages
  me:       { defaultTab: 'chat',    canShowInLive: true,  label: '/me',        group: 'System'  },
  ['do']:   { defaultTab: 'chat',    canShowInLive: true,  label: '/do',        group: 'System'  },
  ooc:      { defaultTab: 'chat',    canShowInLive: true,  label: '/ooc',       group: 'System'  },
  b:        { defaultTab: 'chat',    canShowInLive: true,  label: '/b',         group: 'System'  },
  s:        { defaultTab: 'chat',    canShowInLive: true,  label: '/s',         group: 'System'  },
  reports:  { defaultTab: 'chat',    canShowInLive: true,  label: 'reports',    group: 'System'  },
  alarms:   { defaultTab: 'chat',    canShowInLive: true,  label: 'A Alarms',   group: 'System'  },
  plarms:   { defaultTab: 'chat',    canShowInLive: true,  label: 'P Alarms',   group: 'System'  },

  // Gang tab messages
  g:        { defaultTab: 'gang',    canShowInLive: true,  label: '/g',         group: 'Gang'  },
  gang:     { defaultTab: 'gang',    canShowInLive: true,  label: 'Gang',       group: 'Gang'  },

  // Job tab messages
  f:        { defaultTab: 'job',     canShowInLive: true,  label: '/f',         group: 'Job'   },
  dep:      { defaultTab: 'job',     canShowInLive: true,  label: '/dep',       group: 'Job'   },
  job:      { defaultTab: 'job',     canShowInLive: true,  label: 'jobs',       group: 'Job'   },
  dispatch: { defaultTab: 'job',     canShowInLive: true,  label: 'Dispatch',   group: 'Job'   },

  // event messages
  event:    { defaultTab: 'event',   canShowInLive: true,  label: 'Event',      group: 'Event' },

  // Helper tab messages
  hc:       { defaultTab: 'helper',  canShowInLive: true,  label: 'Helper',     group: 'Helper'  },

  // Special - these go to their own tabs, no showInLive option needed
  // announce, event, admin, staff - will fallback to tab with same name
};

// Helper: Generate default showInLive settings from MESSAGE_CATEGORIES
function generateShowInLiveDefaults() {
  const defaults = {};
  for (const [key, config] of Object.entries(MESSAGE_CATEGORIES)) {
    if (config.canShowInLive) {
      defaults[key] = true;
    }
  }
  return defaults;
}

// Helper: Generate tabs data structure from CHAT_TABS
function generateTabsData() {
  const tabs = {};
  for (const key of Object.keys(CHAT_TABS)) {
    tabs[key] = { messages: [], unread: false };
  }
  return tabs;
}

window.APP = {
  template: '#app_template',
  name: 'app',
  data() {
    return {
      style: CONFIG.style,
      showInput: false,
      showWindow: false,
      suggestions: [],
      templates: CONFIG.templates,
      message: '',
      messages: [], // Keep for backward compatibility
      oldMessages: [],
      oldMessagesIndex: -1,
      // New tab system - Generated from CHAT_TABS config
      activeTab: 'live',
      tabs: generateTabsData(),
      // Player state for conditional tabs
      hasGang: false,
      hasJob: false,
      // Settings
      showSettings: false,
      settingsTab: 'chat',
      settings: {
        settingsVersion: SETTINGS_VERSION,
        showOnNewMessage: true,
        lockPosition: true,
        fontSize: 'medium',
        chatWidth: 40,
        chatHeight: 240,
        chatPosX: 1,
        chatPosY: 5,
        themeColor: '#65aeff',
        menuF5: { x: 2.5, y: 8 },
        menuF6: { x: 2.5, y: 8 },
        menus: {
          f5:        { useChatColor: true, color: '#3aa0ff' },
          f6:        { useChatColor: true, color: '#3aa0ff' },
          tattoo:    { useChatColor: true, color: '#16d6c1', usePrimaryChat: true, colorPrimary: '#FFB734' },
          barber:    { useChatColor: true, color: '#ff4d79' },
          documents: { useChatColor: true, color: '#8b1a1a', usePrimaryChat: true, colorPrimary: '#d4af37' },
          ghabz:     { useChatColor: true, color: '#4fd2ff' },
          jail:      { useChatColor: true, color: '#e0463b' },
          boss:      { useChatColor: true, color: '#ef4444', usePrimaryChat: true, colorPrimary: '#b91c1c' },
          skill:     { useChatColor: true, color: '#9cfcf8', usePrimaryChat: true, colorPrimary: '#0e7490' },
          skin:      { useChatColor: true, color: '#ef4444', usePrimaryChat: true, colorPrimary: '#b91c1c' }
        },
        showInLive: generateShowInLiveDefaults()
      },
      // Temp settings for editing (applied on button click)
      tempSettings: {
        settingsVersion: SETTINGS_VERSION,
        showOnNewMessage: true,
        lockPosition: true,
        fontSize: 'medium',
        chatWidth: 40,
        chatHeight: 240,
        chatPosX: 1,
        chatPosY: 5,
        themeColor: '#65aeff',
        menuF5: { x: 2.5, y: 8 },
        menuF6: { x: 2.5, y: 8 },
        menus: {
          f5:        { useChatColor: true, color: '#3aa0ff' },
          f6:        { useChatColor: true, color: '#3aa0ff' },
          tattoo:    { useChatColor: true, color: '#16d6c1', usePrimaryChat: true, colorPrimary: '#FFB734' },
          barber:    { useChatColor: true, color: '#ff4d79' },
          documents: { useChatColor: true, color: '#8b1a1a', usePrimaryChat: true, colorPrimary: '#d4af37' },
          ghabz:     { useChatColor: true, color: '#4fd2ff' },
          jail:      { useChatColor: true, color: '#e0463b' },
          boss:      { useChatColor: false, color: '#ef4444', usePrimaryChat: false, colorPrimary: '#b91c1c' },
          skill:     { useChatColor: false, color: '#9cfcf8', usePrimaryChat: false, colorPrimary: '#0e7490' },
          skin:      { useChatColor: false, color: '#ef4444', usePrimaryChat: false, colorPrimary: '#b91c1c' }
        },
        showInLive: generateShowInLiveDefaults()
      },
      // Default settings for reset
      defaultSettings: {
        settingsVersion: SETTINGS_VERSION,
        showOnNewMessage: true,
        lockPosition: true,
        fontSize: 'medium',
        chatWidth: 40,
        chatHeight: 240,
        chatPosX: 1,
        chatPosY: 5,
        themeColor: '#65aeff',
        menuF5: { x: 2.5, y: 8 },
        menuF6: { x: 2.5, y: 8 },
        menus: {
          f5:        { useChatColor: true, color: '#3aa0ff' },
          f6:        { useChatColor: true, color: '#3aa0ff' },
          tattoo:    { useChatColor: true, color: '#16d6c1', usePrimaryChat: true, colorPrimary: '#FFB734' },
          barber:    { useChatColor: true, color: '#ff4d79' },
          documents: { useChatColor: true, color: '#8b1a1a', usePrimaryChat: true, colorPrimary: '#d4af37' },
          ghabz:     { useChatColor: true, color: '#4fd2ff' },
          jail:      { useChatColor: true, color: '#e0463b' },
          boss:      { useChatColor: false, color: '#ef4444', usePrimaryChat: false, colorPrimary: '#b91c1c' },
          skill:     { useChatColor: false, color: '#9cfcf8', usePrimaryChat: false, colorPrimary: '#0e7490' },
          skin:      { useChatColor: false, color: '#ef4444', usePrimaryChat: false, colorPrimary: '#b91c1c' }
        },
        showInLive: generateShowInLiveDefaults()
      },
      isAdmin: false,
      isHelper: false,
      // Drag state
      isDragging: false,
      isDraggingSettings: false,
      isDraggingGhost: null,
      ghostOffset: { x: 0, y: 0 },
      dragOffset: { x: 0, y: 0 },
      settingsPosX: null,
      settingsPosY: null,
      // Staff sound
      staffSound: null
    };
  },
  computed: {
    currentTabMessages() {
      return this.tabs[this.activeTab].messages;
    },
    // Generate visible tabs from CHAT_TABS config based on permissions
    visibleTabs() {
      const tabs = [];
      for (const [key, config] of Object.entries(CHAT_TABS)) {
        // Check permission
        let hasPermission = true;
        if (config.requiresPerm) {
          hasPermission = this[config.requiresPerm] === true;
        }
        // Special case for staff tab - show if has messages even without admin
        if (key === 'staff' && !hasPermission && this.tabs.staff.messages.length > 0) {
          hasPermission = true;
        }
        if (hasPermission) {
          tabs.push({
            key: key,
            label: config.label,
            order: config.order,
            unread: this.tabs[key] ? this.tabs[key].unread : false
          });
        }
      }
      // Sort by order
      return tabs.sort((a, b) => a.order - b.order);
    },
    // Generate showInLive options from MESSAGE_CATEGORIES config (flat list - legacy)
    showInLiveOptions() {
      const options = [];
      for (const [key, config] of Object.entries(MESSAGE_CATEGORIES)) {
        if (config.canShowInLive) {
          options.push({
            key: key,
            label: config.label
          });
        }
      }
      return options;
    },
    // Generate grouped showInLive options for better UI organization
    showInLiveGrouped() {
      const groups = {};
      for (const [key, config] of Object.entries(MESSAGE_CATEGORIES)) {
        if (config.canShowInLive) {
          // Check permission based on defaultTab
          const tabConfig = CHAT_TABS[config.defaultTab];
          if (tabConfig && tabConfig.requiresPerm) {
            if (this[tabConfig.requiresPerm] !== true) {
              continue; // Skip if user doesn't have permission
            }
          }

          const groupName = config.group || 'Other';
          if (!groups[groupName]) {
            groups[groupName] = {
              name: groupName,
              items: []
            };
          }
          groups[groupName].items.push({
            key: key,
            label: config.label
          });
        }
      }
      // Convert to sorted array
      return Object.values(groups).sort((a, b) => {
        // Chat first, then alphabetical
        if (a.name === 'Chat') return -1;
        if (b.name === 'Chat') return 1;
        return a.name.localeCompare(b.name);
      });
    },
    computedAppStyle() {
      return {
        width: this.settings.chatWidth + '%',
        left: this.settings.chatPosX + '%',
        top: this.settings.chatPosY + '%'
      };
    },
    computedChatStyle() {
      return {
        height: this.settings.chatHeight + 'px'
      };
    },
    computedSettingsStyle() {
      if (this.settingsPosX !== null && this.settingsPosY !== null) {
        return {
          left: this.settingsPosX + 'px',
          top: this.settingsPosY + 'px',
          transform: 'none'
        };
      }
      return {};
    },
    hasUnsavedChanges() {
      return JSON.stringify(this.tempSettings) !== JSON.stringify(this.settings);
    },
    canSeeHelper() {
      return this.isHelper || this.isAdmin;
    },
    themeStyle() {
      const hex = this.settings.themeColor || '#65aeff';
      const r = parseInt(hex.slice(1, 3), 16);
      const g = parseInt(hex.slice(3, 5), 16);
      const b = parseInt(hex.slice(5, 7), 16);
      return {
        '--theme-color': hex,
        '--theme-rgb': `${r}, ${g}, ${b}`
      };
    },
    menuDefs() {
      return [
        { key: 'f5', label: 'Menu Gang (F5)', pos: true },
        { key: 'f6', label: 'Menu Job (F6)', pos: true },
        { key: 'tattoo', label: 'Tattoo Shop', pos: false, dual: true },
        { key: 'barber', label: 'Barber Shop', pos: false },
        { key: 'documents', label: 'DOJ Documents (F9)', pos: false, dual: true },
        { key: 'ghabz', label: 'Ghabz (Sun Billing)', pos: false },
        { key: 'jail', label: 'Jail (Sun Jail)', pos: false },
        { key: 'boss', label: 'Boss Action', pos: false, dual: true },
        { key: 'skill', label: 'Skill Menu (I)', pos: false, dual: true },
        { key: 'skin', label: 'Skin Menu (/skin)', pos: false, dual: true }
      ];
    }
  },
  destroyed() {
    clearInterval(this.focusTimer);
    window.removeEventListener('message', this.listener);
  },
  mounted() {
    this.loadSettings();
    this.pushMenuSettings();
    post('http://chat/loaded', JSON.stringify({}));
    this.listener = window.addEventListener('message', (event) => {
      const item = event.data || event.detail; //'detail' is for debuging via browsers
      if (this[item.type]) {
        this[item.type](item);
      }
    });
  },
  watch: {
    // Watch all tab messages for show on new message feature
    'tabs.live.messages': function() { this.onNewMessage('live'); },
    'tabs.chat.messages': function() { this.onNewMessage('chat'); },
    'tabs.gang.messages': function() { this.onNewMessage('gang'); },
    'tabs.job.messages': function() { this.onNewMessage('job'); },
    'tabs.event.messages': function() { this.onNewMessage('event'); },
    'tabs.admin.messages': function() { this.onNewMessage('admin'); },
    'tabs.staff.messages': function() { this.onNewMessage('staff'); },
    'tabs.helper.messages': function() { this.onNewMessage('helper'); },
    currentTabMessages() {
      const messagesObj = this.$refs.messages;
      this.$nextTick(() => {
        if (messagesObj) {
          messagesObj.scrollTop = messagesObj.scrollHeight;
        }
      });
    },
  },
  methods: {
    // Handle new message in any tab
    onNewMessage(tabName) {
      // Show window on new message if setting is enabled
      if (this.settings.showOnNewMessage) {
        if (this.showWindowTimer) {
          clearTimeout(this.showWindowTimer);
        }
        this.showWindow = true;
        this.resetShowWindowTimer();
      }
    },

    // Tab Methods
    switchTab(tabName) {
      this.activeTab = tabName;
      this.tabs[tabName].unread = false;
      this.showSettings = false;

      // Scroll to bottom when switching tabs
      this.$nextTick(() => {
        const messagesObj = this.$refs.messages;
        if (messagesObj) {
          messagesObj.scrollTop = messagesObj.scrollHeight;
        }
      });
    },

    // Settings Methods
    toggleSettings() {
      this.showSettings = !this.showSettings;
      if (this.showSettings) {
        // Copy current settings to temp when opening
        this.tempSettings = JSON.parse(JSON.stringify(this.settings));
        // Reset settings panel position
        this.settingsPosX = null;
        this.settingsPosY = null;
        this.settingsTab = 'chat';
      }
    },

    resetSettings() {
      this.tempSettings.chatPosX = this.defaultSettings.chatPosX;
      this.tempSettings.chatPosY = this.defaultSettings.chatPosY;
      this.tempSettings.themeColor = this.defaultSettings.themeColor;
      this.tempSettings.menuF5 = { x: this.defaultSettings.menuF5.x, y: this.defaultSettings.menuF5.y };
      this.tempSettings.menuF6 = { x: this.defaultSettings.menuF6.x, y: this.defaultSettings.menuF6.y };
      this.tempSettings.menus = JSON.parse(JSON.stringify(this.defaultSettings.menus));
    },

    // Drag Methods for Chat Position
    startDragChat(e) {
      if (e.target.closest('.chat-input') || e.target.closest('textarea')) return;
      // Check if position is locked
      if (this.settings.lockPosition) return;
      this.isDragging = true;
      const rect = this.$el.getBoundingClientRect();
      this.dragOffset.x = e.clientX - rect.left;
      this.dragOffset.y = e.clientY - rect.top;
      document.addEventListener('mousemove', this.onDragChat);
      document.addEventListener('mouseup', this.stopDragChat);
    },

    onDragChat(e) {
      if (!this.isDragging) return;
      const newX = ((e.clientX - this.dragOffset.x) / window.innerWidth) * 100;
      const newY = ((e.clientY - this.dragOffset.y) / window.innerHeight) * 100;
      this.tempSettings.chatPosX = Math.max(0, Math.min(90, newX));
      this.tempSettings.chatPosY = Math.max(0, Math.min(90, newY));
      // Live preview
      this.settings.chatPosX = this.tempSettings.chatPosX;
      this.settings.chatPosY = this.tempSettings.chatPosY;
    },

    stopDragChat() {
      if (this.isDragging) {
        this.isDragging = false;
        this.saveSettings();
      }
      document.removeEventListener('mousemove', this.onDragChat);
      document.removeEventListener('mouseup', this.stopDragChat);
    },

    // Drag Methods for Settings Panel
    startDragSettings(e) {
      this.isDraggingSettings = true;
      const panel = this.$el.querySelector('.settings-panel');
      const rect = panel.getBoundingClientRect();
      this.dragOffset.x = e.clientX - rect.left;
      this.dragOffset.y = e.clientY - rect.top;
      document.addEventListener('mousemove', this.onDragSettings);
      document.addEventListener('mouseup', this.stopDragSettings);
    },

    onDragSettings(e) {
      if (!this.isDraggingSettings) return;
      this.settingsPosX = Math.max(0, e.clientX - this.dragOffset.x);
      this.settingsPosY = Math.max(0, e.clientY - this.dragOffset.y);
    },

    stopDragSettings() {
      this.isDraggingSettings = false;
      document.removeEventListener('mousemove', this.onDragSettings);
      document.removeEventListener('mouseup', this.stopDragSettings);
    },

    // Per-menu accent + F5/F6 ghost relocate
    menuAccent(key) {
      const m = this.tempSettings.menus && this.tempSettings.menus[key];
      if (!m) return this.tempSettings.themeColor;
      return m.useChatColor ? this.tempSettings.themeColor : m.color;
    },

    accentRgba(key, alpha) {
      let hex = (this.menuAccent(key) || '#3aa0ff').replace('#', '');
      if (hex.length === 3) hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
      const n = parseInt(hex, 16);
      return 'rgba(' + ((n >> 16) & 255) + ',' + ((n >> 8) & 255) + ',' + (n & 255) + ',' + alpha + ')';
    },

    ghostDisplayPos(which) {
      const a = this.tempSettings.menuF5, b = this.tempSettings.menuF6;
      if (a.x === b.x && a.y === b.y && which === 'f6') {
        return { x: b.x, y: Math.min(86, b.y + 32) };
      }
      return which === 'f5' ? a : b;
    },

    ghostStyle(which) {
      const p = this.ghostDisplayPos(which);
      return {
        left: p.x + '%',
        top: p.y + '%',
        borderColor: this.accentRgba(which, 0.55),
        boxShadow: '0 16px 40px rgba(0,0,0,0.5), 0 0 22px ' + this.accentRgba(which, 0.28)
      };
    },

    startDragGhost(e, which) {
      e.preventDefault();
      e.stopPropagation();
      this.isDraggingGhost = which;
      const rect = e.currentTarget.getBoundingClientRect();
      this.ghostOffset.x = e.clientX - rect.left;
      this.ghostOffset.y = e.clientY - rect.top;
      document.addEventListener('mousemove', this.onDragGhost);
      document.addEventListener('mouseup', this.stopDragGhost);
    },

    onDragGhost(e) {
      if (!this.isDraggingGhost) return;
      let x = ((e.clientX - this.ghostOffset.x) / window.innerWidth) * 100;
      let y = ((e.clientY - this.ghostOffset.y) / window.innerHeight) * 100;
      x = Math.max(0, Math.min(92, Math.round(x * 10) / 10));
      y = Math.max(0, Math.min(92, Math.round(y * 10) / 10));
      const key = this.isDraggingGhost === 'f5' ? 'menuF5' : 'menuF6';
      this.tempSettings[key] = { x: x, y: y };
    },

    stopDragGhost() {
      this.isDraggingGhost = null;
      document.removeEventListener('mousemove', this.onDragGhost);
      document.removeEventListener('mouseup', this.stopDragGhost);
    },

    applySettings() {
      // Apply temp settings to actual settings
      this.settings = JSON.parse(JSON.stringify(this.tempSettings));
      this.saveSettings();
      this.pushMenuSettings();
      this.showSettings = false;
    },

    saveSettings() {
      try {
        localStorage.setItem('chatSettings', JSON.stringify(this.settings));
      } catch (e) {
        console.warn('Could not save chat settings:', e);
      }
    },

    pushMenuSettings() {
      const s = this.settings;
      const rc = (key) => {
        const m = s.menus && s.menus[key];
        if (!m) return s.themeColor;
        return m.useChatColor ? s.themeColor : m.color;
      };
      const rcp = (key) => {
        const m = s.menus && s.menus[key];
        if (!m) return s.themeColor;
        return m.usePrimaryChat ? s.themeColor : (m.colorPrimary || m.color);
      };
      post('http://chat/saveMenuSettings', JSON.stringify({
        default: s.themeColor,
        f5: { color: rc('f5'), x: s.menuF5.x, y: s.menuF5.y },
        f6: { color: rc('f6'), x: s.menuF6.x, y: s.menuF6.y },
        tattoo: { color: rc('tattoo'), colorPrimary: rcp('tattoo') },
        barber: { color: rc('barber') },
        documents: { color: rc('documents'), colorPrimary: rcp('documents') },
        ghabz: { color: rc('ghabz') },
        jail: { color: rc('jail') },
        boss: { color: rc('boss'), colorPrimary: rcp('boss') },
        skill: { color: rc('skill'), colorPrimary: rcp('skill') },
        skin: { color: rc('skin'), colorPrimary: rcp('skin') }
      }));
    },

    RESYNC_MENU() {
      this.pushMenuSettings();
    },

    mergeMenus(parsedMenus) {
      const def = this.defaultSettings.menus;
      const out = {};
      for (const k in def) {
        const d = def[k];
        const p = (parsedMenus && parsedMenus[k]) || {};
        out[k] = {};
        for (const f in d) {
          out[k][f] = p[f] !== undefined ? p[f] : d[f];
        }
      }
      return out;
    },

    loadSettings() {
      try {
        const saved = localStorage.getItem('chatSettings');
        if (saved) {
          const parsed = JSON.parse(saved);
          const savedVersion = parsed.settingsVersion || 1;

          if (savedVersion < SETTINGS_VERSION) {
            this.settings = {
              ...this.settings,
              ...parsed,
              settingsVersion: SETTINGS_VERSION,
              menus: this.mergeMenus(parsed.menus),
              showInLive: generateShowInLiveDefaults()
            };
            this.saveSettings();
            console.log('Chat settings migrated to version', SETTINGS_VERSION);
          } else {
            this.settings = {
              ...this.settings,
              ...parsed,
              menus: this.mergeMenus(parsed.menus),
              showInLive: {
                ...this.settings.showInLive,
                ...(parsed.showInLive || {})
              }
            };
          }
          this.tempSettings = JSON.parse(JSON.stringify(this.settings));
        }
      } catch (e) {
        console.warn('Could not load chat settings:', e);
      }
    },

    // Existing Methods
    On_Tab(){
      for (const [key, value] of Object.entries(this.suggestions)) {
        const suc = JSON.stringify(value.name);
         if(suc.match(this.message)){
           this.message = suc.substring( 1, suc.length - 1 ) + " ";
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

    FORCE_CLOSE_CHAT() {
      this.message = '';
      this.showInput = false;
      this.showSettings = false;
      this.showWindow = false;
      clearInterval(this.focusTimer);
      clearTimeout(this.showWindowTimer);
    },

    // Open settings panel via /chatsetting command
    OPEN_SETTINGS() {
      this.showWindow = true;
      this.showSettings = true;
      this.tempSettings = JSON.parse(JSON.stringify(this.settings));
      this.settingsPosX = null;
      this.settingsPosY = null;
      this.settingsTab = 'chat';
    },

    ON_MESSAGE({ message }) {
      const msgType = message.type || null;
      let targetTab = 'live'; // default

      // Determine target tab using fallback logic:
      // 1. Check MESSAGE_CATEGORIES config
      // 2. If not found, check if tab with same name exists
      // 3. If nothing matches, go to 'live'
      if (message.category && this.tabs[message.category]) {
        // Category already set (from cl_chat.lua) - use it
        targetTab = message.category;
      } else if (msgType) {
        const categoryConfig = MESSAGE_CATEGORIES[msgType];
        if (categoryConfig && categoryConfig.defaultTab && this.tabs[categoryConfig.defaultTab]) {
          // Found in MESSAGE_CATEGORIES config
          targetTab = categoryConfig.defaultTab;
        } else if (CHAT_TABS[msgType]) {
          // Fallback: tab with same name as type exists
          targetTab = msgType;
        }
      }

      // Add to designated tab
      if (this.tabs[targetTab]) {
        this.tabs[targetTab].messages.push(message);
        if (this.tabs[targetTab].messages.length > MAX_MESSAGES_PER_TAB) {
          this.tabs[targetTab].messages.shift();
        }
      }

      // Also add to Live if user enabled in settings (showInLive)
      const categoryConfig = msgType ? MESSAGE_CATEGORIES[msgType] : null;
      const canShowInLive = categoryConfig && categoryConfig.canShowInLive;
      if (targetTab !== 'live' && canShowInLive && this.settings.showInLive[msgType]) {
        this.tabs.live.messages.push(message);
        if (this.tabs.live.messages.length > MAX_MESSAGES_PER_TAB) {
          this.tabs.live.messages.shift();
        }
        // Set Live unread if not currently viewing Live
        if (this.activeTab !== 'live') {
          this.tabs.live.unread = true;
        }
      }

      // Set unread badge if not viewing that tab
      if (this.activeTab !== targetTab && this.tabs[targetTab]) {
        this.tabs[targetTab].unread = true;
      }

      // Keep backward compatibility - add to main messages array too
      this.messages.push(message);
      if (this.messages.length > MAX_MESSAGES_PER_TAB) {
        this.messages.shift();
      }
    },

    ON_CLEAR() {
      // Clear all tabs - Dynamic from CHAT_TABS config
      for (const key of Object.keys(CHAT_TABS)) {
        if (this.tabs[key]) {
          this.tabs[key].messages = [];
          this.tabs[key].unread = false;
        }
      }

      // Clear backward compat
      this.messages = [];
      this.oldMessages = [];
      this.oldMessagesIndex = -1;
    },

    ON_SUGGESTION_ADD({ suggestion }) {
      if (!suggestion.params) {
        suggestion.params = [];
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

    // Set admin status
    SET_ADMIN({ isAdmin }) {
      this.isAdmin = isAdmin;
    },

    // Set helper status
    SET_HELPER({ isHelper }) {
      this.isHelper = isHelper;
      if (!this.canSeeHelper && this.activeTab === 'helper') {
        this.switchTab('live');
      }
    },

    // Set gang status
    SET_GANG_STATUS({ hasGang }) {
      this.hasGang = hasGang;
      // If player loses gang and is on gang tab, switch to live
      if (!hasGang && this.activeTab === 'gang') {
        this.switchTab('live');
      }
    },

    // Set job status
    SET_JOB_STATUS({ hasJob }) {
      this.hasJob = hasJob;
      // If player loses job and is on job tab, switch to live
      if (!hasJob && this.activeTab === 'job') {
        this.switchTab('live');
      }
    },

    // Staff PM - Route /ww and /pm messages to Staff tab
    SHOW_ADMIN_PM({ from, message }) {
      // Create a message for the staff tab
      const staffMessage = {
        color: [255, 215, 0], // Gold color
        multiline: true,
        args: ['^3' + from, '^0' + message],
        category: 'staff',
        type: 'staff'
      };

      // Add to staff tab
      this.tabs.staff.messages.push(staffMessage);
      if (this.tabs.staff.messages.length > MAX_MESSAGES_PER_TAB) {
        this.tabs.staff.messages.shift();
      }

      // Set unread if not viewing staff tab
      if (this.activeTab !== 'staff') {
        this.tabs.staff.unread = true;
      }

      // Show chat window and switch to staff tab
      this.showWindow = true;
      this.switchTab('staff');
      this.resetShowWindowTimer();

      // Play notification sound
      this.playStaffSound();
    },

    playStaffSound() {
      try {
        if (!this.staffSound) {
          this.staffSound = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdH2Onrq+vLGqrrXCxL65tbK0usHHyMXAvry8wMXJycfDwL28vsHFx8fFwb27u77Bw8TDwL26uLm7vb/AwL67ubW0tba4uru6uba0s7O0tba3t7a0sbCvsLGys7OysK6trKytra6urq2sq6qpqaqrq6uqqqmop6eoqKioqKempaSlpaWlpaWkpKOjo6OioqKioaGhoaCgoJ+fn5+enp6dnZ2dnJycnJubm5qampmZmZmYmJiXl5eXlpaWlZWVlJSUlJOTk5OSkpKRkZGRkJCQj4+Pj46Ojo6NjY2MjIyMi4uLioqKioqJiYmIiIiIh4eHh4aGhoaFhYWEhISEg4ODg4KCgoKBgYGBgICAgH9/f39+fn5+fX19fXx8fHx7e3t7enp6enl5eXl4eHh4d3d3d3Z2dnZ1dXV1dHR0dHNzc3NycnJycXFxcXBwcHBvb29vbm5ubm1tbW1sbGxsa2tra2pqamppaWlpaGhoaGdnZ2dmZmZmZWVlZWRkZGRjY2NjYmJiYmFhYWFgYGBgX19fX15eXl5dXV1dXFxcXFtbW1taWlpaWVlZWVhYWFhXV1dXVlZWVlVVVVVUVFRUU1NTU1JSUlJRUVFRUFBQUE9PT09OTk5OTU1NTUxMTExLS0tLSkpKSklJSUlISEhIR0dHR0ZGRkZFRUVFREREREREQ0NDQ0JCQkJBQUFBQEBAQD8/Pz8+Pj4+PT09PTw8PDw7Ozs7Ojo6Ojk5OTk4ODg4Nzc3NzY2NjY1NTU1NDQ0NDMzMzMyMjIyMTExMTAwMDAvLy8vLi4uLi0tLS0sLCwsKysrKyoqKiooKCgoKSkpKSoqKiorKysrLCwsLC0tLS0uLi4uLy8vLzAwMDAxMTExMjIyMjMzMzM0NDQ0NTU1NTY2NjY3Nzc3ODg4ODk5OTk6Ojo6Ozs7Ozw8PDw9PT09Pj4+Pj8/Pz9AQEBAQUFBQUJCQ0NEREREREVFRkZGR0dHR0hISEhJSUlJSkpKSktLS0tMTExMTU1NTU5OTk5PT09PUFBQUFFRUVRUVFRVVVVVV1dXV1hYWFhaWlpaW1tbW1xcXFxdXV1dXl5eXl9fX19gYGBgYWFhYWJiYmJjY2NjZGRkZGVlZWVmZmZmZ2dnZ2hoaGhpaWlpampqamtra2tsbGxsbW1tbW5ubm5vb29vcHBwcHFxcXFycnJyc3Nzc3R0dHR1dXV1dnZ2dnd3d3d4eHh4eXl5eXp6enp7e3t7fHx8fH19fX1+fn5+f39/f4CAgICBgYGBgoKCgoODg4OEhISEhYWFhYaGhoaHh4eHiIiIiImJiYmKioqKi4uLi4yMjIyNjY2Njo6Ojo+Pj4+QkJCQkZGRkZKSkpKTk5OTlJSUlJWVlZWWlpaWl5eXl5iYmJiZmZmZmpqamptbm5ucnJycnZ2dnZ6enp6fn5+foKCgoKGhoaGioqKio6Ojo6SkpKSlpaWlpqampqenp6eoqKioqampqaqqqqurq6urrKysrK2tra2urq6ur6+vr7CwsLCxsbGxsrKysrOzs7O0tLS0tbW1tba2tra3t7e3uLi4uLm5ubm6urq6u7u7u7y8vLy9vb29vr6+vr+/v7/AwMDAwcHBwcLCwsLDw8PDxMTExMXFxcXGxsbGx8fHx8jIyMjJycnJysrKysvLy8vMzMzMzc3Nzc7Ozs7Pz8/P0NDQ0A==');
        }
        this.staffSound.currentTime = 0;
        this.staffSound.volume = 0.5;
        this.staffSound.play().catch(() => {});
      } catch (e) {
        console.warn('Could not play staff sound:', e);
      }
    },

    warn(msg) {
      this.tabs.live.messages.push({
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
          this.showSettings = false; // Also hide settings when chat fades
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
          message: stripEmojis(this.message),
        }));
        this.oldMessages.unshift(this.message);
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
      this.showSettings = false; // Hide settings when closing chat
      clearInterval(this.focusTimer);
      this.resetShowWindowTimer();
    },
  },
};

const stripEmojis = (str) =>
  str
    .replace(
      /([\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF])/g,
      ''
    )
    .replace(/\s+/g, ' ')
    .trim();
