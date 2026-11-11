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

// ========================================
// Report Panel (Admin) - Vanilla JS
// ========================================
;(function() {
  var rpReports = {};
  var rpSortMode = "time";
  var rpEyeSVG = '<svg viewBox="0 0 24 24"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>';
  var rpPhoneSVG = '<svg viewBox="0 0 24 24"><path d="M6.62 10.79a15.05 15.05 0 0 0 6.59 6.59l2.2-2.2a1 1 0 0 1 1.01-.24c1.12.37 2.33.57 3.57.57a1 1 0 0 1 1 1V20a1 1 0 0 1-1 1A17 17 0 0 1 3 4a1 1 0 0 1 1-1h3.5a1 1 0 0 1 1 1c0 1.25.2 2.45.57 3.57a1 1 0 0 1-.25 1.02l-2.2 2.2z"/></svg>';
  var rpAcceptTimers = {};
  var rpSpectateState = {};
  var rpClosedReports = [];
  var rpActiveTab = "active";

  function rpEscape(str) {
    if (!str) return "";
    var div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }

  function rpTimeAgo(timestamp) {
    if (!timestamp) return "";
    var now = Math.floor(Date.now() / 1000);
    var diff = now - timestamp;
    if (diff < 0) diff = 0;
    if (diff < 60) return diff + "s";
    if (diff < 3600) return Math.floor(diff / 60) + "m";
    if (diff < 86400) return Math.floor(diff / 3600) + "h";
    return Math.floor(diff / 86400) + "d";
  }

  window.addEventListener('sund:rerender-rp', function() {
    rpRender();
  });

  function rpGetSorted() {
    var arr = [];
    var hidden = window.__sundHiddenIds || {};
    for (var id in rpReports) {
      if (rpReports.hasOwnProperty(id)) {
        if (hidden[id]) continue;
        arr.push({ id: id, report: rpReports[id] });
      }
    }
    if (rpSortMode === "time") {
      arr.sort(function(a, b) {
        var pa = a.report.status === "pending" ? 1 : 0;
        var pb = b.report.status === "pending" ? 1 : 0;
        if (pa !== pb) return pa - pb;
        return (a.report.time || 0) - (b.report.time || 0);
      });
    } else if (rpSortMode === "category") {
      arr.sort(function(a, b) {
        var pa = a.report.status === "pending" ? 1 : 0;
        var pb = b.report.status === "pending" ? 1 : 0;
        if (pa !== pb) return pa - pb;
        var catA = (a.report.cat || a.report.message || "").toLowerCase();
        var catB = (b.report.cat || b.report.message || "").toLowerCase();
        if (catA < catB) return -1;
        if (catA > catB) return 1;
        return (a.report.time || 0) - (b.report.time || 0);
      });
    }
    return arr;
  }

  function rpUpdateTabCounts(activeCount, historyCount) {
    var activeEl = document.getElementById('rpActiveCount');
    var historyEl = document.getElementById('rpHistoryCount');
    if (activeCount !== null && activeCount !== undefined && activeEl) {
      activeEl.textContent = activeCount > 0 ? activeCount : "";
    }
    if (historyCount !== null && historyCount !== undefined && historyEl) {
      historyEl.textContent = historyCount > 0 ? historyCount : "";
    }
  }

  function rpRender() {
    var panel = document.getElementById('reportPanel');
    if (!panel) return;
    var list = panel.querySelector('.rp-list');
    if (!list) return;
    if (window.__sundActiveTab) return;
    list.innerHTML = '';

    var activeCount = 0;
    for (var _k in rpReports) { if (rpReports.hasOwnProperty(_k)) activeCount++; }
    rpUpdateTabCounts(activeCount, rpClosedReports.length);

    var sortMenu = panel.querySelector('.rp-sort-menu');

    if (rpActiveTab === "history") {
      if (sortMenu) sortMenu.classList.remove('visible');
      rpRenderHistory(list, panel);
      return;
    }

    var sorted = rpGetSorted();
    var count = sorted.length;

    for (var i = 0; i < sorted.length; i++) {
      var id = sorted[i].id;
      var report = sorted[i].report;
      var statusClass = report.status === "open" ? "open" : "pending";
      var typeName = "";
      if (report.cat) {
        typeName = rpEscape(report.cat);
      } else if (report.type === 0) {
        typeName = "Soal";
      } else {
        typeName = rpEscape(report.message || "Report");
      }
      var hasMore = (report.cat === "More" || report.cat === "more" || (report.message && report.message.length > 0));
      var moreClass = hasMore ? "visible" : "";
      var timeStr = rpTimeAgo(report.time);
      var moreTooltip = hasMore ? rpEscape(report.message || "") : "";
      var respondName = (report.status === "pending" && report.respond && report.respond.name && report.respond.name !== "none") ? rpEscape(report.respond.name) : "";

      var mineMap = window.__sundMineIds || {};
      var isMine  = !!mineMap[String(id)];


      var origId   = String(id);
      var curId    = String(report.owner && report.owner.id != null ? report.owner.id : id);
      var idTooltip = (origId !== curId);
      var typeTooltip =  'Report ID: ' + origId;

      var div = document.createElement('div');
      div.className = 'rp-item' + (isMine ? ' rp-mine' : '');
      div.setAttribute('data-id', rpEscape(id));
      div.setAttribute('data-owner-id', report.owner.id);
      div.innerHTML =
        '<div class="rp-spectate-btn" data-id="' + report.owner.id + '">' + rpEyeSVG + '</div>' +
        '<div class="rp-status-icon ' + statusClass + '"' + (respondName ? ' data-tooltip="' + respondName + '"' : '') + '></div>' +
        '<span class="rp-player-id" data-tooltip="' + rpEscape(report.owner.name || '') + ' | Level ' + (report.owner.level || 0) + '">ID ' + report.owner.id + '</span>' +
        // Always attach tooltip to the report type (reason) showing the report id (and orig/new id info if present)
        '<span class="rp-report-type" data-tooltip="' + rpEscape(typeTooltip) + '">' + typeName + '</span>' +
        '<div class="rp-more-indicator ' + moreClass + '"' + (moreTooltip ? ' data-tooltip="' + moreTooltip + '"' : '') + '></div>' +
        '<span class="rp-time">' + timeStr + '</span>';
      list.appendChild(div);

      var state = rpSpectateState[report.owner.id];
      if (state) {
        var spBtn = div.querySelector('.rp-spectate-btn');
        if (spBtn) {
          if (state === 'accept-ready') {
            spBtn.classList.add('active', 'accept-ready');
            spBtn.innerHTML = rpPhoneSVG;
          } else if (state === 'active') {
            spBtn.classList.add('active');
          }
        }
      }
    }

    if (count === 0) {
      var empty = document.createElement('div');
      empty.className = 'rp-empty';
      empty.textContent = 'Reporti Nist';
      list.appendChild(empty);
    }
  }

  var rpActionColors = {
    "accepted": "#4caf50",
    "rejected": "#f44336",
    "cancelled": "#9e9e9e",
    "auto-closed": "#f44336"
  };

  var rpActionLabels = {
    "accepted": "Accept",
    "rejected": "Reject",
    "cancelled": "Cancel",
    "auto-closed": "Auto"
  };

  function rpRenderHistory(list, panel) {
    var arr = rpClosedReports.slice();
    if (rpSortMode === "category") {
      arr.sort(function(a, b) {
        var aa = a.action === "auto-closed" ? 0 : 1;
        var ba = b.action === "auto-closed" ? 0 : 1;
        if (aa !== ba) return aa - ba;
        var catA = (a.cat || a.message || "").toLowerCase();
        var catB = (b.cat || b.message || "").toLowerCase();
        if (catA < catB) return -1;
        if (catA > catB) return 1;
        return (b.closedAt || 0) - (a.closedAt || 0);
      });
    } else {
      arr.sort(function(a, b) {
        var aa = a.action === "auto-closed" ? 0 : 1;
        var ba = b.action === "auto-closed" ? 0 : 1;
        if (aa !== ba) return aa - ba;
        return (b.closedAt || 0) - (a.closedAt || 0);
      });
    }

    for (var i = 0; i < arr.length; i++) {
      var r = arr[i];
      var color = rpActionColors[r.action] || "#9e9e9e";
      var label = rpActionLabels[r.action] || r.action;
      var typeName = "";
      if (r.cat) {
        typeName = rpEscape(r.cat);
      } else if (r.type === 0) {
        typeName = "Soal";
      } else {
        typeName = rpEscape(r.message || "Report");
      }
      var closedByName = (r.closedBy && r.closedBy.name) ? rpEscape(r.closedBy.name) : "?";
      var timeStr = rpTimeAgo(r.time);
      var closedStr = rpTimeAgo(r.closedAt);

      var div = document.createElement('div');
      div.className = 'rp-item rp-history-item';
      div.setAttribute('data-report-id', String((r.owner && r.owner.id) || ''));
      div.setAttribute('data-report-time', String(r.time || 0));
      div.innerHTML =
        '<div class="rp-history-action" style="background:' + color + ';" data-tooltip="' + label + '"></div>' +
        '<span class="rp-player-id" data-tooltip="' + rpEscape((r.owner && r.owner.name) || '') + ' | Level ' + ((r.owner && r.owner.level) || 0) + '">ID ' + ((r.owner && r.owner.id) || '?') + '</span>' +
        '<span class="rp-report-type">' + typeName + '</span>' +
        '<span class="rp-closed-by" data-tooltip="' + closedByName + '">' + closedByName + '</span>' +
        '<span class="rp-time" data-tooltip="Close: ' + closedStr + '">' + timeStr + '</span>';
      list.appendChild(div);
    }

    if (arr.length === 0) {
      var empty = document.createElement('div');
      empty.className = 'rp-empty';
      empty.textContent = 'History Nist';
      list.appendChild(empty);
    }
  }

  function rpLoadPosition(panel) {
    try {
      var saved = localStorage.getItem('rp_panel_pos');
      if (saved) {
        var pos = JSON.parse(saved);
        panel.style.left = pos.x + 'px';
        panel.style.top = pos.y + 'px';
        panel.style.right = 'auto';
        rpClamp(panel);
      }
    } catch(ex) {}
  }

  function rpSavePosition(panel) {
    try {
      localStorage.setItem('rp_panel_pos', JSON.stringify({
        x: parseInt(panel.style.left) || 0,
        y: parseInt(panel.style.top) || 0
      }));
    } catch(ex) {}
  }

  function rpClamp(panel) {
    var rect = panel.getBoundingClientRect();
    var maxX = window.innerWidth - rect.width;
    var maxY = window.innerHeight - rect.height;
    var x = parseInt(panel.style.left) || 0;
    var y = parseInt(panel.style.top) || 0;
    x = Math.max(0, Math.min(x, maxX));
    y = Math.max(0, Math.min(y, maxY));
    panel.style.left = x + 'px';
    panel.style.top = y + 'px';
    panel.style.right = 'auto';
  }

  var panel = document.getElementById('reportPanel');
  if (panel) rpLoadPosition(panel);

  var rpSizeLevel = 1;
  function rpLoadSize() {
    try {
      var saved = localStorage.getItem('rp_panel_size');
      if (saved) rpSizeLevel = parseInt(saved) || 1;
      if (rpSizeLevel < 1 || rpSizeLevel > 4) rpSizeLevel = 1;
    } catch(ex) {}
    rpApplySize();
  }
  function rpApplySize() {
    if (!panel) return;
    panel.classList.remove('rp-size-2', 'rp-size-3', 'rp-size-4');
    if (rpSizeLevel > 1) panel.classList.add('rp-size-' + rpSizeLevel);
  }
  if (panel) rpLoadSize();

  document.addEventListener('click', function(e) {
    if (!e.target.closest('.rp-size-btn')) return;
    e.stopPropagation();
    rpSizeLevel = rpSizeLevel >= 4 ? 1 : rpSizeLevel + 1;
    rpApplySize();
    try { localStorage.setItem('rp_panel_size', String(rpSizeLevel)); } catch(ex) {}
    rpClamp(panel);
  });

  var rpLocked = false;
  function rpLoadLock() {
    try {
      var saved = localStorage.getItem('rp_panel_locked');
      if (saved === '1') rpLocked = true;
    } catch(ex) {}
    rpApplyLock();
  }
  function rpApplyLock() {
    var btn = panel ? panel.querySelector('.rp-lock-btn') : null;
    var header = panel ? panel.querySelector('.rp-header') : null;
    if (!btn) return;
    var openSvg = btn.querySelector('.rp-lock-open');
    var closedSvg = btn.querySelector('.rp-lock-closed');
    if (rpLocked) {
      btn.classList.add('locked');
      if (openSvg) openSvg.style.display = 'none';
      if (closedSvg) closedSvg.style.display = 'block';
      if (header) header.style.cursor = 'default';
    } else {
      btn.classList.remove('locked');
      if (openSvg) openSvg.style.display = 'block';
      if (closedSvg) closedSvg.style.display = 'none';
      if (header) header.style.cursor = 'move';
    }
  }
  if (panel) rpLoadLock();

  document.addEventListener('click', function(e) {
    if (!e.target.closest('.rp-lock-btn')) return;
    e.stopPropagation();
    rpLocked = !rpLocked;
    rpApplyLock();
    try { localStorage.setItem('rp_panel_locked', rpLocked ? '1' : '0'); } catch(ex) {}
  });

  // Drag
  var rpHeader = panel ? panel.querySelector('.rp-header') : null;
  var rpDragging = false;
  var rpOffX = 0, rpOffY = 0;

  if (rpHeader) {
    rpHeader.addEventListener('mousedown', function(e) {
      if (rpLocked) return;
      if (e.target.closest('.rp-lock-btn') || e.target.closest('.rp-size-btn') || e.target.closest('.rp-sort-btn')) return;
      rpDragging = true;
      rpOffX = e.clientX - panel.offsetLeft;
      rpOffY = e.clientY - panel.offsetTop;
      e.preventDefault();
    });
  }

  document.addEventListener('mousemove', function(e) {
    if (!rpDragging) return;
    panel.style.left = (e.clientX - rpOffX) + 'px';
    panel.style.top = (e.clientY - rpOffY) + 'px';
    panel.style.right = 'auto';
    rpClamp(panel);
  });

  document.addEventListener('mouseup', function() {
    if (rpDragging) {
      rpDragging = false;
      rpSavePosition(panel);
    }
  });

  window.addEventListener('resize', function() {
    if (panel && panel.style.display !== 'none') {
      rpClamp(panel);
    }
  });

  function rpClearAcceptTimer(ownerId) {
    if (rpAcceptTimers[ownerId]) {
      clearTimeout(rpAcceptTimers[ownerId]);
      delete rpAcceptTimers[ownerId];
    }
  }

  function rpSetBtnToPhone(btn) {
    btn.classList.add('accept-ready');
    btn.innerHTML = rpPhoneSVG;
  }

  function rpSetBtnToEye(btn) {
    btn.classList.remove('active', 'accept-ready');
    btn.innerHTML = rpEyeSVG;
  }

  document.addEventListener('click', function(e) {
    var btn = e.target.closest('.rp-spectate-btn');
    if (!btn) return;
    e.stopPropagation();
    var ownerId = btn.getAttribute('data-id');
    var item = btn.closest('.rp-item');
    var reportId = item ? item.getAttribute('data-id') : null;

    if (btn.classList.contains('accept-ready')) {
      post('http://chat/reportPanelAction', JSON.stringify({
        action: "acall",
        id: String(ownerId)
      }));
      rpClearAcceptTimer(ownerId);
      rpSetBtnToEye(btn);
      delete rpSpectateState[ownerId];
      return;
    }

    if (btn.classList.contains('active')) {
      rpClearAcceptTimer(ownerId);
      rpSetBtnToEye(btn);
      delete rpSpectateState[ownerId];
      post('http://chat/reportPanelAction', JSON.stringify({
        action: "spectate",
        id: String(ownerId)
      }));
      return;
    }

    btn.classList.add('active');
    btn.innerHTML = rpEyeSVG;
    rpSpectateState[ownerId] = 'active';
    post('http://chat/reportPanelAction', JSON.stringify({
      action: "spectate",
      id: String(ownerId)
    }));

    rpClearAcceptTimer(ownerId);
    rpAcceptTimers[ownerId] = setTimeout(function() {
      var current = document.querySelector('.rp-spectate-btn[data-id="' + ownerId + '"]');
      if (current && current.classList.contains('active')) {
        rpSetBtnToPhone(current);
      }
      rpSpectateState[ownerId] = 'accept-ready';
      delete rpAcceptTimers[ownerId];
    }, 4000);
  });

  // Global tooltip for report panel
  var rpTooltipEl = document.getElementById('rpGlobalTooltip');
  document.addEventListener('mouseenter', function(e) {
    if (!e.target || !e.target.closest) return;
    var el = e.target.closest('[data-tooltip]');
    if (!el || !rpTooltipEl) return;
    var text = el.getAttribute('data-tooltip');
    if (!text) return;
    rpTooltipEl.textContent = text;
    var app = document.getElementById('app');
    if (app) {
      var cs = getComputedStyle(app);
      var tr = cs.getPropertyValue('--theme-rgb').trim();
      if (tr) rpTooltipEl.style.setProperty('--theme-rgb', tr);
    }
    var scaleMap = {1: 1, 2: 1.15, 3: 1.3, 4: 1.5};
    var s = scaleMap[rpSizeLevel] || 1;
    rpTooltipEl.style.transform = 'scale(' + s + ')';
    rpTooltipEl.style.transformOrigin = 'center bottom';
    rpTooltipEl.style.display = 'block';
    var rect = el.getBoundingClientRect();
    var ttRect = rpTooltipEl.getBoundingClientRect();
    var left = rect.left + rect.width / 2 - ttRect.width / 2;
    var top = rect.top - ttRect.height - 8;
    if (top < 4) {
      top = rect.bottom + 8;
    }
    if (left < 4) left = 4;
    if (left + ttRect.width > window.innerWidth - 4) left = window.innerWidth - ttRect.width - 4;
    rpTooltipEl.style.left = left + 'px';
    rpTooltipEl.style.top = top + 'px';
  }, true);

  document.addEventListener('mouseleave', function(e) {
    if (!e.target || !e.target.closest) return;
    if (e.target.closest('[data-tooltip]') && rpTooltipEl) {
      rpTooltipEl.style.display = 'none';
    }
  }, true);

  function rpClearHoverStates() {
    if (rpTooltipEl) rpTooltipEl.style.display = 'none';
    var hovered = document.querySelectorAll('.rp-item.rp-hovered');
    for (var i = 0; i < hovered.length; i++) hovered[i].classList.remove('rp-hovered');
    var btnHovered = document.querySelectorAll('.rp-btn-hovered');
    for (var j = 0; j < btnHovered.length; j++) btnHovered[j].classList.remove('rp-btn-hovered');
  }

  document.addEventListener('mouseenter', function(e) {
    if (!e.target || !e.target.closest) return;
    var item = e.target.closest('.rp-item');
    if (item) item.classList.add('rp-hovered');
    var btn = e.target.closest('.rp-lock-btn, .rp-size-btn, .rp-sort-btn, .rp-sort-option');
    if (btn) btn.classList.add('rp-btn-hovered');
  }, true);

  document.addEventListener('mouseleave', function(e) {
    if (!e.target || !e.target.closest) return;
    var item = e.target.closest('.rp-item');
    if (item) item.classList.remove('rp-hovered');
    var btn = e.target.closest('.rp-lock-btn, .rp-size-btn, .rp-sort-btn, .rp-sort-option');
    if (btn) btn.classList.remove('rp-btn-hovered');
  }, true);

  document.addEventListener('mouseleave', function() {
    rpClearHoverStates();
  });

  window.addEventListener('blur', function() {
    rpClearHoverStates();
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' || e.key === 'Enter') rpClearHoverStates();
  });

  document.addEventListener('visibilitychange', function() {
    rpClearHoverStates();
  });

  // Sort button click
  document.addEventListener('click', function(e) {
    if (e.target.closest('.rp-sort-btn')) {
      e.stopPropagation();
      var menu = document.querySelector('.rp-sort-menu');
      if (menu) menu.classList.toggle('visible');
    }
  });

  // Sort option click
  document.addEventListener('click', function(e) {
    var opt = e.target.closest('.rp-sort-option');
    if (!opt) return;
    e.stopPropagation();
    rpSortMode = opt.getAttribute('data-sort');
    var opts = document.querySelectorAll('.rp-sort-option');
    for (var i = 0; i < opts.length; i++) opts[i].classList.remove('active');
    opt.classList.add('active');
    var menu = document.querySelector('.rp-sort-menu');
    if (menu) menu.classList.remove('visible');
    rpRender();
  });

  document.addEventListener('click', function(e) {
    var tab = e.target.closest('.rp-tab');
    if (!tab) return;
    e.stopPropagation();
    rpActiveTab = tab.getAttribute('data-tab') || 'active';
    var tabs = document.querySelectorAll('.rp-tab');
    for (var i = 0; i < tabs.length; i++) tabs[i].classList.remove('active');
    tab.classList.add('active');
    rpRender();
  });

  function rpSyncTheme() {
    if (!panel) return;
    var app = document.getElementById('app');
    if (!app) return;
    var cs = getComputedStyle(app);
    var tc = cs.getPropertyValue('--theme-color').trim();
    var tr = cs.getPropertyValue('--theme-rgb').trim();
    if (tc) panel.style.setProperty('--theme-color', tc);
    if (tr) panel.style.setProperty('--theme-rgb', tr);
  }

  // NUI message handler for report panel
  window.addEventListener('message', function(event) {
    var data = event.data || event.detail;
    if (!data || !data.type) return;

    if (data.type === 'SHOW_REPORT_PANEL') {
      rpReports = data.reports || {};
      rpClosedReports = data.closedReports || [];
      rpSyncTheme();
      rpRender();
      if (panel) panel.style.display = 'block';
    } else if (data.type === 'UPDATE_REPORT_PANEL') {
      rpReports = data.reports || {};
      rpClosedReports = data.closedReports || [];
      rpSyncTheme();
      rpRender();
    } else if (data.type === 'SUND_ARM_AR') {
      var oid = String(data.targetId || '');
      if (!oid) return;
      rpSpectateState[oid] = 'active';
      var btnNow = document.querySelector('.rp-spectate-btn[data-id="' + oid + '"]');
      if (btnNow) {
        btnNow.classList.add('active');
        btnNow.innerHTML = rpEyeSVG;
      }
      if (rpAcceptTimers[oid]) clearTimeout(rpAcceptTimers[oid]);
      rpAcceptTimers[oid] = setTimeout(function() {
        var current = document.querySelector('.rp-spectate-btn[data-id="' + oid + '"]');
        if (current && current.classList.contains('active')) {
          rpSetBtnToPhone(current);
        }
        rpSpectateState[oid] = 'accept-ready';
        delete rpAcceptTimers[oid];
      }, 4000);
    } else if (data.type === 'HIDE_REPORT_PANEL') {
      rpClearHoverStates();
      if (panel) panel.style.display = 'none';
    }

    if (data.type === 'ON_OPEN' || data.type === 'ON_CLOSE') {
      rpClearHoverStates();
    }
  });
})();

;(function() {
  var rsPanel = document.getElementById('reportSubmitPanel');
  var rsCatGrid = rsPanel.querySelector('.rs-cat-grid');
  var rsStepCats = rsPanel.querySelector('.rs-step-categories');
  var rsStepDesc = rsPanel.querySelector('.rs-step-desc');
  var rsMessage = rsPanel.querySelector('.rs-message');
  var rsCharCurrent = rsPanel.querySelector('.rs-char-current');
  var rsSubmitBtn = rsPanel.querySelector('.rs-submit-btn');
  var rsDescCat = rsPanel.querySelector('.rs-desc-cat');
  var rsDescBox = rsPanel.querySelector('.rs-desc-box');
  var rsDescForm = rsPanel.querySelector('.rs-desc-form');
  var rsBackBtn = rsPanel.querySelector('.rs-back-btn');
  var rsCategories = [];
  var rsSelectedCat = null;
  var rsCatDescriptions = window.REPORT_CATEGORY_DESCRIPTIONS || {};

  var rsCatColors = {
    'REPORT_COMBAT_LOGOUT': '#ef5350',
    'REPORT_KOS': '#e53935',
    'REPORT_NCZ_SAFEZONE': '#ff9800',
    'REPORT_POWER_GAMING': '#ff7043',
    'REPORT_VDM': '#f44336',
    'REPORT_FEAR_RP': '#ab47bc',
    'REPORT_SEARCH': '#42a5f5',
    'REPORT_META_GAMING': '#7e57c2',
    'REPORT_MIX_IC_OOC': '#5c6bc0',
    'REPORT_FAHASHI': '#ec407a',
    'REPORT_BUG_GLITCH': '#66bb6a',
    'HELP': '#26c6da',
    'REPORT_MORE': '#78909c'
  };

  function rsEscape(str) {
    var div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }

  function rsRenderCategories() {
    var html = '';
    for (var i = 0; i < rsCategories.length; i += 2) {
      if (i + 1 < rsCategories.length) {
        var cat2 = rsCategories[i + 1];
        var color2 = rsCatColors[cat2.key] || '#65aeff';
        html += '<div class="rs-cat-item" data-key="' + rsEscape(cat2.key) + '" data-label="' + rsEscape(cat2.label) + '">';
        html += '<div class="rs-cat-dot" style="background:' + color2 + '"></div>';
        html += '<span>' + rsEscape(cat2.label) + '</span>';
        html += '</div>';
      }
      var cat1 = rsCategories[i];
      var color1 = rsCatColors[cat1.key] || '#65aeff';
      html += '<div class="rs-cat-item" data-key="' + rsEscape(cat1.key) + '" data-label="' + rsEscape(cat1.label) + '">';
      html += '<div class="rs-cat-dot" style="background:' + color1 + '"></div>';
      html += '<span>' + rsEscape(cat1.label) + '</span>';
      html += '</div>';
    }
    rsCatGrid.innerHTML = html;
  }

  function rsShowCategoryStep() {
    rsStepCats.style.display = '';
    rsStepDesc.style.display = 'none';
    rsBackBtn.style.display = 'none';
    rsSelectedCat = null;
    rsMessage.value = '';
    rsCharCurrent.textContent = '0';
    rsSubmitBtn.disabled = false;
  }

  function rsShowDescStep(key, label) {
    rsSelectedCat = { key: key, label: label };
    rsDescCat.textContent = label;
    var desc = rsCatDescriptions[key] || '';
    rsDescBox.textContent = desc;
    rsDescBox.style.display = desc ? '' : 'none';
    if (key === 'HELP') {
      rsDescForm.style.display = 'none';
      rsSubmitBtn.textContent = 'ارسال سوال';
    } else if (key === 'REPORT_MORE') {
      rsDescForm.style.display = '';
      rsMessage.placeholder = 'توضیحات خود را بنویسید... (حداقل ۵ کاراکتر)';
      rsSubmitBtn.textContent = 'ارسال گزارش';
    } else {
      rsDescForm.style.display = '';
      rsMessage.placeholder = 'توضیحات خود را بنویسید... (اختیاری)';
      rsSubmitBtn.textContent = 'ارسال گزارش';
    }
    rsMessage.value = '';
    rsCharCurrent.textContent = '0';
    rsSubmitBtn.disabled = false;
    rsStepCats.style.display = 'none';
    rsStepDesc.style.display = '';
    rsBackBtn.style.display = '';
  }

  function rsClose() {
    rsPanel.style.display = 'none';
    rsShowCategoryStep();
    post('http://chat/reportSubmitAction', JSON.stringify({ action: 'cancel' }));
  }

  function rsSubmit(message, category) {
    rsSubmitBtn.disabled = true;
    post('http://chat/reportSubmitAction', JSON.stringify({
      action: 'submit',
      message: message,
      category: category
    }));
    rsPanel.style.display = 'none';
    rsShowCategoryStep();
  }

  rsPanel.addEventListener('click', function(e) {
    if (e.target.classList.contains('rs-overlay')) {
      rsClose();
      return;
    }

    if (e.target.closest('.rs-close-btn')) {
      rsClose();
      return;
    }

    if (e.target.closest('.rs-desc-back')) {
      rsShowCategoryStep();
      return;
    }

    var catItem = e.target.closest('.rs-cat-item');
    if (catItem) {
      var key = catItem.getAttribute('data-key');
      var label = catItem.getAttribute('data-label');
      rsShowDescStep(key, label);
      return;
    }

    if (e.target.closest('.rs-submit-btn') && rsSelectedCat) {
      if (rsSelectedCat.key === 'HELP') {
        rsSubmit(rsSelectedCat.label, rsSelectedCat.label);
      } else if (rsSelectedCat.key === 'REPORT_MORE') {
        var msg = rsMessage.value.trim();
        if (msg.length < 5) {
          rsMessage.style.border = '1px solid #ff4444';
          rsMessage.placeholder = 'لطفا توضیحات را وارد کنید (حداقل ۵ کاراکتر)';
          setTimeout(function() { rsMessage.style.border = ''; }, 2000);
          return;
        }
        rsSubmit(msg, rsSelectedCat.label);
      } else {
        var msg = rsMessage.value.trim();
        var finalMsg = msg.length > 0 ? msg : rsSelectedCat.label;
        rsSubmit(finalMsg, rsSelectedCat.label);
      }
      return;
    }
  });

  rsMessage.addEventListener('input', function() {
    rsCharCurrent.textContent = rsMessage.value.length;
  });

  document.addEventListener('keydown', function(e) {
    if (rsPanel.style.display !== 'none' && e.key === 'Escape') {
      if (rsStepDesc.style.display !== 'none') {
        rsShowCategoryStep();
      } else {
        rsClose();
      }
    }
  });

  window.addEventListener('message', function(event) {
    var data = event.data || event.detail;
    if (!data || !data.type) return;

    if (data.type === 'OPEN_REPORT_SUBMIT') {
      rsCategories = data.categories || [];
      rsRenderCategories();
      rsShowCategoryStep();
      rsPanel.style.display = '';
    }
  });
})();

;(function() {
  var tiPanel = document.getElementById('ticketIndicator');
  var tiText = tiPanel.querySelector('.ti-text');
  var tdPanel = document.getElementById('ticketDetail');
  var tdStatusValue = tdPanel.querySelector('.td-status-value');
  var tdCatValue = tdPanel.querySelector('.td-cat-value');
  var tdTimeValue = tdPanel.querySelector('.td-time-value');
  var tdAdminRow = tdPanel.querySelector('.td-admin-row');
  var tdAdminValue = tdPanel.querySelector('.td-admin-value');
  var tdCancelBtn = tdPanel.querySelector('.td-cancel-btn');
  var tdClosedActions = tdPanel.querySelector('.td-closed-actions');
  var tdNormalActions = tdPanel.querySelector('.td-actions:not(.td-closed-actions)');
  var trPanel = document.getElementById('ticketRating');
  var trAdminName = trPanel.querySelector('.tr-admin-name');
  var trStars = trPanel.querySelectorAll('.tr-star');
  var trComment = trPanel.querySelector('.tr-comment');
  var trSubmitBtn = trPanel.querySelector('.tr-submit-btn');
  var trSelectedRating = 0;
  var trReportId = null;

  var ticketData = {
    status: null,
    adminName: null,
    cat: null,
    message: null,
    time: null
  };

  var ticketCancelAllowed = false;

  function tdEscape(str) {
    var div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }

  function tdTimeAgo(timestamp) {
    if (!timestamp) return '';
    var now = Math.floor(Date.now() / 1000);
    var diff = now - timestamp;
    if (diff < 60) return diff + ' ثانیه';
    if (diff < 3600) return Math.floor(diff / 60) + ' دقیقه';
    if (diff < 86400) return Math.floor(diff / 3600) + ' ساعت';
    return Math.floor(diff / 86400) + ' روز';
  }

  function tiShow(status, adminName) {
    tiPanel.className = '';
    if (status === 'open') {
      tiPanel.classList.add('ti-open');
      tiText.textContent = 'گزارش باز';
    } else if (status === 'pending') {
      tiPanel.classList.add('ti-pending');
      tiText.textContent = 'در حال بررسی';
    } else if (status === 'closed') {
      tiPanel.classList.add('ti-closed');
      tiText.textContent = 'بسته شد';
    }
    tiPanel.style.display = '';
  }

  function tiHide() {
    tiPanel.style.display = 'none';
    tdPanel.style.display = 'none';
    ticketData.status = null;
  }

  function tdShow() {
    tdStatusValue.className = 'td-value td-status-value';
    if (ticketData.status === 'open') {
      tdStatusValue.textContent = 'در صف انتظار';
      tdStatusValue.classList.add('td-status-open');
      tdAdminRow.style.display = 'none';
      tdNormalActions.style.display = '';
      tdClosedActions.style.display = 'none';
    } else if (ticketData.status === 'pending') {
      tdStatusValue.textContent = 'در حال بررسی';
      tdStatusValue.classList.add('td-status-pending');
      tdAdminRow.style.display = '';
      tdAdminValue.textContent = ticketData.adminName || '';
      tdNormalActions.style.display = '';
      tdClosedActions.style.display = 'none';
    } else if (ticketData.status === 'closed') {
      tdStatusValue.textContent = 'بسته شد';
      tdStatusValue.classList.add('td-status-closed');
      tdAdminRow.style.display = '';
      tdAdminValue.textContent = ticketData.adminName || '';
      tdNormalActions.style.display = 'none';
      tdClosedActions.style.display = '';
    }
    tdCatValue.textContent = ticketData.cat || '-';
    tdTimeValue.textContent = ticketData.time ? tdTimeAgo(ticketData.time) + ' پیش' : '-';
    if (!ticketCancelAllowed) {
      tdNormalActions.style.display = 'none';
    }
    tdPanel.style.display = '';
  }

  function tdClose() {
    tdPanel.style.display = 'none';
    post('http://chat/ticketAction', JSON.stringify({ action: 'closeDetail' }));
  }

  tiPanel.addEventListener('click', function() {
    if (ticketData.status) {
      tdShow();
      post('http://chat/ticketAction', JSON.stringify({ action: 'openDetail' }));
    }
  });

  tdPanel.addEventListener('click', function(e) {
    if (e.target.classList.contains('td-overlay') || e.target.closest('.td-close-btn')) {
      tdClose();
      return;
    }
    if (e.target.closest('.td-cancel-btn')) {
      tdPanel.style.display = 'none';
      post('http://chat/ticketAction', JSON.stringify({ action: 'cancel' }));
      return;
    }
    if (e.target.closest('.td-rate-btn')) {
      tdPanel.style.display = 'none';
      trShow(trReportId, ticketData.adminName);
      return;
    }
  });

  function trShow(reportId, adminName) {
    trReportId = reportId;
    trAdminName.textContent = adminName || '';
    trSelectedRating = 0;
    trComment.value = '';
    trSubmitBtn.disabled = true;
    for (var i = 0; i < trStars.length; i++) {
      trStars[i].classList.remove('selected', 'tr-star-low', 'tr-star-mid', 'tr-star-high');
    }
    trPanel.style.display = '';
  }

  function trClose() {
    trPanel.style.display = 'none';
    var rid = trReportId;
    trReportId = null;
    trSelectedRating = 0;
    tiHide();
    post('http://chat/ticketRatingAction', JSON.stringify({ action: 'skip', reportId: rid }));
  }

  function trUpdateStars(value) {
    trSelectedRating = value;
    trSubmitBtn.disabled = false;
    for (var i = 0; i < trStars.length; i++) {
      var v = parseInt(trStars[i].getAttribute('data-value'));
      trStars[i].classList.remove('selected', 'tr-star-low', 'tr-star-mid', 'tr-star-high');
      if (v <= value) {
        trStars[i].classList.add('selected');
        if (value <= 3) trStars[i].classList.add('tr-star-low');
        else if ( value <= 6) trStars[i].classList.add('tr-star-mid');
        else trStars[i].classList.add('tr-star-high');
      }
    }
  }

  trPanel.addEventListener('click', function(e) {
    if (e.target.classList.contains('tr-overlay')) {
      trClose();
      return;
    }

    var star = e.target.closest('.tr-star');
    if (star) {
      trUpdateStars(parseInt(star.getAttribute('data-value')));
      return;
    }

    if (e.target.closest('.tr-skip-btn')) {
      trClose();
      return;
    }

    if (e.target.closest('.tr-submit-btn') && trSelectedRating > 0) {
      post('http://chat/ticketRatingAction', JSON.stringify({
        action: 'submit',
        reportId: trReportId,
        rating: trSelectedRating,
        comment: trComment.value.trim()
      }));
      trPanel.style.display = 'none';
      trReportId = null;
      trSelectedRating = 0;
      tiHide();
      return;
    }
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      if (trPanel.style.display !== 'none') {
        trClose();
      } else if (tdPanel.style.display !== 'none') {
        tdClose();
      }
    }
  });

  window.addEventListener('message', function(event) {
    var data = event.data || event.detail;
    if (!data || !data.type) return;

    if (data.type === 'TICKET_STATUS_UPDATE') {
      if (data.cat) ticketData.cat = data.cat;
      if (data.message) ticketData.message = data.message;
      if (data.time) ticketData.time = data.time;
      if (data.adminName) ticketData.adminName = data.adminName;
      ticketData.status = data.status;
      if (data.status === 'closed') {
        trReportId = data.reportId || trReportId;
      }
      tiShow(data.status, data.adminName);
    } else if (data.type === 'TICKET_HIDE') {
      tiHide();
    } else if (data.type === 'OPEN_RATING_DIRECT') {
      trReportId = data.reportId;
      trShow(data.reportId, data.adminName);
    } else if (data.type === 'SET_TICKET_CANCEL_ALLOWED') {
      ticketCancelAllowed = !!data.allowed;
    }
  });
})();
