Vue.component('message', {
  template: '#message_template',
  data() {
    return {
      copied: false,
    };
  },
  computed: {
    starred() {
      return this.$parent.isStarred(this.msgId);
    },
    plainText() {
      const div = document.createElement('div');
      div.innerHTML = this.textEscaped;
      return div.textContent || div.innerText || '';
    },
    textEscaped() {
      let s = this.template ? this.template : this.templates[this.templateId];

      if (this.template) {
        //We disable templateId since we are using a direct raw template
        this.templateId = -1;
      }

      //This hack is required to preserve backwards compatability
      if (this.templateId == CONFIG.defaultTemplateId
          && this.args.length == 1) {
        s = this.templates[CONFIG.defaultAltTemplateId] //Swap out default template :/
      }

      s = s.replace(/{(\d+)}/g, (match, number) => {
        const argEscaped = this.args[number] != undefined ? this.escape(this.args[number]) : match
        if (number == 0 && this.color) {
          //color is deprecated, use templates or ^1 etc.
          return this.colorizeOld(argEscaped);
        }
        return argEscaped;
      });
      return this.colorize(s);
    },
  },
  methods: {
    toggleStar() {
      this.$parent.toggleStar(this.msgId, this.plainText);
    },
    runAction() {
      if (!this.action || !this.action.event) return;
      post('http://chat/action', JSON.stringify({
        event: this.action.event,
        args: this.action.args || [],
      }));
    },
    quoteText() {
      this.$parent.quoteMessage(this.plainText);
    },
    copyText() {
      const tmp = document.createElement('textarea');
      tmp.value = this.plainText;
      tmp.style.position = 'fixed';
      tmp.style.opacity = '0';
      document.body.appendChild(tmp);
      tmp.select();
      try {
        document.execCommand('copy');
      } catch (e) { /* clipboard not available */ }
      document.body.removeChild(tmp);
      this.copied = true;
      clearTimeout(this._copiedTimer);
      this._copiedTimer = setTimeout(() => { this.copied = false; }, 1200);
    },
    colorizeOld(str) {
      return `<span style="color: rgb(${this.color[0]}, ${this.color[1]}, ${this.color[2]})">${str}</span>`
    },
    colorize(str) {
      let s = "<span>" + (str.replace(/\^([0-9])/g, (str, color) => `</span><span class="color-${color}">`)) + "</span>";

      const styleDict = {
        '*': 'font-weight: bold;',
        '_': 'text-decoration: underline;',
        '~': 'text-decoration: line-through;',
        '=': 'text-decoration: underline line-through;',
        'r': 'text-decoration: none;font-weight: normal;',
      };

      const styleRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
      while (s.match(styleRegex)) { //Any better solution would be appreciated :P
        s = s.replace(styleRegex, (str, style, inner) => `<em style="${styleDict[style]}">${inner}</em>`)
      }
      return s.replace(/<span[^>]*><\/span[^>]*>/g, '');
    },
    escape(unsafe) {
      return String(unsafe)
       .replace(/&/g, '&amp;')
       .replace(/</g, '&lt;')
       .replace(/>/g, '&gt;')
       .replace(/"/g, '&quot;')
       .replace(/'/g, '&#039;');
    },
  },
  props: {
    templates: {
      type: Object,
    },
    args: {
      type: Array,
    },
    template: {
      type: String,
      default: null,
    },
    templateId: {
      type: String,
      default: CONFIG.defaultTemplateId,
    },
    multiline: {
      type: Boolean,
      default: false,
    },
    color: { //deprecated
      type: Array,
      default: false,
    },
    action: {
      type: Object,
      default: null,
    },
    msgId: {
      type: [Number, String],
      default: null,
    },
  },
});
