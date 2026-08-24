(function (t) {
    function e(e) {
        for (var i, o, r = e[0], c = e[1], l = e[2], d = 0, m = []; d < r.length; d++) (o = r[d]), Object.prototype.hasOwnProperty.call(n, o) && n[o] && m.push(n[o][0]), (n[o] = 0);
        for (i in c) Object.prototype.hasOwnProperty.call(c, i) && (t[i] = c[i]);
        u && u(e);
        while (m.length) m.shift()();
        return a.push.apply(a, l || []), s();
    }
    function s() {
        for (var t, e = 0; e < a.length; e++) {
            for (var s = a[e], i = !0, r = 1; r < s.length; r++) {
                var c = s[r];
                0 !== n[c] && (i = !1);
            }
            i && (a.splice(e--, 1), (t = o((o.s = s[0]))));
        }
        return t;
    }
    var i = {},
        n = { app: 0 },
        a = [];
    function o(e) {
        if (i[e]) return i[e].exports;
        var s = (i[e] = { i: e, l: !1, exports: {} });
        return t[e].call(s.exports, s, s.exports, o), (s.l = !0), s.exports;
    }
    (o.m = t),
        (o.c = i),
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
                for (var i in t)
                    o.d(
                        s,
                        i,
                        function (e) {
                            return t[e];
                        }.bind(null, i)
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
    var r = (window["webpackJsonp"] = window["webpackJsonp"] || []),
        c = r.push.bind(r);
    (r.push = e), (r = r.slice());
    for (var l = 0; l < r.length; l++) e(r[l]);
    var u = c;
    a.push([0, "chunk-vendors"]), s();
})({
    0: function (t, e, s) {
        t.exports = s("56d7");
    },
    "02e8": function (t, e, s) {
        t.exports = s.p + "img/sale.40347e7a.png";
    },
    "034f": function (t, e, s) {
        "use strict";
        s("85ec");
    },
    "56d7": function (t, e, s) {
        "use strict";
        s.r(e);
        s("e260"), s("e6cf"), s("cca6"), s("a79d");
        var i = s("2b0e"),
            n = function () {
                var t = this,
                    e = t.$createElement,
                    s = t._self._c || e;
                return s("div", { attrs: { id: "App" } }, [
                    s("div", { staticClass: "Notify", class: { NotifyOpenned: !t.NotifyOpenned }, style: t.styleNotify }, [t._v(t._s(t.Notify))]),
                    s("div", { staticClass: "BodyBox", class: { MarketOpenned: !t.openned }, style: t.styleBox }, [
                        s("div", { staticClass: "HeaderBox" }, [
                            s("p", { staticClass: "Title" }, [t._v(t._s(t.translate.TR_TITLE))]),
                            s("p", { staticClass: "SubTitle" }, [t._v(t._s(t.translate.TR_SUBTITLE))]),
                            s("p", { staticClass: "CloseTitle", on: { click: t.close } }, [t._v("X")]),
                        ]),
                        s("div", { staticClass: "SectionBox" }, [
                            s("div", { staticClass: "OptionsBox" }, [
                                s("p", { staticClass: "OptionsText" }, [t._v(t._s(t.translate.TR_OPTIONS_TITLE))]),
                                s("div", { staticClass: "ItemBox" }, [
                                    s("div", { staticClass: "clickOption", on: { click: t.openAnuncios } }),
                                    s("div", { staticClass: "CircleGreen" }),
                                    s("div", { staticClass: "ItemTextBox" }, [
                                        s("p", { staticClass: "ItemTitle" }, [t._v(t._s(t.translate.TR_OPTIONS_1))]),
                                        s("p", { staticClass: "ItemText" }, [t._v(t._s(t.products.length) + " " + t._s(t.translate.TR_ANNOUNCES))]),
                                    ]),
                                    t._m(0),
                                ]),
                                s("div", { staticClass: "ItemBox" }, [
                                    s("div", { staticClass: "clickOption", on: { click: t.openMyAnuncios } }),
                                    s("div", { staticClass: "CircleRed" }),
                                    s("div", { staticClass: "ItemTextBox" }, [
                                        s("p", { staticClass: "ItemTitle" }, [t._v(t._s(t.translate.TR_OPTIONS_2))]),
                                        s("p", { staticClass: "ItemText" }, [
                                            t._v(
                                                t._s(
                                                    t.products.filter(function (e) {
                                                        return e.identifier == t.myIdentifier;
                                                    }).length
                                                ) +
                                                    " " +
                                                    t._s(t.translate.TR_ANNOUNCES)
                                            ),
                                        ]),
                                        
                                        
                                    ]),
                                    t._m(1),
                                ]),
                            ]),
                            s(
                                "div",
                                { staticClass: "ContentBox" },
                                [
                                    "Anuncios" == t.page
                                        ? s("Anuncios", { attrs: { products: t.products, translate: t.translate, NameResource: t.NameResource } })
                                        : "MyAnuncios" == t.page
                                        ? s("MyAnuncios", { attrs: { myProducts: t.myProducts, inventory: t.inventory, translate: t.translate, NameResource: t.NameResource } })
                                        : t._e(),
                                ],
                                1
                            ),
                        ]),
                    ]),
                ]);
            },
            a = [
                function () {
                    var t = this,
                        e = t.$createElement,
                        i = t._self._c || e;
                    return i("div", { staticClass: "ItemImageBox" }, [i("img", { staticClass: "ItemImage", attrs: { src: s("02e8"), alt: "" } })]);
                },
                function () {
                    var t = this,
                        e = t.$createElement,
                        i = t._self._c || e;
                    return i("div", { staticClass: "ItemImageBox" }, [i("img", { staticClass: "ItemImage", attrs: { src: s("5926"), alt: "" } })]);
                },
            ],
            o =
                (s("99af"),
                s("b0c0"),
                s("d3b7"),
                function () {
                    var t = this,
                        e = t.$createElement,
                        i = t._self._c || e;
                    return i("div", { staticClass: "AnunciosBox" }, [
                        t.isLoading
                            ? i("div", { staticClass: "loader color-green" })
                            : i("div", [
                                  t.inProduct
                                      ? t._e()
                                      : i("div", { staticClass: "SearchBox" }, [
                                            i("img", { staticClass: "SearchImage", attrs: { src: s("bbc5") } }),
                                            i("input", {
                                                directives: [{ name: "model", rawName: "v-model", value: t.search, expression: "search" }],
                                                staticClass: "SearchInput",
                                                attrs: { type: "text", placeholder: t.translate.TR_SEARCH },
                                                domProps: { value: t.search },
                                                on: {
                                                    input: function (e) {
                                                        e.target.composing || (t.search = e.target.value);
                                                    },
                                                },
                                            }),
                                        ]),
                                  t.inProduct
                                      ? i("div", { staticClass: "BuyBox" }, [
                                            i("div", { staticClass: "InfoProductBox" }, [
                                                i("div", { staticClass: "InfoProductImageBox" }, [i("img", { staticClass: "InfoProductImage", attrs: { src: t.product.img, alt: "" } })]),
                                                i("div", { staticClass: "InfoProductTextBox" }, [
                                                    i("div", { staticClass: "InfoProductInTextBox" }, [
                                                        i("p", { staticClass: "InfoProductName" }, [t._v(t._s(t.product.name))]),
                                                        i("p", { staticClass: "InfoProductAmount" }, [t._v(t._s(t.translate.TR_WEIGHT) + " " + t._s(t.product.weight))]),
                                                        i("p", { staticClass: "InfoProductAmount" }, [t._v(t._s(t.translate.TR_DISPONIBLE) + " " + t._s(t.product.amount) + " " + t._s(t.translate.TR_UNITS))]),
                                                        // i("p", { staticClass: "InfoProductOwner" }, [t._v(t._s(t.translate.TR_BY_OWNER) + " " + t._s(t.product.owner))]),
                                                    ]),
                                                    i("div", { staticClass: "InfoProductPriceBox" }, [
                                                        i("p", { staticClass: "InfoProductPrice" }, [t._v(t._s(t.translate.TR_SIMBOL_MONEY) + " " + t._s(t.product.price) + " " + t._s(t.translate.TR_UNITS2))]),
                                                    ]),
                                                ]),
                                            ]),
                                            i("div", { staticClass: "NeedsBox" }, [
                                                i("div", { staticClass: "NeedsInfoBox" }, [
                                                    i("div", { staticClass: "NeedsAmountBox" }, [
                                                        i("p", { staticClass: "NeedsInfoTextAmount" }, [t._v(t._s(t.translate.TR_MODAL_AMOUNT))]),
                                                        i("input", {
                                                            directives: [{ name: "model", rawName: "v-model", value: t.amountBuy, expression: "amountBuy" }],
                                                            staticClass: "NeedsInfoInputAmount",
                                                            attrs: { type: "number", min: "0" },
                                                            domProps: { value: t.amountBuy },
                                                            on: {
                                                                input: function (e) {
                                                                    e.target.composing || (t.amountBuy = e.target.value);
                                                                },
                                                            },
                                                        }),
                                                    ]),
                                                    i("div", { staticClass: "NeedsPriceBox" }, [
                                                        i("p", { staticClass: "TotalPrice" }, [t._v(t._s(t.translate.TR_TOTAL_PRICE))]),
                                                        i("p", { staticClass: "ValueTotalPrice" }, [t._v(t._s(t.translate.TR_SIMBOL_MONEY) + " " + t._s(t.amountBuy * t.product.price))]),
                                                    ]),
                                                ]),
                                                i("div", { staticClass: "NeedsButtonBox" }, [
                                                    i("p", { staticClass: "NeedsButtonBuy", on: { click: t.buyItemuwu } }, [t._v(t._s(t.translate.TR_BUTTON_BUY))]),
                                                    i("p", { staticClass: "NeedsButtonCancel", on: { click: t.cancelBuy } }, [t._v(t._s(t.translate.TR_BUTTON_CANCEL))]),
                                                ]),
                                            ]),
                                        ])
                                      : i("div", { staticClass: "ProductsBox" }, [
                                            i(
                                                "ul",
                                                { staticClass: "ProductsList" },
                                                t._l(
                                                    t.products.filter(function (e) {
                                                        return e.name.toLowerCase().includes(t.search.toLowerCase());
                                                    }),
                                                    function (e, s) {
                                                        return i("li", { key: s, staticClass: "ProductsItemBox" }, [
                                                            i("div", {
                                                                staticClass: "clickOption",
                                                                on: {
                                                                    click: function (s) {
                                                                        return t.seeProduct(e);
                                                                    },
                                                                },
                                                            }),
                                                            i("p", { staticClass: "ProductsItemName" }, [t._v(t._s(e.name) + " x" + t._s(e.amount))]),
                                                            i("img", { staticClass: "ProductsItemImage", attrs: { src: e.img, alt: "" } }),
                                                            // i("p", { staticClass: "ProductsItemOwner" }, [t._v(t._s(t.translate.TR_BY_OWNER) + " " + t._s(e.owner))]),
                                                            i("p", { staticClass: "ProductsItemPrice" }, [t._v(t._s(t.translate.TR_SIMBOL_MONEY) + " " + t._s(e.price))]),
                                                        ]);
                                                    }
                                                ),
                                                0
                                            ),
                                        ]),
                              ]),
                    ]);
                }),
            r = [],
            c = {
                props: { products: {}, translate: {}, NameResource: {} },
                data: function () {
                    return { search: "", inProduct: !1, product: {}, amountBuy: 1, isLoading: !0 };
                },
                methods: {
                    seeProduct: function (t) {
                        (this.product = t), (this.inProduct = !0);
                    },
                    cancelBuy: function () {
                        this.inProduct = !1;
                    },
                    buyItemuwu: function () {
                        this.product.amount >= this.amountBuy && this.amountBuy > 0
                            ? (fetch("https://".concat(this.NameResource, "/buyItemuwu"), { method: "POST", body: JSON.stringify({ item: this.product, selectAmount: this.amountBuy }) }), (this.inProduct = !1), (this.isLoading = !0))
                            : fetch("https://".concat(this.NameResource, "/sendNotify"), { method: "POST", body: JSON.stringify({ color: "brown", Notify: this.translate.TR_DONT_AMOUNT }) });
                    },
                    receiveLua: function (t) {
                        if (t && t.data) {
                            var e = t.data;
                            (e.open || e.Refused) && (this.isLoading = !1);
                        }
                    },
                },
                created: function () {
                    window.addEventListener("message", this.receiveLua);
                },
                destroyed: function () {
                    window.removeEventListener("message", this.receiveLua);
                },
            },
            l = c,
            u = (s("b0b0"), s("2877")),
            d = Object(u["a"])(l, o, r, !1, null, null, null),
            m = d.exports,
            A = function () {
                var t = this,
                    e = t.$createElement,
                    i = t._self._c || e;
                return i("div", { staticClass: "AnunciosBox" }, [
                    t.isLoading
                        ? i("div", { staticClass: "loader color-red" })
                        : i("div", [
                              t.inProduct
                                  ? t._e()
                                  : i("div", { staticClass: "SearchBox" }, [
                                        i("img", { staticClass: "SearchImage", attrs: { src: s("bbc5") } }),
                                        i("input", {
                                            directives: [{ name: "model", rawName: "v-model", value: t.search, expression: "search" }],
                                            staticClass: "SearchInput",
                                            attrs: { type: "text", placeholder: t.translate.TR_SEARCH },
                                            domProps: { value: t.search },
                                            on: {
                                                input: function (e) {
                                                    e.target.composing || (t.search = e.target.value);
                                                },
                                            },
                                        }),
                                    ]),
                              t.inProduct
                                  ? t._e()
                                  : i("div", { staticClass: "ProductsBox" }, [
                                        i("p", { staticClass: "ButtonRefresh", on: { click: t.DisplayModal } }, [t._v(t._s(t.translate.TR_BUTTON_ANNOUNCE))]),
                                        i(
                                            "ul",
                                            { staticClass: "ProductsList" },
                                            t._l(
                                                t.myProducts.filter(function (e) {
                                                    return e.name.toLowerCase().includes(t.search.toLowerCase());
                                                }),
                                                function (e, s) {
                                                    return i("li", { key: s, staticClass: "ProductsItemBox" }, [
                                                        i("div", { staticClass: "DeleteBox" }, [
                                                            i("img", {
                                                                staticClass: "DeleteImage",
                                                                attrs: { src: "img/delete.png", alt: "" },
                                                                on: {
                                                                    click: function (s) {
                                                                        return t.removeItem(e);
                                                                    },
                                                                },
                                                            }),
                                                            i("p", { staticClass: "DeleteText" }, [t._v(t._s(t.translate.TR_BUTTON_REMOVE))]),
                                                        ]),
                                                        i("p", { staticClass: "ProductsItemName" }, [t._v(t._s(e.name) + " x" + t._s(e.amount))]),
                                                        i("img", { staticClass: "ProductsItemImage", attrs: { src: e.img, alt: "" } }),
                                                        // i("p", { staticClass: "ProductsItemOwner" }, [t._v(t._s(t.translate.TR_BY_OWNER) + " " + t._s(e.owner))]),
                                                        i("p", { staticClass: "ProductsItemPrice" }, [t._v(t._s(t.translate.TR_SIMBOL_MONEY) + " " + t._s(e.price))]),
                                                    ]);
                                                }
                                            ),
                                            0
                                        ),
                                    ]),
                              t.modalOpenned
                                  ? i("div", { staticClass: "modalBox" }, [
                                        i("p", { staticClass: "modalTitle" }, [t._v(t._s(t.translate.TR_MODAL_TITLE))]),
                                        i("div", { staticClass: "formBox" }, [
                                            i("div", { staticClass: "cellBox" }, [
                                                i("label", { attrs: { for: "cellItem" } }, [t._v(t._s(t.translate.TR_MODAL_ITEM))]),
                                                i(
                                                    "select",
                                                    {
                                                        directives: [{ name: "model", rawName: "v-model", value: t.selectedItem, expression: "selectedItem" }],
                                                        attrs: { name: "", id: "cellItem" },
                                                        on: {
                                                            change: [
                                                                function (e) {
                                                                    var s = Array.prototype.filter
                                                                        .call(e.target.options, function (t) {
                                                                            return t.selected;
                                                                        })
                                                                        .map(function (t) {
                                                                            var e = "_value" in t ? t._value : t.value;
                                                                            return e;
                                                                        });
                                                                    t.selectedItem = e.target.multiple ? s : s[0];
                                                                },
                                                                function (e) {
                                                                    return t.changePrice();
                                                                },
                                                            ],
                                                        },
                                                    },
                                                    t._l(t.inventory, function (e, s) {
                                                        return i("option", { key: s, domProps: { value: e } }, [t._v(t._s(e.name))]);
                                                    }),
                                                    0
                                                ),
                                            ]),
                                            i("div", { staticClass: "cellBox" }, [
                                                i("label", { attrs: { for: "cellAmount" } }, [t._v(t._s(t.translate.TR_MODAL_AMOUNT))]),
                                                i("input", {
                                                    directives: [{ name: "model", rawName: "v-model", value: t.amountItem, expression: "amountItem" }],
                                                    staticClass: "cellItem",
                                                    attrs: { type: "number", min: "0", step: "1", id: "cellAmount" },
                                                    domProps: { value: t.amountItem },
                                                    on: {
                                                        input: function (e) {
                                                            e.target.composing || (t.amountItem = e.target.value);
                                                        },
                                                    },
                                                }),
                                            ]),
                                            i("div", { staticClass: "cellBox" }, [
                                                i("label", { attrs: { for: "cellPrice" } }, [t._v(t._s(t.translate.TR_MODAL_PRICE))]),
                                                i("input", {
                                                    directives: [{ name: "model", rawName: "v-model", value: t.priceItem, expression: "priceItem" }],
                                                    staticClass: "cellItem",
                                                    attrs: { type: "number", min: "0", id: "cellPrice" },
                                                    domProps: { value: t.priceItem },
                                                    on: {
                                                        input: function (e) {
                                                            e.target.composing || (t.priceItem = e.target.value);
                                                        },
                                                    },
                                                }),
                                            ]),
                                            // برای لاگ دیسکورد پلیر ها
                                            // i("div", { staticClass: "cellCheckBox" }, [
                                            //     i("label", { attrs: { for: "cellAnonymous" } }, [t._v(t._s(t.translate.TR_MODAL_ANONYMOUS))]),
                                            //     i("input", {
                                            //         directives: [{ name: "model", rawName: "v-model", value: t.anonymous, expression: "anonymous" }],
                                            //         staticClass: "cellAnonymous",
                                            //         attrs: { type: "checkbox", id: "cellAnonymous", placeholder: "Anonymous" },
                                            //         domProps: { checked: Array.isArray(t.anonymous) ? t._i(t.anonymous, null) > -1 : t.anonymous },
                                            //         on: {
                                            //             change: function (e) {
                                            //                 var s = t.anonymous,
                                            //                     i = e.target,
                                            //                     n = !!i.checked;
                                            //                 if (Array.isArray(s)) {
                                            //                     var a = null,
                                            //                         o = t._i(s, a);
                                            //                     i.checked ? o < 0 && (t.anonymous = s.concat([a])) : o > -1 && (t.anonymous = s.slice(0, o).concat(s.slice(o + 1)));
                                            //                 } else t.anonymous = n;
                                            //             },
                                            //         },
                                            //     }),
                                            // ]),
                                            i("div", { staticClass: "formButtonBox" }, [
                                                i("p", { staticClass: "NeedsButtonBuy", on: { click: t.anunciarItemuwu } }, [t._v(t._s(t.translate.TR_BUTTON_ANNOUNCE))]),
                                                i(
                                                    "p",
                                                    {
                                                        staticClass: "NeedsButtonCancel",
                                                        on: {
                                                            click: function (e) {
                                                                return t.DisplayModal(!1);
                                                            },
                                                        },
                                                    },
                                                    [t._v(t._s(t.translate.TR_BUTTON_CANCEL))]
                                                ),
                                            ]),
                                        ]),
                                    ])
                                  : t._e(),
                          ]),
                ]);
            },
            p = [],
            g =
                (s("a9e3"),
                {
                    props: { myProducts: {}, inventory: {}, translate: {}, NameResource: {} },
                    data: function () {
                        return { search: "", modalOpenned: !1, selectedItem: "", amountItem: 1, priceItem: 0, anonymous: !1, isLoading: !0 };
                    },
                    methods: {
                        changePrice: function () {
                            (this.priceItem = this.selectedItem.price_recommended), (this.amountItem = 1);
                        },
                        anunciarItemuwu: function () {
                            this.selectedItem.name &&
                                this.amountItem &&
                                this.priceItem &&
                                (this.selectedItem.amount >= this.amountItem && this.amountItem > 0 && Number(this.priceItem) >= 0 && Number(this.priceItem) <= 999999999
                                    ? (fetch("https://".concat(this.NameResource, "/anunciarItemuwu"), {
                                          method: "POST",
                                          body: JSON.stringify({ item: { name: this.selectedItem.name, weight: this.selectedItem.weight, amount: this.amountItem, price: this.priceItem }, anonymous: this.anonymous }),
                                      }),
                                      this.DisplayModal(!1),
                                      (this.isLoading = !0))
                                    : fetch("https://".concat(this.NameResource, "/sendNotify"), { method: "POST", body: JSON.stringify({ color: "brown", Notify: this.translate.TR_DONT_AMOUNT2 }) }));
                        },
                        DisplayModal: function (t) {
                            this.modalOpenned = t;
                        },
                        removeItem: function (t) {
                            fetch("https://".concat(this.NameResource, "/removeItem"), { method: "POST", body: JSON.stringify({ item: t }) }), (this.isLoading = !0);
                        },
                        receiveLua: function (t) {
                            if (t && t.data) {
                                var e = t.data;
                                (e.myProductsOpen || e.Refused) && (this.isLoading = !1);
                            }
                        },
                    },
                    created: function () {
                        window.addEventListener("message", this.receiveLua);
                    },
                    destroyed: function () {
                        window.removeEventListener("message", this.receiveLua);
                    },
                }),
            f = g,
            v = (s("b671"), Object(u["a"])(f, A, p, !1, null, null, null)),
            C = v.exports,
            h = {
                components: { Anuncios: m, MyAnuncios: C },
                data: function () {
                    return {
                        products: [
                            { id: 1, name: "Mochila", owner: "zFightx", identifier: "123", amount: 10, price: 75, img: "/img/backpack.png" },
                            { id: 1, name: "Mochila", owner: "zFightx", identifier: "", amount: 5, price: 75, img: "/img/backpack.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                            { id: 1, name: "Pão caseiro", owner: "zFightx", identifier: "", amount: 150, price: 50, img: "/img/bread.png" },
                        ],
                        myProducts: [],
                        inventory: [],
                        styleBox: { left: "50%", top: "50%", transform: "scale(1.0) translate(-50%, -50%)" },
                        styleNotify: { backgroundColor: "green" },
                        translate: {
                            TR_TITLE: "Market",
                            TR_SUBTITLE: "Item Baraye Kharid Va Frosh",
                            TR_OPTIONS_TITLE: "Bazare Entekhabi",
                            TR_OPTIONS_1: "Tablighat:",
                            TR_OPTIONS_2: "My Items:",
                            TR_ANNOUNCES: "Tablighat",
                            TR_SEARCH: "Search",
                            TR_BY_OWNER: "By:",
                            TR_SIMBOL_MONEY: "$ ",
                            TR_WEIGHT: "Vazn:",
                            TR_DISPONIBLE: "Mojood:",
                            TR_UNITS: "",
                            TR_UNITS2: "",
                            TR_TOTAL_PRICE: "Gheymat:",
                            TR_BUTTON_BUY: "Kharid",
                            TR_BUTTON_ANNOUNCE: "Announce",
                            TR_BUTTON_REMOVE: "Delete",
                            TR_BUTTON_CANCEL: "Cancel",
                            TR_MODAL_TITLE: "Tabligh mahsoul",
                            TR_MODAL_ITEM: "Item",
                            TR_MODAL_AMOUNT: "Meghdar",
                            TR_MODAL_PRICE: "Gheymat Har Vahed",
                            TR_MODAL_ANONYMOUS: "Nashenas",
                            TR_DONT_FULL: "Inventory Shoma Por Ast.",
                            TR_DONT_MONEY: "Shoma pool kafi nadarid.",
                            TR_SUCESS: "Kharid Movafagyat Amiz bod",
                            TR_REMOVED_ITEM: "Item Ba Movafaghiyat Hazf Shod",
                            TR_DONT_AMOUNT: "Inghadr Item Baraye Forush Vojud Nadarad.",
                            TR_NOT_FOUND: "Item Ghablan Forukhte Shode Ya Peyda Nashod.",
                            TR_ADVERTISE_ITEM: "Item Ba Movafaghiyat Elam Shod.",
                            TR_DONT_AMOUNT2: "Shoma In Meghdar Ra Nadarid.",
                        },
                        myIdentifier: "123",
                        page: "Anuncios",
                        waitScreen: !1,
                        NameResource: "uwumarket",
                        openned: !1,
                        Notify: "Você comprou Mochila x10",
                        NotifyOpenned: !1,
                    };
                },
                methods: {
                    openScreen: function (t) {
                        this.waitScreen || ((this.page = t), (this.waitScreen = !0), setTimeout(this.freeScreen, 1e3));
                    },
                    openAnuncios: function () {
                        this.openScreen("Anuncios"), fetch("https://".concat(this.NameResource, "/loaduwuAnuncios"), { method: "POST", body: JSON.stringify({}) });
                    },
                    openMyAnuncios: function () {
                        this.openScreen("MyAnuncios"), fetch("https://".concat(this.NameResource, "/loadMyAnunciosuwu"), { method: "POST", body: JSON.stringify({}) });
                    },
                    freeScreen: function () {
                        this.waitScreen = !1;
                    },
                    disableNotify: function () {
                        (this.NotifyOpenned = !1), (this.Notify = "");
                    },
                    close: function () {
                        fetch("https://".concat(this.NameResource, "/close"), { method: "POST", body: JSON.stringify({}) }), (this.openned = !1);
                    },
                    keyPress: function (t) {
                        var e = t.key;
                        "Escape" == e && this.close();
                    },
                    receiveLua: function (t) {
                        if (t && t.data) {
                            var e = t.data;
                            if (e.config)
                                (this.translate = e.translate),
                                    (this.styleBox.left = e.config.left),
                                    (this.styleBox.top = e.config.top),
                                    (this.styleBox.transform = "scale(".concat(e.config.size, ") transform(-").concat(e.config.left, ", -").concat(e.config.top, ")")),
                                    (this.NameResource = e.NameResource);
                            else if (e.Notify) (this.Notify = e.Notify), (this.styleNotify.backgroundColor = e.color), (this.NotifyOpenned = !0), setTimeout(this.disableNotify, 5e3);
                            else if (e.open) {
                                if (((this.products = e.products), (this.myIdentifier = e.identifier), e.products && e.list_products))
                                    for (var s = 0; s < this.products.length; s++) for (var i = 0; i < e.list_products.length; i++) this.products[s].name == e.list_products[i].label && (this.products[s].img = e.list_products[i].img);
                                this.openned = !0;
                            } else if (e.myProductsOpen && ((this.myProducts = e.myProducts), (this.inventory = e.inventory), e.myProducts && e.list_products)) {
                                for (var n = 0; n < this.myProducts.length; n++) for (var a = 0; a < e.list_products.length; a++) this.myProducts[n].name == e.list_products[a].label && (this.myProducts[n].img = e.list_products[a].img);
                                for (var o = 0; o < this.inventory.length; o++)
                                    for (var r = 0; r < e.list_products.length; r++) this.inventory[o].name == e.list_products[r].label && (this.inventory[o].price_recommended = e.list_products[r].price_recommended);
                            }
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
            y = h,
            T = (s("034f"), Object(u["a"])(y, n, a, !1, null, null, null)),
            I = T.exports;
        (i["a"].config.productionTip = !1),
            new i["a"]({
                render: function (t) {
                    return t(I);
                },
            }).$mount("#app");
    },
    5926: function (t, e) {
        t.exports =
            "data:image/png;base64,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";
    },
    "85ec": function (t, e, s) {},
    "9af4": function (t, e, s) {},
    b0b0: function (t, e, s) {
        "use strict";
        s("9af4");
    },
    b671: function (t, e, s) {
        "use strict";
        s("d50c");
    },
    bbc5: function (t, e) {
        t.exports =
            "data:image/png;base64,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";
    },
    d50c: function (t, e, s) {},
});
//# sourceMappingURL=app.4d977997.js.map
