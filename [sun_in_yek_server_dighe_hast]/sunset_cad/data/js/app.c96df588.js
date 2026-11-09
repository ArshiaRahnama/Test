(function (_) {
    function e(e) {
        for (var E, L, T = e[0], R = e[1], l = e[2], S = 0, O = []; S < T.length; S++) (L = T[S]), Object.prototype.hasOwnProperty.call(a, L) && a[L] && O.push(a[L][0]), (a[L] = 0);
        for (E in R) Object.prototype.hasOwnProperty.call(R, E) && (_[E] = R[E]);
        C && C(e);
        while (O.length) O.shift()();
        return N.push.apply(N, l || []), A();
    }
    function A() {
        for (var _, e = 0; e < N.length; e++) {
            for (var A = N[e], E = !0, T = 1; T < A.length; T++) {
                var R = A[T];
                0 !== a[R] && (E = !1);
            }
            E && (N.splice(e--, 1), (_ = L((L.s = A[0]))));
        }
        return _;
    }
    var E = {},
        a = { app: 0 },
        N = [];
    function L(e) {
        if (E[e]) return E[e].exports;
        var A = (E[e] = { i: e, l: !1, exports: {} });
        return _[e].call(A.exports, A, A.exports, L), (A.l = !0), A.exports;
    }
    (L.m = _),
        (L.c = E),
        (L.d = function (_, e, A) {
            L.o(_, e) || Object.defineProperty(_, e, { enumerable: !0, get: A });
        }),
        (L.r = function (_) {
            "undefined" !== typeof Symbol && Symbol.toStringTag && Object.defineProperty(_, Symbol.toStringTag, { value: "Module" }), Object.defineProperty(_, "__esModule", { value: !0 });
        }),
        (L.t = function (_, e) {
            if ((1 & e && (_ = L(_)), 8 & e)) return _;
            if (4 & e && "object" === typeof _ && _ && _.__esModule) return _;
            var A = Object.create(null);
            if ((L.r(A), Object.defineProperty(A, "default", { enumerable: !0, value: _ }), 2 & e && "string" != typeof _))
                for (var E in _)
                    L.d(
                        A,
                        E,
                        function (e) {
                            return _[e];
                        }.bind(null, E)
                    );
            return A;
        }),
        (L.n = function (_) {
            var e =
                _ && _.__esModule
                    ? function () {
                          return _["default"];
                      }
                    : function () {
                          return _;
                      };
            return L.d(e, "a", e), e;
        }),
        (L.o = function (_, e) {
            return Object.prototype.hasOwnProperty.call(_, e);
        }),
        (L.p = "");
    var T = (window["webpackJsonp"] = window["webpackJsonp"] || []),
        R = T.push.bind(T);
    (T.push = e), (T = T.slice());
    for (var l = 0; l < T.length; l++) e(T[l]);
    var C = R;
    N.push([0, "chunk-vendors"]), A();
})({
    0: function (_, e, A) {
        _.exports = A("56d7");
    },
    "034f": function (_, e, A) {
        "use strict";
        A("85ec");
    },
    "1f8d": function (_) {
        _.exports = JSON.parse(
            '["Code 4 - Under Control","Code 5 - Felony Stop/High Risk Stop","Code 6 - On Foot Persuit","10-1 - Return to Station","10-2 - Shot Fire","10-3 - Stop Transmitting","10-4 - Affirmative","10-5 - Repeat Last Transmission","10-8 - In Service","10-9 - Busy","10-10 - Fight in Progress","10-55 - Traffic Stop","10-15 - Subject in Custody","10-16 - Officer Down","10-20 - Location","10-21 - Status","10-22 - Visual Lost","10-23 - Standby","10-24 - ETA","10-25 - Wanted Person10-31 - Not Wanted, No Warrants","10-70 - Request Backup (Code 1-2-3)","PD: Property Damage Only","PI: Persons Injured","F: Fatal","10-66 - Persuit","10-71 - Request Detective at Scene","Code 1 - No lights or siren, follow all traffic rules - No Urgency at all.","Code 2 - Lights or siren limited use to respond to a scene - Urgent but not severe.","Code 3 - Lights and sirens full use to respond quickly - Urgent."]'
        );
    },
    "388f": function (_) {
        _.exports = JSON.parse(
            '[{"code":"1.1","name":"","fulltext":"","price":200}]'
        );
    },
    "56d7": function (_, e, A) {
        "use strict";
        A.r(e);
        A("e260"), A("e6cf"), A("cca6"), A("a79d");
        var E = A("2b0e"),
            a = function () {
                var _ = this,
                    e = _.$createElement,
                    A = _._self._c || e;
                return A("div", { attrs: { id: "app" } }, ["PoliceCad" == _.showPage ? A("PoliceCad", { attrs: { playerData: _.playerData } }) : _._e()], 1);
            },
            N = [],
            L =
                (A("b0c0"),
                function () {
                    var _ = this,
                        e = _.$createElement,
                        A = _._self._c || e;
                    return A(
                        "section",
                        { staticClass: "police_cad fullpage" },
                        [
                            A("transition", { attrs: { name: "pad" } }, [
                                A("div", { directives: [{ name: "show", rawName: "v-show", value: _.show, expression: "show" }], staticClass: "pad_outer" }, [
                                    A("div", { staticClass: "pad_inner" }, [
                                        A(
                                            "div",
                                            { staticClass: "pad" },
                                            [
                                                A("transition", { attrs: { name: "transition_03" } }, [
                                                    A("div", { directives: [{ name: "show", rawName: "v-show", value: 0 == _.logged, expression: "logged == 0" }], staticClass: "page page_0" }, [
                                                        A("div", { staticClass: "logo" }),
                                                        A("h2", { domProps: { textContent: _._s(_.$ml.get("cad_name")) } }, [_._v("SAN-ANDREAS CAD")]),
                                                        A("button", { staticClass: "btn btn-login", domProps: { textContent: _._s(_.$ml.get("button_enter")) }, on: { click: _.login } }, [_._v(" Вход ")]),
                                                        A("h5", { domProps: { textContent: _._s(_.$ml.get("cad_slogan")) } }, [_._v("TO PROTECT AND TO SERVE")]),
                                                    ]),
                                                ]),
                                                A("div", { staticClass: "page page_loader" }, [
                                                    A("div", { staticClass: "preloader-1" }, [
                                                        A("h3", { staticClass: "text-center", domProps: { textContent: _._s(_.$ml.get("cad_loading")) } }, [_._v("Загрузка")]),
                                                        A("span", { staticClass: "line line-1" }),
                                                        A("span", { staticClass: "line line-2" }),
                                                        A("span", { staticClass: "line line-3" }),
                                                        A("span", { staticClass: "line line-4" }),
                                                        A("span", { staticClass: "line line-5" }),
                                                        A("span", { staticClass: "line line-6" }),
                                                        A("span", { staticClass: "line line-7" }),
                                                        A("span", { staticClass: "line line-8" }),
                                                        A("span", { staticClass: "line line-9" }),
                                                    ]),
                                                ]),
                                                A("transition", { attrs: { name: "transition_03" } }, [
                                                    A("div", { directives: [{ name: "show", rawName: "v-show", value: 2 == _.logged, expression: "logged == 2" }], staticClass: "page page_1" }, [
                                                        A("div", { staticClass: "top_bar" }, [
                                                            A("div", { staticClass: "row" }, [
                                                                A("div", { staticClass: "col-3 d-flex justify-content-start align-items-center" }, [A("div", { staticClass: "logo" })]),
                                                                A("div", { staticClass: "col-6 d-flex justify-content-center align-items-center" }, [
                                                                    A("h2", { domProps: { textContent: _._s(_.$ml.get("cad_fullname")) } }, [_._v("Computer-Aided Dispatching")]),
                                                                ]),
                                                                A("div", { staticClass: "col-3 d-flex justify-content-end align-items-center" }, [
                                                                    A("button", { staticClass: "btn btn-gold btn-close", domProps: { textContent: _._s(_.$ml.get("button_exit")) }, on: { click: _.closeCad } }, [_._v("Выход")]),
                                                                ]),
                                                            ]),
                                                        ]),
                                                        A("div", { staticClass: "content" }, [
                                                            A("div", { staticClass: "left_block" }, [
                                                                A("div", { staticClass: "player_info" }, [
                                                                    A("button", { class: ["onDuty_" + this.policeData.onDuty + " btn-shift hover-shift"] }),
                                                                    A("div", { staticClass: "d-flex justify-content-center" }, [A("h3", [_._v(_._s(this.playerData.name))])]),
                                                                   // A("h4", [_._v(_._s(this.policeData.rank) + " (" + _._s(this.policeData.callsign) + ")")]),
                                                                   A("h4", [_._v(_._s(this.policeData.rank) + "")]),
                                                                ]),
                                                                A("ul", { staticClass: "list-group" }, [
                                                                    A(
                                                                        "li",
                                                                        {
                                                                            staticClass: "list-group-item",
                                                                            class: { active: 0 == _.activeMenu },
                                                                            domProps: { textContent: _._s(_.$ml.get("main_button_1")) },
                                                                            on: {
                                                                                click: function (e) {
                                                                                    return _.selectMenu(0);
                                                                                },
                                                                            },
                                                                        },
                                                                        [_._v("Основная панель")]
                                                                    ),
                                                                    // A(
                                                                    //     "li",
                                                                    //     {
                                                                    //         staticClass: "list-group-item",
                                                                    //         class: { active: 1 == _.activeMenu },
                                                                    //         domProps: { textContent: _._s(_.$ml.get("main_button_2")) },
                                                                    //         on: {
                                                                    //             click: function (e) {
                                                                    //                 return _.selectMenu(1);
                                                                    //             },
                                                                    //         },
                                                                    //     },
                                                                    //     [_._v("Вызовы")]
                                                                    // ),
                                                                    A(
                                                                        "li",
                                                                        {
                                                                            staticClass: "list-group-item",
                                                                            class: { active: 2 == _.activeMenu },
                                                                            domProps: { textContent: _._s(_.$ml.get("main_button_3")) },
                                                                            on: {
                                                                                click: function (e) {
                                                                                    return _.selectMenu(2);
                                                                                },
                                                                            },
                                                                        },
                                                                        [_._v("База жителей")]
                                                                    ),
                                                                    A(
                                                                        "li",
                                                                        {
                                                                            staticClass: "list-group-item",
                                                                            class: { active: 3 == _.activeMenu },
                                                                            domProps: { textContent: _._s(_.$ml.get("main_button_4")) },
                                                                            on: {
                                                                                click: function (e) {
                                                                                    return _.selectMenu(3);
                                                                                },
                                                                            },
                                                                        },
                                                                        [_._v("База автомобилей")]
                                                                    ),
                                                                    A(
                                                                        "li",
                                                                        {
                                                                            staticClass: "list-group-item",
                                                                            class: { active: 4 == _.activeMenu },
                                                                            domProps: { textContent: _._s(_.$ml.get("main_button_5")) },
                                                                            on: {
                                                                                click: function (e) {
                                                                                    return _.selectMenu(4);
                                                                                },
                                                                            },
                                                                        },
                                                                        [_._v("База автомобилей")]
                                                                    ),
                                                                    // A(
                                                                    //     "li",
                                                                    //     {
                                                                    //         staticClass: "list-group-item",
                                                                    //         class: { active: 4 == _.activeMenu },
                                                                    //         domProps: { textContent: _._s(_.$ml.get("main_button_5")) },
                                                                    //         on: {
                                                                    //             click: function (e) {
                                                                    //                 return _.selectMenu(4);
                                                                    //             },
                                                                    //         },
                                                                    //     },
                                                                    //     [_._v("Законы штата")]
                                                                    // ),
                                                                    A(
                                                                        "li",
                                                                        {
                                                                            staticClass: "list-group-item",
                                                                            class: { active: 5 == _.activeMenu },
                                                                            domProps: { textContent: _._s(_.$ml.get("main_button_6")) },
                                                                            on: {
                                                                                click: function (e) {
                                                                                    return _.selectMenu(5);
                                                                                },
                                                                            },
                                                                        },
                                                                        [_._v("10-коды")]
                                                                    ),
                                                                    this.policeData.rank >= _.rankAdmin
                                                                        ? A(
                                                                              "li",
                                                                              {
                                                                                  staticClass: "list-group-item",
                                                                                  class: { active: 6 == _.activeMenu },
                                                                                  domProps: { textContent: _._s(_.$ml.get("main_button_7")) },
                                                                                  on: {
                                                                                      click: function (e) {
                                                                                          return _.selectMenu(6);
                                                                                      },
                                                                                  },
                                                                              },
                                                                              [_._v("Управление")]
                                                                          )
                                                                        : _._e(),
                                                                ]),
                                                                // A("div", { staticClass: "bottom_block" }, [
                                                                //     A(
                                                                //         "div",
                                                                //         { staticClass: "onDuty_buttons" },
                                                                //         [
                                                                //             A("b-button", {
                                                                //                 directives: [{ name: "b-tooltip", rawName: "v-b-tooltip.hover.top", modifiers: { hover: !0, top: !0 } }],
                                                                //                 staticClass: "btn onDuty_1",
                                                                //                 class: { active: 1 == this.policeData.onDuty },
                                                                //                 attrs: { title: _.$ml.get("title_status_1") },
                                                                //                 on: {
                                                                //                     click: function (e) {
                                                                //                         return _.changeShift(1);
                                                                //                     },
                                                                //                 },
                                                                //             }),
                                                                //             A("b-button", {
                                                                //                 directives: [{ name: "b-tooltip", rawName: "v-b-tooltip.hover.top", modifiers: { hover: !0, top: !0 } }],
                                                                //                 staticClass: "btn onDuty_2",
                                                                //                 class: { active: 2 == this.policeData.onDuty },
                                                                //                 attrs: { title: _.$ml.get("title_status_2") },
                                                                //                 on: {
                                                                //                     click: function (e) {
                                                                //                         return _.changeShift(2);
                                                                //                     },
                                                                //                 },
                                                                //             }),
                                                                //             A("b-button", {
                                                                //                 directives: [{ name: "b-tooltip", rawName: "v-b-tooltip.hover.top", modifiers: { hover: !0, top: !0 } }],
                                                                //                 staticClass: "btn onDuty_3",
                                                                //                 class: { active: 3 == this.policeData.onDuty },
                                                                //                 attrs: { title: _.$ml.get("title_status_3") },
                                                                //                 on: {
                                                                //                     click: function (e) {
                                                                //                         return _.changeShift(3);
                                                                //                     },
                                                                //                 },
                                                                //             }),
                                                                //             A("b-button", {
                                                                //                 directives: [{ name: "b-tooltip", rawName: "v-b-tooltip.hover.top", modifiers: { hover: !0, top: !0 } }],
                                                                //                 staticClass: "btn onDuty_0",
                                                                //                 class: { active: 0 == this.policeData.onDuty },
                                                                //                 attrs: { title: _.$ml.get("title_status_4") },
                                                                //                 on: {
                                                                //                     click: function (e) {
                                                                //                         return _.changeShift(0);
                                                                //                     },
                                                                //                 },
                                                                //             }),
                                                                //         ],
                                                                //         1
                                                                //     ),
                                                                //     A(
                                                                //         "button",
                                                                //         {
                                                                //             staticClass: "btn btn-block btn-panic",
                                                                //             class: { active: _.panicOn },
                                                                //             domProps: { textContent: _._s(_.$ml.get("main_button_panic")) },
                                                                //             on: {
                                                                //                 click: function (e) {
                                                                //                     return _.panicClick();
                                                                //                 },
                                                                //             },
                                                                //         },
                                                                //         [_._v("Кнопка паники")]
                                                                //     ),
                                                                // ]),
                                                            ]),
                                                            A(
                                                                "div",
                                                                { staticClass: "center_block" },
                                                                [
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A("div", { directives: [{ name: "show", rawName: "v-show", value: 0 == _.page, expression: "page == 0" }], staticClass: "c_page c_page_1 scrolled" }, [
                                                                            A("div", { staticClass: "d-flex justify-content-between" }, [A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_1")) } }, [_._v("Основная панель")])]),
                                                                            A("div", { directives: [{ name: "show", rawName: "v-show", value: _.onPanic(), expression: "onPanic()" }], staticClass: "onduty_block_outer" }, [
                                                                                A("h5", { staticClass: "redButton", domProps: { textContent: _._s(_.$ml.get("p1_title_0")) } }, [_._v("Активный красный код")]),
                                                                                A("div", { staticClass: "onduty_block" }, [
                                                                                    A(
                                                                                        "div",
                                                                                        { staticClass: "onduty_list" },
                                                                                        _._l(_.policeDutyList, function (e, E) {
                                                                                            return A(
                                                                                                "div",
                                                                                                {
                                                                                                    directives: [{ name: "show", rawName: "v-show", value: e.onPanic, expression: "item.onPanic" }],
                                                                                                    key: "panic" + E,
                                                                                                    staticClass: "onduty_element",
                                                                                                },
                                                                                                [
                                                                                                    A("span", { staticClass: "callsign" }, [_._v(_._s(e.callsign))]),
                                                                                                    _._v(" " + _._s(e.name) + " "),
                                                                                                    A("i", { staticClass: "callsign", class: _.rankList[e.rank].shortname }),
                                                                                                ]
                                                                                            );
                                                                                        }),
                                                                                        0
                                                                                    ),
                                                                                ]),
                                                                            ]),
                                                                            // A("div", { staticClass: "onduty_block_outer" }, [
                                                                            //     A("h5", { domProps: { textContent: _._s(_.$ml.get("p1_title_1")) } }, [_._v("Сотрудники на смене")]),
                                                                            //     A("div", { staticClass: "onduty_block" }, [
                                                                            //         A(
                                                                            //             "div",
                                                                            //             { staticClass: "onduty_list" },
                                                                            //             _._l(_.showOnDuty(!0), function (e, E) {
                                                                            //                 return A("div", { key: "activeDuty_" + E, staticClass: "onduty_element" }, [
                                                                            //                     A("span", { staticClass: "callsign" }, [_._v(_._s(e.callsign))]),
                                                                            //                     _._v(" " + _._s(e.name) + " "),
                                                                            //                     A("i", { staticClass: "callsign", class: _.rankList[e.rank].shortname }),
                                                                            //                     A("i", { class: "status_" + e.onDuty }),
                                                                            //                 ]);
                                                                            //             }),
                                                                            //             0
                                                                            //         ),
                                                                            //         A(
                                                                            //             "div",
                                                                            //             { staticClass: "onduty_list" },
                                                                            //             _._l(_.showOnDuty(!1), function (e, E) {
                                                                            //                 return A("div", { key: "inactiveDuty_" + E, staticClass: "onduty_element inactive" }, [
                                                                            //                     A("span", { staticClass: "callsign" }, [_._v(_._s(e.callsign))]),
                                                                            //                     _._v(_._s(e.name) + " "),
                                                                            //                     A("i", { staticClass: "callsign", class: _.rankList[e.rank].shortname }),
                                                                            //                     A("i", { class: "status_" + e.onDuty }),
                                                                            //                 ]);
                                                                            //             }),
                                                                            //             0
                                                                            //         ),
                                                                            //     ]),
                                                                            // ]),
                                                                            // A("div", { staticClass: "onduty_block_outer" }, [
                                                                            //     A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                            //         A("h5", { domProps: { textContent: _._s(_.$ml.get("p1_title_2")) } }, [_._v(" Сотрудники в патруле")]),
                                                                            //         A("div", { staticClass: "dropdown" }, [
                                                                            //             A(
                                                                            //                 "a",
                                                                            //                 {
                                                                            //                     staticClass: "btn btn-dropdown dropdown-toggle",
                                                                            //                     on: {
                                                                            //                         click: function (e) {
                                                                            //                             return _.showDropDown(3);
                                                                            //                         },
                                                                            //                     },
                                                                            //                 },
                                                                            //                 [_._v(_._s(_.playerOnPatrol))]
                                                                            //             ),
                                                                            //             A(
                                                                            //                 "div",
                                                                            //                 { directives: [{ name: "show", rawName: "v-show", value: _.showDropdownC, expression: "showDropdownC" }], staticClass: "dropdown-menu" },
                                                                            //                 _._l(11, function (e) {
                                                                            //                     return A(
                                                                            //                         "a",
                                                                            //                         {
                                                                            //                             key: "drop_patrol" + e,
                                                                            //                             staticClass: "dropdown-item",
                                                                            //                             on: {
                                                                            //                                 click: function (A) {
                                                                            //                                     return _.changePatrolStatus(e - 1);
                                                                            //                                 },
                                                                            //                             },
                                                                            //                         },
                                                                            //                         [
                                                                            //                             1 == e ? A("span", { domProps: { textContent: _._s(_.$ml.get("p1_leave")) } }, [_._v("Покинуть")]) : _._e(),
                                                                            //                             1 != e
                                                                            //                                 ? A("span", [_._v(_._s(e - 1) + " "), A("span", { domProps: { textContent: _._s(_.$ml.get("p1_patrol")) } }, [_._v("патруль")])])
                                                                            //                                 : _._e(),
                                                                            //                         ]
                                                                            //                     );
                                                                            //                 }),
                                                                            //                 0
                                                                            //             ),
                                                                            //         ]),
                                                                            //     ]),
                                                                            //     A("div", { staticClass: "onduty_block" }, [
                                                                            //         A(
                                                                            //             "div",
                                                                            //             { staticClass: "onduty_list full" },
                                                                            //             _._l(_.policeAdamList, function (e, E) {
                                                                            //                 return A(
                                                                            //                     "div",
                                                                            //                     { directives: [{ name: "show", rawName: "v-show", value: 0 != E, expression: "index !=0" }], key: "adam" + E, staticClass: "onduty_element" },
                                                                            //                     [
                                                                            //                         A("span", { staticClass: "callsign-adam" }, [_._v("(" + _._s(E) + ") " + _._s(_.generateAdamName(E)) + ":")]),
                                                                            //                         _._l(e, function (e, a) {
                                                                            //                             return A("div", { key: "adam" + E + a, staticClass: "adam_player", class: { active: e.policeId == _.policeData.policeId } }, [
                                                                            //                                 A("span", { staticClass: "callsign" }, [_._v(_._s(e.callsign))]),
                                                                            //                                 A("span", { staticClass: "mr-0" }, [_._v(_._s(e.name))]),
                                                                            //                                 A("i", { staticClass: "callsign", class: _.rankList[e.rank].shortname }),
                                                                            //                             ]);
                                                                            //                         }),
                                                                            //                     ],
                                                                            //                     2
                                                                            //                 );
                                                                            //             }),
                                                                            //             0
                                                                            //         ),
                                                                            //     ]),
                                                                            // ]),
                                                                            A("div", { staticClass: "wanted_block_outer" }, [
                                                                                A("div", { staticClass: "wanted_block" }, [
                                                                                    A("h5", { domProps: { textContent: _._s(_.$ml.get("p1_title_3")) } }, [_._v("Люди в розыске")]),
                                                                                    A(
                                                                                        "div",
                                                                                        { staticClass: "wanted_list person" },
                                                                                        _._l(_.showWantedPerson(2), function (e, E) {
                                                                                            return A(
                                                                                                "div",
                                                                                                {
                                                                                                    key: "wanted_person" + E,
                                                                                                    staticClass: "wanted_element",
                                                                                                    on: {
                                                                                                        click: function (A) {
                                                                                                            _.LoadPlayerByName(e.name);
                                                                                                            _.StartWait(() => {
                                                                                                                _.showFullContact(_.findPlayerIndexByidentifier(e.identifier));
                                                                                                            });
                                                                                                        },
                                                                                                    },
                                                                                                },
                                                                                                [A("span", [_._v(_._s(e.name))]), A("span", [_._v(_._s(e.phone))])]
                                                                                            );
                                                                                        }),
                                                                                        0
                                                                                    ),
                                                                                ]),
                                                                                A("div", { staticClass: "wanted_block" }, [
                                                                                    A("h5", { domProps: { textContent: _._s(_.$ml.get("p1_title_4")) } }, [_._v("Машины в розыске")]),
                                                                                    A(
                                                                                        "div",
                                                                                        { staticClass: "wanted_list vehicle" },
                                                                                        _._l(_.showWantedVehicles(2), function (e, E) {
                                                                                            return A(
                                                                                                "div",
                                                                                                {
                                                                                                    key: "wanted_vehicle" + E,
                                                                                                    staticClass: "wanted_element",
                                                                                                    on: {
                                                                                                        click: function (A) {                                                                                              
                                                                                                            _.showFullVehiclePage(_.findVehicleIndexByPlate(e.number));
                                                                                                        },
                                                                                                    },
                                                                                                },
                                                                                                [A("span", [_._v(_._s(e.name))]), A("span", [_._v(_._s(e.number))])]
                                                                                            );
                                                                                        }),
                                                                                        0
                                                                                    ),
                                                                                ]),
                                                                            ]),
                                                                        ]),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A("div", { directives: [{ name: "show", rawName: "v-show", value: 1 == _.page, expression: "page == 1" }], staticClass: "c_page c_page_1 scrolled" }, [
                                                                            A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_2")) } }, [_._v("Последние вызовы")]),
                                                                                A("input", {
                                                                                    directives: [{ name: "model", rawName: "v-model", value: _.searchIdInput, expression: "searchIdInput" }],
                                                                                    staticClass: "form-control search",
                                                                                    attrs: { placeholder: _.$ml.get("text_search") },
                                                                                    domProps: { value: _.searchIdInput },
                                                                                    on: {
                                                                                        input: [
                                                                                            function (e) {
                                                                                                e.target.composing || (_.searchIdInput = e.target.value);
                                                                                            },
                                                                                            _.searchId,
                                                                                        ],
                                                                                    },
                                                                                }),
                                                                            ]),
                                                                            A(
                                                                                "div",
                                                                                { staticClass: "police_call_list" },
                                                                                _._l(_.policeCallsList, function (e, E) {
                                                                                    return A(
                                                                                        "div",
                                                                                        {
                                                                                            directives: [{ name: "show", rawName: "v-show", value: e.show, expression: "item.show" }],
                                                                                            key: "calls_" + e.id,
                                                                                            class: [{ active: 1 == _.onScene(e.crew) }, "police_call_item status_" + e.status],
                                                                                            on: {
                                                                                                click: function (e) {
                                                                                                    return _.showFullPoliceCall(E);
                                                                                                },
                                                                                            },
                                                                                        },
                                                                                        [
                                                                                            A("div", { staticClass: "row" }, [
                                                                                                A("div", { staticClass: "col-3" }, [
                                                                                                    A("h6", [_._v(_._s(_.getDate(e.date)))]),
                                                                                                    A("h6", { class: "status status_" + e.status }, [_._v("(" + _._s(e.status) + ") " + _._s(_.getStatus(e.status)))]),
                                                                                                ]),
                                                                                                A("div", { staticClass: "col-6" }, [
                                                                                                    A("h6", [A("span", { domProps: { textContent: _._s(_.$ml.get("text_call")) } }, [_._v("Вызов")]), _._v(" №" + _._s(e.id))]),
                                                                                                    A("p", [_._v(_._s(e.message))]),
                                                                                                ]),
                                                                                                A("div", { staticClass: "col-3" }, [
                                                                                                    A("h6", { staticClass: "text-right", domProps: { textContent: _._s(_.$ml.get("text_scene")) } }, [_._v("На сцене")]),
                                                                                                    e.crew
                                                                                                        ? A(
                                                                                                              "div",
                                                                                                              { staticClass: "d-flex justify-content-end" },
                                                                                                              _._l(e.crew, function (e, E) {
                                                                                                                  return A("span", { key: "crew" + E, staticClass: "unit", class: { active: e == _.policeData.policeId } }, [
                                                                                                                      _._v(" " + _._s(_.getCallsignById(e)) + " "),
                                                                                                                  ]);
                                                                                                              }),
                                                                                                              0
                                                                                                          )
                                                                                                        : _._e(),
                                                                                                ]),
                                                                                            ]),
                                                                                        ]
                                                                                    );
                                                                                }),
                                                                                0
                                                                            ),
                                                                        ]),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A("div", { directives: [{ name: "show", rawName: "v-show", value: 11 == _.page, expression: "page == 11" }], staticClass: "c_page c_page_11" }, [
                                                                            A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                A(
                                                                                    "button",
                                                                                    {
                                                                                        staticClass: "btn btn-gold",
                                                                                        domProps: { textContent: _._s(_.$ml.get("button_back")) },
                                                                                        on: {
                                                                                            click: function (e) {
                                                                                                return _.selectPage(1);
                                                                                            },
                                                                                        },
                                                                                    },
                                                                                    [_._v("Назад")]
                                                                                ),
                                                                                A("h2", { staticClass: "mb-0" }, [A("span", { domProps: { textContent: _._s(_.$ml.get("text_call")) } }, [_._v("Вызов")]), _._v(" №" + _._s(_.activeCall.id))]),
                                                                            ]),
                                                                            A("div", { class: "police_call_item_description status_" + _.activeCall.status }, [
                                                                                A("p", [_._v(_._s(_.activeCall.message))]),
                                                                                A("h6", [
                                                                                    A("span", { domProps: { textContent: _._s(_.$ml.get("text_called")) } }, [_._v("Вызывавший")]),
                                                                                    _._v(": "),
                                                                                    A("span", { staticClass: "golden" }, [_._v(_._s(_.activeCall.from))]),
                                                                                ]),
                                                                                A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                    A(
                                                                                        "h6",
                                                                                        [
                                                                                            A("span", { domProps: { textContent: _._s(_.$ml.get("text_units")) } }, [_._v("Юниты на сцене")]),
                                                                                            _._v(": "),
                                                                                            _._l(_.activeCall.crew, function (e, E) {
                                                                                                return A("span", { key: "scene" + E, staticClass: "unit", class: { active: e == _.policeData.policeId } }, [_._v(_._s(_.getCallsignById(e)))]);
                                                                                            }),
                                                                                        ],
                                                                                        2
                                                                                    ),
                                                                                    A("div", { staticClass: "dropdown" }, [
                                                                                        A(
                                                                                            "a",
                                                                                            {
                                                                                                class: "btn btn-dropdown dropdown-toggle status_" + _.activeCall.status,
                                                                                                on: {
                                                                                                    click: function (e) {
                                                                                                        return _.showDropDown(1);
                                                                                                    },
                                                                                                },
                                                                                            },
                                                                                            [_._v("(" + _._s(_.activeCall.status) + ") " + _._s(_.statusNames[_.activeCall.status]))]
                                                                                        ),
                                                                                        A(
                                                                                            "div",
                                                                                            { directives: [{ name: "show", rawName: "v-show", value: _.showDropdownA, expression: "showDropdownA" }], staticClass: "dropdown-menu" },
                                                                                            _._l(_.statusNames, function (e, E) {
                                                                                                return A(
                                                                                                    "a",
                                                                                                    {
                                                                                                        key: "units" + E,
                                                                                                        class: "dropdown-item status_" + E,
                                                                                                        on: {
                                                                                                            click: function (e) {
                                                                                                                return _.changeStatus(E);
                                                                                                            },
                                                                                                        },
                                                                                                    },
                                                                                                    [_._v("(" + _._s(E) + ") " + _._s(e))]
                                                                                                );
                                                                                            }),
                                                                                            0
                                                                                        ),
                                                                                    ]),
                                                                                ]),
                                                                            ]),
                                                                            A("div", { staticClass: "police_call_item_buttons" }, [
                                                                                A(
                                                                                    "button",
                                                                                    {
                                                                                        staticClass: "btn btn-gold",
                                                                                        class: { active: _.onScene(_.activeCall.crew) },
                                                                                        on: {
                                                                                            click: function (e) {
                                                                                                return _.leaveScene(_.activeCall.crew);
                                                                                            },
                                                                                        },
                                                                                    },
                                                                                    [_._v(_._s(_.onScene(_.activeCall.crew) ? _.$ml.get("button_leave") : _.$ml.get("button_accept")))]
                                                                                ),
                                                                                A(
                                                                                    "button",
                                                                                    {
                                                                                        staticClass: "btn btn-gold",
                                                                                        domProps: { textContent: _._s(_.$ml.get("button_map")) },
                                                                                        on: {
                                                                                            click: function (e) {
                                                                                                return _.setMark(_.activeCall.id);
                                                                                            },
                                                                                        },
                                                                                    },
                                                                                    [_._v("Показать на карте")]
                                                                                ),
                                                                            ]),
                                                                        ]),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A("div", { directives: [{ name: "show", rawName: "v-show", value: 2 == _.page, expression: "page == 2" }], staticClass: "c_page c_page_2 scrolled" }, [
                                                                            A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_3")) } }, [_._v("База жителей штата")]),
                                                                                A("input", {
                                                                                    directives: [{ name: "model", rawName: "v-model", value: _.searchInput, expression: "searchInput" }],
                                                                                    staticClass: "form-control search",
                                                                                    attrs: { placeholder: _.$ml.get("text_search") },
                                                                                    domProps: { value: _.searchInput },
                                                                                    on: {
                                                                                        keyup: [
                                                                                            function (e) {
                                                                                               if (e.keyCode == 13) {
                                                                                                e.target.composing || (_.searchInput = e.target.value);
                                                                                                // if (_.playerData.policeData.grade < 2) {
                                                                                                //     _.SendNotify('Error','Shoma dastresi kafi nadarid',10000,'error')
                                                                                                //     return; 
                                                                                                // }
                                                                                                _.searchName();
                                                                                                _.StartWait(() => {
                                                                                                   
                                                                                                });
                                                                                               }                                                                                            
                                                                                            }                                                                             
                                                                                        ],
                                                                                    },
                                                                                }),
                                                                            ]),
                                                                            A(
                                                                                "div",
                                                                                { staticClass: "player_list" },
                                                                                _._l(_.playersList, function (e, E) {
                                                                                    return A(
                                                                                        "div",
                                                                                        {
                                                                                            directives: [{ name: "show", rawName: "v-show", value: e.show, expression: "item.show" }],
                                                                                            key: "searchA" + e.id,
                                                                                            class: "police_call_item status_" + e.status,
                                                                                            on: {
                                                                                                click: function (e) {
                                                                                                    return _.showFullContact(E);
                                                                                                },
                                                                                            },
                                                                                        },
                                                                                        [
                                                                                            A("div", { staticClass: "d-flex" }, [
                                                                                                A("div", { staticClass: "item_index" }, [_._v(" " + _._s(E + 1) + " ")]),
                                                                                                A("div", { staticClass: "item_name" }, [_._v(" " + _._s(e.name) + " ")]),
                                                                                                A("div", { staticClass: "item_phone" }, [_._v(" " + _._s(e.phone) + " ")]),
                                                                                                A("div", { class: "item_status status_" + e.status }, [_._v(" " + _._s(_.getPlayerStatus2(e.status)) + " ")]),
                                                                                            ]),
                                                                                        ]
                                                                                    );
                                                                                }),
                                                                                0
                                                                            ),
                                                                        ]),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        21 == _.page
                                                                            ? A("div", { staticClass: "c_page c_page_2 profile scrolled" }, [
                                                                                  A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                      A(
                                                                                          "button",
                                                                                          {
                                                                                              staticClass: "btn btn-gold",
                                                                                              domProps: { textContent: _._s(_.$ml.get("button_back")) },
                                                                                              on: {
                                                                                                  click: function (e) {
                                                                                                      return _.selectPage(2);
                                                                                                  },
                                                                                              },
                                                                                          },
                                                                                          [_._v("Назад")]
                                                                                      ),
                                                                                      A("h2", { staticClass: "mb-0" }, [_._v(_._s(_.activePlayer.name))]),
                                                                                  ]),
                                                                                  A("div", { staticClass: "row" }, [
                                                                                      A("div", { staticClass: "col-4" }, [
                                                                                          A("div", { staticClass: "profile_image" }, [
                                                                                              A(
                                                                                                  "button",
                                                                                                  {
                                                                                                      staticClass: "btn btn-gold upload",
                                                                                                      on: {
                                                                                                          click: function (e) {
                                                                                                              _.showModalC = !0;
                                                                                                          },
                                                                                                      },
                                                                                                  },
                                                                                                  [_._v("Upload photo")]
                                                                                              ),
                                                                                              _.activePlayer.picture ? A("img", { staticClass: "img-fluid", attrs: { src: _.activePlayer.picture } }) : _._e(),
                                                                                          ]),
                                                                                      ]),
                                                                                      A("div", { staticClass: "col-8 pl-0" }, [
                                                                                          A("div", { class: "profile_description status_" + _.activePlayer.status }, [
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { domProps: { textContent: _._s(_.$ml.get("p3_gender")) } }, [_._v("Пол:")]),
                                                                                                  A("h5", [_._v(_._s(_.activePlayer.gender) + " ")]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-none justify-content-between" }, [
                                                                                                  A("h5", [_._v("Вод. лицензия:")]),
                                                                                                  A("h5", { class: { license_false: !_.activePlayer.driveLicense } }, [_._v(_._s(_.checkLicense(_.activePlayer.driveLicense)))]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { domProps: { textContent: _._s(_.$ml.get("p3_phone")) } }, [_._v("Телефон:")]),
                                                                                                  A("h5", [_._v(_._s(_.activePlayer.phone))]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { staticClass: "mb-0", domProps: { textContent: _._s(_.$ml.get("p3_database")) } }, [_._v("Запись в БД:")]),
                                                                                                  A("h5", [_._v(_._s(_.activePlayer.id))]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { staticClass: "mb-0", domProps: { textContent: _._s(_.$ml.get("p3_status")) } }, [_._v("Статус:")]),
                                                                                                  A("div", { staticClass: "dropdown" }, [
                                                                                                      A(
                                                                                                          "a",
                                                                                                          {
                                                                                                              class: "btn btn-dropdown dropdown-toggle status_" + _.activePlayer.status,
                                                                                                              on: {
                                                                                                                  click: function (e) {
                                                                                                                      return _.showDropDown(2);
                                                                                                                  },
                                                                                                              },
                                                                                                          },
                                                                                                          [_._v("(" + _._s(_.activePlayer.status) + ") " + _._s(_.playerStatusNames[_.activePlayer.status]))]
                                                                                                      ),
                                                                                                      A(
                                                                                                          "div",
                                                                                                          {
                                                                                                              directives: [{ name: "show", rawName: "v-show", value: _.showDropdownB, expression: "showDropdownB" }],
                                                                                                              staticClass: "dropdown-menu",
                                                                                                          },
                                                                                                          _._l(_.playerStatusNames, function (e, E) {
                                                                                                              return A(
                                                                                                                  "a",
                                                                                                                  {
                                                                                                                      key: "searchB" + E,
                                                                                                                      class: "dropdown-item status_" + E,
                                                                                                                      on: {
                                                                                                                          click: function (e) {
                                                                                                                              return _.changePlayerStatus(E);
                                                                                                                          },
                                                                                                                      },
                                                                                                                  },
                                                                                                                  [_._v("(" + _._s(E) + ") " + _._s(e))]
                                                                                                              );
                                                                                                          }),
                                                                                                          0
                                                                                                      ),
                                                                                                  ]),
                                                                                              ]),
                                                                                          ]),
                                                                                      ]),
                                                                                  ]),
                                                                                  A("div", { staticClass: "d-none profile_content" }, [
                                                                                      A("p", [A("b", [_._v("Место жительства:")]), _._v(_._s(_.activePlayer.address))]),
                                                                                      A("p", [A("b", [_._v("Комментарий:")]), _._v(_._s(_.activePlayer.about))]),
                                                                                  ]),
                                                                                  0 != _.activePlayer.cars.length
                                                                                      ? A(
                                                                                            "div",
                                                                                            { staticClass: "profile_vehicles vehicles_list" },
                                                                                            [
                                                                                                A("h4", { domProps: { textContent: _._s(_.$ml.get("p3_vehicles")) } }, [_._v("Автомобили гражданина")]),
                                                                                                _._l(_.activePlayer.cars, function (e, E) {
                                                                                                    return A(
                                                                                                        "div",
                                                                                                        {
                                                                                                            key: "player_vehs" + E + e.id,
                                                                                                            class: "police_call_item status_" + e.status,
                                                                                                            on: {
                                                                                                                click: function (A) {
                                                                                                                    _.showFullVehiclePage(_.findVehicleIndexByPlate(e.number));
                                                                                                                },
                                                                                                            },
                                                                                                        },
                                                                                                        [
                                                                                                            A("div", { staticClass: "d-flex" }, [
                                                                                                                A("div", { staticClass: "item_veh_index" }, [_._v(" " + _._s(E + 1) + " ")]),
                                                                                                                A("div", { staticClass: "item_veh_number" }, [_._v(" " + _._s(e.carId) + " ")]),
                                                                                                                A("div", { staticClass: "item_veh_name" }, [_._v(" " + _._s(e.number) + " ")]),
                                                                                                                A("div", { staticClass: "item_veh_owner" }, [_._v(" " + _._s(e.name) + " ")]),
                                                                                                                A("div", { class: "item_veh_status status_" + e.status }, [_._v(_._s(_.getVehicleStatus(e.status)) + " ")]),
                                                                                                            ]),
                                                                                                        ]
                                                                                                    );
                                                                                                }),
                                                                                            ],
                                                                                            2
                                                                                        )
                                                                                      : _._e(),
                                                                                  0 != _.activeTickets.length
                                                                                      ? A("div", { staticClass: "ticket_list" }, [
                                                                                            A("h4", { domProps: { textContent: _._s(_.$ml.get("p3_tickets")) } }, [_._v("Штрафы гражданина")]),
                                                                                            A(
                                                                                                "div",
                                                                                                { staticClass: "ticket_list_inner" },
                                                                                                [
                                                                                                    A("div", { staticClass: "ticket header" }, [
                                                                                                        A("div", { staticClass: "item_ticket_id" }, [_._v("ID")]),
                                                                                                        A("div", { staticClass: "item_ticket_owner", domProps: { textContent: _._s(_.$ml.get("p3_author")) } }, [_._v("Выписал")]),
                                                                                                        A("div", { staticClass: "item_ticket_date", domProps: { textContent: _._s(_.$ml.get("p3_date")) } }, [_._v("Дата")]),
                                                                                                        A("div", { staticClass: "item_ticket_text", domProps: { textContent: _._s(_.$ml.get("p3_reason")) } }, [_._v("Причина штрафа")]),
                                                                                                        //A("div", { staticClass: "item_ticket_price", domProps: { textContent: _._s(_.$ml.get("p3_amount")) } }, [_._v("Сумма")]),
                                                                                                        //A("div", { staticClass: "item_ticket_index", domProps: { textContent: _._s(_.$ml.get("p3_time")) } }, [_._v("Срок")]),
                                                                                                        //A("div", { staticClass: "item_ticket_paid", domProps: { textContent: _._s(_.$ml.get("p3_paid")) } }, [_._v("Paid")]),
                                                                                                        A("div", { staticClass: "item_ticket_delete" }),
                                                                                                    ]),
                                                                                                    _._l(_.activeTickets, function (e, E) {
                                                                                                        return A("div", { key: "ticket" + E + e.id, staticClass: "ticket" }, [
                                                                                                            A("div", { staticClass: "item_ticket_id" }, [_._v(" " + _._s(e.id) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_owner" }, [_._v(" " + _._s(e.sendername) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_date" }, [_._v(" " + _._s(e.date) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_text" }, [_._v(" " + _._s(e.text) + " ")]),
                                                                                                           // A("div", { staticClass: "item_ticket_price" }, [_._v(" " + _._s(e.price) + " ")]),
                                                                                                           // A("div", { staticClass: "item_ticket_index" }, [_._v(" " + _._s(e.penalty) + " ")]),
                                                                                                           // A("div", { staticClass: "item_ticket_paid", class: { false: !e.paid } }, [_._v(" " + _._s(_.checkPaid(e.paid)) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_delete" }, [
                                                                                                                A("button", {
                                                                                                                    staticClass: "del",
                                                                                                                    on: {
                                                                                                                        click: function () {
                                                                                                                            return _.deleteTicket(E,e.id);
                                                                                                                        },
                                                                                                                    },
                                                                                                                }),
                                                                                                            ]),
                                                                                                        ]);
                                                                                                    }),
                                                                                                ],
                                                                                                2
                                                                                            ),
                                                                                        ])
                                                                                      : _._e(),
                                                                                  A("div", { staticClass: "police_tickets" }, [
                                                                                      A("div", { staticClass: "d-flex justify-content-end" }, [
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  staticClass: "btn btn-gold",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_ticket")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          return _.addTicketToActivePlayer();
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Выписать штраф")]
                                                                                          ),
                                                                                      ]),
                                                                                  ]),
                                                                              ])
                                                                            : _._e(),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A("div", { directives: [{ name: "show", rawName: "v-show", value: 3 == _.page, expression: "page == 3" }], staticClass: "c_page c_page_2 scrolled" }, [
                                                                            A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_4")) } }, [_._v("База автомобилей")]),
                                                                                A("input", {
                                                                                    directives: [{ name: "model", rawName: "v-model", value: _.searchVehicleInput, expression: "searchVehicleInput" }],
                                                                                    staticClass: "form-control search",
                                                                                    attrs: { placeholder: _.$ml.get("text_search") },
                                                                                    domProps: { value: _.searchVehicleInput },
                                                                                    on: {
                                                                                        keyup: [
                                                                                            function (e) {
                                                                                               if (e.keyCode == 13) {
                                                                                                // if (_.playerData.policeData.grade < 2) {
                                                                                                //     _.SendNotify('Error','Shoma dastresi kafi nadarid',10000,'error')
                                                                                                //     return; 
                                                                                                // }
                                                                                                e.target.composing || (_.searchVehicleInput = e.target.value);
                                                                                                _.searchVehicle();
                                                                                                _.StartWait(() => {
                                                                                                   
                                                                                                });
                                                                                               }                                                                                            
                                                                                            }                                                                             
                                                                                        ],
                                                                                        input: [
                                                                                            function (e) {
                                                                                                e.target.composing || (_.searchVehicleInput = e.target.value);
                                                                                            },
                                                                                            _.searchVehicle2,
                                                                                        ],
                                                                                    },
                                                                                }),
                                                                            ]),
                                                                            A(
                                                                                "div",
                                                                                { staticClass: "vehicles_list" },
                                                                                _._l(_.vehiclesList, function (e, E) {
                                                                                    return A(
                                                                                        "div",
                                                                                        {
                                                                                            directives: [{ name: "show", rawName: "v-show", value: e.show, expression: "item.show" }],
                                                                                            key: "vehlist" + E + e.id,
                                                                                            class: "police_call_item status_" + e.status,
                                                                                            on: {
                                                                                                click: function (e) {
                                                                                                    return _.showFullVehiclePage(E);
                                                                                                },
                                                                                            },
                                                                                        },
                                                                                        [
                                                                                            A("div", { staticClass: "d-flex" }, [
                                                                                                A("div", { staticClass: "item_veh_index" }, [_._v(" " + _._s(e.carId) + " ")]),
                                                                                                A("div", { staticClass: "item_veh_number" }, [_._v(" " + _._s(e.number) + " ")]),
                                                                                                A("div", { staticClass: "item_veh_name" }, [_._v(" " + _._s(e.name) + "")]),
                                                                                                A("div", { staticClass: "item_veh_owner" }, [_._v(" " + e.ownername + " ")]),
                                                                                                A("div", { class: "item_veh_status status_" + e.status }, [_._v(" " + _._s(_.getVehicleStatus(e.status)) + " ")]),
                                                                                            ]),
                                                                                        ]
                                                                                    );
                                                                                }),
                                                                                0
                                                                            ),
                                                                        ]),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        31 == _.page
                                                                            ? A("div", { staticClass: "c_page c_page_2 profile car_profile" }, [
                                                                                  A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                      A(
                                                                                          "button",
                                                                                          {
                                                                                              staticClass: "btn btn-gold",
                                                                                              domProps: { textContent: _._s(_.$ml.get("button_back")) },
                                                                                              on: {
                                                                                                  click: function (e) {
                                                                                                      return _.selectPage(3);
                                                                                                  },
                                                                                              },
                                                                                          },
                                                                                          [_._v("Назад")]
                                                                                      ),
                                                                                      A("h2", { staticClass: "mb-0" }, [_._v(_._s(_.activeVehicle.name) + " " + _._s(_.activeVehicle.number))]),
                                                                                  ]),
                                                                                  A("div", { staticClass: "row" }, [
                                                                                      A("div", { staticClass: "col-4" }, [
                                                                                          A("div", { staticClass: "profile_image" }, [A("img", { staticClass: "img-fluid", attrs: { src: "https://cdn.discordapp.com/attachments/819492247727767592/869824166910627870/car.png" } })]),
                                                                                      ]),
                                                                                      A("div", { staticClass: "col-8 pl-0" }, [
                                                                                          A("div", { class: "profile_description status_" + _.activeVehicle.status }, [
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { domProps: { textContent: _._s(_.$ml.get("p4_owner")) } }, [_._v("Владелец:")]),
                                                                                                  A(
                                                                                                      "a",
                                                                                                      {
                                                                                                          on: {
                                                                                                              click: function (e) {
                                                                                                                _.LoadPlayerByName(_.activeVehicle.ownername);
                                                                                                                _.StartWait(() => {
                                                                                                                    _.showFullContact(_.findPlayerIndexByidentifier(_.activeVehicle.userdata.identifier));
                                                                                                                });
                                                                                                              },
                                                                                                          },
                                                                                                      },
                                                                                                      [_._v(_._s(_.activeVehicle.ownername))]
                                                                                                  ),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { domProps: { textContent: _._s(_.$ml.get("p4_number")) } }, [_._v("Номер владельца:")]),
                                                                                                  A("h5", [_._v(_._s(_.activeVehicle.userdata.phone_number))]),
                                                                                              ]),
                                                                                             // A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                              //    A("h5", { domProps: { textContent: _._s(_.$ml.get("p4_database")) } }, [_._v("Запись в БД:")]),
                                                                                              //    A("h5", [_._v(_._s(_.activeVehicle.carId))]),
                                                                                              //]),
                                                                                              A("div", { staticClass: "d-none justify-content-between" }, [
                                                                                                  A("h5", [_._v("Цвет:")]),
                                                                                                  A("h5", [
                                                                                                      _._v(_._s(_.activeVehicle.color) + " "),
                                                                                                      A("span", {
                                                                                                          directives: [{ name: "show", rawName: "v-show", value: _.activeVehicle.color, expression: "activeVehicle.color" }],
                                                                                                          staticClass: "vehicle-color",
                                                                                                          style: "background-color:" + _.activeVehicle.color,
                                                                                                      }),
                                                                                                  ]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-none justify-content-between" }, [
                                                                                                  A("h5", [_._v("Продавец:")]),
                                                                                                  A("h5", [_._v(_._s(_.getOwnerName(_.activeVehicle.sellerId)) + " ")]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-none justify-content-between" }, [
                                                                                                  A("h5", [_._v("Номер продавца:")]),
                                                                                                  A("h5", [_._v(_._s(_.getOwnerPhoneByName(_.activeVehicle.sellerId)) + " ")]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { staticClass: "mb-0", domProps: { textContent: _._s(_.$ml.get("p4_status")) } }, [_._v("Статус:")]),
                                                                                                  A("div", { staticClass: "dropdown" }, [
                                                                                                      A(
                                                                                                          "a",
                                                                                                          {
                                                                                                              class: "btn btn-dropdown dropdown-toggle status_" + _.activeVehicle.status,
                                                                                                              on: {
                                                                                                                  click: function (e) {
                                                                                                                      return _.showDropDown(2);
                                                                                                                  },
                                                                                                              },
                                                                                                          },
                                                                                                          [_._v("(" + _._s(_.activeVehicle.status) + ") " + _._s(_.vehicleStatusNames[_.activeVehicle.status]))]
                                                                                                      ),
                                                                                                      A(
                                                                                                          "div",
                                                                                                          {
                                                                                                              directives: [{ name: "show", rawName: "v-show", value: _.showDropdownB, expression: "showDropdownB" }],
                                                                                                              staticClass: "dropdown-menu",
                                                                                                          },
                                                                                                          _._l(_.vehicleStatusNames, function (e, E) {
                                                                                                              return A(
                                                                                                                  "a",
                                                                                                                  {
                                                                                                                      key: "dropdown2" + E,
                                                                                                                      class: "dropdown-item status_" + E,
                                                                                                                      on: {
                                                                                                                          click: function (e) {
                                                                                                                              return _.changeVehicleStatus(E);
                                                                                                                          },
                                                                                                                      },
                                                                                                                  },
                                                                                                                  [_._v("(" + _._s(E) + ") " + _._s(e))]
                                                                                                              );
                                                                                                          }),
                                                                                                          0
                                                                                                      ),
                                                                                                      A("input", {
                                                                                                        directives: [{ name: "model", rawName: "v-model", value: _.activeVehicle.data, expression: "" }],
                                                                                                        staticClass: "form-control search",
                                                                                                        attrs: { placeholder: "Insert data" },
                                                                                                        domProps: { value: _.activeVehicle.data },
                                                                                                        on: {
                                                                                                            keyup: [
                                                                                                                function (e) {
                                                                                                                   if (e.keyCode == 13) {
                                                                                                                    _.SendNotify('Error','Data ba movafaghiat save shod',5000,'success')
                                                                                                                    // _.searchName();
                                                                                                                    _.SetVehicleData(_.activeVehicle.number,e.target.value);
                                                                                                                   }                                                                                            
                                                                                                                }                                                                             
                                                                                                            ],
                                                                                                        },
                                                                                                      }),
                                                                                                      
                                                                                                  ]),
                                                                                              ]),
                                                                                          ]),
                                                                                      ]),
                                                                                  ]),
                                                                              ])
                                                                            : _._e(),
                                                                    ]),
                                                                    // A("transition", { attrs: { name: "list" } }, [
                                                                    //     A(
                                                                    //         "div",
                                                                    //         { directives: [{ name: "show", rawName: "v-show", value: 4 == _.page, expression: "page == 4" }], staticClass: "c_page c_page_2" },
                                                                    //         [
                                                                    //             A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                    //                 A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_5")) } }, [_._v("Законы штата")]),
                                                                    //                 A("input", {
                                                                    //                     directives: [{ name: "model", rawName: "v-model", value: _.searchLawsInput, expression: "searchLawsInput" }],
                                                                    //                     staticClass: "form-control search",
                                                                    //                     attrs: { placeholder: _.$ml.get("text_search") },
                                                                    //                     domProps: { value: _.searchLawsInput },
                                                                    //                     on: {
                                                                    //                         input: [
                                                                    //                             function (e) {
                                                                    //                                 e.target.composing || (_.searchLawsInput = e.target.value);
                                                                    //                             },
                                                                    //                             _.searchLaws,
                                                                    //                         ],
                                                                    //                     },
                                                                    //                 }),
                                                                    //             ]),
                                                                    //             A("div", { staticClass: "d-flex law_header" }, [
                                                                    //                 A("div", { staticStyle: { width: "10%" } }, [_._v("№")]),
                                                                    //                 A("div", { staticStyle: { width: "70%" }, domProps: { textContent: _._s(_.$ml.get("p5_text")) } }, [_._v("Текст")]),
                                                                    //                 A("div", { staticStyle: { width: "10%" }, domProps: { textContent: _._s(_.$ml.get("p5_time")) } }, [_._v("Срок")]),
                                                                    //                 A("div", { staticStyle: { width: "10%" }, domProps: { textContent: _._s(_.$ml.get("p5_penalty")) } }, [_._v("Штраф")]),
                                                                    //             ]),
                                                                    //             _._l(_.allLaws, function (e, E) {
                                                                    //                 return A("div", { directives: [{ name: "show", rawName: "v-show", value: e.show, expression: "item.show" }], key: "laws" + E, staticClass: "law_list" }, [
                                                                    //                     A("div", { staticStyle: { width: "10%" } }, [_._v(" " + _._s(e.code) + " ")]),
                                                                    //                     A("div", { staticStyle: { width: "70%" } }, [A("p", [_._v(_._s(e.name))])]),
                                                                    //                     A("div", { staticStyle: { width: "10%" } }, [A("p", [_._v(_._s(e.penalty))])]),
                                                                    //                     A("div", { staticStyle: { width: "10%" } }, [_._v(" " + _._s(e.price) + " ")]),
                                                                    //                 ]);
                                                                    //             }),
                                                                    //         ],
                                                                    //         2
                                                                    //     ),
                                                                    // ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A("div", { directives: [{ name: "show", rawName: "v-show", value: 4 == _.page, expression: "page == 4" }], staticClass: "c_page c_page_2 scrolled" }, [
                                                                            A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_5")) } }, [_._v("База жителей штата")]),
                                                                                A("input", {
                                                                                    directives: [{ name: "model", rawName: "v-model", value: _.searchInput, expression: "searchInput2" }],
                                                                                    staticClass: "form-control search",
                                                                                    attrs: { placeholder: _.$ml.get("text_search") },
                                                                                    domProps: { value: _.searchInput },
                                                                                    on: {
                                                                                        keyup: [
                                                                                            function (e) {
                                                                                               if (e.keyCode == 13) {
                                                                                                e.target.composing || (_.searchInput = e.target.value);
                                                                                                // if (_.playerData.policeData.grade < 2) {
                                                                                                //     _.SendNotify('Error','Shoma dastresi kafi nadarid',10000,'error')
                                                                                                //     return; 
                                                                                                // }
                                                                                                _.searchWeapon();
                                                                                                _.StartWait(() => {
                                                                                                   
                                                                                                });
                                                                                               }                                                                                            
                                                                                            }                                                                             
                                                                                        ],
                                                                                    },
                                                                                }),
                                                                            ]),
                                                                            A(
                                                                                "div",
                                                                                { staticClass: "player_list" },
                                                                                _._l(_.weaponList, function (e, E) {
                                                                                    return A(
                                                                                        "div",
                                                                                        {
                                                                                            directives: [{ name: "show", rawName: "v-show", value: 1, expression: "item.show" }],
                                                                                            key: "searchA" + e.id,
                                                                                            class: "police_call_item status_" + e.status,
                                                                                            on: {
                                                                                                click: function (e) {
                                                                                                    
                                                                                                    return _.showFullContact2(E);
                                                                                                },
                                                                                            },
                                                                                        },
                                                                                        [
                                                                                            A("div", { staticClass: "d-flex" }, [
                                                                                                //A("div", { staticClass: "item_index" }, [_._v("")]),
                                                                                                A("div", { staticClass: "item_name" }, [_._v(" " + _._s(e.label) + " ")]),
                                                                                                A("div", { staticClass: "KOSO SHER" }, [_._v(" " + _._s(e.data.serial) + " ")]),
                                                                                                //A("div", { class: "item_status status_" + e.status }, [_._v(" " + _._s(_.getPlayerStatus2(e.status)) + " ")]),
                                                                                            ]),
                                                                                        ]
                                                                                    );
                                                                                }),
                                                                                0
                                                                            ),
                                                                        ]),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        23 == _.page
                                                                            ? A("div", { staticClass: "c_page c_page_2 profile scrolled" }, [
                                                                                  A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                      A(
                                                                                          "button",
                                                                                          {
                                                                                              staticClass: "btn btn-gold",
                                                                                              domProps: { textContent: _._s(_.$ml.get("button_back")) },
                                                                                              on: {
                                                                                                  click: function (e) {
                                                                                                      return _.selectPage(4);
                                                                                                  },
                                                                                              },
                                                                                          },
                                                                                          [_._v("Назад")]
                                                                                      ),
                                                                                      A("h2", { staticClass: "mb-0" }, [_._v(_._s(_.activePlayer.label))]),
                                                                                  ]),
                                                                                  A("div", { staticClass: "row" }, [
                                                                                      A("div", { staticClass: "col-4" }, [
                                                                                          A("div", { staticClass: "profile_image" }, [
                                                                                        //       A(
                                                                                        //           "button",
                                                                                        //           {
                                                                                        //               staticClass: "btn btn-gold upload",
                                                                                        //               on: {
                                                                                        //                   click: function (e) {
                                                                                        //                       _.showModalC = !0;
                                                                                        //                   },
                                                                                        //               },
                                                                                        //           },
                                                                                        //           [_._v("Upload photo")]
                                                                                        //       ),
                                                                                             A("img", { staticClass: "img-fluid", attrs: { src: 'nui://sun-inventory-hud/ui/img/items/' + _.activePlayer.name + '.png' } })
                                                                                          ]),
                                                                                      ]),
                                                                                      A("div", { staticClass: "col-8 pl-0" }, [
                                                                                          A("div", { class: "profile_description status_" + _.activePlayer.saveddata.status }, [
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { domProps: { textContent: 'Serial № : ' + _.activePlayer.data.serial  } }, [_._v("Телефон:")]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                A("h5", { domProps: { textContent: _.___ } }, [_._v("Телефон:")]),
                                                                                              ]),
                                                                                              A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                                  A("h5", { staticClass: "mb-0", domProps: { textContent: _._s(_.$ml.get("p3_status")) } }, [_._v("Статус:")]),
                                                                                                  A("div", { staticClass: "dropdown" }, [
                                                                                                      A(
                                                                                                          "a",
                                                                                                          {
                                                                                                              class: "btn btn-dropdown dropdown-toggle status_" + _.activePlayer.status,
                                                                                                              on: {
                                                                                                                  click: function (e) {
                                                                                                                      return _.showDropDown(2);
                                                                                                                  },
                                                                                                              },
                                                                                                          },
                                                                                                          [_._v("(" + _._s(_.activePlayer.saveddata.status) + ") " + _._s(_.weaponStatusNames[_.activePlayer.saveddata.status]))]
                                                                                                      ),
                                                                                                      A(
                                                                                                          "div",
                                                                                                          {
                                                                                                              directives: [{ name: "show", rawName: "v-show", value: _.showDropdownB, expression: "showDropdownB" }],
                                                                                                              staticClass: "dropdown-menu",
                                                                                                          },
                                                                                                          _._l(_.weaponStatusNames, function (e, E) {
                                                                                                              return A(
                                                                                                                  "a",
                                                                                                                  {
                                                                                                                      key: "searchB" + E,
                                                                                                                      class: "dropdown-item status_" + E,
                                                                                                                      on: {
                                                                                                                          click: function (e) {
                                                                                                                              return _.changeWeaponStatus(E);
                                                                                                                          },
                                                                                                                      },
                                                                                                                  },
                                                                                                                  [_._v("(" + _._s(E) + ") " + _._s(e))]
                                                                                                              );
                                                                                                          }),
                                                                                                          0
                                                                                                      ),
                                                                                                  ]),
                                                                                              ]),
                                                                                          ]),
                                                                                      ]),
                                                                                  ]),
                                                                                  A("div", { staticClass: "d-none profile_content" }, [
                                                                                      A("p", [A("b", [_._v("Место жительства:")]), _._v(_._s(_.activePlayer.address))]),
                                                                                      A("p", [A("b", [_._v("Комментарий:")]), _._v(_._s(_.activePlayer.about))]),
                                                                                  ]),
                                                                                  
                                                                                  0 != _.activePlayer.saveddata.tickets.length
                                                                                      ? A("div", { staticClass: "ticket_list" }, [
                                                                                            A("h4", { domProps: { textContent: _._s(_.$ml.get("p3_tickets")) } }, [_._v("Штрафы гражданина")]),
                                                                                            A(
                                                                                                "div",
                                                                                                { staticClass: "ticket_list_inner" },
                                                                                                [
                                                                                                    A("div", { staticClass: "ticket header" }, [
                                                                                                        A("div", { staticClass: "item_ticket_owner", domProps: { textContent: _._s(_.$ml.get("p3_author")) } }, [_._v("Выписал")]),
                                                                                                        A("div", { staticClass: "item_ticket_date", domProps: { textContent: _._s(_.$ml.get("p3_date")) } }, [_._v("Дата")]),
                                                                                                        A("div", { staticClass: "item_ticket_text", domProps: { textContent: _._s(_.$ml.get("p3_reason")) } }, [_._v("Причина штрафа")]),
                                                                                                        //A("div", { staticClass: "item_ticket_price", domProps: { textContent: _._s(_.$ml.get("p3_amount")) } }, [_._v("Сумма")]),
                                                                                                        //A("div", { staticClass: "item_ticket_index", domProps: { textContent: _._s(_.$ml.get("p3_time")) } }, [_._v("Срок")]),
                                                                                                        //A("div", { staticClass: "item_ticket_paid", domProps: { textContent: _._s(_.$ml.get("p3_paid")) } }, [_._v("Paid")]),
                                                                                                        A("div", { staticClass: "item_ticket_delete" }),
                                                                                                    ]),
                                                                                                    _._l(_.activePlayer.saveddata.tickets, function (e, E) {
                                                                                                        return A("div", { key: "ticket" + E + e.id, staticClass: "ticket" }, [
                                                                                                            //A("div", { staticClass: "item_ticket_id" }, [_._v(" " + _._s(e.id) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_owner" }, [_._v(" " + _._s(e.sendername) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_date" }, [_._v(" " + _._s(e.date) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_text" }, [_._v(" " + _._s(e.text) + " ")]),
                                                                                                           // A("div", { staticClass: "item_ticket_price" }, [_._v(" " + _._s(e.price) + " ")]),
                                                                                                           // A("div", { staticClass: "item_ticket_index" }, [_._v(" " + _._s(e.penalty) + " ")]),
                                                                                                           // A("div", { staticClass: "item_ticket_paid", class: { false: !e.paid } }, [_._v(" " + _._s(_.checkPaid(e.paid)) + " ")]),
                                                                                                            A("div", { staticClass: "item_ticket_delete" }, [
                                                                                                                A("button", {
                                                                                                                    staticClass: "del",
                                                                                                                    on: {
                                                                                                                        click: function () {
                                                                                                                            return _.deleteTicket2(E);
                                                                                                                        },
                                                                                                                    },
                                                                                                                }),
                                                                                                            ]),
                                                                                                        ]);
                                                                                                    }),
                                                                                                ],
                                                                                                2
                                                                                            ),
                                                                                        ])
                                                                                      : _._e(),
                                                                                  A("div", { staticClass: "police_tickets" }, [
                                                                                      A("div", { staticClass: "d-flex justify-content-end" }, [
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  staticClass: "btn btn-gold",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_ticket")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          return _.addTicketToActiveWeapon();
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Выписать штраф")]
                                                                                          ),
                                                                                      ]),
                                                                                  ]),
                                                                              ])
                                                                            : _._e(),
                                                                    ]),
                                                                    ////////////////////
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A(
                                                                            "div",
                                                                            { directives: [{ name: "show", rawName: "v-show", value: 5 == _.page, expression: "page == 5" }], staticClass: "c_page c_page_2 scrolled" },
                                                                            [
                                                                                A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                    A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_6")) } }, [_._v("10-коды")]),
                                                                                    A("input", {
                                                                                        directives: [{ name: "model", rawName: "v-model", value: _.search10Input, expression: "search10Input" }],
                                                                                        staticClass: "form-control search",
                                                                                        attrs: { placeholder: _.$ml.get("text_search") },
                                                                                        domProps: { value: _.search10Input },
                                                                                        on: {
                                                                                            input: [
                                                                                                function (e) {
                                                                                                    e.target.composing || (_.search10Input = e.target.value);
                                                                                                },
                                                                                                _.searchPoliceCodes,
                                                                                            ],
                                                                                        },
                                                                                    }),
                                                                                ]),
                                                                                _._l(_.policeCodes, function (e, E) {
                                                                                    return A("p", { directives: [{ name: "show", rawName: "v-show", value: e.show, expression: "item.show" }], key: "codes" + E }, [_._v(_._s(e.text))]);
                                                                                }),
                                                                            ],
                                                                            2
                                                                        ),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        A("div", { directives: [{ name: "show", rawName: "v-show", value: 6 == _.page, expression: "page == 6" }], staticClass: "c_page c_page_2 admin_police scrolled" }, [
                                                                            A("div", { staticClass: "d-flex justify-content-between" }, [A("h2", { domProps: { textContent: _._s(_.$ml.get("main_button_7")) } }, [_._v("Управление")])]),
                                                                            A(
                                                                                "div",
                                                                                { staticClass: "player_list" },
                                                                                _._l(_.policeDutyList, function (e, E) {
                                                                                    return A(
                                                                                        "div",
                                                                                        {
                                                                                            key: "edit_cop_" + E,
                                                                                            staticClass: "police_call_item",
                                                                                            on: {
                                                                                                click: function (e) {
                                                                                                    return _.showPoliceFullPage(E);
                                                                                                },
                                                                                            },
                                                                                        },
                                                                                        [
                                                                                            A("div", { staticClass: "d-flex admin_police_item" }, [
                                                                                                A("div", { staticClass: "numb" }, [_._v(" " + _._s(E) + " ")]),
                                                                                                A("div", { staticClass: "name" }, [_._v(" " + _._s(e.name) + " ")]),
                                                                                                A("div", { staticClass: "callsign" }, [_._v(" " + _._s(e.callsign) + " ")]),
                                                                                                A("div", { staticClass: "rank" }, [_._v(" " + _._s(_.rankList[e.rank].name) + " ")]),
                                                                                            ]),
                                                                                        ]
                                                                                    );
                                                                                }),
                                                                                0
                                                                            ),
                                                                        ]),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        _.showModalA
                                                                            ? A("div", { staticClass: "police-modal" }, [
                                                                                  A("div", { staticClass: "modal_inner" }, [
                                                                                      A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                          A("h2", { domProps: { textContent: _._s(_.$ml.get("p3_ticket")) } }, [_._v("Выписка штрафа")]),
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  staticClass: "btn btn-gold",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_close")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          (_.showModalA = !1), _.clearViolationList();
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Закрыть")]
                                                                                          ),
                                                                                      ]),
                                                                                      A("div", { staticClass: "modal_content" }, [
                                                                                          A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p3_officer")) } }, [_._v("Имя офицера: ")]), _._v(_._s(_.playerData.name))]),
                                                                                          A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p3_name")) } }, [_._v("Нарушитель: ")]), _._v(_._s(_.activePlayer.name))]),
                                                                                          A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p3_date2")) } }, [_._v("Дата: ")]), _._v(_._s(_.todayDate()))]),
                                                                                          A("h4", { domProps: { textContent: _._s(_.$ml.get("p3_violations")) } }, [_._v("Список нарушений:")]),
                                                                                          A(
                                                                                              "div",
                                                                                              { staticClass: "violation_list added scrolled" },
                                                                                              _._l(_.activeViolations, function (e, E) {
                                                                                                  return A("div", { key: "addedviolation" + E, staticClass: "violation_item" }, [
                                                                                                      A("div", { staticClass: "violation_item_code" }, [_._v(" " + _._s(e.code) + " ")]),
                                                                                                      A("div", { staticClass: "violation_item_name" }, [_._v(" " + _._s(e.name) + " ")]),
                                                                                                      A("div", { staticClass: "violation_item_penalty" }, [
                                                                                                          _._v(" " + _._s(e.penalty)),
                                                                                                          A(
                                                                                                              "span",
                                                                                                              {
                                                                                                                  directives: [{ name: "show", rawName: "v-show", value: e.penalty, expression: "violation.penalty" }],
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_short")) },
                                                                                                              },
                                                                                                              [_._v("мин.")]
                                                                                                          ),
                                                                                                      ]),
                                                                                                      A("div", { staticClass: "violation_item_price" }, [_._v(" " + _._s(e.price) + " ")]),
                                                                                                      A("div", { staticClass: "violation_item_button" }, [
                                                                                                          A(
                                                                                                              "a",
                                                                                                              {
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_delete")) },
                                                                                                                  on: {
                                                                                                                      click: function (e) {
                                                                                                                          return _.deleteViolationFromList(E);
                                                                                                                      },
                                                                                                                  },
                                                                                                              },
                                                                                                              [_._v("Удалить")]
                                                                                                          ),
                                                                                                      ]),
                                                                                                  ]);
                                                                                              }),
                                                                                              0
                                                                                          ),
                                                                                          A(
                                                                                              "div",
                                                                                              { staticClass: "violation_list scrolled" },
                                                                                              _._l(_.allLaws, function (e, E) {
                                                                                                  return A("div", { key: "violations" + E, staticClass: "violation_item" }, [
                                                                                                      A("div", { staticClass: "violation_item_code" }, [_._v(" " + _._s(e.code) + " ")]),
                                                                                                      //A("input", { staticClass: "violation_item_name" }, [_._v(" " + _._s(e.name) + " ")]),
                                                                                                      A("input", {
																										attrs: { id: "input-vio-text-" + E },
                                                                                                        staticClass: "violation_item_name",
                                                                                                        }),
                                                                                                      A("div", { staticClass: "violation_item_penalty" }, [
                                                                                                          _._v(" " + _._s(e.penalty)),
                                                                                                          A(
                                                                                                              "span",
                                                                                                              {
                                                                                                                  directives: [{ name: "show", rawName: "v-show", value: e.penalty, expression: "violation.penalty" }],
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_short")) },
                                                                                                              },
                                                                                                              [_._v("мин.")]
                                                                                                          ),
                                                                                                      ]),//, [_._v(" $" + _._s(e.price) + " ")]
                                                                                                      A("div", { staticClass: "violation_item_price" ,attrs: { id: "input-vio-price-" + E } }),
                                                                                                      A("div", { staticClass: "violation_item_button" }, [
                                                                                                          A(
                                                                                                              "a",
                                                                                                              {
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_add")) },
                                                                                                                  on: {
                                                                                                                      click: function (e) {
                                                                                                                          return _.addViolationToList(E);
                                                                                                                      },
                                                                                                                  },
                                                                                                              },
                                                                                                              [_._v("Добавить")]
                                                                                                          ),
                                                                                                      ]),
                                                                                                  ]);
                                                                                              }),
                                                                                              0
                                                                                          ),
                                                                                      ]),
                                                                                      A("div", { staticClass: "d-flex justify-content-between align-items-center" }, [
                                                                                          A("h5", [
                                                                                              //A("span", { domProps: { textContent: _._s(_.$ml.get("p3_amount2")) } }, [_._v("Сумма")]),
                                                                                             // _._v(": $" + _._s(_.violationsSum)),
                                                                                              A("span", { directives: [{ name: "show", rawName: "v-show", value: _.violationsTime, expression: "violationsTime" }], staticClass: "nob" }, [
                                                                                                  _._v(", "),
                                                                                                  A("span", { domProps: { textContent: _._s(_.$ml.get("p3_time")) } }, [_._v("срок")]),
                                                                                                  _._v(": " + _._s(_.violationsTime) + " "),
                                                                                                  A("span", { domProps: { textContent: _._s(_.$ml.get("p3_short")) } }, [_._v("мин.")]),
                                                                                                  _._v(" (" + _._s(_.violationsTimeConverted) + " h.)"),
                                                                                              ]),
                                                                                          ]),
                                                                                          A("button", { staticClass: "btn btn-gold", domProps: { textContent: _._s(_.$ml.get("p3_write")) }, on: { click: _.issueFine } }, [
                                                                                              _._v("Выписать штраф"),
                                                                                          ]),
                                                                                      ]),
                                                                                  ]),
                                                                              ])
                                                                            : _._e(),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        _.showModalB
                                                                            ? A("div", { staticClass: "police-modal" }, [
                                                                                  A("div", { staticClass: "modal_inner" }, [
                                                                                      A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                          A("h2", { domProps: { textContent: _._s(_.$ml.get("p7_name")) } }, [_._v("Данные сотрудника")]),
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  staticClass: "btn btn-gold",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p7_cancel")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          (_.showModalB = !1), (_.showDropdownD = !1);
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Закрыть")]
                                                                                          ),
                                                                                      ]),
                                                                                      A("div", { staticClass: "modal_content" }, [
                                                                                          A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p7_officer")) } }, [_._v("Имя офицера:")]), _._v(_._s(_.activeCop.name))]),
                                                                                          A("div", { staticClass: "d-flex" }, [
                                                                                              A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p7_rank")) } }, [_._v("Звание:")])]),
                                                                                              A("div", { staticClass: "dropdown" }, [
                                                                                                  A(
                                                                                                      "a",
                                                                                                      {
                                                                                                          staticClass: "btn btn-dropdown dropdown-toggle police-toggle",
                                                                                                          on: {
                                                                                                              click: function (e) {
                                                                                                                  return _.showDropDown(4);
                                                                                                              },
                                                                                                          },
                                                                                                      },
                                                                                                      [_._v(_._s(_.rankList[_.activeCop.rank].name) + " "), A("i", { staticClass: "callsign", class: _.rankList[_.activeCop.rank].shortname })]
                                                                                                  ),
                                                                                                  A(
                                                                                                      "div",
                                                                                                      { directives: [{ name: "show", rawName: "v-show", value: _.showDropdownD, expression: "showDropdownD" }], staticClass: "dropdown-menu" },
                                                                                                      _._l(_.rankList, function (e, E) {
                                                                                                          return A(
                                                                                                              "a",
                                                                                                              {
                                                                                                                  key: "rank_" + E,
                                                                                                                  staticClass: "dropdown-item",
                                                                                                                  class: { active: _.activeCop.rank == E },
                                                                                                                  on: {
                                                                                                                      click: function (e) {
                                                                                                                          return _.changePlayerRank(E);
                                                                                                                      },
                                                                                                                  },
                                                                                                              },
                                                                                                              [_._v(_._s(E) + " " + _._s(e.name))]
                                                                                                          );
                                                                                                      }),
                                                                                                      0
                                                                                                  ),
                                                                                              ]),
                                                                                          ]),
                                                                                          A("div", { staticClass: "d-flex" }, [
                                                                                              A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p7_callsign")) } }, [_._v("Позывной: ")])]),
                                                                                              A("input", {
                                                                                                  directives: [{ name: "model", rawName: "v-model", value: _.callsignTemp, expression: "callsignTemp" }],
                                                                                                  staticClass: "callsign",
                                                                                                  domProps: { value: _.callsignTemp },
                                                                                                  on: {
                                                                                                      input: function (e) {
                                                                                                          e.target.composing || (_.callsignTemp = e.target.value);
                                                                                                      },
                                                                                                  },
                                                                                              }),
                                                                                              A(
                                                                                                  "button",
                                                                                                  {
                                                                                                      staticClass: "btn btn-callsign",
                                                                                                      domProps: { textContent: _._s(_.$ml.get("p7_change")) },
                                                                                                      on: {
                                                                                                          click: function (e) {
                                                                                                              return _.saveNewCallsign();
                                                                                                          },
                                                                                                      },
                                                                                                  },
                                                                                                  [_._v("Изменить")]
                                                                                              ),
                                                                                          ]),
                                                                                      ]),
                                                                                      A("div", { staticClass: "d-flex justify-content-start align-items-center" }, [
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  directives: [{ name: "show", rawName: "v-show", value: !_.sureFire, expression: "!sureFire" }],
                                                                                                  staticClass: "btn btn-danger",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p7_fire")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          (_.sureFire = !0), (_.showDropdownD = !1);
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Уволить сотрудника")]
                                                                                          ),
                                                                                          A(
                                                                                              "h5",
                                                                                              {
                                                                                                  directives: [{ name: "show", rawName: "v-show", value: _.sureFire, expression: "sureFire" }],
                                                                                                  staticClass: "mb-0",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p7_sure")) },
                                                                                              },
                                                                                              [_._v("Вы уверены?")]
                                                                                          ),
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  directives: [{ name: "show", rawName: "v-show", value: _.sureFire, expression: "sureFire" }],
                                                                                                  staticClass: "ml-3 mr-3 btn btn-danger",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p7_fire")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          return _.fireCop(_.activeCop);
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Уволить")]
                                                                                          ),
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  directives: [{ name: "show", rawName: "v-show", value: _.sureFire, expression: "sureFire" }],
                                                                                                  staticClass: "btn btn-gold",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p7_cancel")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          _.sureFire = !1;
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Отмена")]
                                                                                          ),
                                                                                      ]),
                                                                                  ]),
                                                                              ])
                                                                            : _._e(),
                                                                    ]),
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        _.showModalC
                                                                            ? A("div", { staticClass: "police-modal" }, [
                                                                                  A("div", { staticClass: "modal_inner" }, [
                                                                                      A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                          A("h2", { domProps: { textContent: _._s(_.$ml.get("p8_name")) } }, [_._v("Загрузить фотографию")]),
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  staticClass: "btn btn-gold",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p8_close")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          _.showModalC = !1;
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Закрыть")]
                                                                                          ),
                                                                                      ]),
                                                                                      A("div", { staticClass: "modal_content d-flex flex-column align-items-start" }, [
                                                                                          A("label", { domProps: { textContent: _._s(_.$ml.get("p8_link")) } }, [_._v("Ссылка на фотографию")]),
                                                                                          A("input", {
                                                                                              directives: [{ name: "model", rawName: "v-model", value: _.inputImage, expression: "inputImage" }],
                                                                                              staticClass: "photo_upload",
                                                                                              domProps: { value: _.inputImage },
                                                                                              on: {
                                                                                                  input: function (e) {
                                                                                                      e.target.composing || (_.inputImage = e.target.value);
                                                                                                  },
                                                                                              },
                                                                                          }),
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  staticClass: "btn btn-green",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p8_save")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          return _.addImageToPlayer();
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Save")]
                                                                                          ),
                                                                                      ]),
                                                                                  ]),
                                                                              ])
                                                                            : _._e(),
                                                                    ]),
                                                                    ////
                                                                    A("transition", { attrs: { name: "list" } }, [
                                                                        _.showModalE
                                                                            ? A("div", { staticClass: "police-modal" }, [
                                                                                  A("div", { staticClass: "modal_inner" }, [
                                                                                      A("div", { staticClass: "d-flex justify-content-between" }, [
                                                                                          A("h2", { domProps: { textContent: _._s(_.$ml.get("p3_ticket")) } }, [_._v("Выписка штрафа")]),
                                                                                          A(
                                                                                              "button",
                                                                                              {
                                                                                                  staticClass: "btn btn-gold",
                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_close")) },
                                                                                                  on: {
                                                                                                      click: function (e) {
                                                                                                          (_.showModalE = !1), _.clearViolationList();
                                                                                                      },
                                                                                                  },
                                                                                              },
                                                                                              [_._v("Закрыть")]
                                                                                          ),
                                                                                      ]),
                                                                                      A("div", { staticClass: "modal_content" }, [
                                                                                          A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p3_officer")) } }, [_._v("Имя офицера: ")]), _._v(_._s(_.playerData.name))]),
                                                                                          A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p3_name")) } }, [_._v("Нарушитель: ")]), _._v(_._s(_.activePlayer.name))]),
                                                                                          A("h5", [A("span", { domProps: { textContent: _._s(_.$ml.get("p3_date2")) } }, [_._v("Дата: ")]), _._v(_._s(_.todayDate()))]),
                                                                                          A("h4", { domProps: { textContent: _._s(_.$ml.get("p3_violations")) } }, [_._v("Список нарушений:")]),
                                                                                          A(
                                                                                              "div",
                                                                                              { staticClass: "violation_list added scrolled" },
                                                                                              _._l(_.activeViolations, function (e, E) {
                                                                                                  return A("div", { key: "addedviolation" + E, staticClass: "violation_item" }, [
                                                                                                      A("div", { staticClass: "violation_item_code" }, [_._v(" " + _._s(e.code) + " ")]),
                                                                                                      A("div", { staticClass: "violation_item_name" }, [_._v(" " + _._s(e.name) + " ")]),
                                                                                                      A("div", { staticClass: "violation_item_penalty" }, [
                                                                                                          _._v(" " + _._s(e.penalty)),
                                                                                                          A(
                                                                                                              "span",
                                                                                                              {
                                                                                                                  directives: [{ name: "show", rawName: "v-show", value: e.penalty, expression: "violation.penalty" }],
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_short")) },
                                                                                                              },
                                                                                                              [_._v("мин.")]
                                                                                                          ),
                                                                                                      ]),
                                                                                                      A("div", { staticClass: "violation_item_price" }, [_._v(" " + _._s(e.price) + " ")]),
                                                                                                      A("div", { staticClass: "violation_item_button" }, [
                                                                                                          A(
                                                                                                              "a",
                                                                                                              {
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_delete")) },
                                                                                                                  on: {
                                                                                                                      click: function (e) {
                                                                                                                          return _.deleteViolationFromList(E);
                                                                                                                      },
                                                                                                                  },
                                                                                                              },
                                                                                                              [_._v("Удалить")]
                                                                                                          ),
                                                                                                      ]),
                                                                                                  ]);
                                                                                              }),
                                                                                              0
                                                                                          ),
                                                                                          A(
                                                                                              "div",
                                                                                              { staticClass: "violation_list scrolled" },
                                                                                              _._l(_.allLaws, function (e, E) {
                                                                                                  return A("div", { key: "violations" + E, staticClass: "violation_item" }, [
                                                                                                      A("div", { staticClass: "violation_item_code" }, [_._v(" " + _._s(e.code) + " ")]),
                                                                                                      //A("input", { staticClass: "violation_item_name" }, [_._v(" " + _._s(e.name) + " ")]),
                                                                                                      A("input", {
																										attrs: { id: "input-vio-text-" + E },
                                                                                                        staticClass: "violation_item_name",
                                                                                                        }),
                                                                                                      A("div", { staticClass: "violation_item_penalty" }, [
                                                                                                          _._v(" " + _._s(e.penalty)),
                                                                                                          A(
                                                                                                              "span",
                                                                                                              {
                                                                                                                  directives: [{ name: "show", rawName: "v-show", value: e.penalty, expression: "violation.penalty" }],
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_short")) },
                                                                                                              },
                                                                                                              [_._v("мин.")]
                                                                                                          ),
                                                                                                      ]),//, [_._v(" $" + _._s(e.price) + " ")]
                                                                                                      A("div", { staticClass: "violation_item_price" ,attrs: { id: "input-vio-price-" + E } }),
                                                                                                      A("div", { staticClass: "violation_item_button" }, [
                                                                                                          A(
                                                                                                              "a",
                                                                                                              {
                                                                                                                  domProps: { textContent: _._s(_.$ml.get("p3_add")) },
                                                                                                                  on: {
                                                                                                                      click: function (e) {
                                                                                                                          return _.addViolationToList(E);
                                                                                                                      },
                                                                                                                  },
                                                                                                              },
                                                                                                              [_._v("Добавить")]
                                                                                                          ),
                                                                                                      ]),
                                                                                                  ]);
                                                                                              }),
                                                                                              0
                                                                                          ),
                                                                                      ]),
                                                                                      A("div", { staticClass: "d-flex justify-content-between align-items-center" }, [
                                                                                          A("h5", [
                                                                                              //A("span", { domProps: { textContent: _._s(_.$ml.get("p3_amount2")) } }, [_._v("Сумма")]),
                                                                                             // _._v(": $" + _._s(_.violationsSum)),
                                                                                              A("span", { directives: [{ name: "show", rawName: "v-show", value: _.violationsTime, expression: "violationsTime" }], staticClass: "nob" }, [
                                                                                                  _._v(", "),
                                                                                                  A("span", { domProps: { textContent: _._s(_.$ml.get("p3_time")) } }, [_._v("срок")]),
                                                                                                  _._v(": " + _._s(_.violationsTime) + " "),
                                                                                                  A("span", { domProps: { textContent: _._s(_.$ml.get("p3_short")) } }, [_._v("мин.")]),
                                                                                                  _._v(" (" + _._s(_.violationsTimeConverted) + " h.)"),
                                                                                              ]),
                                                                                          ]),
                                                                                          A("button", { staticClass: "btn btn-gold", domProps: { textContent: _._s(_.$ml.get("p3_write")) }, on: { click: _.issueFine2 } }, [
                                                                                              _._v("Выписать штраф"),
                                                                                          ]),
                                                                                      ]),
                                                                                  ]),
                                                                              ])
                                                                            : _._e(),
                                                                    ]),
                                                                ],
                                                                1
                                                            ),
                                                        ]),
                                                    ]),
                                                ]),
                                            ],
                                            1
                                        ),
                                    ]),
                                ]),
                            ]),
                        ],
                        1
                    );
                }),
            T = [],
            R = (A("1276"), A("ac1f"), A("fb6a"), A("7db0"), A("c740"), A("159b"), A("4de4"), A("4d63"), A("25f0"), A("841c"), A("d3b7"), A("caad"), A("2532"), A("a434"), A("13d5"), A("bc3a")),
            l = A.n(R),
            C = A("1f8d"),
            S = A("8328"),
            O = A("388f"),
            t = {
                name: "PoliceCad",
                components: {},
                props: { playerData: Object },
                data: function () {
                    return {
                        show: !1,
                        logged: 0,
                        wait: 0,
                        page: 0,
                        activeMenu: 0,
                        panicOn: !1,
                        playerOnPatrol: "Not selected",
                        policeCodes: {},
                        allVehicles: S,
                        allLaws: O,
                        policeData: this.playerData.policeData,
                        playersList: [],
                        weaponList: [],
                        ___: '',
                        wantedList: [],
                        vehiclesList: [],
                        ticketsList: [],
                        policeCallsList: [],
                        policeDutyList: [],
                        policeAdamList: [],
                        activePlayer: {},
                        activeTickets: [],
                        activeCall: {},
                        activeVehicle: {},
                        activeViolations: [],
                        activeCop: {},
                        activePanic: [],
                        searchInput: "",
                        searchIdInput: "",
                        search10Input: "",
                        searchLawsInput: "",
                        searchVehicleInput: "",
                        statusNames: ["Under control", "Unknown", "Normal", "Threat", "Danger"],
                        playerStatusNames: ["Standard",  "Arrested" , "Wanted" , "In prison", "Special"],
                        vehicleStatusNames: ["Standard", "Arrested", "Wanted", "Stolen", "Special"],
                        weaponStatusNames: ["Standard", "Wanted", "Stolen"],
                        rankList: [
                            { name: "Recruet", shortname: "rec" },
                            { name: "Officer", shortname: "po1" },
                            { name: "Sergeant", shortname: "ser1" },
                            { name: "Lieutenant", shortname: "lie" },
                            { name: "Commandant", shortname: "chief" },
                        ],
                        rankAdmin: 4,
                        showDropdownA: !1,
                        showDropdownB: !1,
                        showDropdownC: !1,
                        showDropdownD: !1,
                        showModalA: !1,
                        showModalB: !1,
                        showModalC: !1,
                        showModalE: !1,
                        sureFire: !1,
                        violationsSum: 0,
                        violationsTime: 0,
                        violationsTimeConverted: 0,
                        callsignTemp: "",
                        inputImage: void 0,
                    };
                },
                methods: {
                    closeCad: function () {
                        l.a
                            .post("https://sunset_cad/CloseCad", {})
                            .then(function () {})
                            .catch(function () {
                                console.log();
                            });
                    },
                    login: function () {
                        var _ = this;
                        (this.logged = 1),
                            this.showAdamList(),
                            this.sortyBycallsign(this.policeDutyList),
                           // this.addTicketsToPlayers(),
                           // this.addVehiclesToPlayers(),
                           // this.showAll(this.playersList),
                            this.showAll(this.policeCallsList),
                            //this.showAll(this.vehiclesList),
                            this.showAll(this.allLaws),
                            this.sortByDate(this.policeCallsList),
                           // this.sortByNames(this.playersList),
                           // this.sortByNumbers(this.vehiclesList),
                            this.convertPoliceCodes(),
                            setTimeout(function () {
                                _.logged = 2;
                            }, 2e3);
                    },
                    ShowLoading: function (second) {
                        var _ = this;
                        (this.logged = 1),                        
                            setTimeout(function () {
                                _.logged = 2;
                            }, second * 1000);
                    },
                    StartWait:function (functioncode) {
                        var _ = this;
                        this.wait = 1
                        this.logged = 1
                        function wait() {
                            if (_.wait == 0){
                                functioncode()
                             } else {
                                setTimeout(wait, 100);
                            }  
                        }
                        setTimeout(wait, 100);
                    },
                    selectMenu: function (_) {
                        (this.activeMenu = _), this.selectPage(_), (this.showModalA = !1), (this.showModalB = !1), (this.showModalC = !1),(this.showModalE = !1), this.clearViolationList(), this.closeDropDowns();
                    },
                    selectPage: function (_) {
                        (this.page = _), this.closeDropDowns();
                    },
                    closeDropDowns: function () {
                        (this.showDropdownA = !1), (this.showDropdownB = !1), (this.showDropdownC = !1), (this.showDropdownD = !1);
                    },
                    getName: function (_) {
                        var e = _.split(" ");
                        return e[0];
                    },
                    getSurname: function (_) {
                        var e = _.split(" ");
                        return e[1];
                    },
                    getDate: function (_) {
                        var e = new Date(_);
                        if (e) {
                            var A = e.getFullYear(),
                                E = ("0" + (e.getMonth() + 1)).slice(-2),
                                a = ("0" + e.getDate()).slice(-2);
                            return a + "." + E + "." + A;
                        }
                        return (e = "01.01.1900"), e;
                    },
                    todayDate: function () {
                        var _ = new Date(),
                            e = ("0" + _.getHours()).slice(-2),
                            A = ("0" + _.getMinutes()).slice(-2),
                            E = _.getFullYear(),
                            a = ("0" + (_.getMonth() + 1)).slice(-2),
                            N = ("0" + _.getDate()).slice(-2),
                            L = e + ":" + A + " " + N + "." + a + "." + E;
                        return L;
                    },
                    getStatus: function (_) {
                        return this.statusNames[_];
                    },
                    getPlayerStatus: function (_) {
                        return this.playerStatusNames[_];
                    },
                    getPlayerStatus2: function (_) {
                        return _ <= 1 ? void 0 : this.playerStatusNames[_];
                    },
                    getVehicleStatus: function (_) {
                        return _ <= 1 ? void 0 : this.vehicleStatusNames[_];
                    },
                    getOwnerName: function (_) {
                        var e = this.playersList.find(function (e) {
                            return e.name == _;
                        });
                        if (e) return e.name;
                        var A = "unknown";
                        return A;
                    },
                    getOwnerId: function (_) {
                        var e = this.playersList.find(function (e) {
                            return e.id == _;
                        });
                        if (e) return e.name;
                        var A = "unknown";
                        return A;
                    },
                    getOwnerPhone: function (_) {
                        var e = this.playersList.find(function (e) {
                            return e.id == _;
                        });
                        return e ? e.phone : void 0;
                    },
                    getOwnerPhoneByName: function (_) {
                        var e = this.playersList.find(function (e) {
                            return e.name == _;
                        });
                        return e ? e.phone : void 0;
                    },
                    GetIdentifierByPhone: function (_) {
                        var e = this.playersList.find(function (e) {
                            return e.phone == _;
                        });
                        return e ? e.identifier : void 0;
                    },
                    getCallsignById: function (_) {
                        var e = this.policeDutyList.find(function (e) {
                            return e.policeId == _;
                        });
                        return e ? e.callsign : void 0;
                    },
                    findCarByName: function (_) {
                        if (_) {
                            var e = this.allVehicles.find(function (e) {
                                return e.gameName == _;
                            });
                            return e;
                        }
                    },
                    findPlayerIndexByidentifier: function (_) {
                        if (void 0 != _)
                            return this.playersList.findIndex(function (e) {
                                return e.identifier == _;
                            });
                    },
                    findPlayerIndexByName: function (_) {
                        if (void 0 != _)
                            return this.playersList.findIndex(function (e) {
                                return e.name == _;
                            });
                    },
                    findVehicleIndexById: function (_) {
                        if (void 0 != _)
                            return this.vehiclesList.findIndex(function (e) {
                                return e.carId == _;
                            });
                    },
                    findVehicleIndexByPlate: function (_) {
                        if (void 0 != _)
                            return this.vehiclesList.findIndex(function (e) {
                                return e.number == _;
                            });
                    },
                    addTicketsToPlayers: function () {
                        var _ = this;
                        this.playersList.forEach(function (e) {
                            e.tickets = _.ticketsList.filter(function (_) {
                                return _.identifier == e.identifier;
                            });
                        });
                    },
                    addVehiclesToPlayers: function () {
                        var _ = this;
                        this.playersList.forEach(function (e) {
                            e.cars = _.vehiclesList.filter(function (_) {
                                return _.owner == e.identifier;
                            });
                        });
                    },
                    showAll: function (_) {
                        _.forEach(function (_) {
                            return (_.show = !0);
                        });
                    },
                    searchName: function () {
                        var _ = this,
                            e = this.searchInput;
                        if (e) {
                            l.a
                                .post("https://sunset_cad/GetUser", { value : e })
                                .then(function (data) {

                                    //_.playersList = data.data
                                   // console.log(JSON.stringify( _.playersList))
                                    _.playersList = JSON.parse(data)
                                    _.showAll(_.playersList)
                                })
                                .catch(function () {
                                    console.log();
                                });
                            
                        };
                    },
                    searchWeapon: function () {
                        var _ = this,
                            e = this.searchInput;
                        if (e) {
                            l.a
                                .post("https://sunset_cad/GetWeapon", { value : e })
                                .then(function (data) {
                                    //_.weaponList = JSON.parse(data.data)
                                    //_.showAll(_.weaponList)
                                })
                                .catch(function () {
                                    console.log();
                                });
                            
                        };
                    },
                    SetVehicleData: function (plate,data) {
                            l.a
                                .post("https://sunset_cad/UpdateVehicleData", { plate : plate, data : data})
                                .then(function (data) {

                                })
                                .catch(function () {
                                    console.log();
                                });
                            
                    },
                    searchId: function () {
                        var _ = this,
                            e = this.searchIdInput;
                        if (e) {
                            var A = new RegExp(e, "igm");
                            this.policeCallsList.forEach(function (e) {
                                var E = e.id.toString() + _.getDate(e.date) + e.from + _.getStatus(e.status),
                                    a = E.search(A);
                                e.show = -1 != a;
                            });
                        } else this.showAll(this.policeCallsList);
                    },
                    searchPoliceCodes: function () {
                        var _ = this.search10Input;
                        if (_) {
                            var e = new RegExp(_, "igm");
                            for (var A in this.policeCodes) {
                                var E = this.policeCodes[A],
                                    a = E.text.toString(),
                                    N = a.search(e);
                                E.show = -1 != N;
                            }
                        } else for (var L in this.policeCodes) this.policeCodes[L].show = !0;
                    },
                    searchVehicle: function () {
                        // if (this.playerData.policeData.grade < 5) {
                        //     this.SendNotify('Error','Shoma dastresi kafi nadarid',10000,'error')
                        //     this.logged = 2
                        //     return; 
                        // }
                        var _ = this,
                            e = this.searchVehicleInput;
                            if (e) {
                                l.a
                                    .post("https://sunset_cad/GetVehicle", { value : e })
                                    .then(function (data) {
                                        _.vehiclesList = JSON.parse(data.data)
                                        _.showAll(_.vehiclesList)
                                    })
                                    .catch(function () {
                                        console.log();
                                    });
                                
                            };

                    },
                    SendNotify: function(title,text,time,type) {
                        l.a
                        .post("https://sunset_cad/ShowNotify", { title : title , text : text , time : time ,type : type})
                        .then(function (data) {

                        })
                        .catch(function () {
                            console.log();
                        });
                    },
                    searchVehicle2: function () {
                        var _ = this,
                            e = this.searchVehicleInput;
                        if (e) {
                            var A = new RegExp(e, "igm");
                            this.vehiclesList.forEach(function (e) {
                                var E = e.name + " " + e.type + " " + _.getOwnerName(e.ownerId) + e.number + e.carId + _.getVehicleStatus(e.status),
                                    a = E.search(A);
                                e.show = -1 != a;
                            });
                        } else this.showAll(this.vehiclesList);
                    },
                    searchLaws: function () {
                        var _ = this.searchLawsInput;
                        if (_) {
                            var e = new RegExp(_, "igm");
                            this.allLaws.forEach(function (_) {
                                var A = _.code + " " + _.name + " " + _.price,
                                    E = A.search(e);
                                _.show = -1 != E;
                            });
                        } else this.showAll(this.allLaws);
                    },
                    showFullContact: function (_) {
                        (this.activeMenu = 2), (this.page = 21), (this.activePlayer = this.playersList[_]), (this.activeTickets = this.activePlayer.tickets);
                    },
                    showFullContact2: function (_) {
                        if (this.weaponList[_].data.serial.includes("GS-")){
                            this.___ = 'Owner name : ' + this.weaponList[_].data.name
                        }
                        else{
                            this.___ = ''
                        }
                        (this.activeMenu = 2), (this.page = 23), (this.activePlayer = this.weaponList[_]);
                    },
                    LoadPlayerByName: function (_) {
                        l.a
                                .post("https://sunset_cad/GetUser", { value : _ })
                                .then(function (data) {

                                    //_.playersList = data.data
                                   // console.log(JSON.stringify( _.playersList))
                                    _.playersList = JSON.parse(data)
                                })
                                .catch(function () {
                                    console.log();
                                });
                    },
                    showFullVehiclePage: function (_) {
                        (this.activeVehicle = this.vehiclesList[_]), (this.activeMenu = 3), (this.page = 31);
                    },
                    showFullPoliceCall: function (_) {
                        (this.activeCall = this.policeCallsList[_]), (this.page = 11);
                    },
                    sortByDate: function (_) {
                        _.sort(function (_, e) {
                            var A = new Date(_.date),
                                E = new Date(e.date);
                            return E - A;
                        });
                    },
                    sortByNames: function (_) {
                        _.sort(function (_, e) {
                            return _.name.localeCompare(e.name);
                        });
                    },
                    sortyBycallsign: function (_) {
                        _.sort(function (_, e) {
                            return _.callsign.localeCompare(e.callsign);
                        });
                    },
                    sortByNumbers: function (_) {
                        _.sort(function (_, e) {
                            return _.carId - e.carId;
                        });
                    },
                    onScene: function (_) {
                        if (!_) return !1;
                        var e = this.policeData.policeId;
                        return !!_.includes(e);
                    },
                    showDropDown: function (_) {
                        1 == _ && (this.showDropdownA = !this.showDropdownA), 2 == _ && (this.showDropdownB = !this.showDropdownB), 3 == _ && (this.showDropdownC = !this.showDropdownC), 4 == _ && (this.showDropdownD = !this.showDropdownD);
                    },
                    setMark: function (_) {
                        console.log(_),
                            l.a
                                .post("https://sunset_cad/SetMark", { id: this.activeCall.id })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    leaveScene: function (_) {
                        var e = this,
                            A = this.onScene(_),
                            E = this.policeData.policeId;
                        A
                            ? this.activeCall.crew.forEach(function (_, A) {
                                  _ == E && e.activeCall.crew.splice(A, 1);
                              })
                            : (this.activeCall.crew || this.$set(this.activeCall, "crew", []),
                              this.activeCall.crew.push(E),
                              l.a
                                  .post("https://sunset_cad/Crew", { crew: E, id: this.activeCall.id })
                                  .then(function () {})
                                  .catch(function () {
                                      console.log();
                                  }));
                    },
                    changeStatus: function (_) {
                        (this.activeCall.status = _),
                            (this.showDropdownA = !1),
                            l.a
                                .post("https://sunset_cad/ChangeCallStatus", { status: this.activeCall.status, id: this.activeCall.id })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    changePlayerStatus: function (_) {
                        (this.activePlayer.status = _),
                            (this.showDropdownB = !1),
                            l.a
                                .post("https://sunset_cad/ChangePlayerStatus", { status: this.activePlayer.status, identifier: this.activePlayer.identifier })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    changeWeaponStatus: function (_) {
                        (this.activePlayer.saveddata.status = _),
                            (this.showDropdownB = !1),
                            l.a
                                .post("https://sunset_cad/ChangeWeaponStatus", { status: this.activePlayer.saveddata.status, serial: this.activePlayer.data.serial })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    changePatrolStatus: function (_) {
                        var e = this,
                            A = this.policeDutyList.findIndex(function (_) {
                                return _.policeId == e.policeData.policeId;
                            });
                        0 == _
                            ? ((this.playerOnPatrol = "Not selected"), (this.policeDutyList[A].adam = void 0), this.showAdamList())
                            : ((this.policeDutyList[A].adam = _), (this.playerOnPatrol = this.generateAdamName(_)), this.showAdamList()),
                            (this.showDropdownC = !1),
                            l.a
                                .post("https://sunset_cad/ChangePatrolStatus", { policeId: this.policeDutyList[A].policeId.toString(), status: _ })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    changeVehicleStatus: function (_) {
                        (this.activeVehicle.status = _),
                            (this.showDropdownB = !1),
                            l.a
                                .post("https://sunset_cad/ChangeVehicleStatus", { status: this.activeVehicle.status, plate: this.activeVehicle.number })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    changeShift: function (_) {
                        var e = this;
                        this.policeData.onDuty = _;
                        var A = this.policeDutyList.find(function (_) {
                            return _.policeId == e.policeData.policeId;
                        });
                        (A.onDuty = this.policeData.onDuty),
                            l.a
                                .post("https://sunset_cad/ChangeShift", { shift: _, policeId: this.policeData.policeId })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    panicClick: function () {
                        var _ = this;
                        (this.panicOn = !this.panicOn), (this.policeData.onPanic = this.panicOn);
                        var e = this.policeDutyList.find(function (e) {
                            return e.policeId == _.policeData.policeId;
                        });
                        (e.onPanic = this.policeData.onPanic),
                            this.onPanic(),
                            1 == this.panicOn
                                ? l.a
                                      .post("https://sunset_cad/PanicOn", {})
                                      .then(function () {})
                                      .catch(function () {
                                          console.log();
                                      })
                                : l.a
                                      .post("https://sunset_cad/PanicOff", { shift: this.policeData.onDuty, policeId: this.policeData.policeId })
                                      .then(function () {})
                                      .catch(function () {
                                          console.log();
                                      });
                    },
                    convertPoliceCodes: function () {
                        var _ = this;
                        (this.policeCodes = {}),
                            C.forEach(function (e, A) {
                                _.policeCodes[A] = { text: e.toString(), show: !0 };
                            });
                    },
                    checkPaid: function (_) {
                        return _ ? "Yes" : "No";
                    },
                    checkLicense: function (_) {
                        return _ ? "Присутствует" : "Отсутствует";
                    },
                    addTicketToActivePlayer: function () {
                        this.showModalA = !0;
                    },
                    addTicketToActiveWeapon: function () {
                        this.showModalE = !0;
                    },
                    deleteTicket: function (_,_2) {
                        // if (this.playerData.policeData.grade < 10) {
                        //     this.SendNotify('Error','Shoma dastresi kafi nadarid',10000,'error')
                        //     return; 
                        // }
                        var e = this.activeTickets[_].id;
                        this.activeTickets.splice(_, 1),
                            l.a
                                .post("https://sunset_cad/DeleteTicket", { id: _2 })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    deleteTicket2: function (_) {
                        // if (this.playerData.policeData.grade < 10) {
                        //     this.SendNotify('Error','Shoma dastresi kafi nadarid',10000,'error')
                        //     return; 
                        // }
                        this.activeTickets.splice(_, 1),
                            l.a
                                .post("https://sunset_cad/DeleteTicketWeapon", { id: _ ,serial: this.activePlayer.data.serial})
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    addViolationToList: function (_) {
						const text = document.getElementById('input-vio-text-'+_).value
						const insertData = {"code":this.activeViolations.length + 1,"name":text,"fulltext":"test","price":""};
						this.activeViolations.push(insertData), this.calculateViolations();
                        //this.activeViolations.push(this.allLaws[_]), this.calculateViolations();
                    },
                    deleteViolationFromList: function (_) {
                        this.activeViolations.splice(_, 1), this.calculateViolations();
                    },
                    clearViolationList: function () {
                        (this.activeViolations = []), this.calculateViolations();
                    },
                    calculateViolations: function () {
                        var _ = this;
                        (this.violationsSum = 0),
                            (this.violationsTime = 0),
                            this.activeViolations.forEach(function (e) {
                                e.price && (_.violationsSum += parseInt(e.price)), e.penalty && (_.violationsTime += parseInt(e.penalty));
                            }),
                            (this.violationsTimeConverted = this.violationsTime / 60);
                    },
                    issueFine: function () {
                        var _ = this;
                        var identifier = _.activePlayer.identifier;
                        this.activeViolations.forEach(function (e, A) {
                            var E = e;
                            // (E.id = 0),
                            //     (E.ownerId = _.activePlayer.id),
                            //     (E.operatorId = _.playerData.id),
                            //     (E.date = new Date()),
                            //     (E.paid = !1),
                            //     (E.text = _.activeViolations[A].name),
                            _.selectMenu(2);
                            _.StartWait(() => {
                                _.showFullContact(_.findPlayerIndexByidentifier(identifier));
                            });
                                l.a
                                    .post("https://sunset_cad/NewData", {
                                        text: E.name,
                                        identifier: identifier,
                                    })
                                    .then(function () {
                                    })
                                    .catch(function () {
                                        console.log();
                                    });
                                    
                        }),
                            //this.addTicketsToPlayers(),
                            (this.showModalA = !1),
                            this.clearViolationList();
                    },
                    issueFine2: function () {
                        var _ = this;
                        var identifier = _.activePlayer.data.serial;
                        this.activeViolations.forEach(function (e, A) {
                            var E = e;
                            _.selectMenu(4);
                            _.StartWait(() => {
                                _.showFullContact2(_.activePlayer.data.serial);
                            });
                                l.a
                                    .post("https://sunset_cad/NewDataWeapon", {
                                        text: E.name,
                                        serial: identifier,
                                    })
                                    .then(function () {
                                    })
                                    .catch(function () {
                                        console.log();
                                    });
                                    
                        }),
                            (this.showModalE = !1),
                            this.clearViolationList();
                    },
                    getRandomInt: function (_, e) {
                        return (_ = Math.ceil(_)), (e = Math.floor(e)), Math.floor(Math.random() * (e - _)) + _;
                    },
                    showWantedPerson: function (_) {
                        return this.wantedList;
                    },
                    showWantedVehicles: function (_) {
                        return this.vehiclesList.filter(function (e) {
                            return e.status === _;
                        });
                    },
                    showOnDuty: function (_) {
                        return _
                            ? this.policeDutyList.filter(function (_) {
                                  return 0 != _.onDuty;
                              })
                            : this.policeDutyList.filter(function (_) {
                                  return 0 == _.onDuty;
                              });
                    },
                    groupBy: function (_, e) {
                        return _.reduce(function (_, A) {
                            return (_[A[e]] = _[A[e]] || []).push(A), _;
                        }, {});
                    },
                    showAdamList: function () {
                        this.policeAdamList = [];
                        var _ = [];
                        this.policeDutyList.forEach(function (e) {
                            void 0 != e.adam && _.push(e);
                        }),
                            (this.policeAdamList = this.groupBy(_, "adam"));
                    },
                    generateAdamName: function (_) {
                        var e = this.policeAdamList[_];
                        if (e) {
                            var A = [],
                                E = [];
                            e.forEach(function (_) {
                                return A.push(_.callsign.slice(0, 1));
                            });
                            var a = Math.min.apply(Math, A);
                            e.forEach(function (_) {
                                return E.push(_.rank);
                            });
                            var N = Math.max.apply(Math, E),
                                L = e.find(function (_) {
                                    return _.rank == N;
                                });
                            return a + "A—" + L.callsign.slice(-1);
                        }
                        return this.policeData.callsign.slice(0, 1) + "A—" + this.policeData.callsign.slice(-1);
                    },
                    showPoliceFullPage: function (_) {
                        (this.activeCop = this.policeDutyList[_]), (this.showModalB = !0), (this.callsignTemp = this.activeCop.callsign);
                    },
                    saveNewCallsign: function () {
                        (this.activeCop.callsign = this.callsignTemp),
                            l.a
                                .post("https://sunset_cad/SaveNewCallsign", { callsign: this.activeCop.callsign, policeId: this.activeCop.policeId })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    fireCop: function (_) {
                        var e = this.policeDutyList.findIndex(function (e) {
                            return e.policeId == _.policeId;
                        });
                        this.policeDutyList.splice(e, 1),
                            (this.showModalB = !1),
                            (this.sureFire = !1),
                            (this.showDropdownD = !1),
                            this.showAdamList(),
                            l.a
                                .post("https://sunset_cad/FireCop", { policeId: _.policeId })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    changePlayerRank: function (_) {
                        (this.activeCop.rank = _),
                            (this.showDropdownD = !1),
                            l.a
                                .post("https://sunset_cad/ChangePlayerRank", { rank: this.activeCop.rank, policeId: this.activeCop.policeId })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    onPanic: function () {
                        var _ = !1;
                        return (
                            this.policeDutyList.forEach(function (e) {
                                1 == e.onPanic && (_ = !0);
                            }),
                            _
                        );
                    },
                    addImageToPlayer: function () {
                        (this.activePlayer.picture = this.inputImage),
                            (this.inputImage = void 0),
                            (this.showModalC = !1),
                            l.a
                                .post("https://sunset_cad/AddImageToPlayer", { image: this.activePlayer.picture, identifier: this.activePlayer.identifier })
                                .then(function () {})
                                .catch(function () {
                                    console.log();
                                });
                    },
                    convertCrew: function () {
                        this.policeCallsList.forEach(function (_) {
                            var e = JSON.parse(_.crew);
                            _.crew = e;
                        });
                    },
                    doCommand: function (_) {
                        27 == _.keyCode
                            ? l.a
                                  .post("https://sunset_cad/CloseCad", {})
                                  .then(function () {})
                                  .catch(function () {
                                      console.log();
                                  })
                            : 192 == _.keyCode &&
                              l.a
                                  .post("https://sunset_cad/Tilda", {})
                                  .then(function () {})
                                  .catch(function () {
                                      console.log();
                                  });
                    },
                },
                mounted: function () {
                    var _ = this;
                    (this.show = !0),
                        window.addEventListener(
                            "message",
                            function (e) {
                                if ("VehicleData" == e.data.type) (_.vehiclesList = JSON.parse(e.data.data)) ,_.addVehiclesToPlayers(), _.showAll(_.vehiclesList);
                                else if ("WantedData" == e.data.type) (_.wantedList = JSON.parse(e.data.data));
                                else if ("UserData" == e.data.type) (_.playersList = JSON.parse(e.data.data)), _.showAll(_.playersList), _.addTicketsToPlayers(), _.addVehiclesToPlayers();
                                else if ("WeaponData" == e.data.type) (_.weaponList = JSON.parse(e.data.data));
                                else if ("UpdateWeaponData" == e.data.type) (_.weaponList[e.data.data.serial].saveddata = e.data.data );
                                else if ("LoadTicket" == e.data.type) (_.ticketsList = JSON.parse(e.data.data)), _.showAll(_.ticketsList), _.addTicketsToPlayers();
                                //else if ("GetTickets" == e.data.type) (_.ticketsList = JSON.parse(e.data.data)), _.showAll(_.ticketsList), _.addTicketsToPlayers(), (_.activeTickets = _.activePlayer.tickets);
                                else if ("StopWait" == e.data.type){
                                    _.logged = 2
                                    _.wait = 0
                                }
                                else if ("VehiclesStatus" == e.data.type) {
                                    var A = JSON.parse(e.data.data);
                                    A.forEach(function (e) {
                                        var A = _.vehiclesList.findIndex(function (_) {
                                            return _.number == e.number;
                                        });
                                        _.vehiclesList[A].status = e.status;
                                    }),
                                        _.showAll(_.vehiclesList);
                                }
                                else if ("CitizensStatus" == e.data.type) {
                                    var E = JSON.parse(e.data.data);
                                    E.forEach(function (e) {
                                        var A = _.playersList.findIndex(function (_) {
                                            return _.name == e.name;
                                        });
                                        _.playersList[A].status = e.status;
                                    });
                                } else
                                    "GetPoliceCalls" == e.data.type
                                        ? ((_.policeCallsList = JSON.parse(e.data.data)), _.showAll(_.policeCallsList))
                                        : "GetPoliceOnDuty" == e.data.type &&
                                          ((_.policeDutyList = JSON.parse(e.data.data)),
                                          _.onPanic(),
                                          _.showAdamList(),
                                          _.sortyBycallsign(_.policeDutyList),
                                          _.addTicketsToPlayers(),
                                          _.addVehiclesToPlayers(),
                                          _.showAll(_.playersList),
                                          _.showAll(_.policeCallsList),
                                          _.showAll(_.vehiclesList),
                                          _.showAll(_.allLaws),
                                          _.sortByDate(_.policeCallsList),
                                          _.sortByNames(_.playersList),
                                          _.sortByNumbers(_.vehiclesList),
                                          _.convertPoliceCodes());
                            },
                            !1
                        );
                },
                created: function () {
                    window.addEventListener("keydown", this.doCommand);
                },
                destroyed: function () {
                    window.addEventListener("keydown", this.doCommand);
                },
            },
            s = t,
            G = (A("95ec"), A("2877")),
            I = Object(G["a"])(s, L, T, !1, null, "03058434", null),
            F = I.exports,
            m = {
                name: "App",
                components: { PoliceCad: F },
                data: function () {
                    return {
                        showPage: "",
                        characterList: [],
                        playerData: { id: 1, phone: "8004455", name: "Javier Bennett", age: "33", roles: "police", money: 4500099, policeData: { rank: 4, callsign: "2L—1", policeId: 555e4, onDuty: 1 } },
                    };
                },
                methods: {},
                computed: {},
                mounted: function () {
                    var _ = this;
                    window.addEventListener(
                        "message",
                        function (e) {
                            "UpdatePlayerData" == e.data.type
                                ? ((_.playerData.phone = e.data.phone),
                                  (_.playerData.name = e.data.name),
                                  (_.playerData.roles = e.data.job),
                                  (_.playerData.policeData.policeId = e.data.policeId),
                                  (_.playerData.policeData.callsign = e.data.callsign),
                                  (_.playerData.policeData.rank = e.data.rank),
                                  (_.playerData.policeData.grade = e.data.grade))
                                : "OpenPoliceCad" == e.data.type
                                ? (_.showPage = "PoliceCad")
                                : "ClosePoliceCad" == e.data.type && (_.showPage = "");
                        },
                        !1
                    );
                },
            },
            i = m,
            o = (A("034f"), Object(G["a"])(i, a, N, !1, null, null, null)),
            P = o.exports,
            c = A("353c");
        E["default"].use(c["MLInstaller"]);
        new c["MLCreate"]({
            initial: "en",
            save: !0,
            languages: [
                new c["MLanguage"]("en").create({
                    button_enter: "Login",
                    button_exit: "Exit",
                    button_back: "Back",
                    button_leave: "Leaving the call",
                    button_accept: "Take the call",
                    button_map: "Show on map",
                    text_search: "search",
                    text_called: "Called",
                    text_units: "Units on the scene",
                    text_scene: "on scene",
                    text_call: "Call",
                    cad_name: "Sunset CAD",
                    cad_fullname: "Sunset CAD",
                    cad_slogan: "TO PROTECT AND TO SERVE",
                    cad_loading: "Loading",
                    main_button_1: "Main panel",
                    main_button_2: "Calls",
                    main_button_3: "List of citizens",
                    main_button_4: "List of vehicles",
                    main_button_5: "List of weapons",
                    main_button_6: "10-codes",
                    main_button_7: "Management",
                    main_button_panic: "Panic button",
                    title_status_1: "On shift",
                    title_status_2: "On Call",
                    title_status_3: "Busy",
                    title_status_4: "Off shift",
                    p1_title_0: "Active panic button",
                    p1_title_1: "Shift workers",
                    p1_title_2: "Patrol officers",
                    p1_title_3: "People Wanted",
                    p1_title_4: "Wanted cars",
                    p1_leave: "Leave",
                    p1_patrol: "patrol",
                    p1_not_selected: "Not selected",
                    p3_birthdate: "Date of birth",
                    p3_gender: "Gender",
                    p3_phone: "Phone",
                    p3_database: "Database №",
                    p3_status: "Status",
                    p3_vehicles: "Citizen vehicles",
                    p3_ticket: "Data",
                    p3_tickets: "Citizen data",
                    p3_author: "Author",
                    p3_date: "Date",
                    p3_reason: "Reason",
                    p3_amount: "Sum",
                    p3_time: "Time",
                    p3_paid: "Paid",
                    p3_officer: "Officer's name: ",
                    p3_name: "Intruder: ",
                    p3_date2: "Date: ",
                    p3_violations: "List of violations",
                    p3_short: "min",
                    p3_amount2: "Amount",
                    p3_add: "Add",
                    p3_write: "Confirm",
                    p3_delete: "Del",
                    p3_close: "Close",
                    p4_owner: "Owner",
                    p4_number: "Owner number",
                    p4_database: "Database №",
                    p4_status: "Status",
                    p5_text: "Text",
                    p5_time: "Time",
                    p5_penalty: "Penalty",
                    p7_name: "Employee data",
                    p7_officer: "Officer's name: ",
                    p7_rank: "Rank: ",
                    p7_callsign: "Call sign: ",
                    p7_fire: "Fire",
                    p7_close: "Close",
                    p7_change: "Change",
                    p7_sure: "Are you sure?",
                    p7_cancel: "Cancel",
                    p8_name: "Upload a photo",
                    p8_close: "Close",
                    p8_link: "Link to photo",
                    p8_save: "Save",
                }),
                new c["MLanguage"]("ru").create({
                    button_enter: "Войти",
                    button_exit: "Выйти",
                    button_back: "Назад",
                    button_leave: "Покинуть вызов",
                    button_accept: "Принять вызов",
                    button_map: "Показать на карте",
                    text_search: "поиск",
                    text_called: "Вызывавший",
                    text_units: "Юниты на сцене",
                    text_scene: "На сцене",
                    text_call: "Вызов",
                    cad_name: "POLICE CAD",
                    cad_fullname: "Computer-Aided Dispatching",
                    cad_slogan: "TO PROTECT AND TO SERVE",
                    cad_loading: "Загрузка",
                    main_button_1: "Основная панель",
                    main_button_2: "Вызовы",
                    main_button_3: "База жителей",
                    main_button_4: "База автомобилей",
                    main_button_5: "Законы штата",
                    main_button_6: "10-коды",
                    main_button_7: "Управление",
                    main_button_panic: "Кнопка паники",
                    title_status_1: "На смене",
                    title_status_2: "На вызове",
                    title_status_3: "Занят",
                    title_status_4: "Вне смены",
                    p1_title_0: "Активный красный код",
                    p1_title_1: "Сотрудники на смене",
                    p1_title_2: "Сотруники в патруле",
                    p1_title_3: "Люди в розыске",
                    p1_title_4: "Машины в розыске",
                    p1_leave: "Покинуть",
                    p1_patrol: "патруль",
                    p1_not_selected: "Не выбрано",
                    p3_birthdate: "Дата рождения",
                    p3_gender: "Пол",
                    p3_phone: "Телефон",
                    p3_database: "Запись в БД",
                    p3_status: "Статус",
                    p3_vehicles: "Автомобили гражданина",
                    p3_ticket: "Выписать штраф",
                    p3_tickets: "Штрафы гражданина",
                    p3_author: "Выдал",
                    p3_date: "Дата",
                    p3_reason: "Причина",
                    p3_amount: "Сумма",
                    p3_time: "Срок",
                    p3_paid: "Плата",
                    p3_officer: "Имя офицера: ",
                    p3_name: "Нарушитель: ",
                    p3_date2: "Дата: ",
                    p3_violations: "Список нарушений",
                    p3_short: "мин",
                    p3_amount2: "Сумма",
                    p3_add: "Добавить",
                    p3_write: "Выписать штраф",
                    p3_delete: "Удалить",
                    p3_close: "Закрыть",
                    p4_owner: "Владелец",
                    p4_number: "Номер владельца",
                    p4_database: "Запись в БД",
                    p4_status: "Статус",
                    p5_text: "Текст",
                    p5_time: "Срок",
                    p5_penalty: "Штраф",
                    p7_name: "Данные сотрудника",
                    p7_officer: "Имя офицера: ",
                    p7_rank: "Звание: ",
                    p7_callsign: "Позывной: ",
                    p7_fire: "Уволить",
                    p7_close: "Закрыть",
                    p7_change: "Изменить",
                    p7_sure: "Вы уверены?",
                    p7_cancel: "Отменить",
                    p8_name: "Загрузить фотографию",
                    p8_close: "Закрыть",
                    p8_link: "Ссылка на фотографию",
                    p8_save: "Сохранить",
                }),
            ],
        });
        var H = A("5f5b"),
            p = A("b1e0"),
            V = (A("f9e3"), A("2dd8"), A("6672")),
            h = A.n(V),
            n = A("87b8"),
            d = A.n(n),
            D = A("958a"),
            v = A.n(D),
            r = A("d8c5"),
            B = A.n(r),
            g = A("e0ec"),
            M = A.n(g);
        E["default"].use(H["a"]),
            E["default"].use(p["a"]),
            E["default"].use(h.a),
            E["default"].use(d.a),
            E["default"].use(v.a),
            E["default"].use(B.a),
            E["default"].use(M.a),
            (E["default"].config.productionTip = !1),
            new E["default"]({
                render: function (_) {
                    return _(P);
                },
            }).$mount("#app");
    },
    6672: function (_, e, A) {},
    8328: function (_) {
        _.exports = JSON.parse(
            '[{"modelHash":1032823388,"modelName":"ninef","gameName":"NINEF","vehicleMakeName":"OBEY","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2833484545,"modelName":"ninef2","gameName":"NINEF2","vehicleMakeName":"OBEY","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3950024287,"modelName":"blista","gameName":"BLISTA","vehicleMakeName":"DINKA","flags":"FLAG_CAN_HAVE_NEONS FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2485144969,"modelName":"asea","gameName":"ASEA","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2487343317,"modelName":"asea2","gameName":"ASEA","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_EXTRAS_REQUIRE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":524108981,"modelName":"boattrailer","gameName":"BOATTRAILER","vehicleMakeName":"","flags":"FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":3581397346,"modelName":"bus","gameName":"BUS","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_IS_BUS FLAG_USE_FULL_ANIMS_FOR_MP_WARP_ENTRY_POINTS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3087536137,"modelName":"armytanker","gameName":"ARMYTRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_EXPLODE_ON_CONTACT FLAG_DONT_SPAWN_AS_AMBIENT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2818520053,"modelName":"armytrailer","gameName":"ARMYTRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2657817814,"modelName":"armytrailer2","gameName":"ARMYTRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":3517691494,"modelName":"freighttrailer","gameName":"FREIGHTTRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2222034228,"modelName":"coach","gameName":"COACH","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_IS_BUS FLAG_USE_FULL_ANIMS_FOR_MP_WARP_ENTRY_POINTS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1283517198,"modelName":"airbus","gameName":"AIRBUS","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_HAS_LIVERY FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_IS_BUS FLAG_USE_FULL_ANIMS_FOR_MP_WARP_ENTRY_POINTS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2391954683,"modelName":"asterope","gameName":"ASTROPE","vehicleMakeName":"KARIN","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1560980623,"modelName":"airtug","gameName":"AIRTUG","vehicleMakeName":"","flags":"FLAG_IS_ELECTRIC FLAG_DONT_SPAWN_IN_CARGEN FLAG_INCREASE_PED_COMMENTS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1171614426,"modelName":"ambulance","gameName":"AMBULAN","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_HAS_LIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3471458123,"modelName":"barracks","gameName":"BARRACKS","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1074326203,"modelName":"barracks2","gameName":"BARRACKS2","vehicleMakeName":"HVY","flags":"FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3486135912,"modelName":"baller","gameName":"BALLER","vehicleMakeName":"GALLIVAN","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":142944341,"modelName":"baller2","gameName":"BALLER2","vehicleMakeName":"GALLIVAN","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":850565707,"modelName":"bjxl","gameName":"BJXL","vehicleMakeName":"KARIN","flags":"FLAG_EXTRAS_SCRIPT FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":3253274834,"modelName":"banshee","gameName":"BANSHEE","vehicleMakeName":"BRAVADO","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2053223216,"modelName":"benson","gameName":"BENSON","vehicleMakeName":"VAPID","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_INTERIOR_BLOCKED_BY_BOOT FLAG_HAS_INTERIOR_EXTRAS FLAG_IGNORE_RWINDOW_COLLISION","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":999999,"Speed":81.56,"Acceleration":82.5,"Braking":26.67,"Handling":77.27},{"modelHash":1126868326,"modelName":"bfinjection","gameName":"BFINJECT","vehicleMakeName":"BF","flags":"FLAG_BOOT_IN_FRONT FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":850991848,"modelName":"biff","gameName":"BIFF","vehicleMakeName":"HVY","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_HAS_INTERIOR_EXTRAS FLAG_PEDS_CAN_STAND_ON_TOP FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_CAN_BE_DRIVEN_ON","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":2166734073,"modelName":"blazer","gameName":"BLAZER","vehicleMakeName":"NAGASAKI","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_QUADBIKE"},{"modelHash":4246935337,"modelName":"blazer2","gameName":"BLAZER2","vehicleMakeName":"NAGASAKI","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_QUADBIKE"},{"modelHash":3025077634,"modelName":"blazer3","gameName":"BLAZER03","vehicleMakeName":"NAGASAKI","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_QUADBIKE"},{"modelHash":4278019151,"modelName":"bison","gameName":"BISON","vehicleMakeName":"BRAVADO","flags":"FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_ATTACH_TRAILER_IN_CITY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2072156101,"modelName":"bison2","gameName":"BISON","vehicleMakeName":"BRAVADO","flags":"FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_ATTACH_TRAILER_IN_CITY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1739845664,"modelName":"bison3","gameName":"BISON","vehicleMakeName":"BRAVADO","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_ATTACH_TRAILER_IN_CITY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2307837162,"modelName":"boxville","gameName":"BOXVILLE","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_HAS_LIVERY FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_INTERIOR_EXTRAS FLAG_PEDS_CAN_STAND_ON_TOP","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":4061868990,"modelName":"boxville2","gameName":"BOXVILLE","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_HAS_LIVERY FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":121658888,"modelName":"boxville3","gameName":"BOXVILLE","vehicleMakeName":"BRUTE","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DAMPEN_STICKBOMB_DAMAGE FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1069929536,"modelName":"bobcatxl","gameName":"BOBCATXL","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_STRONG FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_ATTACH_TRAILER_IN_CITY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR","image":"https://i.imgur.com/i9AZIDg.png","price":23000,"Speed":81.56,"Acceleration":82.5,"Braking":26.67,"Handling":77.27,"Seats":2,"Mass":2600,"Train":"RWD","MaxSpeed":130},{"modelHash":2859047862,"modelName":"bodhi2","gameName":"BODHI2","vehicleMakeName":"CANIS","flags":"FLAG_EXTRAS_SCRIPT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_USE_STEERING_PARAM_FOR_LEAN FLAG_HAS_NO_ROOF FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP ALLOW_OBJECT_LOW_LOD_COLLISION FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":3612755468,"modelName":"buccaneer","gameName":"BUCCANEE","vehicleMakeName":"ALBANY","flags":"FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3990165190,"modelName":"buffalo","gameName":"BUFFALO","vehicleMakeName":"BRAVADO","flags":"FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":736902334,"modelName":"buffalo2","gameName":"BUFFALO02","vehicleMakeName":"BRAVADO","flags":"FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1886712733,"modelName":"bulldozer","gameName":"BULLDOZE","vehicleMakeName":"HVY","flags":"FLAG_NO_BOOT FLAG_EXTRAS_STRONG FLAG_EXTRAS_ALL FLAG_USE_HIGHER_DOOR_TORQUE FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_IS_BULKY FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_TWO_DOORS_ONE_SEAT","plateType":"VPT_NONE","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":2598821281,"modelName":"bullet","gameName":"BULLET","vehicleMakeName":"VAPID","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_REQUIRE FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR","image":"https://i.imgur.com/iwiYfXE.png","price":155000,"Speed":81.56,"Acceleration":82.5,"Braking":26.67,"Handling":77.27,"Seats":2,"Mass":1100,"Train":"RWD","MaxSpeed":152},{"modelHash":4143991942,"modelName":"blimp","gameName":"BLIMP","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_ALLOWS_RAPPEL FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_BLIMP"},{"modelHash":2948279460,"modelName":"burrito","gameName":"BURRITO","vehicleMakeName":"DECLASSE","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_HAS_LIVERY FLAG_DELIVERY FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3387490166,"modelName":"burrito2","gameName":"BURRITO","vehicleMakeName":"DECLASSE","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2551651283,"modelName":"burrito3","gameName":"BURRITO","vehicleMakeName":"DECLASSE","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_AVERAGE_CAR FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":893081117,"modelName":"burrito4","gameName":"BURRITO","vehicleMakeName":"DECLASSE","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_AVERAGE_CAR FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1132262048,"modelName":"burrito5","gameName":"BURRITO","vehicleMakeName":"DECLASSE","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_AVERAGE_CAR FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2006918058,"modelName":"cavalcade","gameName":"CAVCADE","vehicleMakeName":"ALBANY","flags":"FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":3505073125,"modelName":"cavalcade2","gameName":"CAVCADE","vehicleMakeName":"ALBANY","flags":"FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":456714581,"modelName":"policet","gameName":"POLICET","vehicleMakeName":"","flags":"FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2549763894,"modelName":"gburrito","gameName":"GBURRITO","vehicleMakeName":"DECLASSE","flags":"FLAG_AVERAGE_CAR FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_NONE","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3334677549,"modelName":"cablecar","gameName":"CABLECAR","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":1147287684,"modelName":"caddy","gameName":"CADDY","vehicleMakeName":"","flags":"FLAG_IS_ELECTRIC FLAG_INCREASE_PED_COMMENTS FLAG_HAS_NO_ROOF FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3757070668,"modelName":"caddy2","gameName":"CADDY","vehicleMakeName":"","flags":"FLAG_IS_ELECTRIC FLAG_INCREASE_PED_COMMENTS FLAG_HAS_NO_ROOF FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1876516712,"modelName":"camper","gameName":"CAMPER","vehicleMakeName":"BRUTE","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_HAS_LIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2072687711,"modelName":"carbonizzare","gameName":"CARBONIZ","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2983812512,"modelName":"cheetah","gameName":"CHEETAH","vehicleMakeName":"GROTTI","flags":"FLAG_NO_BOOT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_NO_ROOF FLAG_HAS_INTERIOR_EXTRAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3249425686,"modelName":"comet2","gameName":"COMET2","vehicleMakeName":"PFISTER","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":330661258,"modelName":"cogcabrio","gameName":"COGCABRI","vehicleMakeName":"ENUS","flags":"FLAG_SPORTS FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":108773431,"modelName":"coquette","gameName":"COQUETTE","vehicleMakeName":"INVERTO","flags":"FLAG_NO_BOOT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3288047904,"modelName":"cutter","gameName":"CUTTER","vehicleMakeName":"HVY","flags":"FLAG_EXTRAS_SCRIPT FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":2751205197,"modelName":"gresley","gameName":"GRESLEY","vehicleMakeName":"BRAVADO","flags":"FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":3164157193,"modelName":"dilettante","gameName":"DILETTAN","vehicleMakeName":"KARIN","flags":"FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1682114128,"modelName":"dilettante2","gameName":"DILETTAN","vehicleMakeName":"KARIN","flags":"FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2633113103,"modelName":"dune","gameName":"DUNE","vehicleMakeName":"BF","flags":"FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_DONT_TIMESLICE_WHEELS FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":534258863,"modelName":"dune2","gameName":"DUNE2","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":37348240,"modelName":"hotknife","gameName":"HOTKNIFE","vehicleMakeName":"VAPID","flags":"FLAG_SPORTS FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_DONT_SPAWN_IN_CARGEN FLAG_INCREASE_PED_COMMENTS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":90000,"Speed":75.12,"Acceleration":75,"Braking":14.33,"Handling":56.06,"Seats":2,"Mass":700,"Train":"RWD","MaxSpeed":140},{"modelHash":1770332643,"modelName":"dloader","gameName":"DLOADER","vehicleMakeName":"BRAVADO","flags":"FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_POOR_CAR FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":1177543287,"modelName":"dubsta","gameName":"DUBSTA","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":3900892662,"modelName":"dubsta2","gameName":"DUBSTA","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":2164484578,"modelName":"dump","gameName":"DUMP","vehicleMakeName":"HVY","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_IS_BULKY FLAG_DONT_TIMESLICE_WHEELS FLAG_CANNOT_BE_PICKUP_BY_CARGOBOB","plateType":"VPT_NONE","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":2589662668,"modelName":"rubble","gameName":"RUBBLE","vehicleMakeName":"JOBUILT","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_USE_STRICTER_EXIT_COLLISION_TESTS","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":3410276810,"modelName":"docktug","gameName":"DOCKTUG","vehicleMakeName":"","flags":"FLAG_DONT_SPAWN_IN_CARGEN FLAG_INCREASE_PED_COMMENTS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_ATTACH_TRAILER_ON_HIGHWAY","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":80636076,"modelName":"dominator","gameName":"DOMINATO","vehicleMakeName":"VAPID","flags":"FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":35000,"Speed":77.8,"Acceleration":72.5,"Braking":26.67,"Handling":68.18,"Seats":2,"Mass":1600,"Train":"RWD","MaxSpeed":145},{"modelHash":3609690755,"modelName":"emperor","gameName":"EMPEROR","vehicleMakeName":"ALBANY","flags":"FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2411965148,"modelName":"emperor2","gameName":"EMPEROR","vehicleMakeName":"ALBANY","flags":"FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3053254478,"modelName":"emperor3","gameName":"EMPEROR","vehicleMakeName":"ALBANY","flags":"FLAG_POOR_CAR FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3003014393,"modelName":"entityxf","gameName":"ENTITYXF","vehicleMakeName":"OVERFLOD","flags":"FLAG_NO_BOOT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":4289813342,"modelName":"exemplar","gameName":"EXEMPLAR","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3728579874,"modelName":"elegy2","gameName":"ELEGY2","vehicleMakeName":"ANNIS","flags":"FLAG_SPORTS FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3703357000,"modelName":"f620","gameName":"F620","vehicleMakeName":"OCELOT","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1127131465,"modelName":"fbi","gameName":"FBI","vehicleMakeName":"","flags":"FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2647026068,"modelName":"fbi2","gameName":"FBI2","vehicleMakeName":"","flags":"FLAG_LAW_ENFORCEMENT FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3903372712,"modelName":"felon","gameName":"FELON","vehicleMakeName":"LAMPADA","flags":"FLAG_SPORTS FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":4205676014,"modelName":"felon2","gameName":"FELON2","vehicleMakeName":"LAMPADA","flags":"FLAG_SPORTS FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2299640309,"modelName":"feltzer2","gameName":"FELTZER","vehicleMakeName":"BENEFAC","flags":"FLAG_SPORTS FLAG_EXTRAS_GANG FLAG_EXTRAS_RARE FLAG_EXTRAS_STRONG FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1938952078,"modelName":"firetruk","gameName":"FIRETRUK","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EMERGENCY_SERVICE FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_CREATE_WEAPON_MANAGER_ON_SPAWN","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1353720154,"modelName":"flatbed","gameName":"FLATBED","vehicleMakeName":"MTL","flags":"FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_REQUIRE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_CANNOT_TAKE_COVER_WHEN_STOOD_ON","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":1491375716,"modelName":"forklift","gameName":"FORK","vehicleMakeName":"HVY","flags":"FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3157435195,"modelName":"fq2","gameName":"FQ2","vehicleMakeName":"FATHOM","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_USE_FAT_INTERIOR_LIGHT FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":499169875,"modelName":"fusilade","gameName":"FUSILADE","vehicleMakeName":"SCHYSTER","flags":"FLAG_SPORTS FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1909141499,"modelName":"fugitive","gameName":"FUGITIVE","vehicleMakeName":"CHEVAL","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2016857647,"modelName":"futo","gameName":"FUTO","vehicleMakeName":"KARIN","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_POOR_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2519238556,"modelName":"granger","gameName":"GRANGER","vehicleMakeName":"DECLASSE","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_ALLOWS_RAPPEL FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":2494797253,"modelName":"gauntlet","gameName":"GAUNTLET","vehicleMakeName":"BRAVADO","flags":"FLAG_CAN_HAVE_NEONS FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":884422927,"modelName":"habanero","gameName":"HABANERO","vehicleMakeName":"EMPEROR","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":1518533038,"modelName":"hauler","gameName":"HAULER","vehicleMakeName":"JOBUILT","flags":"FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_USE_STRICTER_EXIT_COLLISION_TESTS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":444583674,"modelName":"handler","gameName":"HANDLER","vehicleMakeName":"","flags":"FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":418536135,"modelName":"infernus","gameName":"INFERNUS","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3005245074,"modelName":"ingot","gameName":"INGOT","vehicleMakeName":"VULCAR","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":886934177,"modelName":"intruder","gameName":"INTRUDER","vehicleMakeName":"KARIN","flags":"FLAG_EXTRAS_GANG FLAG_AVERAGE_CAR FLAG_POOR_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3117103977,"modelName":"issi2","gameName":"ISSI2","vehicleMakeName":"WEENY","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3670438162,"modelName":"Jackal","gameName":"JACKAL","vehicleMakeName":"OCELOT","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":4174679674,"modelName":"journey","gameName":"JOURNEY","vehicleMakeName":"ZIRCONIU","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1051415893,"modelName":"jb700","gameName":"JB700","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":544021352,"modelName":"khamelion","gameName":"KHAMEL","vehicleMakeName":"HIJAK","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_IS_ELECTRIC FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1269098716,"modelName":"landstalker","gameName":"LANDSTAL","vehicleMakeName":"DUNDREAR","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":469291905,"modelName":"lguard","gameName":"LGUARD","vehicleMakeName":"","flags":"FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2170765704,"modelName":"manana","gameName":"MANANA","vehicleMakeName":"ALBANY","flags":"FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_POOR_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":914654722,"modelName":"mesa","gameName":"MESA","vehicleMakeName":"CANIS","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":3546958660,"modelName":"mesa2","gameName":"MESA","vehicleMakeName":"CANIS","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":2230595153,"modelName":"mesa3","gameName":"MESA","vehicleMakeName":"CANIS","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":321739290,"modelName":"crusader","gameName":"CRUSADER","vehicleMakeName":"CANIS","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_LAW_ENFORCEMENT FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_CANNOT_BE_MODDED FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3984502180,"modelName":"minivan","gameName":"MINIVAN","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":30000,"Speed":67.07,"Acceleration":37.5,"Braking":13.33,"Handling":57.58,"Seats":4,"Mass":2000,"Train":"RWD","MaxSpeed":125},{"modelHash":3510150843,"modelName":"mixer","gameName":"MIXER","vehicleMakeName":"HVY","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":475220373,"modelName":"mixer2","gameName":"MIXER2","vehicleMakeName":"HVY","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":3861591579,"modelName":"monroe","gameName":"MONROE","vehicleMakeName":"PEGASSI","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1783355638,"modelName":"mower","gameName":"MOWER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_INCREASE_PED_COMMENTS FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":904750859,"modelName":"mule","gameName":"MULE","vehicleMakeName":"MAIBATSU","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_INTERIOR_BLOCKED_BY_BOOT","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":3244501995,"modelName":"mule2","gameName":"MULE","vehicleMakeName":"MAIBATSU","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_INTERIOR_BLOCKED_BY_BOOT","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":1348744438,"modelName":"oracle","gameName":"ORACLE2","vehicleMakeName":"UBERMACH","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3783366066,"modelName":"oracle2","gameName":"ORACLE","vehicleMakeName":"UBERMACH","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":569305213,"modelName":"packer","gameName":"PACKER","vehicleMakeName":"MTL","flags":"FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_ATTACH_TRAILER_ON_HIGHWAY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":3486509883,"modelName":"patriot","gameName":"PATRIOT","vehicleMakeName":"MAMMOTH","flags":"FLAG_EXTRAS_STRONG FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":2287941233,"modelName":"pbus","gameName":"PBUS","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_USE_FULL_ANIMS_FOR_MP_WARP_ENTRY_POINTS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3917501776,"modelName":"penumbra","gameName":"PENUMBRA","vehicleMakeName":"MAIBATSU","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1830407356,"modelName":"peyote","gameName":"PEYOTE","vehicleMakeName":"VAPID","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_AVERAGE_CAR","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":38000,"Speed":69.75,"Acceleration":40,"Braking":8.33,"Handling":56.06,"Seats":2,"Mass":2100,"Train":"RWD","MaxSpeed":130},{"modelHash":2157618379,"modelName":"phantom","gameName":"PHANTOM","vehicleMakeName":"JOBUILT","flags":"FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_USE_STRICTER_EXIT_COLLISION_TESTS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":2199527893,"modelName":"phoenix","gameName":"PHOENIX","vehicleMakeName":"IMPONTE","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_NO_ROOF FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":""},{"modelHash":1507916787,"modelName":"picador","gameName":"PICADOR","vehicleMakeName":"CHEVAL","flags":"FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2112052861,"modelName":"pounder","gameName":"POUNDER","vehicleMakeName":"MTL","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":2046537925,"modelName":"police","gameName":"POLICE","vehicleMakeName":"","flags":"FLAG_HAS_LIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2321795001,"modelName":"police4","gameName":"POLICE4","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_DONT_SPAWN_IN_CARGEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2667966721,"modelName":"police2","gameName":"POLICE2","vehicleMakeName":"","flags":"FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_REPORT_CRIME_IF_STANDING_ON FLAG_HAS_LIVERY","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1912215274,"modelName":"police3","gameName":"POLICE","vehicleMakeName":"","flags":"FLAG_HAS_LIVERY FLAG_EXTRAS_ALL FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HAS_INTERIOR_EXTRAS FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2758042359,"modelName":"policeold1","gameName":"POLICEO1","vehicleMakeName":"","flags":"FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2515846680,"modelName":"policeold2","gameName":"POLICEO2","vehicleMakeName":"","flags":"FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":4175309224,"modelName":"pony","gameName":"PONY","vehicleMakeName":"BRUTE","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_HAS_LIVERY FLAG_DELIVERY FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_BULKY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":943752001,"modelName":"pony2","gameName":"PONY","vehicleMakeName":"BRUTE","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_HAS_LIVERY FLAG_DELIVERY FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_BULKY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2844316578,"modelName":"prairie","gameName":"PRAIRIE","vehicleMakeName":"BOLLOKAN","flags":"FLAG_SPORTS FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":741586030,"modelName":"pranger","gameName":"PRANGER","vehicleMakeName":"","flags":"FLAG_LAW_ENFORCEMENT FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_HAS_INTERIOR_EXTRAS FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2411098011,"modelName":"premier","gameName":"PREMIER","vehicleMakeName":"DECLASSE","flags":"FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3144368207,"modelName":"primo","gameName":"PRIMO","vehicleMakeName":"ALBANY","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":356391690,"modelName":"proptrailer","gameName":"proptrailer","vehicleMakeName":"","flags":"FLAG_EXTRAS_SCRIPT FLAG_EXTRAS_ALL FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":1645267888,"modelName":"rancherxl","gameName":"RANCHERX","vehicleMakeName":"DECLASSE","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_USE_HIGHER_DOOR_TORQUE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":1933662059,"modelName":"rancherxl2","gameName":"RANCHERX","vehicleMakeName":"DECLASSE","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_BULKY FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":2360515092,"modelName":"rapidgt","gameName":"RAPIDGT","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1737773231,"modelName":"rapidgt2","gameName":"RAPIDGT","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2643899483,"modelName":"radi","gameName":"RADI","vehicleMakeName":"VAPID","flags":"FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":3627815886,"modelName":"ratloader","gameName":"RLOADER","vehicleMakeName":"","flags":"FLAG_EXTRAS_STRONG FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_INCREASE_PED_COMMENTS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3087195462,"modelName":"rebel","gameName":"REBEL01","vehicleMakeName":"KARIN","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":4280472072,"modelName":"regina","gameName":"REGINA","vehicleMakeName":"DUNDREAR","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_FAKE_EXTRALIGHTS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2249373259,"modelName":"rebel2","gameName":"REBEL02","vehicleMakeName":"KARIN","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":3196165219,"modelName":"rentalbus","gameName":"RENTBUS","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_HAS_LIVERY FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_EXTRAS_ALL FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_IS_BUS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":4067225593,"modelName":"ruiner","gameName":"RUINER","vehicleMakeName":"IMPONTE","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_NO_ROOF FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":1162065741,"modelName":"rumpo","gameName":"RUMPO","vehicleMakeName":"BRAVADO","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_HAS_LIVERY FLAG_DELIVERY FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_BULKY","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2518351607,"modelName":"rumpo2","gameName":"RUMPO","vehicleMakeName":"BRAVADO","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_DELIVERY FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_BULKY","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":782665360,"modelName":"rhino","gameName":"RHINO","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_EXTRAS_ALL FLAG_DONT_CLOSE_DOOR_UPON_EXIT FLAG_USE_HIGHER_DOOR_TORQUE FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_IS_TANK FLAG_USE_COVERBOUND_INFO_FOR_COVERGEN FLAG_DONT_TIMESLICE_WHEELS FLAG_CAN_NAVIGATE_TO_ON_VEHICLE_ENTRY","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3089277354,"modelName":"riot","gameName":"RIOT","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_EXTRAS_ALL FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DAMPEN_STICKBOMB_DAMAGE FLAG_DONT_SPAWN_IN_CARGEN FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_BULLETPROOF_GLASS","plateType":"VPT_NONE","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3448987385,"modelName":"ripley","gameName":"RIPLEY","vehicleMakeName":"","flags":"FLAG_EXTRAS_ALL FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_INCREASE_PED_COMMENTS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_IS_BULKY FLAG_USE_STRICTER_EXIT_COLLISION_TESTS","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2136773105,"modelName":"rocoto","gameName":"rocoto","vehicleMakeName":"OBEY","flags":"FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":627094268,"modelName":"romero","gameName":"ROMERO","vehicleMakeName":"CHARIOT","flags":"FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2609945748,"modelName":"sabregt","gameName":"SABREGT","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3695398481,"modelName":"sadler","gameName":"SADLER","vehicleMakeName":"VAPID","flags":"FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_ATTACH_TRAILER_IN_CITY FLAG_HAS_INTERIOR_EXTRAS FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":734217681,"modelName":"sadler2","gameName":"SADLER","vehicleMakeName":"VAPID","flags":"FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_ATTACH_TRAILER_IN_CITY FLAG_EXTRAS_REQUIRE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":3105951696,"modelName":"sandking","gameName":"SANDKING","vehicleMakeName":"VAPID","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":22800,"Speed":69.75,"Acceleration":50,"Braking":20,"Handling":60.61,"Seats":2,"Mass":2400,"Train":"AWD","MaxSpeed":130},{"modelHash":989381445,"modelName":"sandking2","gameName":"SANDKIN2","vehicleMakeName":"VAPID","flags":"FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":45000,"Speed":69.75,"Acceleration":50,"Braking":20,"Handling":60.61,"Seats":4,"Mass":2400,"Train":"AWD","MaxSpeed":130},{"modelHash":3039514899,"modelName":"schafter2","gameName":"SCHAFTER","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3548084598,"modelName":"schwarzer","gameName":"SCHWARZE","vehicleMakeName":"BENEFAC","flags":"FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2594165727,"modelName":"scrap","gameName":"SCRAP","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_IGNORE_RWINDOW_COLLISION","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1221512915,"modelName":"seminole","gameName":"SEMINOLE","vehicleMakeName":"CANIS","flags":"FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":1349725314,"modelName":"sentinel","gameName":"SENTINEL","vehicleMakeName":"UBERMACH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":873639469,"modelName":"sentinel2","gameName":"SENTINEL2","vehicleMakeName":"UBERMACH","flags":"FLAG_SPORTS FLAG_EXTRAS_REQUIRE FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3172678083,"modelName":"zion","gameName":"ZION","vehicleMakeName":"UBERMACH","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3101863448,"modelName":"zion2","gameName":"ZION2","vehicleMakeName":"UBERMACH","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1337041428,"modelName":"serrano","gameName":"SERRANO","vehicleMakeName":"BENEFAC","flags":"FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":2611638396,"modelName":"sheriff","gameName":"SHERIFF","vehicleMakeName":"","flags":"FLAG_HAS_LIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_LAW_ENFORCEMENT FLAG_EMERGENCY_SERVICE FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_REPORT_CRIME_IF_STANDING_ON FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1922257928,"modelName":"sheriff2","gameName":"SHERIFF2","vehicleMakeName":"","flags":"FLAG_HAS_LIVERY FLAG_LAW_ENFORCEMENT FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_HAS_INTERIOR_EXTRAS FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3484649228,"modelName":"speedo","gameName":"SPEEDO","vehicleMakeName":"VAPID","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_DELIVERY FLAG_EXTRAS_ALL FLAG_IS_BULKY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR","price":18000,"Speed":69.75,"Acceleration":45,"Braking":20,"Handling":54.55,"Seats":4,"Mass":2500,"Train":"RWD","MaxSpeed":130},{"modelHash":728614474,"modelName":"speedo2","gameName":"SPEEDO2","vehicleMakeName":"VAPID","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_DELIVERY FLAG_EXTRAS_ALL FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":24000,"Speed":69.75,"Acceleration":50,"Braking":21.67,"Handling":57.58,"Seats":4,"Mass":2500,"Train":"RWD","MaxSpeed":130},{"modelHash":2817386317,"modelName":"stanier","gameName":"STANIER","vehicleMakeName":"VAPID","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":10000,"Speed":75.12,"Acceleration":50,"Braking":30,"Handling":74.24,"Seats":4,"Mass":1800,"Train":"RWD","MaxSpeed":140},{"modelHash":1545842587,"modelName":"stinger","gameName":"STINGER","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":2196019706,"modelName":"stingergt","gameName":"STINGERG","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1747439474,"modelName":"stockade","gameName":"STOCKADE","vehicleMakeName":"BRUTE","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DAMPEN_STICKBOMB_DAMAGE FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_FLEE_FROM_COMBAT","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":4080511798,"modelName":"stockade3","gameName":"STOCKADE","vehicleMakeName":"BRUTE","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DAMPEN_STICKBOMB_DAMAGE FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_NONE","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":1723137093,"modelName":"stratum","gameName":"STRATUM","vehicleMakeName":"ZIRCONIU","flags":"FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":970598228,"modelName":"sultan","gameName":"SULTAN","vehicleMakeName":"KARIN","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR","image":"https://i.imgur.com/1Ao0fBe.jpg"},{"modelHash":1123216662,"modelName":"superd","gameName":"SUPERD","vehicleMakeName":"ENUS","flags":"FLAG_EXTRAS_REQUIRE FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":384071873,"modelName":"surano","gameName":"SURANO","vehicleMakeName":"BENEFAC","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":699456151,"modelName":"surfer","gameName":"SURFER","vehicleMakeName":"BF","flags":"FLAG_IS_VAN FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2983726598,"modelName":"surfer2","gameName":"SURFER2","vehicleMakeName":"BF","flags":"FLAG_IS_VAN FLAG_EXTRAS_STRONG FLAG_POOR_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2400073108,"modelName":"surge","gameName":"SURGE","vehicleMakeName":"CHEVAL","flags":"FLAG_AVERAGE_CAR FLAG_IS_ELECTRIC FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1951180813,"modelName":"taco","gameName":"TACO","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3286105550,"modelName":"tailgater","gameName":"TAILGATE","vehicleMakeName":"OBEY","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3338918751,"modelName":"taxi","gameName":"TAXI","vehicleMakeName":"","flags":"FLAG_EXTRAS_TAXI FLAG_EXTRAS_REQUIRE FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1917016601,"modelName":"trash","gameName":"TRASH","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_PEDS_CAN_STAND_ON_TOP","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1641462412,"modelName":"tractor","gameName":"TRACTOR","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_INCREASE_PED_COMMENTS FLAG_IS_BULKY FLAG_HAS_NO_ROOF FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2218488798,"modelName":"tractor2","gameName":"TRACTOR2","vehicleMakeName":"STANLEY","flags":"FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_INCREASE_PED_COMMENTS FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1445631933,"modelName":"tractor3","gameName":"TRACTOR2","vehicleMakeName":"STANLEY","flags":"FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_OFFROAD_VEHICLE FLAG_INCREASE_PED_COMMENTS FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_EXTRAS_REQUIRE","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1019737494,"modelName":"graintrailer","gameName":"GRAINTRAILER","vehicleMakeName":"","flags":"FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":3895125590,"modelName":"baletrailer","gameName":"BALETRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":48339065,"modelName":"tiptruck","gameName":"TIPTRUCK","vehicleMakeName":"BRUTE","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_PEDS_CAN_STAND_ON_TOP","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":3347205726,"modelName":"tiptruck2","gameName":"TIPTRUCK2","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_PEDS_CAN_STAND_ON_TOP","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":464687292,"modelName":"tornado","gameName":"TORNADO","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1531094468,"modelName":"tornado2","gameName":"TORNADO2","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1762279763,"modelName":"tornado3","gameName":"TORNADO3","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":2261744861,"modelName":"tornado4","gameName":"TORNADO","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_POOR_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1941029835,"modelName":"tourbus","gameName":"TOURBUS","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_IS_BUS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2971866336,"modelName":"towtruck","gameName":"TOWTRUCK","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_USE_STRICTER_EXIT_COLLISION_TESTS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":3852654278,"modelName":"towtruck2","gameName":"TOWTRUCK","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":516990260,"modelName":"utillitruck","gameName":"UTILTRUC","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":887537515,"modelName":"utillitruck2","gameName":"UTILTRUC","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2132890591,"modelName":"utillitruck3","gameName":"UTILTRUC","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":523724515,"modelName":"voodoo2","gameName":"VOODOO","vehicleMakeName":"DECLASSE","flags":"FLAG_POOR_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":1777363799,"modelName":"washington","gameName":"WASHINGT","vehicleMakeName":"ALBANY","flags":"FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2333339779,"modelName":"stretch","gameName":"STRETCH","vehicleMakeName":"DUNDREAR","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_ALL FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":65402552,"modelName":"youga","gameName":"YOUGA","vehicleMakeName":"BRAVADO","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_BULKY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":758895617,"modelName":"ztype","gameName":"ZTYPE","vehicleMakeName":"TRUFFADE","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":788045382,"modelName":"sanchez","gameName":"SANCHEZ01","vehicleMakeName":"MAIBATSU","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2841686334,"modelName":"sanchez2","gameName":"SANCHEZ02","vehicleMakeName":"MAIBATSU","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":4108429845,"modelName":"scorcher","gameName":"SCORCHER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_STRONG FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_CYCLE","type":"VEHICLE_TYPE_BICYCLE"},{"modelHash":1127861609,"modelName":"tribike","gameName":"TRIBIKE","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS FLAG_DRIVER_SHOULD_BE_MALE","plateType":"VPT_NONE","vehicleClass":"VC_CYCLE","type":"VEHICLE_TYPE_BICYCLE"},{"modelHash":3061159916,"modelName":"tribike2","gameName":"TRIBIKE2","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS FLAG_DRIVER_SHOULD_BE_MALE","plateType":"VPT_NONE","vehicleClass":"VC_CYCLE","type":"VEHICLE_TYPE_BICYCLE"},{"modelHash":3894672200,"modelName":"tribike3","gameName":"TRIBIKE3","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS FLAG_DRIVER_SHOULD_BE_MALE","plateType":"VPT_NONE","vehicleClass":"VC_CYCLE","type":"VEHICLE_TYPE_BICYCLE"},{"modelHash":3458454463,"modelName":"fixter","gameName":"FIXTER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_CYCLE","type":"VEHICLE_TYPE_BICYCLE"},{"modelHash":448402357,"modelName":"cruiser","gameName":"CRUISER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS FLAG_DRIVER_SHOULD_BE_MALE","plateType":"VPT_NONE","vehicleClass":"VC_CYCLE","type":"VEHICLE_TYPE_BICYCLE"},{"modelHash":1131912276,"modelName":"BMX","gameName":"BMX","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS FLAG_DRIVER_SHOULD_BE_MALE","plateType":"VPT_NONE","vehicleClass":"VC_CYCLE","type":"VEHICLE_TYPE_BICYCLE"},{"modelHash":4260343491,"modelName":"policeb","gameName":"POLICEB","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_LAW_ENFORCEMENT FLAG_NO_RESPRAY FLAG_IGNORE_ON_SIDE_CHECK FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_BIKE_CLAMP_PICKUP_LEAN_RATE FLAG_REPORT_CRIME_IF_STANDING_ON","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1672195559,"modelName":"akuma","gameName":"AKUMA","vehicleMakeName":"DINKA","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":11251904,"modelName":"carbonrs","gameName":"CARBON","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_NO_RESPRAY FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2154536131,"modelName":"bagger","gameName":"BAGGER","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_BIKE_CLAMP_PICKUP_LEAN_RATE","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":4180675781,"modelName":"bati","gameName":"BATI","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3403504941,"modelName":"bati2","gameName":"BATI2","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_NO_RESPRAY FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3401388520,"modelName":"ruffian","gameName":"RUFFIAN","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2006142190,"modelName":"daemon","gameName":"DAEMON","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2623969160,"modelName":"double","gameName":"DOUBLE","vehicleMakeName":"DINKA","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3385765638,"modelName":"pcj","gameName":"PCJ","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":4154065143,"modelName":"vader","gameName":"VADER","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3469130167,"modelName":"vigero","gameName":"VIGERO","vehicleMakeName":"DECLASSE","flags":"FLAG_CAN_HAVE_NEONS FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":55628203,"modelName":"faggio2","gameName":"FAGGIO","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":301427732,"modelName":"hexer","gameName":"HEXER","vehicleMakeName":"LCC","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":837858166,"modelName":"annihilator","gameName":"ANNIHL","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_LAW_ENFORCEMENT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_ALLOWS_RAPPEL FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON FLAG_USE_PILOT_HELMET","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":788747387,"modelName":"buzzard","gameName":"BUZZARD","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_PILOT_HELMET FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":745926877,"modelName":"buzzard2","gameName":"BUZZARD2","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_PILOT_HELMET FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":4244420235,"modelName":"cargobob","gameName":"CARGOBOB","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DONT_ROTATE_TAIL_ROTOR FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_CAN_BE_DRIVEN_ON FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":1621617168,"modelName":"cargobob2","gameName":"CARGOBOB","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DONT_ROTATE_TAIL_ROTOR FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_CAN_BE_DRIVEN_ON FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":1394036463,"modelName":"cargobob3","gameName":"CARGOBOB","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DONT_ROTATE_TAIL_ROTOR FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_CAN_BE_DRIVEN_ON FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":1044954915,"modelName":"skylift","gameName":"SKYLIFT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_SCRIPT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":353883353,"modelName":"polmav","gameName":"POLMAV","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_LAW_ENFORCEMENT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_ALLOWS_RAPPEL FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":2634305738,"modelName":"maverick","gameName":"MAVERICK","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_ALLOWS_RAPPEL FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":3660088182,"modelName":"nemesis","gameName":"NEMESIS","vehicleMakeName":"PRINCIPL","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":744705981,"modelName":"frogger","gameName":"FROGGER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":1949211328,"modelName":"frogger2","gameName":"FROGGER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":3650256867,"modelName":"cuban800","gameName":"CUBAN800","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":970356638,"modelName":"duster","gameName":"DUSTER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_PLANE_WEAR_ALTERNATIVE_HELMET","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2172210288,"modelName":"stunt","gameName":"STUNT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_PLANE_WEAR_ALTERNATIVE_HELMET","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2548391185,"modelName":"mammatus","gameName":"MAMMATUS","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT FLAG_IGNORE_TRAPPED_HULL_CHECK","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1058115860,"modelName":"jet","gameName":"JET","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":3080461301,"modelName":"shamal","gameName":"SHAMAL","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":621481054,"modelName":"luxor","gameName":"LUXOR","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1981688531,"modelName":"titan","gameName":"TITAN","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_LIGHTING_INTERIOR_OVERRIDE FLAG_USE_PILOT_HELMET FLAG_DISABLE_CAMERA_PUSH_BEYOND","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":3013282534,"modelName":"lazer","gameName":"LAZER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON FLAG_USE_WEAPON_WHEEL_WITHOUT_HELMET FLAG_USE_PILOT_HELMET FLAG_HAS_EJECTOR_SEATS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":368211810,"modelName":"cargoplane","gameName":"CARGOPL","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_SCRIPT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":400514754,"modelName":"squalo","gameName":"SQUALO","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":3251507587,"modelName":"marquis","gameName":"MARQUIS","vehicleMakeName":"DINKA","flags":"FLAG_NO_BOOT FLAG_TALL_SHIP FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":1033245328,"modelName":"dinghy","gameName":"DINGHY","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_GIVE_SCUBA_GEAR_ON_EXIT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":276773164,"modelName":"dinghy2","gameName":"DINGHY","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_GIVE_SCUBA_GEAR_ON_EXIT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":861409633,"modelName":"jetmax","gameName":"JETMAX","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":3806844075,"modelName":"predator","gameName":"PREDATOR","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_LAW_ENFORCEMENT FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":290013743,"modelName":"tropic","gameName":"TROPIC","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":3264692260,"modelName":"seashark","gameName":"SEASHARK","vehicleMakeName":"SPEEDOPH","flags":"FLAG_NO_BOOT FLAG_EXTRAS_RARE FLAG_GEN_NAVMESH FLAG_IS_JETSKI FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":3678636260,"modelName":"seashark2","gameName":"SEASHARK","vehicleMakeName":"SPEEDOPH","flags":"FLAG_NO_BOOT FLAG_EXTRAS_RARE FLAG_GEN_NAVMESH FLAG_IS_JETSKI FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":771711535,"modelName":"submersible","gameName":"SUBMERS","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_GIVE_SCUBA_GEAR_ON_EXIT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_SUBMARINE"},{"modelHash":184361638,"modelName":"freightcar","gameName":"FREIGHT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":1030400667,"modelName":"freight","gameName":"FREIGHT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":920453016,"modelName":"freightcont1","gameName":"FREIGHT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_FORCE_ENABLE_CHASSIS_COLLISION","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":240201337,"modelName":"freightcont2","gameName":"FREIGHT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_FORCE_ENABLE_CHASSIS_COLLISION","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":642617954,"modelName":"freightgrain","gameName":"FREIGHT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":586013744,"modelName":"tankercar","gameName":"FREIGHT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_EXPLODE_ON_CONTACT FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":868868440,"modelName":"metrotrain","gameName":"FREIGHT","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_IS_ELECTRIC FLAG_DONT_SPAWN_AS_AMBIENT FLAG_CANNOT_BE_DRIVEN_BY_PLAYER","plateType":"VPT_NONE","vehicleClass":"VC_RAIL","type":"VEHICLE_TYPE_TRAIN"},{"modelHash":2154757102,"modelName":"docktrailer","gameName":"DOCKTRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":3417488910,"modelName":"trailers","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2715434129,"modelName":"trailers2","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_HAS_LIVERY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2236089197,"modelName":"trailers3","gameName":"TRAILERS3","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2524324030,"modelName":"tvtrailer","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":390902130,"modelName":"raketrailer","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":3564062519,"modelName":"tanker","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_EXPLODE_ON_CONTACT FLAG_DONT_SPAWN_AS_AMBIENT FLAG_SPRAY_PETROL_BEFORE_EXPLOSION","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2016027501,"modelName":"trailerlogs","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2078290630,"modelName":"tr2","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":1784254509,"modelName":"tr3","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2091594960,"modelName":"tr4","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2942498482,"modelName":"trflat","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":712162987,"modelName":"trailersmall","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":2621610858,"modelName":"velum","gameName":"VELUM","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":3078201489,"modelName":"adder","gameName":"ADDER","vehicleMakeName":"TRUFFADE","flags":"FLAG_NO_BOOT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":2672523198,"modelName":"voltic","gameName":"VOLTIC","vehicleMakeName":"COIL","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_IS_ELECTRIC FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":338562499,"modelName":"vacca","gameName":"VACCA","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":4012021193,"modelName":"suntrap","gameName":"SUNTRAP","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":3945366167,"modelName":"bifta","gameName":"BIFTA","vehicleMakeName":"BF","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP ","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":231083307,"modelName":"speeder","gameName":"SPEEDER","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":92612664,"modelName":"kalahari","gameName":"KALAHARI","vehicleMakeName":"CANIS","flags":"FLAG_EXTRAS_SCRIPT FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_USE_STEERING_PARAM_FOR_LEAN FLAG_HAS_NO_ROOF","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":1488164764,"modelName":"paradise","gameName":"PARADISE","vehicleMakeName":"BRAVADO","flags":"FLAG_SMALL_WORKER FLAG_IS_VAN FLAG_HAS_LIVERY FLAG_EXTRAS_STRONG FLAG_EXTRAS_REQUIRE FLAG_DELIVERY FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_BULKY","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2997294755,"modelName":"jester","gameName":"JESTER","vehicleMakeName":"DINKA","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":408192225,"modelName":"turismor","gameName":"TURISMOR","vehicleMakeName":"GROTTI","flags":"FLAG_NO_BOOT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":767087018,"modelName":"alpha","gameName":"ALPHA","vehicleMakeName":"ALBANY","flags":"FLAG_SPORTS FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1341619767,"modelName":"vestra","gameName":"VESTRA","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_LIVERY FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":117401876,"modelName":"btype","gameName":"ROOSEVELT","vehicleMakeName":"ALBANY","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_EXTRAS_ALL FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":2891838741,"modelName":"zentorno","gameName":"ZENTORNO","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":4152024626,"modelName":"massacro","gameName":"MASSACRO","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":486987393,"modelName":"huntley","gameName":"HUNTLEY","vehicleMakeName":"ENUS","flags":"FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":1836027715,"modelName":"thrust","gameName":"THRUST","vehicleMakeName":"DINKA","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":841808271,"modelName":"rhapsody","gameName":"RHAPSODY","vehicleMakeName":"DECLASSE","flags":"FLAG_AVERAGE_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1373123368,"modelName":"warrener","gameName":"WARRENER","vehicleMakeName":"VULCAR","flags":"FLAG_AVERAGE_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_HEADLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3089165662,"modelName":"blade","gameName":"BLADE","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"https://i.imgur.com/Pd5MzBm.png","price":160000,"Speed":77.8,"Acceleration":81,"Braking":26.67,"Handling":67.58,"Seats":2,"Mass":1200,"Train":"RWD","MaxSpeed":145},{"modelHash":75131841,"modelName":"glendale","gameName":"GLENDALE","vehicleMakeName":"BENEFAC","flags":"FLAG_AVERAGE_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3863274624,"modelName":"panto","gameName":"PANTO","vehicleMakeName":"BENEFAC","flags":"FLAG_EXTRAS_ALL FLAG_EXTRAS_STRONG FLAG_POOR_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3057713523,"modelName":"dubsta3","gameName":"DUBSTA3","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":1078682497,"modelName":"pigalle","gameName":"PIGALLE","vehicleMakeName":"LAMPADA","flags":"FLAG_AVERAGE_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_HEADLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":3449006043,"modelName":"monster","gameName":"MONSTER","vehicleMakeName":"VAPID","flags":"FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":743478836,"modelName":"sovereign","gameName":"SOVEREIGN","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_NO_RESPRAY FLAG_IGNORE_ON_SIDE_CHECK FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_BIKE_CLAMP_PICKUP_LEAN_RATE","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":165154707,"modelName":"miljet","gameName":"MILJET","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1824333165,"modelName":"besra","gameName":"BESRA","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_PILOT_HELMET","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1011753235,"modelName":"coquette2","gameName":"COQUETTE2","vehicleMakeName":"INVERTO","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":3955379698,"modelName":"swift","gameName":"SWIFT","vehicleMakeName":"BUCKING","flags":"FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_HAS_LIVERY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":3228633070,"modelName":"submersible2","gameName":"SUBMERS2","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_GIVE_SCUBA_GEAR_ON_EXIT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_SUBMARINE"},{"modelHash":723973206,"modelName":"dukes","gameName":"DUKES","vehicleMakeName":"IMPONTE","flags":"FLAG_EXTRAS_STRONG FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3968823444,"modelName":"dukes2","gameName":"DUKES2","vehicleMakeName":"IMPONTE","flags":"FLAG_EXTRAS_STRONG FLAG_DISABLE_THROUGH_WINDSCREEN FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":237764926,"modelName":"buffalo3","gameName":"BUFFALO3","vehicleMakeName":"BRAVADO","flags":"FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3379262425,"modelName":"dominator2","gameName":"DOMINATO2","vehicleMakeName":"VAPID","flags":"FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":725000,"Speed":78.07,"Acceleration":83.75,"Braking":16.67,"Handling":77.88,"Seats":2,"Mass":1670,"Train":"RWD","MaxSpeed":145.5},{"modelHash":3393804037,"modelName":"dodo","gameName":"DODO","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1233534620,"modelName":"marshall","gameName":"MARSHALL","vehicleMakeName":"CHEVAL","flags":"FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT FLAG_HAS_LIVERY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":3681241380,"modelName":"blimp2","gameName":"BLIMP2","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_ALLOWS_RAPPEL FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_BLIMP"},{"modelHash":349315417,"modelName":"gauntlet2","gameName":"GAUNTLET2","vehicleMakeName":"BRAVADO","flags":"FLAG_CAN_HAVE_NEONS FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1923400478,"modelName":"stalion","gameName":"STALION","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG EXTRAS_CONVERTIBLE FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3893323758,"modelName":"stalion2","gameName":"STALION2","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG EXTRAS_CONVERTIBLE FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1039032026,"modelName":"blista2","gameName":"BLISTA2","vehicleMakeName":"DINKA","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_POOR_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3703315515,"modelName":"blista3","gameName":"BLISTA3","vehicleMakeName":"DINKA","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_POOR_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":4135840458,"modelName":"innovation","gameName":"INNOVATION","vehicleMakeName":"LCC","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1265391242,"modelName":"hakuchou","gameName":"HAKUCHOU","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3205927392,"modelName":"furoregt","gameName":"FURORE","vehicleMakeName":"LAMPADA","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2242229361,"modelName":"mule3","gameName":"MULE","vehicleMakeName":"MAIBATSU","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_INTERIOR_BLOCKED_BY_BOOT","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":1077420264,"modelName":"velum2","gameName":"VELUM2","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1956216962,"modelName":"tanker2","gameName":"TANKER","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_EXPLODE_ON_CONTACT FLAG_DONT_SPAWN_AS_AMBIENT FLAG_SPRAY_PETROL_BEFORE_EXPLOSION","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":941800958,"modelName":"casco","gameName":"CASCO","vehicleMakeName":"LAMPADA","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":444171386,"modelName":"boxville4","gameName":"BOXVILLE","vehicleMakeName":"BRUTE","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_DELIVERY FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DAMPEN_STICKBOMB_DAMAGE FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":970385471,"modelName":"hydra","gameName":"HYDRA","vehicleMakeName":"MAMMOTH","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_PILOT_HELMET FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2434067162,"modelName":"insurgent","gameName":"INSURGENT","vehicleMakeName":"HVY","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_CONSIDERED_FOR_VEHICLE_ENTRY_WHEN_STOOD_ON FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_PREFER_ENTER_TURRET_AFTER_DRIVER FLAG_HAS_DIRECTIONAL_SHUFFLES FLAG_USE_SMALLER_OPEN_DOOR_RATIO_TOLERANCE FLAG_DONT_STOP_WHEN_GOING_TO_CLIMB_UP_POINT FLAG_DISABLE_BUSTING","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":2071877360,"modelName":"insurgent2","gameName":"INSURGENT2","vehicleMakeName":"HVY","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_USE_SMALLER_OPEN_DOOR_RATIO_TOLERANCE FLAG_DISABLE_BUSTING","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":296357396,"modelName":"gburrito2","gameName":"GBURRITO2","vehicleMakeName":"DECLASSE","flags":"FLAG_AVERAGE_CAR FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS","plateType":"VPT_NONE","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2198148358,"modelName":"technical","gameName":"TECHNICAL","vehicleMakeName":"KARIN","flags":"FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_DISABLE_AUTO_VAULT_ON_VEHICLE FLAG_HAS_REAR_MOUNTED_TURRET","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":509498602,"modelName":"dinghy3","gameName":"DINGHY","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_GIVE_SCUBA_GEAR_ON_EXIT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":4212341271,"modelName":"savage","gameName":"SAVAGE","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HELI_USES_FIXUPS_ON_OPEN_DOOR FLAG_USE_PILOT_HELMET FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":1753414259,"modelName":"enduro","gameName":"ENDURO","vehicleMakeName":"DINKA","flags":"FLAG_NO_BOOT FLAG_HAS_LIVERY FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2186977100,"modelName":"guardian","gameName":"GUARDIAN","vehicleMakeName":"VAPID","flags":"FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_CANNOT_TAKE_COVER_WHEN_STOOD_ON FLAG_USE_FIVE_ANIM_THROW_FP","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_INDUSTRIAL","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":640818791,"modelName":"lectro","gameName":"LECTRO","vehicleMakeName":"PRINCIPL","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2922118804,"modelName":"kuruma","gameName":"KURUMA","vehicleMakeName":"KARIN","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":410882957,"modelName":"kuruma2","gameName":"KURUMA2","vehicleMakeName":"KARIN","flags":"FLAG_DISABLE_THROUGH_WINDSCREEN FLAG_AVERAGE_CAR FLAG_POOR_CAR","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3039269212,"modelName":"trash2","gameName":"TRASH","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_DONT_SPAWN_IN_CARGEN FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_PEDS_CAN_STAND_ON_TOP","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":630371791,"modelName":"barracks3","gameName":"BARRACKS","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2694714877,"modelName":"valkyrie","gameName":"VALKYRIE","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_LAW_ENFORCEMENT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_ALLOWS_RAPPEL FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":833469436,"modelName":"slamvan2","gameName":"SLAMVAN2","vehicleMakeName":"VAPID","flags":"FLAG_HAS_LIVERY FLAG_USE_STRICTER_EXIT_COLLISION_TESTS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":236000,"Speed":72.43,"Acceleration":62.6,"Braking":20,"Handling":71.21,"Seats":2,"Mass":1400,"Train":"RWD","MaxSpeed":140},{"modelHash":1075432268,"modelName":"swift2","gameName":"SWIFT2","vehicleMakeName":"BUCKING","flags":"FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_USE_LIGHTING_INTERIOR_OVERRIDE","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":3080673438,"modelName":"luxor2","gameName":"LUXOR2","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_USE_LIGHTING_INTERIOR_OVERRIDE","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2728226064,"modelName":"feltzer3","gameName":"FELTZER3","vehicleMakeName":"BENEFAC","flags":"FLAG_SPORTS FLAG_EXTRAS_GANG FLAG_EXTRAS_RARE FLAG_EXTRAS_STRONG FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_GULL_WING_DOORS FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1987142870,"modelName":"osiris","gameName":"OSIRIS","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_GULL_WING_DOORS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3796912450,"modelName":"virgo","gameName":"VIRGO","vehicleMakeName":"ALBANY","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1581459400,"modelName":"windsor","gameName":"WINDSOR","vehicleMakeName":"ENUS","flags":"FLAG_EXTRAS_REQUIRE FLAG_HAS_LIVERY FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":784565758,"modelName":"coquette3","gameName":"COQUETTE3","vehicleMakeName":"INVERTO","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_CONVERTIBLE FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2941886209,"modelName":"vindicator","gameName":"VINDICATOR","vehicleMakeName":"DINKA","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1663218586,"modelName":"t20","gameName":"T20","vehicleMakeName":"PROGEN","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":2815302597,"modelName":"brawler","gameName":"BRAWLER","vehicleMakeName":"COIL","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS FLAG_CARGOBOB_HOOK_UP_CHASSIS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":1070967343,"modelName":"toro","gameName":"TORO","vehicleMakeName":"LAMPADA","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_HAS_REAR_SEAT_ACTIVITIES","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":349605904,"modelName":"chino","gameName":"CHINO","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":225000,"Speed":75.12,"Acceleration":70,"Braking":26.67,"Handling":68.18,"Seats":2,"Mass":2300,"Train":"RWD","MaxSpeed":130},{"modelHash":1102544804,"modelName":"verlierer2","gameName":"VERLIER","vehicleMakeName":"BRAVADO","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2351681756,"modelName":"nightshade","gameName":"NITESHAD","vehicleMakeName":"IMPONTE","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2634021974,"modelName":"mamba","gameName":"MAMBA","vehicleMakeName":"DECLASSE","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":4180339789,"modelName":"limo2","gameName":"LIMO2","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_HAS_DIRECTIONAL_SHUFFLES FLAG_USE_HEADING_ONLY_IN_TURRET_MATRIX FLAG_DISABLE_BUSTING FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_CAPPED_EXPLOSION_DAMAGE FLAG_HAS_INCREASED_RAMMING_FORCE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2809443750,"modelName":"schafter3","gameName":"SCHAFTER3","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1489967196,"modelName":"schafter4","gameName":"SCHAFTER4","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3406724313,"modelName":"schafter5","gameName":"SCHAFTER5","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_CAPPED_EXPLOSION_DAMAGE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1922255844,"modelName":"schafter6","gameName":"SCHAFTER6","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_CAPPED_EXPLOSION_DAMAGE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":906642318,"modelName":"cog55","gameName":"COG55","vehicleMakeName":"ENUS","flags":"FLAG_EXTRAS_REQUIRE FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":704435172,"modelName":"cog552","gameName":"COG552","vehicleMakeName":"ENUS","flags":"FLAG_EXTRAS_REQUIRE FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_CAPPED_EXPLOSION_DAMAGE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2264796000,"modelName":"cognoscenti","gameName":"COGNOSC","vehicleMakeName":"ENUS","flags":"FLAG_EXTRAS_REQUIRE FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":3690124666,"modelName":"cognoscenti2","gameName":"COGNOSC2","vehicleMakeName":"ENUS","flags":"FLAG_EXTRAS_REQUIRE FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_CAPPED_EXPLOSION_DAMAGE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":1878062887,"modelName":"baller3","gameName":"BALLER3","vehicleMakeName":"GALLIVAN","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":634118882,"modelName":"baller4","gameName":"BALLER4","vehicleMakeName":"GALLIVAN","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":470404958,"modelName":"baller5","gameName":"BALLER5","vehicleMakeName":"GALLIVAN","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_CAPPED_EXPLOSION_DAMAGE","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":666166960,"modelName":"baller6","gameName":"BALLER6","vehicleMakeName":"GALLIVAN","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_CAPPED_EXPLOSION_DAMAGE","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":908897389,"modelName":"toro2","gameName":"TORO","vehicleMakeName":"LAMPADA","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_HAS_REAR_SEAT_ACTIVITIES","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":3983945033,"modelName":"seashark3","gameName":"SEASHARK","vehicleMakeName":"SPEEDOPH","flags":"FLAG_NO_BOOT FLAG_EXTRAS_RARE FLAG_GEN_NAVMESH FLAG_IS_JETSKI FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":867467158,"modelName":"dinghy4","gameName":"DINGHY","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_RARE FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_GIVE_SCUBA_GEAR_ON_EXIT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":1448677353,"modelName":"tropic2","gameName":"TROPIC","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_SPAWN_BOAT_ON_TRAILER FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":437538602,"modelName":"speeder2","gameName":"SPEEDER","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":2025593404,"modelName":"cargobob4","gameName":"CARGOBOB","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DONT_ROTATE_TAIL_ROTOR FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_CAN_BE_DRIVEN_ON FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":710198397,"modelName":"supervolito","gameName":"SVOLITO","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_USE_LIGHTING_INTERIOR_OVERRIDE","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":2623428164,"modelName":"supervolito2","gameName":"SVOLITO2","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_USE_LIGHTING_INTERIOR_OVERRIDE","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":1543134283,"modelName":"valkyrie2","gameName":"VALKYRI2","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_LAW_ENFORCEMENT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_ALLOWS_RAPPEL FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":2255212070,"modelName":"faction3","gameName":"FACTION3","vehicleMakeName":"WILLARD","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_HAS_LOWRIDER_DONK_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3168702960,"modelName":"minivan2","gameName":"MINIVAN2","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":330000,"Speed":67.07,"Acceleration":37.5,"Braking":15,"Handling":58.33,"Seats":4,"Mass":2200,"Train":"RWD","MaxSpeed":125},{"modelHash":223258115,"modelName":"sabregt2","gameName":"SABREGT2","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1119641113,"modelName":"slamvan3","gameName":"SLAMVAN3","vehicleMakeName":"VAPID","flags":"FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":2497353967,"modelName":"tornado5","gameName":"TORNADO5","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_LOWRIDER_HYDRAULICS FLAG_HAS_LIVERY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":3395457658,"modelName":"virgo2","gameName":"VIRGO2","vehicleMakeName":"DUNDREAR","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":16646064,"modelName":"virgo3","gameName":"VIRGO3","vehicleMakeName":"DUNDREAR","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3999278268,"modelName":"sultanrs","gameName":"SULTANRS","vehicleMakeName":"KARIN","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":633712403,"modelName":"banshee2","gameName":"BANSHEE2","vehicleMakeName":"BRAVADO","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":2999939664,"modelName":"nimbus","gameName":"NIMBUS","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_USE_LIGHTING_INTERIOR_OVERRIDE","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1203490606,"modelName":"xls","gameName":"XLS","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":3862958888,"modelName":"xls2","gameName":"XLS2","vehicleMakeName":"BENEFAC","flags":"FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_HAS_CAPPED_EXPLOSION_DAMAGE FLAG_HAS_INCREASED_RAMMING_FORCE","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR"},{"modelHash":2537130571,"modelName":"seven70","gameName":"SEVEN70","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1426219628,"modelName":"fmj","gameName":"FMJ","vehicleMakeName":"VAPID","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":1274868363,"modelName":"bestiagts","gameName":"BESTIAGTS","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2465164804,"modelName":"pfister811","gameName":"PFISTER811","vehicleMakeName":"PFISTER","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3989239879,"modelName":"brickade","gameName":"BRICKADE","vehicleMakeName":"HVY","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_USE_FAT_INTERIOR_LIGHT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_HAS_BULLET_RESISTANT_GLASS","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1475773103,"modelName":"rumpo3","gameName":"RUMPO3","vehicleMakeName":"BRAVADO","flags":"FLAG_IS_VAN FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_EXTRAS_STRONG FLAG_HAS_BULLET_RESISTANT_GLASS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2449479409,"modelName":"volatus","gameName":"VOLATUS","vehicleMakeName":"BUCKING","flags":"FLAG_HELICOPTER_WITH_LANDING_GEAR FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_USE_LIGHTING_INTERIOR_OVERRIDE","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":2123327359,"modelName":"prototipo","gameName":"PROTOTIPO","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_GULL_WING_DOORS FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":234062309,"modelName":"reaper","gameName":"REAPER","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":2194326579,"modelName":"tug","gameName":"TUG","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_TALL_SHIP FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_AS_AMBIENT FLAG_CANNOT_TAKE_COVER_WHEN_STOOD_ON FLAG_CANNOT_BE_PICKUP_BY_CARGOBOB","plateType":"VPT_NONE","vehicleClass":"VC_BOAT","type":"VEHICLE_TYPE_BOAT"},{"modelHash":2364918497,"modelName":"windsor2","gameName":"WINDSOR2","vehicleMakeName":"ENUS","flags":"FLAG_EXTRAS_REQUIRE FLAG_HAS_LIVERY FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COUPE","type":"VEHICLE_TYPE_CAR"},{"modelHash":482197771,"modelName":"lynx","gameName":"LYNX","vehicleMakeName":"OCELOT","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":741090084,"modelName":"gargoyle","gameName":"GARGOYLE","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_BIKE_CLAMP_PICKUP_LEAN_RATE","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2067820283,"modelName":"tyrus","gameName":"TYRUS","vehicleMakeName":"PROGEN","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":819197656,"modelName":"sheava","gameName":"SHEAVA","vehicleMakeName":"EMPEROR","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3517794615,"modelName":"omnis","gameName":"OMNIS","vehicleMakeName":"OBEY","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3062131285,"modelName":"le7b","gameName":"LE7B","vehicleMakeName":"ANNIS","flags":"FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_GULL_WING_DOORS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG","plateType":"VPT_NONE","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":683047626,"modelName":"contender","gameName":"CONTENDER","vehicleMakeName":"VAPID","flags":"FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_EXTRAS_STRONG FLAG_HAS_BULLET_RESISTANT_GLASS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUV","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":101905590,"modelName":"trophytruck","gameName":"TROPHY","vehicleMakeName":"VAPID","flags":"FLAG_NO_BOOT FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":3631668194,"modelName":"trophytruck2","gameName":"TROPHY2","vehicleMakeName":"VAPID","flags":"FLAG_NO_BOOT FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":2191146052,"modelName":"rallytruck","gameName":"RALLYTRUCK","vehicleMakeName":"MTL","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_USE_FAT_INTERIOR_LIGHT","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":390201602,"modelName":"cliffhanger","gameName":"CLIFFHANGER","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":86520421,"modelName":"bf400","gameName":"BF400","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1887331236,"modelName":"tropos","gameName":"TROPOS","vehicleMakeName":"LAMPADA","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1549126457,"modelName":"brioso","gameName":"BRIOSO","vehicleMakeName":"GROTTI","flags":"FLAG_EXTRAS_ALL FLAG_EXTRAS_STRONG FLAG_POOR_CAR","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COMPACT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3223586949,"modelName":"tampa2","gameName":"TAMPA2","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":196747873,"modelName":"elegy","gameName":"ELEGY","vehicleMakeName":"ANNIS","flags":"FLAG_SPORTS FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":272929391,"modelName":"tempesta","gameName":"TEMPESTA","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":2246633323,"modelName":"italigtb","gameName":"ITALIGTB","vehicleMakeName":"PROGEN","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3812247419,"modelName":"italigtb2","gameName":"ITALIGTB2","vehicleMakeName":"PROGEN","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":1034187331,"modelName":"nero","gameName":"NERO","vehicleMakeName":"TRUFFADE","flags":"FLAG_FRONT_BOOT FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_RECESSED_HEADLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":1093792632,"modelName":"nero2","gameName":"NERO2","vehicleMakeName":"TRUFFADE","flags":"FLAG_FRONT_BOOT FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":1886268224,"modelName":"specter","gameName":"SPECTER","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1074745671,"modelName":"specter2","gameName":"SPECTER2","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":4055125828,"modelName":"diablous","gameName":"DIABLOUS","vehicleMakeName":"PRINCIPL","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1790834270,"modelName":"diablous2","gameName":"DIABLOUS2","vehicleMakeName":"PRINCIPL","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2704629607,"modelName":"blazer5","gameName":"BLAZER5","vehicleMakeName":"NAGASAKI","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_AMPHIBIOUS_QUADBIKE"},{"modelHash":941494461,"modelName":"ruiner2","gameName":"RUINER2","vehicleMakeName":"IMPONTE","flags":"FLAG_HAS_PARACHUTE FLAG_JUMPING_CAR FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_NO_ROOF FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3467805257,"modelName":"dune4","gameName":"DUNE4","vehicleMakeName":"","flags":"FLAG_EXTRAS_STRONG FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP FLAG_RAMP","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":3982671785,"modelName":"dune5","gameName":"DUNE5","vehicleMakeName":"","flags":"FLAG_EXTRAS_STRONG FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP FLAG_RAMP","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":2645431192,"modelName":"phantom2","gameName":"PHANTOM2","vehicleMakeName":"JOBUILT","flags":"FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_RAMMING_SCOOP FLAG_HAS_EXTRA_SHUFFLE_SEAT_ON_VEHICLE","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":989294410,"modelName":"voltic2","gameName":"VOLTIC2","vehicleMakeName":"COIL","flags":"FLAG_HAS_ROCKET_BOOST FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_IS_ELECTRIC FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":2536829930,"modelName":"penetrator","gameName":"penetrator","vehicleMakeName":"OCELOT","flags":"FLAG_SPORTS FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":682434785,"modelName":"boxville5","gameName":"BOXVILLE5","vehicleMakeName":"","flags":"FLAG_BIG FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_EXTRAS_REQUIRE FLAG_DONT_SPAWN_IN_CARGEN FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_INTERIOR_EXTRAS FLAG_PEDS_CAN_STAND_ON_TOP FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_HAS_DIRECTIONAL_SHUFFLES FLAG_USE_HEADING_ONLY_IN_TURRET_MATRIX FLAG_DISABLE_BUSTING FLAG_RAMMING_SCOOP FLAG_HAS_BULLET_RESISTANT_GLASS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2382949506,"modelName":"wastelander","gameName":"WASTLNDR","vehicleMakeName":"MTL","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_USE_FAT_INTERIOR_LIGHT","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_SERVICE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1180875963,"modelName":"technical2","gameName":"TECHNICAL2","vehicleMakeName":"KARIN","flags":"FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_DISABLE_AUTO_VAULT_ON_VEHICLE FLAG_HAS_REAR_MOUNTED_TURRET","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_AMPHIBIOUS_AUTOMOBILE"},{"modelHash":627535535,"modelName":"fcr","gameName":"FCR","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3537231886,"modelName":"fcr2","gameName":"FCR2","vehicleMakeName":"PEGASSI","flags":"FLAG_EXTRAS_STRONG FLAG_EXTRAS_SCRIPT FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2272483501,"modelName":"comet3","gameName":"COMET3","vehicleMakeName":"PFISTER","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_STRONG FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS","plateType":"VPT_NONE","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":777714999,"modelName":"ruiner3","gameName":"RUINER","vehicleMakeName":"IMPONTE","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_NO_ROOF FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2736567667,"modelName":"tornado6","gameName":"TORNADO6","vehicleMakeName":"DECLASSE","flags":"FLAG_SPAWN_ON_TRAILER FLAG_AVERAGE_CAR FLAG_POOR_CAR","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":3005788552,"modelName":"faggio3","gameName":"FAGGIO3","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2452219115,"modelName":"faggio","gameName":"FAGGION","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_RICH_CAR FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3620039993,"modelName":"raptor","gameName":"RAPTOR","vehicleMakeName":"BF","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP ","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3685342204,"modelName":"vortex","gameName":"VORTEX","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2179174271,"modelName":"avarus","gameName":"AVARUS","vehicleMakeName":"LCC","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1491277511,"modelName":"sanctus","gameName":"SANCTUS","vehicleMakeName":"LCC","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1026149675,"modelName":"youga2","gameName":"YOUGA2","vehicleMakeName":"BRAVADO","flags":"FLAG_IS_VAN FLAG_POOR_CAR FLAG_AVERAGE_CAR FLAG_IS_BULKY FLAG_HAS_REAR_SEAT_ACTIVITIES","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_VAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":4039289119,"modelName":"hakuchou2","gameName":"HAKUCHOU2","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2688780135,"modelName":"nightblade","gameName":"NIGHTBLADE","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":6774487,"modelName":"chimera","gameName":"CHIMERA","vehicleMakeName":"NAGASAKI","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_QUADBIKE"},{"modelHash":2035069708,"modelName":"esskey","gameName":"ESSKEY","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3676349299,"modelName":"wolfsbane","gameName":"WOLFSBANE","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3285698347,"modelName":"zombiea","gameName":"ZOMBIEA","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3724934023,"modelName":"zombieb","gameName":"ZOMBIEB","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":822018448,"modelName":"defiler","gameName":"DEFILER","vehicleMakeName":"SHITZU","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2890830793,"modelName":"daemon2","gameName":"DAEMON2","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":1873600305,"modelName":"ratbike","gameName":"RATBIKE","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_BIKE_CLAMP_PICKUP_LEAN_RATE","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3889340782,"modelName":"shotaro","gameName":"SHOTARO","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":2771538552,"modelName":"manchez","gameName":"MANCHEZ","vehicleMakeName":"MAIBATSU","flags":"FLAG_NO_BOOT FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3854198872,"modelName":"blazer4","gameName":"BLAZER4","vehicleMakeName":"NAGASAKI","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_QUADBIKE"},{"modelHash":3194418602,"modelName":"trailers4","gameName":"TRAILER","vehicleMakeName":"","flags":"FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT","plateType":"VPT_NONE","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":917809321,"modelName":"xa21","gameName":"XA21","vehicleMakeName":"OCELOT","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_CARGOBOB_HOOK_UP_CHASSIS FLAG_HAS_GULL_WING_DOORS FLAG_FRONT_BOOT","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3525819835,"modelName":"caddy3","gameName":"CADDY3","vehicleMakeName":"","flags":"FLAG_IS_ELECTRIC FLAG_INCREASE_PED_COMMENTS FLAG_HAS_NO_ROOF FLAG_PEDS_INSIDE_CAN_BE_SET_ON_FIRE_MP FLAG_EXTRAS_STRONG","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_CAR"},{"modelHash":1939284556,"modelName":"vagner","gameName":"VAGNER","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_GULL_WING_DOORS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":177270108,"modelName":"phantom3","gameName":"PHANTOM3","vehicleMakeName":"JOBUILT","flags":"FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_HAS_EXTRA_SHUFFLE_SEAT_ON_VEHICLE FLAG_DONT_HOLD_LOW_GEARS_WHEN_ENGINE_UNDER_LOAD","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":433954513,"modelName":"nightshark","gameName":"NIGHTSHARK","vehicleMakeName":"HVY","flags":"FLAG_AVERAGE_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_CONSIDERED_FOR_VEHICLE_ENTRY_WHEN_STOOD_ON FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_HAS_DIRECTIONAL_SHUFFLES FLAG_USE_SMALLER_OPEN_DOOR_RATIO_TOLERANCE FLAG_DONT_STOP_WHEN_GOING_TO_CLIMB_UP_POINT FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":223240013,"modelName":"cheetah2","gameName":"CHEETAH2","vehicleMakeName":"GROTTI","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_FRONT_BOOT","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1504306544,"modelName":"torero","gameName":"TORERO","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_HAS_GULL_WING_DOORS FLAG_FRONT_BOOT","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":387748548,"modelName":"hauler2","gameName":"HAULER2","vehicleMakeName":"JOBUILT","flags":"FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_BIG FLAG_CAN_HONK_WHEN_FLEEING FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_USE_FAT_INTERIOR_LIGHT FLAG_IS_BULKY FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_ATTACH_TRAILER_ON_HIGHWAY FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_DONT_HOLD_LOW_GEARS_WHEN_ENGINE_UNDER_LOAD","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_COMMERCIAL","type":"VEHICLE_TYPE_CAR"},{"modelHash":1502869817,"modelName":"trailerlarge","gameName":"TRLARGE","vehicleMakeName":"","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_UTILITY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":1356124575,"modelName":"technical3","gameName":"TECHNICAL3","vehicleMakeName":"KARIN","flags":"FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_DISABLE_AUTO_VAULT_ON_VEHICLE FLAG_HAS_REAR_MOUNTED_TURRET FLAG_TURRET_MODS_ON_ROOF FLAG_KEEP_ALL_TURRETS_SYNCHRONISED","plateType":"VPT_FRONT_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":2370534026,"modelName":"insurgent3","gameName":"INSURGENT3","vehicleMakeName":"HVY","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_CONSIDERED_FOR_VEHICLE_ENTRY_WHEN_STOOD_ON FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_PREFER_ENTER_TURRET_AFTER_DRIVER FLAG_HAS_DIRECTIONAL_SHUFFLES FLAG_USE_SMALLER_OPEN_DOOR_RATIO_TOLERANCE FLAG_DONT_STOP_WHEN_GOING_TO_CLIMB_UP_POINT FLAG_DISABLE_BUSTING FLAG_KEEP_ALL_TURRETS_SYNCHRONISED","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":562680400,"modelName":"apc","gameName":"APC","vehicleMakeName":"HVY","flags":"FLAG_NO_BOOT FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_EXTRAS_ALL FLAG_USE_HIGHER_DOOR_TORQUE FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_IS_TANK FLAG_USE_COVERBOUND_INFO_FOR_COVERGEN FLAG_DONT_TIMESLICE_WHEELS FLAG_TURRET_MODS_ON_ROOF FLAG_RESET_TURRET_SEAT_HEADING FLAG_UPDATE_WEAPON_BATTERY_BONES FLAG_DONT_HOLD_LOW_GEARS_WHEN_ENGINE_UNDER_LOAD FLAG_INCREASE_LOW_SPEED_TORQUE FLAG_KEEP_ALL_TURRETS_SYNCHRONISED FLAG_HAS_INCREASED_RAMMING_FORCE","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_AMPHIBIOUS_AUTOMOBILE"},{"modelHash":3084515313,"modelName":"tampa3","gameName":"TAMPA3","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG FLAG_DRIVER_NO_DRIVE_BY FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_TURRET_MODS_ON_ROOF FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_KEEP_ALL_TURRETS_SYNCHRONISED","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1897744184,"modelName":"dune3","gameName":"DUNE3","vehicleMakeName":"BF","flags":"FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_RESET_TURRET_SEAT_HEADING FLAG_TURRET_MODS_ON_ROOF FLAG_KEEP_ALL_TURRETS_SYNCHRONISED FLAG_HAS_INCREASED_RAMMING_FORCE","plateType":"VPT_NONE","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":2413121211,"modelName":"trailersmall2","gameName":"TRSMALL2","vehicleMakeName":"VOMFEUER","flags":"FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_PEDS_CAN_STAND_ON_TOP FLAG_GEN_NAVMESH FLAG_DONT_SPAWN_AS_AMBIENT FLAG_TURRET_MODS_ON_ROOF FLAG_RESET_TURRET_SEAT_HEADING FLAG_KEEP_ALL_TURRETS_SYNCHRONISED FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_UPDATE_WEAPON_BATTERY_BONES FLAG_SET_WANTED_FOR_ATTACHED_VEH FLAG_HAS_TURRET_SEAT_ON_VEHICLE","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_TRAILER"},{"modelHash":4262731174,"modelName":"halftrack","gameName":"HALFTRACK","vehicleMakeName":"BRAVADO","flags":"FLAG_NO_BOOT FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_DISABLE_AUTO_VAULT_ON_VEHICLE FLAG_HAS_REAR_MOUNTED_TURRET FLAG_TURRET_MODS_ON_ROOF FLAG_DONT_HOLD_LOW_GEARS_WHEN_ENGINE_UNDER_LOAD FLAG_INCREASE_LOW_SPEED_TORQUE FLAG_KEEP_ALL_TURRETS_SYNCHRONISED FLAG_HAS_INCREASED_RAMMING_FORCE","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":159274291,"modelName":"ardent","gameName":"ARDENT","vehicleMakeName":"OCELOT","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":884483972,"modelName":"oppressor","gameName":"OPPRESSOR","vehicleMakeName":"PEGASSI","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_IGNORE_ON_SIDE_CHECK FLAG_AVERAGE_CAR FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_HAS_GLIDER FLAG_HAS_ROCKET_BOOST FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_HAS_INCREASED_RAMMING_FORCE","plateType":"VPT_NONE","vehicleClass":"VC_MOTORCYCLE","type":"VEHICLE_TYPE_BIKE"},{"modelHash":3188613414,"modelName":"jester2","gameName":"JESTER2","vehicleMakeName":"DINKA","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3663206819,"modelName":"massacro2","gameName":"MASSACRO2","vehicleMakeName":"DEWBAUCH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3705788919,"modelName":"ratloader2","gameName":"RLOADER2","vehicleMakeName":"BRAVADO","flags":"FLAG_EXTRAS_STRONG FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_INCREASE_PED_COMMENTS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":729783779,"modelName":"slamvan","gameName":"SLAMVAN","vehicleMakeName":"VAPID","flags":"FLAG_USE_STRICTER_EXIT_COLLISION_TESTS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":838982985,"modelName":"z190","gameName":"Z190","vehicleMakeName":"KARIN","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":3903371924,"modelName":"viseris","gameName":"VISERIS","vehicleMakeName":"LAMPADATI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_FRONT_BOOT FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":661493923,"modelName":"comet5","gameName":"COMET5","vehicleMakeName":"PFISTER","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2765724541,"modelName":"raiden","gameName":"RAIDEN","vehicleMakeName":"COIL","flags":"FLAG_DISABLE_THROUGH_WINDSCREEN FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_ELECTRIC","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2762269779,"modelName":"riata","gameName":"RIATA","vehicleMakeName":"VAPID","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":1352136073,"modelName":"sc1","gameName":"SC1","vehicleMakeName":"UBERMACH","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_GULL_WING_DOORS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3981782132,"modelName":"autarch","gameName":"AUTARCH","vehicleMakeName":"OVERFLOD","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":903794909,"modelName":"savestra","gameName":"SAVESTRA","vehicleMakeName":"ANNIS","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_CAN_HAVE_NEONS FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":2215179066,"modelName":"gt500","gameName":"GT500","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1561920505,"modelName":"comet4","gameName":"COMET4","vehicleMakeName":"PFISTER","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_EXTRAS_STRONG FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS FLAG_CARGOBOB_HOOK_UP_CHASSIS FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING","plateType":"VPT_NONE","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2445973230,"modelName":"neon","gameName":"NEON","vehicleMakeName":"PFISTER","flags":"FLAG_DISABLE_THROUGH_WINDSCREEN FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_ELECTRIC","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":1104234922,"modelName":"sentinel3","gameName":"sentinel3","vehicleMakeName":"UBERMACH","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":2859440138,"modelName":"khanjali","gameName":"KHANJALI","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_EXTRAS_ALL FLAG_DONT_CLOSE_DOOR_UPON_EXIT FLAG_USE_HIGHER_DOOR_TORQUE FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_IS_TANK FLAG_USE_COVERBOUND_INFO_FOR_COVERGEN FLAG_DONT_TIMESLICE_WHEELS FLAG_INCREASE_LOW_SPEED_TORQUE FLAG_CAN_NAVIGATE_TO_ON_VEHICLE_ENTRY FLAG_RESET_TURRET_SEAT_HEADING FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":4081974053,"modelName":"barrage","gameName":"BARRAGE","vehicleMakeName":"","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_IS_BULKY FLAG_EXTRAS_STRONG FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_CONSIDERED_FOR_VEHICLE_ENTRY_WHEN_STOOD_ON FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_PREFER_ENTER_TURRET_AFTER_DRIVER FLAG_DISABLE_BUSTING FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_RESET_TURRET_SEAT_HEADING","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":447548909,"modelName":"volatol","gameName":"VOLATOL","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_LIGHTING_INTERIOR_OVERRIDE FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_RESET_TURRET_SEAT_HEADING FLAG_DISABLE_CAMERA_PUSH_BEYOND FLAG_CHECK_WARP_TASK_FLAG_DURING_ENTER FLAG_DONT_CRASH_ABANDONED_NEAR_GROUND","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1181327175,"modelName":"akula","gameName":"AKULA","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HELICOPTER_WITH_LANDING_GEAR FLAG_HELI_USES_FIXUPS_ON_OPEN_DOOR FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_RESET_TURRET_SEAT_HEADING FLAG_USE_PILOT_HELMET FLAG_HAS_CAPPED_EXPLOSION_DAMAGE FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_CHECK_WARP_TASK_FLAG_DURING_ENTER","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":1483171323,"modelName":"deluxo","gameName":"DELUXO","vehicleMakeName":"IMPONTE","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_HAS_GULL_WING_DOORS FLAG_USE_ROOT_AS_BASE_LOCKON_POS FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":886810209,"modelName":"stromberg","gameName":"STROMBERG","vehicleMakeName":"OCELOT","flags":"FLAG_CAN_HAVE_NEONS FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_SUBMARINECAR"},{"modelHash":3602674979,"modelName":"chernobog","gameName":"CHERNOBOG","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_EXTRAS_ONLY_BREAK_WHEN_DESTROYED FLAG_EXTRAS_ALL FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_RESET_TURRET_SEAT_HEADING FLAG_DONT_HOLD_LOW_GEARS_WHEN_ENGINE_UNDER_LOAD FLAG_INCREASE_LOW_SPEED_TORQUE FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_OUTRIGGER_LEGS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_CREATE_WEAPON_MANAGER_ON_SPAWN FLAG_HAS_REAR_MOUNTED_TURRET FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_HEADLIGHTS_ON_TAP_ONLY","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2601952180,"modelName":"riot2","gameName":"RIOT2","vehicleMakeName":"","flags":"FLAG_BIG FLAG_NO_BOOT FLAG_AVOID_TURNS FLAG_EXTRAS_STRONG FLAG_EXTRAS_ALL FLAG_PEDS_CAN_STAND_ON_TOP FLAG_DONT_SPAWN_IN_CARGEN FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_BULLETPROOF_GLASS FLAG_CARGOBOB_HOOK_UP_CHASSIS FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_HAS_REAR_MOUNTED_TURRET FLAG_TURRET_MODS_ON_ROOF FLAG_RESET_TURRET_SEAT_HEADING","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_EMERGENCY","type":"VEHICLE_TYPE_CAR"},{"modelHash":2176659152,"modelName":"avenger","gameName":"AVENGER","vehicleMakeName":"MAMMOTH","flags":"FLAG_USE_INTERIOR_RED_LIGHT FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_HAS_JATO_BOOST_MOD FLAG_HOLD_TO_SHUFFLE FLAG_HAS_VERTICAL_FLIGHT_MODE FLAG_DONT_CRASH_ABANDONED_NEAR_GROUND FLAG_CREATE_WEAPON_MANAGER_ON_SPAWN FLAG_HAS_BULLET_RESISTANT_GLASS FLAG_USE_ROOT_AS_BASE_LOCKON_POS FLAG_DISABLE_CAMERA_PUSH_BEYOND FLAG_CHECK_WARP_TASK_FLAG_DURING_ENTER","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":408970549,"modelName":"avenger2","gameName":"AVENGER","vehicleMakeName":"MAMMOTH","flags":"FLAG_USE_INTERIOR_RED_LIGHT FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS FLAG_RESET_TURRET_SEAT_HEADING FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_HAS_JATO_BOOST_MOD FLAG_HOLD_TO_SHUFFLE FLAG_HAS_VERTICAL_FLIGHT_MODE FLAG_DONT_CRASH_ABANDONED_NEAR_GROUND FLAG_CHECK_WARP_TASK_FLAG_DURING_ENTER","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1489874736,"modelName":"thruster","gameName":"THRUSTER","vehicleMakeName":"MAMMOTH","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_HAS_JATO_BOOST_MOD FLAG_HAS_HELI_STRAFE_MODE FLAG_HAS_VERTICAL_ROCKET_BOOST FLAG_HELICOPTER_WITH_LANDING_GEAR","plateType":"VPT_NONE","vehicleClass":"VC_MILITARY","type":"VEHICLE_TYPE_HELI"},{"modelHash":1871995513,"modelName":"yosemite","gameName":"YOSEMITE","vehicleMakeName":"DECLASSE","flags":"FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_DROP_SUSPENSION_WHEN_STOPPED","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":15219735,"modelName":"hermes","gameName":"HERMES","vehicleMakeName":"ALBANY","flags":"FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_DROP_SUSPENSION_WHEN_STOPPED FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT_HIGH","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":600450546,"modelName":"hustler","gameName":"HUSTLER","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_ALL FLAG_EXTRAS_STRONG FLAG_USE_STRICTER_EXIT_COLLISION_TESTS FLAG_USE_RESTRICTED_DRIVEBY_HEIGHT","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":1741861769,"modelName":"streiter","gameName":"STREITER","vehicleMakeName":"BENEFACTOR","flags":"FLAG_BOOT_IN_FRONT FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_EXTRAS_STRONG FLAG_PARKING_SENSORS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS","plateType":"VPT_NONE","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3884762073,"modelName":"revolter","gameName":"REVOLTER","vehicleMakeName":"UBERMACH","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_RECESSED_HEADLIGHT_CORONAS ","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":867799010,"modelName":"pariah","gameName":"PARIAH","vehicleMakeName":"OCELOT","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":4173521127,"modelName":"kamacho","gameName":"KAMACHO","vehicleMakeName":"CANIS","flags":"FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_IS_OFFROAD_VEHICLE FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_IS_BULKY FLAG_HAS_INTERIOR_EXTRAS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_OFF_ROAD","type":"VEHICLE_TYPE_CAR"},{"modelHash":2068293287,"modelName":"Lurcher","gameName":"LURCHER","vehicleMakeName":"ALBANY","flags":"FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":3463132580,"modelName":"btype2","gameName":"BTYPE2","vehicleMakeName":"ALBANY","flags":"FLAG_SPORTS FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_DONT_SPAWN_IN_CARGEN FLAG_INCREASE_PED_COMMENTS","plateType":"VPT_NONE","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":2175389151,"modelName":"faction","gameName":"FACTION","vehicleMakeName":"WILLARD","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2504420315,"modelName":"faction2","gameName":"FACTION2","vehicleMakeName":"WILLARD","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":525509695,"modelName":"moonbeam","gameName":"MOONBEAM","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_HAS_REAR_SEAT_ACTIVITIES","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":1896491931,"modelName":"moonbeam2","gameName":"MOONBEAM2","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_HAS_REAR_SEAT_ACTIVITIES FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2254540506,"modelName":"primo2","gameName":"PRIMO2","vehicleMakeName":"ALBANY","flags":"FLAG_PARKING_SENSORS FLAG_AVERAGE_CAR FLAG_POOR_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_SEDAN","type":"VEHICLE_TYPE_CAR"},{"modelHash":2933279331,"modelName":"chino2","gameName":"CHINO2","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":3281516360,"modelName":"buccaneer2","gameName":"BUCCANEE2","vehicleMakeName":"ALBANY","flags":"FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_ALL FLAG_AVERAGE_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_HAS_LOWRIDER_HYDRAULICS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"},{"modelHash":2006667053,"modelName":"voodoo","gameName":"VOODOO2","vehicleMakeName":"DECLASSE","flags":"FLAG_POOR_CAR FLAG_HAS_LOWRIDER_HYDRAULICS ","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":3052358707,"modelName":"vigilante","gameName":"VIGILANTE","vehicleMakeName":"","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_GULL_WING_DOORS FLAG_HAS_ROCKET_BOOST FLAG_HAS_INCREASED_RAMMING_FORCE FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING FLAG_HAS_BULLETPROOF_GLASS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":4262088844,"modelName":"bombushka","gameName":"BOMBUSHKA","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_LIGHTING_INTERIOR_OVERRIDE FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_TURRET_MODS_ON_ROOF FLAG_SECOND_TURRET_MOD FLAG_HAS_JATO_BOOST_MOD FLAG_RESET_TURRET_SEAT_HEADING FLAG_KEEP_ALL_TURRETS_SYNCHRONISED FLAG_DISABLE_CAMERA_PUSH_BEYOND","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2771347558,"modelName":"alphaz1","gameName":"ALPHAZ1","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":3902291871,"modelName":"seabreeze","gameName":"SEABREEZE","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_IGNORE_TRAPPED_HULL_CHECK","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1043222410,"modelName":"tula","gameName":"TULA","vehicleMakeName":"MAMMOTH","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HEADLIGHTS_ON_LANDINGGEAR FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_RESET_TURRET_SEAT_HEADING FLAG_KEEP_ALL_TURRETS_SYNCHRONISED FLAG_TURRET_MODS_ON_ROOF FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_HAS_JATO_BOOST_MOD FLAG_HOLD_TO_SHUFFLE","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2310691317,"modelName":"havok","gameName":"HAVOK","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_STANDARD_FLIGHT_HELMET","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":4252008158,"modelName":"hunter","gameName":"HUNTER","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_NO_RESPRAY FLAG_AVERAGE_CAR FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_DONT_TIMESLICE_WHEELS FLAG_HELI_USES_FIXUPS_ON_OPEN_DOOR FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_RESET_TURRET_SEAT_HEADING FLAG_USE_PILOT_HELMET FLAG_HAS_CAPPED_EXPLOSION_DAMAGE FLAG_USE_AIRCRAFT_STYLE_WEAPON_TARGETING","plateType":"VPT_NONE","vehicleClass":"VC_HELICOPTER","type":"VEHICLE_TYPE_HELI"},{"modelHash":2531412055,"modelName":"microlight","gameName":"microlight","vehicleMakeName":"NAGASAKI","flags":"FLAG_NO_BOOT FLAG_DONT_SPAWN_IN_CARGEN FLAG_HEADLIGHTS_USE_ACTUAL_BONE_POS FLAG_DONT_SPAWN_AS_AMBIENT FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_USE_TURRET_RELATIVE_AIM_CALCULATION FLAG_TURRET_MODS_ON_ROOF FLAG_RESET_TURRET_SEAT_HEADING FLAG_TURRET_MOD_WITH_NO_STOCK_TURRET FLAG_EQUIP_UNARMED_ON_ENTER","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":3319621991,"modelName":"rogue","gameName":"ROGUE","vehicleMakeName":"WESTERN","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_DISABLE_WEAPON_WHEEL_IN_FIRST_PERSON FLAG_USE_PILOT_HELMET FLAG_IGNORE_TRAPPED_HULL_CHECK FLAG_HAS_EJECTOR_SEATS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2908775872,"modelName":"pyro","gameName":"PYRO","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_HAS_JATO_BOOST_MOD FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_PILOT_HELMET FLAG_HAS_EJECTOR_SEATS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":3287439187,"modelName":"howard","gameName":"HOWARD","vehicleMakeName":"BUCKING","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_STANDARD_FLIGHT_HELMET","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":3545667823,"modelName":"mogul","gameName":"MOGUL","vehicleMakeName":"MAMMOTH","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_TURRET_SEAT_ON_VEHICLE FLAG_TURRET_ENTRY_ATTACH_TO_DRIVER_SEAT FLAG_RESET_TURRET_SEAT_HEADING FLAG_KEEP_ALL_TURRETS_SYNCHRONISED FLAG_TURRET_MODS_ON_ROOF FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_HAS_JATO_BOOST_MOD FLAG_IGNORE_TRAPPED_HULL_CHECK FLAG_HOLD_TO_SHUFFLE","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2594093022,"modelName":"starling","gameName":"STARLING","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_HAS_ROCKET_BOOST FLAG_USE_STANDARD_FLIGHT_HELMET FLAG_IGNORE_TRAPPED_HULL_CHECK","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1036591958,"modelName":"nokota","gameName":"NOKOTA","vehicleMakeName":"","flags":"FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_PILOT_HELMET FLAG_IGNORE_TRAPPED_HULL_CHECK","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":1565978651,"modelName":"molotok","gameName":"MOLOTOK","vehicleMakeName":"","flags":"FLAG_NO_BOOT FLAG_DRIVER_NO_DRIVE_BY FLAG_DONT_SPAWN_IN_CARGEN FLAG_DONT_SPAWN_AS_AMBIENT FLAG_BLOCK_FROM_ATTRACTOR_SCENARIO FLAG_DONT_TIMESLICE_WHEELS FLAG_USE_WEAPON_WHEEL_WITHOUT_HELMET FLAG_USE_PILOT_HELMET FLAG_HAS_EJECTOR_SEATS","plateType":"VPT_NONE","vehicleClass":"VC_PLANE","type":"VEHICLE_TYPE_PLANE"},{"modelHash":2049897956,"modelName":"rapidgt3","gameName":"RAPIDGT3","vehicleMakeName":"DEWBAUCH","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1841130506,"modelName":"retinue","gameName":"RETINUE","vehicleMakeName":"VAPID","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR","image":"http://placehold.it/256x256","price":"999999"},{"modelHash":1392481335,"modelName":"cyclone","gameName":"CYCLONE","vehicleMakeName":"COIL","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS FLAG_IS_ELECTRIC","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3296789504,"modelName":"visione","gameName":"VISIONE","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_COUNT_AS_FACEBOOK_DRIVEN FLAG_HAS_GULL_WING_DOORS FLAG_CARGOBOB_HOOK_UP_CHASSIS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":3312836369,"modelName":"turismo2","gameName":"TURISMO2","vehicleMakeName":"GROTTI","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG FLAG_FRONT_BOOT","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":2889029532,"modelName":"infernus2","gameName":"INFERNUS2","vehicleMakeName":"PEGASSI","flags":"FLAG_SPORTS FLAG_SPAWN_ON_TRAILER FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_CAN_HAVE_NEONS FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_EXTRAS_REQUIRE FLAG_EXTRAS_STRONG","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":1234311532,"modelName":"gp1","gameName":"GP1","vehicleMakeName":"PROGEN","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_RECESSED_HEADLIGHT_CORONAS FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_HAS_GULL_WING_DOORS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SUPER","type":"VEHICLE_TYPE_CAR"},{"modelHash":719660200,"modelName":"ruston","gameName":"RUSTON","vehicleMakeName":"HIJAK","flags":"FLAG_SPORTS FLAG_EXTRAS_CONVERTIBLE FLAG_EXTRAS_STRONG FLAG_RICH_CAR FLAG_NO_BROKEN_DOWN_SCENARIO FLAG_RECESSED_TAILLIGHT_CORONAS","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT","type":"VEHICLE_TYPE_CAR"},{"modelHash":3692679425,"modelName":"btype3","gameName":"ROOSEVELT2","vehicleMakeName":"ALBANY","flags":"FLAG_SPORTS FLAG_RICH_CAR FLAG_COUNT_AS_FACEBOOK_DRIVEN","plateType":"VPT_BACK_PLATES","vehicleClass":"VC_SPORT_CLASSIC","type":"VEHICLE_TYPE_CAR"},{"modelHash":972671128,"modelName":"tampa","gameName":"TAMPA","vehicleMakeName":"DECLASSE","flags":"FLAG_EXTRAS_STRONG FLAG_AVERAGE_CAR FLAG_HAS_INTERIOR_EXTRAS FLAG_CAN_HAVE_NEONS","plateType":"VPT_FRONT_AND_BACK_PLATES","vehicleClass":"VC_MUSCLE","type":"VEHICLE_TYPE_CAR"}]'
        );
    },
    "85ec": function (_, e, A) {},
    "87b8": function (_, e, A) {},
    "958a": function (_, e, A) {},
    "95ec": function (_, e, A) {
        "use strict";
        A("bb7d");
    },
    bb7d: function (_, e, A) {},
});
//# sourceMappingURL=app.c96df588.js.map
