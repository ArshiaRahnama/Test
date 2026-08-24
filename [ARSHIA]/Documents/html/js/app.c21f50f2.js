(function (t) {
    function e(e) {
        for (var a, o, c = e[0], r = e[1], l = e[2], u = 0, g = []; u < c.length; u++) (o = c[u]), Object.prototype.hasOwnProperty.call(n, o) && n[o] && g.push(n[o][0]), (n[o] = 0);
        for (a in r) Object.prototype.hasOwnProperty.call(r, a) && (t[a] = r[a]);
        m && m(e);
        while (g.length) g.shift()();
        return i.push.apply(i, l || []), s();
    }
    function s() {
        for (var t, e = 0; e < i.length; e++) {
            for (var s = i[e], a = !0, c = 1; c < s.length; c++) {
                var r = s[c];
                0 !== n[r] && (a = !1);
            }
            a && (i.splice(e--, 1), (t = o((o.s = s[0]))));
        }
        return t;
    }
    var a = {},
        n = { app: 0 },
        i = [];
    function o(e) {
        if (a[e]) return a[e].exports;
        var s = (a[e] = { i: e, l: !1, exports: {} });
        return t[e].call(s.exports, s, s.exports, o), (s.l = !0), s.exports;
    }
    (o.m = t),
        (o.c = a),
        (o.d = function (t, e, s) {
            o.o(t, e) || Object.defineProperty(t, e, { enumerable: !0, get: s });
        }),
        (o.r = function (t) {
            "undefined" !== typeof Symbol && Symbol.toStringTag && Object.defineProperty(t, Symbol.toStringTag, { value: "Module" }), Object.defineProperty(t, "__esModule", { value: !0 });
        }),
        (o.t = function (t, e) {
            if ((1 & e && (t = o(t)), 8 & e)) return t;
            if (4 & e && "object" === typeof t && t && t.__esModule) return t;
            var s = Object.create(null);
            if ((o.r(s), Object.defineProperty(s, "default", { enumerable: !0, value: t }), 2 & e && "string" != typeof t))
                for (var a in t)
                    o.d(
                        s,
                        a,
                        function (e) {
                            return t[e];
                        }.bind(null, a)
                    );
            return s;
        }),
        (o.n = function (t) {
            var e =
                t && t.__esModule
                    ? function () {
                          return t["default"];
                      }
                    : function () {
                          return t;
                      };
            return o.d(e, "a", e), e;
        }),
        (o.o = function (t, e) {
            return Object.prototype.hasOwnProperty.call(t, e);
        }),
        (o.p = "");
    var c = (window["webpackJsonp"] = window["webpackJsonp"] || []),
        r = c.push.bind(c);
    (c.push = e), (c = c.slice());
    for (var l = 0; l < c.length; l++) e(c[l]);
    var m = r;
    i.push([0, "chunk-vendors"]), s();
})({
    0: function (t, e, s) {
        t.exports = s("56d7");
    },
    "034f": function (t, e, s) {
        "use strict";
        s("85ec");
    },
    "56d7": function (t, e, s) {
        "use strict";
        s.r(e);
        s("e260"), s("e6cf"), s("cca6"), s("a79d");
        var a = s("2b0e"),
            n = function () {
                var t = this,
                    e = t.$createElement,
                    s = t._self._c || e;
                return s(
                    "div",
                    { class: { Closed: !t.openned }, attrs: { id: "App" } },
                    [
                        "Document" == t.page
                            ? s("Document", { attrs: { logo: t.logo, translate: t.translate, NameResource: t.NameResource, close: t.close, creating: t.creating } })
                            : "Edit" == t.page
                            ? s("Edit", { attrs: { infos_document: t.infos_document, logo: t.logo, translate: t.translate, NameResource: t.NameResource, close: t.close, creating: t.creating } })
                            : "ViewDocument" == t.page
                            ? s("ViewDocument", { attrs: { infos_document: t.infos_document, logo: t.logo, translate: t.translate, NameResource: t.NameResource, close: t.close, creating: t.creating } })
                            : t._e(),
                    ],
                    1
                );
            },
            i = [],
            o =
                (s("d3b7"),
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", [
                        s("div", { staticClass: "DocumentBox" }, [
                            s("div", { staticClass: "DocumentButtonsBox" }, [
                                s("div", { staticClass: "DocumentButtons" }, [
                                    s("p", { staticClass: "DocumentButtonsText" }, [t._v(t._s(t.translate.TR_CREATE))]),
                                    s("div", { staticClass: "DocumentButtonsImageBox" }, [s("img", { staticClass: "DocumentButtonsImage", attrs: { src: "img/checked.png", alt: "" }, on: { click: t.saveModel } })]),
                                ]),
                                s("div", { staticClass: "DocumentButtons" }, [
                                    s("p", { staticClass: "DocumentButtonsText" }, [t._v(t._s(t.translate.TR_CANCEL))]),
                                    s("div", { staticClass: "DocumentButtonsImageBox" }, [s("img", { staticClass: "DocumentButtonsImage", attrs: { src: "img/cancel.png", alt: "" }, on: { click: t.close } })]),
                                ]),
                            ]),
                            s("div", { staticClass: "DocumentPageBox" }, [
                                t._m(0),
                                t._m(1),
                                s("div", { staticClass: "DocumentTitleBox" }, [
                                    s("div", { staticClass: "DocumentTitleImageBox" }, [s("img", { staticClass: "DocumentTitleImage", attrs: { src: t.logo, alt: "" } })]),
                                    s("p", { staticClass: "DocumentTitleText" }, [t._v(t._s(t.translate.TR_TITLE))]),
                                    s("input", {
                                        directives: [{ name: "model", rawName: "v-model", value: t.infos_document.date, expression: "infos_document.date" }],
                                        staticClass: "DocumentTitleDate",
                                        attrs: { type: "text", spellcheck: "false" },
                                        domProps: { value: t.infos_document.date },
                                        on: {
                                            input: function (e) {
                                                e.target.composing || t.$set(t.infos_document, "date", e.target.value);
                                            },
                                        },
                                    }),
                                ]),
                                s("div", { staticClass: "DocumentTextBox" }, [
                                    s("div", { staticClass: "DocumentTextTitleBox" }, [
                                        s("input", {
                                            directives: [{ name: "model", rawName: "v-model", value: t.infos_document.title, expression: "infos_document.title" }],
                                            staticClass: "DocumentTextTitle",
                                            attrs: { type: "text", spellcheck: "false" },
                                            domProps: { value: t.infos_document.title },
                                            on: {
                                                input: function (e) {
                                                    e.target.composing || t.$set(t.infos_document, "title", e.target.value);
                                                },
                                            },
                                        }),
                                    ]),
                                    s("div", { staticClass: "DocumentTextLiteralBox" }, [
                                        s("textarea", {
                                            directives: [{ name: "model", rawName: "v-model", value: t.infos_document.text, expression: "infos_document.text" }],
                                            ref: "literaltext",
                                            staticClass: "DocumentTextLiteral",
                                            attrs: { spellcheck: "false" },
                                            domProps: { value: t.infos_document.text },
                                            on: {
                                                input: [
                                                    function (e) {
                                                        e.target.composing || t.$set(t.infos_document, "text", e.target.value);
                                                    },
                                                    t.autoResize,
                                                ],
                                            },
                                        }),
                                    ]),
                                ]),
                            ]),
                            s(
                                "div",
                                { staticClass: "DocumentPageBox" },
                                [
                                    t._m(2),
                                    t._m(3),
                                    t._l(t.infos_document.images, function (e, a) {
                                        return s("div", { key: a, staticClass: "DocumentImagesBox" }, [
                                            s("div", { staticClass: "DocumentImagesDeleteBox" }, [
                                                s("img", {
                                                    staticClass: "DocumentImagesDelete",
                                                    attrs: { src: "img/delete.png", alt: "" },
                                                    on: {
                                                        click: function (e) {
                                                            return t.deleteImage(a);
                                                        },
                                                    },
                                                }),
                                            ]),
                                            s("img", { staticClass: "DocumentImages", attrs: { src: e, alt: "" } }),
                                            s("p"),
                                        ]);
                                    }),
                                    s("div", { staticClass: "DocumentImagesBox" }, [
                                        s("div", { staticClass: "DocumentInsertImageBox", class: { DocumentInsertImageBoxEnable: t.InsertImageEnabled } }, [
                                            s("input", {
                                                directives: [{ name: "model", rawName: "v-model", value: t.inputImage, expression: "inputImage" }],
                                                staticClass: "DocumentInsert",
                                                attrs: { type: "text", placeholder: "URL IMAGE with .png .gif or .jpg", spellcheck: "false" },
                                                domProps: { value: t.inputImage },
                                                on: {
                                                    input: function (e) {
                                                        e.target.composing || (t.inputImage = e.target.value);
                                                    },
                                                },
                                            }),
                                            s("p", { staticClass: "DocumentInsertButton", on: { click: t.insertImage } }, [t._v(t._s(t.translate.TR_BUTTON_INSERT))]),
                                        ]),
                                        s("img", {
                                            staticClass: "DocumentImages",
                                            attrs: { src: "img/insertimg.png", alt: "" },
                                            on: {
                                                click: function (e) {
                                                    return t.enableInsertImage(!0);
                                                },
                                            },
                                        }),
                                        s("p", [t._v(t._s(t.translate.TR_INSERT))]),
                                    ]),
                                ],
                                2
                            ),
                            s("div", { staticClass: "DocumentPageBox" }, [
                                t._m(4),
                                t._m(5),
                                s(
                                    "div",
                                    { staticClass: "DocumentAllAsignsBox" },
                                    t._l(t.infos_document.signatures, function (e, a) {
                                        return s("div", { key: a, staticClass: "DocumentAsignBox" }, [
                                            s("input", {
                                                directives: [{ name: "model", rawName: "v-model", value: e.asign, expression: "item.asign" }],
                                                staticClass: "DocumentAsign",
                                                attrs: { type: "text", spellcheck: "false" },
                                                domProps: { value: e.asign },
                                                on: {
                                                    input: function (s) {
                                                        s.target.composing || t.$set(e, "asign", s.target.value);
                                                    },
                                                },
                                            }),
                                            s("input", {
                                                directives: [{ name: "model", rawName: "v-model", value: e.info, expression: "item.info" }],
                                                staticClass: "DocumentInfoAsign",
                                                attrs: { type: "text", spellcheck: "false" },
                                                domProps: { value: e.info },
                                                on: {
                                                    input: function (s) {
                                                        s.target.composing || t.$set(e, "info", s.target.value);
                                                    },
                                                },
                                            }),
                                        ]);
                                    }),
                                    0
                                ),
                            ]),
                        ]),
                    ]);
                }),
            c = [
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
            ],
            r =
                (s("caad"),
                s("a434"),
                s("2532"),
                {
                    props: { logo: {}, translate: {}, NameResource: {}, close: {}, creating: {} },
                    data: function () {
                        return {
                            infos_document: {
                                date: "تاریخ",
                                title: "عنوان",
                                text:
                                    "",
                                images: [],
                                signatures: [],
                            },
                            inputImage: "",
                            InsertImageEnabled: !1,
                        };
                    },
                    methods: {
                        autoResize: function () {
                            var t = this.$refs.literaltext;
                            t.style.height = t.scrollHeight + "px";
                        },
                        deleteImage: function (t) {
                            this.infos_document.images.splice(t, 1);
                        },
                        enableInsertImage: function (t) {
                            this.InsertImageEnabled = t;
                        },
                        insertImage: function () {
                            (this.inputImage.includes(".png") || this.inputImage.includes(".jpg") || this.inputImage.includes(".gif")) &&
                                (this.infos_document.images.push(this.inputImage), (this.inputImage = ""), this.enableInsertImage(!1));
                        },
                        insertSigniture: function () {
                            //    
                                fetch("https://".concat(this.NameResource, "/getdata"),{ method: "POST"}).then(d => d.json()).then((data) =>{
                                    this.infos_document.signatures.push({ asign: data["name"], info: data["job"]["label"] + " | " + data["job"]["grade_label"]});
                                })
                        },
                        removeSigniture: function () {
                            this.infos_document.signatures.length > 0 && this.infos_document.signatures.pop();
                        },
                        saveModel: function () {
                            fetch("https://".concat(this.NameResource, "/saveModel"), { method: "POST", body: JSON.stringify({ infos_document: this.infos_document, creating: this.creating }) }), this.close();
                        },
                    },
                    mounted: function () {
                        this.autoResize();
                    },
                }),
            l = r,
            m = s("2877"),
            u = Object(m["a"])(l, o, c, !1, null, null, null),
            g = u.exports,
            d = function () {
                var t = this,
                    e = t.$createElement,
                    s = t._self._c || e;
                return s("div", [
                    s("div", { staticClass: "DocumentBox" }, [
                        s("div", { staticClass: "DocumentButtonsBox" }, [
                            s("div", { staticClass: "DocumentButtons" }, [
                                s("p", { staticClass: "DocumentButtonsText" }, [t._v(t._s(t.translate.TR_SAVE))]),
                                s("div", { staticClass: "DocumentButtonsImageBox" }, [s("img", { staticClass: "DocumentButtonsImage", attrs: { src: "img/checked.png", alt: "" }, on: { click: t.saveDocument } })]),
                            ]),
                            s("div", { staticClass: "DocumentButtons" }, [
                                s("p", { staticClass: "DocumentButtonsText" }, [t._v(t._s(t.translate.TR_CANCEL))]),
                                s("div", { staticClass: "DocumentButtonsImageBox" }, [s("img", { staticClass: "DocumentButtonsImage", attrs: { src: "img/cancel.png", alt: "" }, on: { click: t.close } })]),
                            ]),
                            s("div", { staticClass: "DocumentButtons" }, [
                                s("p", { staticClass: "DocumentButtonsText" }, [t._v(t._s(t.translate.TR_ADD))]),
                                s("div", { staticClass: "DocumentButtonsImageBox" }, [s("img", { staticClass: "DocumentButtonsImage", attrs: { src: "img/add.png", alt: "" }, on: { click: t.insertSigniture } })]),
                            ]),
                            s("div", { staticClass: "DocumentButtons" }, [
                                s("p", { staticClass: "DocumentButtonsText" }, [t._v(t._s(t.translate.TR_REMOVE))]),
                                s("div", { staticClass: "DocumentButtonsImageBox" }, [s("img", { staticClass: "DocumentButtonsImage", attrs: { src: "img/remove.png", alt: "" }, on: { click: t.removeSigniture } })]),
                            ]),
                        ]),
                        s("div", { staticClass: "DocumentPageBox" }, [
                            t._m(0),
                            t._m(1),
                            s("div", { staticClass: "DocumentTitleBox" }, [
                                s("div", { staticClass: "DocumentTitleImageBox" }, [s("img", { staticClass: "DocumentTitleImage", attrs: { src: t.logo, alt: "" } })]),
                                s("p", { staticClass: "DocumentTitleText" }, [t._v(t._s(t.translate.TR_TITLE))]),
                                s("input", {
                                    directives: [{ name: "model", rawName: "v-model", value: t.infos_document.date, expression: "infos_document.date" }],
                                    staticClass: "DocumentTitleDate",
                                    attrs: { type: "text", spellcheck: "false" },
                                    domProps: { value: t.infos_document.date },
                                    on: {
                                        input: function (e) {
                                            e.target.composing || t.$set(t.infos_document, "date", e.target.value);
                                        },
                                    },
                                }),
                            ]),
                            s("div", { staticClass: "DocumentTextBox" }, [
                                s("div", { staticClass: "DocumentTextTitleBox" }, [
                                    s("input", {
                                        directives: [{ name: "model", rawName: "v-model", value: t.infos_document.title, expression: "infos_document.title" }],
                                        staticClass: "DocumentTextTitle",
                                        attrs: { type: "text", spellcheck: "false" },
                                        domProps: { value: t.infos_document.title },
                                        on: {
                                            input: function (e) {
                                                e.target.composing || t.$set(t.infos_document, "title", e.target.value);
                                            },
                                        },
                                    }),
                                ]),
                                s("div", { staticClass: "DocumentTextLiteralBox" }, [
                                    s("textarea", {
                                        directives: [{ name: "model", rawName: "v-model", value: t.infos_document.text, expression: "infos_document.text" }],
                                        ref: "teste",
                                        staticClass: "DocumentTextLiteral",
                                        attrs: { spellcheck: "false" },
                                        domProps: { value: t.infos_document.text },
                                        on: {
                                            input: [
                                                function (e) {
                                                    e.target.composing || t.$set(t.infos_document, "text", e.target.value);
                                                },
                                                t.autoResize,
                                            ],
                                        },
                                    }),
                                ]),
                            ]),
                        ]),
                        s(
                            "div",
                            { staticClass: "DocumentPageBox" },
                            [
                                t._m(2),
                                t._m(3),
                                t._l(t.infos_document.images, function (e, a) {
                                    return s("div", { key: a, staticClass: "DocumentImagesBox" }, [
                                        s("div", { staticClass: "DocumentImagesDeleteBox" }, [
                                            s("img", {
                                                staticClass: "DocumentImagesDelete",
                                                attrs: { src: "img/delete.png", alt: "" },
                                                on: {
                                                    click: function (e) {
                                                        return t.deleteImage(a);
                                                    },
                                                },
                                            }),
                                        ]),
                                        s("img", { staticClass: "DocumentImages", attrs: { src: e, alt: "" } }),
                                        s("p"),
                                    ]);
                                }),
                                s("div", { staticClass: "DocumentImagesBox" }, [
                                    s("div", { staticClass: "DocumentInsertImageBox", class: { DocumentInsertImageBoxEnable: t.InsertImageEnabled } }, [
                                        s("input", {
                                            directives: [{ name: "model", rawName: "v-model", value: t.inputImage, expression: "inputImage" }],
                                            staticClass: "DocumentInsert",
                                            attrs: { type: "text", placeholder: "URL IMAGE with .png .gif or .jpg", spellcheck: "false" },
                                            domProps: { value: t.inputImage },
                                            on: {
                                                input: function (e) {
                                                    e.target.composing || (t.inputImage = e.target.value);
                                                },
                                            },
                                        }),
                                        s("p", { staticClass: "DocumentInsertButton", on: { click: t.insertImage } }, [t._v(t._s(t.translate.TR_BUTTON_INSERT))]),
                                    ]),
                                    s("img", {
                                        staticClass: "DocumentImages",
                                        attrs: { src: "img/insertimg.png", alt: "" },
                                        on: {
                                            click: function (e) {
                                                return t.enableInsertImage(!0);
                                            },
                                        },
                                    }),
                                    s("p", [t._v(t._s(t.translate.TR_INSERT))]),
                                ]),
                            ],
                            2
                        ),
                        s("div", { staticClass: "DocumentPageBox" }, [
                            t._m(4),
                            t._m(5),
                            s(
                                "div",
                                { staticClass: "DocumentAllAsignsBox" },
                                t._l(t.infos_document.signatures, function (e, a) {
                                    return s("div", { key: a, staticClass: "DocumentAsignBox" }, [
                                        s("input", {
                                            directives: [{ name: "model", rawName: "v-model", value: e.asign, expression: "item.asign" }],
                                            staticClass: "DocumentAsign",
                                            attrs: { type: "text", spellcheck: "false", readonly: "" },
                                            domProps: { value: e.asign },
                                            on: {
                                                input: function (s) {
                                                    s.target.composing || t.$set(e, "asign", s.target.value);
                                                },
                                            },
                                        }),
                                        s("input", {
                                            directives: [{ name: "model", rawName: "v-model", value: e.info, expression: "item.info" }],
                                            staticClass: "DocumentInfoAsign",
                                            attrs: { type: "text", spellcheck: "false", readonly: "" },
                                            domProps: { value: e.info },
                                            on: {
                                                input: function (s) {
                                                    s.target.composing || t.$set(e, "info", s.target.value);
                                                },
                                            },
                                        }),
                                    ]);
                                }),
                                0
                            ),
                        ]),
                    ]),
                ]);
            },
            p = [
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
            ],
            f =
                (s("b0c0"),
                {
                    props: { infos_document: {}, logo: {}, translate: {}, NameResource: {}, creating: {}, close: {} },
                    data: function () {
                        return { inputImage: "", InsertImageEnabled: !1 };
                    },
                    methods: {
                        autoResize: function () {
                            var t = this.$refs.teste;
                            t.style.height = t.scrollHeight + "px";
                        },
                        deleteImage: function (t) {
                            this.infos_document.images.splice(t, 1);
                        },
                        enableInsertImage: function (t) {
                            this.InsertImageEnabled = t;
                        },
                        insertImage: function () {
                            (this.inputImage.includes(".png") || this.inputImage.includes(".jpg") || this.inputImage.includes(".gif")) &&
                                (this.infos_document.images.push(this.inputImage), (this.inputImage = ""), this.enableInsertImage(!1));
                        },
                        insertSigniture: function () {
                            // Create Doc
                            var d = new Date();
                            fetch("https://".concat(this.NameResource, "/getdata"),{ method: "POST"}).then(d => d.json()).then((data) =>{
                                this.infos_document.signatures.push({ asign: data["name"], info: data["job"]["label"] + " | " + data["job"]["grade_label"] + " | " + convertDate(GetDate()) + "| " +  d.getHours() + ":" + d.getMinutes()});
                            })
                        },
                        removeSigniture: function () {
                            this.infos_document.signatures.length > 0 && this.infos_document.signatures.pop();
                        },
                        saveDocument: function () {
                            "model" == this.infos_document.name
                                ? fetch("https://".concat(this.NameResource, "/saveModel"), { method: "POST", body: JSON.stringify({ creating: this.creating, infos_document: this.infos_document }) })
                                : fetch("https://".concat(this.NameResource, "/saveDocument"), { method: "POST", body: JSON.stringify({ creating: this.creating, infos_document: this.infos_document }) }),
                                this.close();
                        },
                    },
                    mounted: function () {
                        this.autoResize();
                    },
                }),
            v = f,
            _ = Object(m["a"])(v, d, p, !1, null, null, null),
            h = _.exports,
            C = function () {
                var t = this,
                    e = t.$createElement,
                    s = t._self._c || e;
                return s("div", [
                    s("div", { staticClass: "DocumentBox" }, [
                        s("div", { staticClass: "DocumentButtonsBox" }, [
                            s("div", { staticClass: "DocumentButtons" }, [
                                s("p", { staticClass: "DocumentButtonsText" }, [t._v(t._s(t.translate.TR_EXIT))]),
                                s("div", { staticClass: "DocumentButtonsImageBox" }, [s("img", { staticClass: "DocumentButtonsImage", attrs: { src: "img/cancel.png", alt: "" }, on: { click: t.close } })]),
                            ]),
                        ]),
                        s("div", { staticClass: "DocumentPageBox" }, [
                            t._m(0),
                            t._m(1),
                            s("div", { staticClass: "DocumentTitleBox" }, [
                                s("div", { staticClass: "DocumentTitleImageBox" }, [s("img", { staticClass: "DocumentTitleImage", attrs: { src: t.logo, alt: "" } })]),
                                s("p", { staticClass: "DocumentTitleText" }, [t._v(t._s(t.translate.TR_TITLE))]),
                                s("input", {
                                    directives: [{ name: "model", rawName: "v-model", value: t.infos_document.date, expression: "infos_document.date" }],
                                    staticClass: "DocumentTitleDate",
                                    attrs: { type: "text", spellcheck: "false", readonly: "" },
                                    domProps: { value: t.infos_document.date },
                                    on: {
                                        input: function (e) {
                                            e.target.composing || t.$set(t.infos_document, "date", e.target.value);
                                        },
                                    },
                                }),
                            ]),
                            s("div", { staticClass: "DocumentTextBox" }, [
                                s("div", { staticClass: "DocumentTextTitleBox" }, [
                                    s("input", {
                                        directives: [{ name: "model", rawName: "v-model", value: t.infos_document.title, expression: "infos_document.title" }],
                                        staticClass: "DocumentTextTitle",
                                        attrs: { type: "text", spellcheck: "false", readonly: "" },
                                        domProps: { value: t.infos_document.title },
                                        on: {
                                            input: function (e) {
                                                e.target.composing || t.$set(t.infos_document, "title", e.target.value);
                                            },
                                        },
                                    }),
                                ]),
                                s("div", { staticClass: "DocumentTextLiteralBox" }, [
                                    s("textarea", {
                                        directives: [{ name: "model", rawName: "v-model", value: t.infos_document.text, expression: "infos_document.text" }],
                                        ref: "teste",
                                        staticClass: "DocumentTextLiteral",
                                        attrs: { spellcheck: "false", readonly: "" },
                                        domProps: { value: t.infos_document.text },
                                        on: {
                                            input: [
                                                function (e) {
                                                    e.target.composing || t.$set(t.infos_document, "text", e.target.value);
                                                },
                                                t.autoResize,
                                            ],
                                        },
                                    }),
                                ]),
                            ]),
                        ]),
                        s(
                            "div",
                            { staticClass: "DocumentPageBox" },
                            [
                                t._m(2),
                                t._m(3),
                                t._l(t.infos_document.images, function (t, e) {
                                    return s("div", { key: e, staticClass: "DocumentImagesBox" }, [s("img", { staticClass: "DocumentImages", attrs: { src: t, alt: "" } }), s("p")]);
                                }),
                            ],
                            2
                        ),
                        s("div", { staticClass: "DocumentPageBox" }, [
                            t._m(4),
                            t._m(5),
                            s(
                                "div",
                                { staticClass: "DocumentAllAsignsBox" },
                                t._l(t.infos_document.signatures, function (e, a) {
                                    return s("div", { key: a, staticClass: "DocumentAsignBox" }, [
                                        s("input", {
                                            directives: [{ name: "model", rawName: "v-model", value: e.asign, expression: "item.asign" }],
                                            staticClass: "DocumentAsign",
                                            attrs: { type: "text", spellcheck: "false", readonly: "" },
                                            domProps: { value: e.asign },
                                            on: {
                                                input: function (s) {
                                                    s.target.composing || t.$set(e, "asign", s.target.value);
                                                },
                                            },
                                        }),
                                        s("input", {
                                            directives: [{ name: "model", rawName: "v-model", value: e.info, expression: "item.info" }],
                                            staticClass: "DocumentInfoAsign",
                                            attrs: { type: "text", spellcheck: "false", readonly: "" },
                                            domProps: { value: e.info },
                                            on: {
                                                input: function (s) {
                                                    s.target.composing || t.$set(e, "info", s.target.value);
                                                },
                                            },
                                        }),
                                    ]);
                                }),
                                0
                            ),
                        ]),
                    ]),
                ]);
            },
            x = [
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageHeaderBox" }, [s("img", { staticClass: "PageHeaderImage", attrs: { src: "img/canto.png", alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        s = t._self._c || e;
                    return s("div", { staticClass: "PageFooterBox" }, [s("img", { staticClass: "PageFooterImage", attrs: { src: "img/rodape.png", alt: "" } })]);
                },
            ],
            D = {
                props: { infos_document: {}, logo: {}, translate: {}, NameResource: {}, close: {} },
                data: function () {
                    return {};
                },
                methods: {
                    autoResize: function () {
                        var t = this.$refs.teste;
                        t.style.height = t.scrollHeight + "px";
                    },
                },
                mounted: function () {
                    this.autoResize();
                },
            },
            I = D,
            B = Object(m["a"])(I, C, x, !1, null, null, null),
            T = B.exports,
            E = {
                name: "App",
                components: { Document: g, Edit: h, ViewDocument: T },
                data: function () {
                    return {
                        page: "",
                        infos_document: {
                            date: "تاریخ",
                            title: "عنوان",
                            text:
                                "",
                            images: [],
                            signatures: [],
                        },
                        logo: "img/LegendaryBanner.png",
                        translate: {
                            TR_TITLE: "Judiciary Legendary",
                            TR_EXIT: "Exit",
                            TR_CREATE: "Create",
                            TR_SAVE: "Save",
                            TR_CANCEL: "Cancel",
                            TR_ADD: "+ Signature",
                            TR_REMOVE: "- Signature",
                            TR_INSERT: "Click to insert a image",
                            TR_BUTTON_INSERT: "INSERT",
                            TR_EXAMPLE_NAME: "Example Name",
                            TR_EXAMPLE_INFO: "Example Info",
                        },
                        NameResource: "Documents",
                        openned: !1,
                        creating: !1,
                    };
                },
                methods: {
                    OpenScreen: function (t) {
                        this.page = t;
                    },
                    close: function () {
                        fetch("https://".concat(this.NameResource, "/close"), { method: "POST", body: JSON.stringify({}) }), (this.page = ""), (this.openned = !1);
                    },
                    keyPress: function (t) {
                        var e = t.key;
                        "Escape" == e && this.close();
                    },
                    receiveLua: function (t) {
                        if (t && t.data) {
                            var e = t.data;
                            e.config
                                ? ((this.translate = e.translate), (this.NameResource = e.NameResource), (this.logo = e.logo))
                                : e.openCreateModel
                                ? ((this.openned = !0), this.OpenScreen("Document"), (this.creating = !0))
                                : e.openCreateDocument
                                ? ((this.openned = !0), (this.infos_document = e.infos_document), this.OpenScreen("Edit"), (this.creating = !0))
                                : e.openEditModel || e.openEditDocument
                                ? ((this.openned = !0), (this.infos_document = e.infos_document), this.OpenScreen("Edit"), (this.creating = !1))
                                : e.openViewDocument && ((this.openned = !0), (this.infos_document = e.infos_document), this.OpenScreen("ViewDocument"), (this.creating = !1));
                        }
                    },
                },
                created: function () {
                    window.addEventListener("message", this.receiveLua), window.addEventListener("keydown", this.keyPress);
                },
                destroyed: function () {
                    window.removeEventListener("message", this.receiveLua), window.removeEventListener("keydown", this.keyPress);
                },
            },
            P = E,
            R = (s("034f"), Object(m["a"])(P, n, i, !1, null, null, null)),
            y = R.exports;
        (a["a"].config.productionTip = !1),
            new a["a"]({
                render: function (t) {
                    return t(y);
                },
            }).$mount("#app");
    },
    "85ec": function (t, e, s) {},
});

// create date shamsi and miladi
const GetDate = ()=>{
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    
    today = yyyy + '/' + mm + '/' + dd;

    return today;
}

function div(a, b) {
    return parseInt((a / b));
}
function gregorian_to_jalali(g_y, g_m, g_d) {
    var g_days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var j_days_in_month = [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];
    var jalali = [];
    var gy = g_y - 1600;
    var gm = g_m - 1;
    var gd = g_d - 1;
 
    var g_day_no = 365 * gy + div(gy + 3, 4) - div(gy + 99, 100) + div(gy + 399, 400);
 
    for (var i = 0; i < gm; ++i)
        g_day_no += g_days_in_month[i];
    if (gm > 1 && ((gy % 4 == 0 && gy % 100 != 0) || (gy % 400 == 0)))
        /* leap and after Feb */
        g_day_no++;
    g_day_no += gd;
 
    var j_day_no = g_day_no - 79;
 
    var j_np = div(j_day_no, 12053);
    /* 12053 = 365*33 + 32/4 */
    j_day_no = j_day_no % 12053;
 
    var jy = 979 + 33 * j_np + 4 * div(j_day_no, 1461);
    /* 1461 = 365*4 + 4/4 */
 
    j_day_no %= 1461;
 
    if (j_day_no >= 366) {
        jy += div(j_day_no - 1, 365);
        j_day_no = (j_day_no - 1) % 365;
    }
    for (var i = 0; i < 11 && j_day_no >= j_days_in_month[i]; ++i)
        j_day_no -= j_days_in_month[i];
    var jm = i + 1;
    var jd = j_day_no + 1;
    jalali[0] = jy;
    jalali[1] = jm;
    jalali[2] = jd;
    return jalali;
    //return jalali[0] + "_" + jalali[1] + "_" + jalali[2];
    //return jy + "/" + jm + "/" + jd;
}
function get_year_month_day(date) {
    var convertDate;
    var y = date.substr(0, 4);
    var m = date.substr(5, 2);
    var d = date.substr(8, 2);
    convertDate = gregorian_to_jalali(y, m, d);
    return convertDate;
}
function get_hour_minute_second(time) {
    var convertTime = [];
    convertTime[0] = time.substr(0, 2);
    convertTime[1] = time.substr(3, 2);
    convertTime[2] = time.substr(6, 2);
    return convertTime;
}
function convertDate(date) {
    var convertDateTime = get_year_month_day(date.substr(0, 10));
    convertDateTime = convertDateTime[0] + "/" + convertDateTime[1] + "/" + convertDateTime[2] + " " + date.substr(10);
    return convertDateTime;
}

