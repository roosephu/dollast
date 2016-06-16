webpackJsonp([0],[
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var vue, vuex, vueRouter, vueResource, debug, moment, log, router, x$, app, extraRules, key, val;
	vue = __webpack_require__(1);
	vuex = __webpack_require__(3);
	vueRouter = __webpack_require__(4);
	vueResource = __webpack_require__(5);
	debug = __webpack_require__(29);
	moment = __webpack_require__(32);
	vue.use(vuex);
	vue.config.debug = true;
	debug.enable("dollast:*");
	log = debug('dollast:main');
	vue.use(vueRouter);
	router = __webpack_require__(135);
	vue.use(vueResource);
	vue.http.options.root = '/api';
	x$ = app = __webpack_require__(211);
	x$.store = __webpack_require__(147);
	app = vue.extend(app);
	extraRules = {
	  positive: function(text){
	    return 0 < parseFloat(text);
	  },
	  isTime: function(text){
	    return moment(text, 'YYYY-MM-DD HH:mm:ss').isValid();
	  },
	  isPassword: function(text){
	    return 4 <= text.length && text.length <= 15;
	  },
	  isUserId: function(text){
	    if (4 > text.length || text.length > 15) {
	      return false;
	    } else {
	      return /^[a-zA-Z0-9._]*$/.test(text);
	    }
	  },
	  isAccess: function(text){
	    return /^([r-][w-][x-]){3}$/.test(text);
	  }
	};
	for (key in extraRules) {
	  val = extraRules[key];
	  $.fn.form.settings.rules[key] = val;
	}
	router.start(app, '#app');
	if (MathJax) {
	  MathJax.Hub.Config({
	    tex2jax: {
	      inlineMath: [['$', '$'], ['\\(', '\\)']]
	    }
	  });
	} else {
	  log.error('No MathJax found.');
	}
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/client/main.ls.map


/***/ },
/* 1 */,
/* 2 */,
/* 3 */,
/* 4 */,
/* 5 */,
/* 6 */,
/* 7 */,
/* 8 */,
/* 9 */,
/* 10 */,
/* 11 */,
/* 12 */,
/* 13 */,
/* 14 */,
/* 15 */,
/* 16 */,
/* 17 */,
/* 18 */,
/* 19 */,
/* 20 */,
/* 21 */,
/* 22 */,
/* 23 */,
/* 24 */,
/* 25 */,
/* 26 */,
/* 27 */,
/* 28 */,
/* 29 */,
/* 30 */,
/* 31 */,
/* 32 */,
/* 33 */,
/* 34 */,
/* 35 */,
/* 36 */,
/* 37 */,
/* 38 */,
/* 39 */,
/* 40 */,
/* 41 */,
/* 42 */,
/* 43 */,
/* 44 */,
/* 45 */,
/* 46 */,
/* 47 */,
/* 48 */,
/* 49 */,
/* 50 */,
/* 51 */,
/* 52 */,
/* 53 */,
/* 54 */,
/* 55 */,
/* 56 */,
/* 57 */,
/* 58 */,
/* 59 */,
/* 60 */,
/* 61 */,
/* 62 */,
/* 63 */,
/* 64 */,
/* 65 */,
/* 66 */,
/* 67 */,
/* 68 */,
/* 69 */,
/* 70 */,
/* 71 */,
/* 72 */,
/* 73 */,
/* 74 */,
/* 75 */,
/* 76 */,
/* 77 */,
/* 78 */,
/* 79 */,
/* 80 */,
/* 81 */,
/* 82 */,
/* 83 */,
/* 84 */,
/* 85 */,
/* 86 */,
/* 87 */,
/* 88 */,
/* 89 */,
/* 90 */,
/* 91 */,
/* 92 */,
/* 93 */,
/* 94 */,
/* 95 */,
/* 96 */,
/* 97 */,
/* 98 */,
/* 99 */,
/* 100 */,
/* 101 */,
/* 102 */,
/* 103 */,
/* 104 */,
/* 105 */,
/* 106 */,
/* 107 */,
/* 108 */,
/* 109 */,
/* 110 */,
/* 111 */,
/* 112 */,
/* 113 */,
/* 114 */,
/* 115 */,
/* 116 */,
/* 117 */,
/* 118 */,
/* 119 */,
/* 120 */,
/* 121 */,
/* 122 */,
/* 123 */,
/* 124 */,
/* 125 */,
/* 126 */,
/* 127 */,
/* 128 */,
/* 129 */,
/* 130 */,
/* 131 */,
/* 132 */,
/* 133 */,
/* 134 */,
/* 135 */
/***/ function(module, exports, __webpack_require__) {

	var vueRouter, router;
	vueRouter = __webpack_require__(4);
	router = new vueRouter();
	router.map({
	  "/": {
	    component: __webpack_require__(136)
	  },
	  "/about": {
	    component: __webpack_require__(138)
	  },
	  "/problem": {
	    component: __webpack_require__(140)
	  },
	  "/problem/create": {
	    component: __webpack_require__(150)
	  },
	  "/problem/:pid": {
	    component: __webpack_require__(153)
	  },
	  "/problem/:pid/modify": {
	    component: __webpack_require__(150)
	  },
	  "/problem/:pid/stat": {
	    component: __webpack_require__(156)
	  },
	  "/problem/:pid/data": {
	    component: __webpack_require__(175)
	  },
	  "/solution": {
	    component: __webpack_require__(178)
	  },
	  "/solution/submit/:pid": {
	    component: __webpack_require__(181)
	  },
	  "/solution/user/:uid": {
	    component: __webpack_require__(136)
	  },
	  "/solution/:sid": {
	    component: __webpack_require__(184)
	  },
	  "/round": {
	    component: __webpack_require__(187)
	  },
	  "/round/create": {
	    component: __webpack_require__(190)
	  },
	  "/round/:rid": {
	    component: __webpack_require__(193)
	  },
	  "/round/:rid/modify": {
	    component: __webpack_require__(190)
	  },
	  "/round/:rid/board": {
	    component: __webpack_require__(196)
	  },
	  "/user": {
	    component: __webpack_require__(199)
	  },
	  "/user/login": {
	    component: __webpack_require__(202)
	  },
	  "/user/register": {
	    component: __webpack_require__(205)
	  },
	  "/user/:uid": {
	    component: __webpack_require__(199)
	  },
	  "/user/:uid/modify": {
	    component: __webpack_require__(208)
	  }
	});
	module.exports = router;
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/client/router.ls.map


/***/ },
/* 136 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_template__ = __webpack_require__(137)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/site/index.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 137 */
/***/ function(module, exports) {

	module.exports = "<div><h1 class=\"ui dividing header\">welcome</h1><h3 class=\"ui\">this is dollast, an buggy online judge.</h3></div>";

/***/ },
/* 138 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_template__ = __webpack_require__(139)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/site/about.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 139 */
/***/ function(module, exports) {

	module.exports = "<div><p>Hi 小朋友们大家好，还记得我是谁吗，对了我就是青年理论计算机科学家 BBL ！（背景音乐：我可是世界上最厉害的……</p><p>为了答谢广大人民群众对我的厚爱，以及老师们拉着我非要我写一个 OJ 出来，我就花了几个星期码了这样一个网站出来 →_→</p><div><h2>Q: 为何这网站如此具有朴素简洁美？</h2><h3>A: 朴实沉毅乃校训，不可忘怀。（其实是我懒得做 UI 了 = =）</h3><div><p>有兴趣的同学可以自己设计一套 UI 给我……聪明的同学已经发现了我网站的架构了：每次 get 一个网页作为模板，所以只需要写一套 partials 里面的东西就可以了……</p><p>\"我才不会告诉你们我早就写好了 theme 功能，就差一个美工了 →_→</p></div><br/></div><div><h2>\"Q: 为什么要起一个 dollast 这种中二的名字？\"</h2><h3>\"A: 我也不知道你快来咬我呀哈哈哈哈…… 因为这边儿名字是 YXJ 起的 →_→\"</h3><div><p>\"其实我早就做好了准备，要改名字只要一行命令就可以了 233\"</p></div><br/></div><div><h2>\"Q: 那请问贵站有哪些特性？\"</h2><h3>\"A: 终于有人肯问一个正常点的问题了！我们目前只支持两个特性：1. 朴素 2. 不能评测……因为没写完。\"</h3><div><p>\"我的美妙的寒假全葬送在这个网站上了……说好的青年理论计算机科学家呢 →_→\"</p></div><br/></div><div><h2>\"Q: 你写这个 OJ ，是不是要钦点成为 CJ 的校内 OJ？\"</h2><h3>\"A: 我没有任何这个意思。你们有一个好，刷题刷的比谁都快，但是问来问去的问题，too simple。西方的那个 OJ 我没用过？美国的 SPOJ，不知道比你们快到哪去了，我用的谈笑风生。你们啊，too young，sometimes naive。\"</h3><div><p>\"再问我就烂尾啦 = =\"</p></div><br/></div><div><h2>\"Q: 那么具体说来你用的是怎样一个架构？\"</h2><h3>\"A: \"<del>\"M(ongoDB)A(ngularjs)N(odejs)K(oa) ，外加一个 cpp 作为沙盒。目前发现没什么代码量……\"</del>\"I used months to refactor the code from Angular.js to React.js. The backend remains to be Koa.js\"</h3><div><p>\"据说码代码的时间只要学习新姿势的一半，学习新姿势的时间只要调试的一半\"</p></div><br/></div></div>";

/***/ },
/* 140 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(141)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/problem/list.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(149)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/problem/list.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 141 */
/***/ function(module, exports, __webpack_require__) {

	var vue, co, debug, problem, raiseError, log;
	vue = __webpack_require__(1);
	co = __webpack_require__(142);
	debug = __webpack_require__(29);
	problem = __webpack_require__(143);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:problem:list');
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      filter: 'all',
	      options: ['all', 'solved', 'unsolved'],
	      problems: []
	    };
	  },
	  components: {
	    problem: problem
	  },
	  route: {
	    data: co.wrap(function*(){
	      var response, problems;
	      response = (yield vue.http.get('problem')).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      problems = response.data;
	      return {
	        problems: problems
	      };
	    })
	  },
	  ready: function(){
	    var $filter, this$ = this;
	    $filter = $('.dropdown');
	    $filter.dropdown({
	      on: 'hover',
	      onChange: function(value){
	        return this$.filter = value;
	      }
	    });
	    return $filter.dropdown('set text', 'all');
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/problem/list.vue.map


/***/ },
/* 142 */,
/* 143 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(144)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/format/problem.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(145)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/format/problem.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 144 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    prob: Object
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/format/problem.vue.map


/***/ },
/* 145 */
/***/ function(module, exports) {

	module.exports = "<a v-if=\"prob &amp;&amp; prob._id &gt; 0\" href=\"#/problem/{{prob._id}}\" class=\"ui label green\">{{prob._id}}. {{prob.outlook.title}}</a><a v-else=\"v-else\" class=\"ui label green\">hidden</a>";

/***/ },
/* 146 */
/***/ function(module, exports, __webpack_require__) {

	var vue, co, debug, store, log, login, logout, raiseError, resolveError, out$ = typeof exports != 'undefined' && exports || this;
	vue = __webpack_require__(1);
	co = __webpack_require__(142);
	debug = __webpack_require__(29);
	store = __webpack_require__(147);
	log = debug('dollast:actions');
	out$.login = login = function(arg$){
	  var dispatch;
	  dispatch = arg$.dispatch;
	  if (localStorage.token) {
	    return dispatch('login', localStorage.token);
	  }
	};
	out$.logout = logout = function(arg$){
	  var dispatch;
	  dispatch = arg$.dispatch;
	  delete localStorage.token;
	  return dispatch('logout');
	};
	out$.raiseError = raiseError = function(arg$, response){
	  var dispatch;
	  dispatch = arg$.dispatch;
	  log('raise', {
	    response: response
	  });
	  return dispatch('raiseError', response.errors[0]);
	};
	out$.resolveError = resolveError = function(arg$){
	  var dispatch;
	  dispatch = arg$.dispatch;
	  return dispatch('resolveError');
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/client/actions/index.ls.map


/***/ },
/* 147 */
/***/ function(module, exports, __webpack_require__) {

	var vue, vuex, auth, state, mutations;
	vue = __webpack_require__(1);
	vuex = __webpack_require__(3);
	auth = __webpack_require__(148);
	state = {
	  session: {
	    guest: true
	  },
	  error: void 8
	};
	mutations = {
	  login: function(state, token){
	    var payload, clientInfo;
	    payload = auth.jwt.dec(token);
	    clientInfo = JSON.parse(payload.client);
	    localStorage.token = token;
	    vue.http.headers.common.Authorization = "Bearer " + token;
	    return state.session = {
	      guest: false,
	      uid: clientInfo.uid,
	      token: token
	    };
	  },
	  logout: function(state){
	    return state.session = {
	      guest: true
	    };
	  },
	  raiseError: function(state, error){
	    return state.error = error;
	  },
	  resolveError: function(){
	    return state.error = void 8;
	  }
	};
	module.exports = new vuex.Store({
	  state: state,
	  mutations: mutations
	});
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/client/store/index.ls.map


/***/ },
/* 148 */
/***/ function(module, exports, __webpack_require__) {

	var debug, pubKey, RSAEntity, log, ref$, out$ = typeof exports != 'undefined' && exports || this;
	debug = __webpack_require__(29);
	pubKey = '-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCV8qwyGUz1mKUNyMUXIb5THUYJ\n9Xf9WgL/GC5UeVon7JKtzeWXRSCmzxlO5XD4GD8zcJ728kNfABdizPQ1HG4MFfRc\ns5vPQDiIR23dafkGODmE039aKRiTc+xxrLgx3huasFan+2yG/tiFQbXEFfAmLaal\n6FuOukBTwitq0XBdiQIDAQAB\n-----END PUBLIC KEY-----';
	RSAEntity = forge.pki.publicKeyFromPem(pubKey);
	log = debug('dollast:auth');
	ref$ = out$;
	ref$.RSA = {
	  enc: function(txt){
	    return txt;
	  },
	  dec: function(cipher, key){
	    return cipher;
	  }
	};
	ref$.jwt = {
	  enc: function(header, payload, key){
	    var header64, payload64, unsignedToken, h, signature64, ret;
	    if ('string' !== typeof header) {
	      header = JSON.stringify(header);
	    }
	    if ('string' !== typeof payload) {
	      payload = JSON.stringify(payload);
	    }
	    header64 = forge.util.encode64(header);
	    payload64 = forge.util.encode64(payload);
	    unsignedToken = header64 + "." + payload64;
	    h = forge.hmac.create();
	    h.start('sha256', key);
	    h.update(unsignedToken);
	    signature64 = forge.util.encode64(forge.util.hexToBytes(h.digest().toHex()));
	    ret = (unsignedToken + "." + signature64).replace(/\#g, '_' .replace /['+/g'], '-').replace(/\=/g, '');
	    return ret;
	  },
	  dec: function(token){
	    var jwtStruct, payload;
	    jwtStruct = token.split('.');
	    while (jwtStruct[1].length % 4 !== 0) {
	      jwtStruct[1] += "=";
	    }
	    return payload = JSON.parse(forge.util.decode64(jwtStruct[1]));
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/client/store/auth.ls.map


/***/ },
/* 149 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui\"><h1 class=\"ui dividing header\">Problem List</h1><div class=\"ui dropdown floated pointing button labeled icon\"><input type=\"hidden\" name=\"filter\"/><div class=\"default text\">please select filter</div><i class=\"dropdown icon\"></i><div class=\"menu\"><div v-for=\"item in options\" data-value=\"{{item}}\" class=\"item\">{{item}}</div></div></div><a href=\"#/problem/create\" class=\"ui icon labeled button right floated primary\"><i class=\"icon plus\"></i>create</a><div class=\"ui segment\"><div class=\"ui very relaxed divided link list\"><div v-for=\"problem in problems\" class=\"item\"><div class=\"ui right floated\">??</div><div class=\"ui description\"><problem :prob=\"problem\"></problem></div></div></div></div></div>";

/***/ },
/* 150 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(151)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/problem/modify.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(152)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/problem/modify.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 151 */
/***/ function(module, exports, __webpack_require__) {

	var debug, co, vue, raiseError, log, flattenObject, getFormValues, setFormValues, this$ = this;
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	vue = __webpack_require__(1);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:problem:modify');
	flattenObject = function(obj){
	  var ret, key, val;
	  ret = {};
	  for (key in obj) {
	    val = obj[key];
	    if ('object' === typeof val) {
	      import$(ret, flattenObject(val));
	    } else {
	      ret[key] = val;
	    }
	  }
	  return ret;
	};
	getFormValues = function(){
	  var values, outlook, config, permit;
	  values = $('.form').form('get values');
	  outlook = {
	    title: values.title,
	    description: values.description,
	    inputFormat: values.inputFormat,
	    outputFormat: values.outputFormat,
	    sampleInput: values.sampleInput,
	    sampleOutput: values.sampleOutput
	  };
	  config = {
	    rid: values.rid,
	    pid: values.pid,
	    judger: values.judger,
	    timeLimit: values.timeLimit,
	    spaceLimit: values.spaceLimit,
	    outLimit: values.outLimit,
	    stkLimit: values.stkLimit
	  };
	  permit = {
	    owner: values.owner,
	    group: values.group,
	    access: values.access
	  };
	  if (config.rid === "") {
	    delete config.rid;
	  } else {
	    config.rid = parseInt(config.rid);
	  }
	  config.timeLimit = parseFloat(config.timeLimit);
	  config.spaceLimit = parseFloat(config.spaceLimit);
	  config.outLimit = parseFloat(config.outLimit);
	  config.stkLimit = parseFloat(config.stkLimit);
	  return {
	    outlook: outlook,
	    config: config,
	    permit: permit
	  };
	};
	setFormValues = function(data){
	  var problem, $form;
	  problem = flattenObject(data);
	  $form = $('#problem-modify');
	  return $form.form('set values', problem);
	};
	module.exports = {
	  vuex: {
	    getters: {
	      uid: function(it){
	        return it.session.uid;
	      }
	    },
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      pid: "",
	      files: [],
	      judgers: ['string', 'real', 'strict', 'custom'],
	      problem: {
	        _id: "",
	        outlook: {
	          title: 'hello world'
	        },
	        config: {
	          dataset: []
	        }
	      }
	    };
	  },
	  computed: {
	    title: function(){
	      if (this.problem._id !== "") {
	        return "Problem " + this.problem._id + ". " + this.problem.outlook.title;
	      } else {
	        return "Create new problem";
	      }
	    }
	  },
	  ready: function(){
	    var submit, $form, this$ = this;
	    $('.dropdown').dropdown();
	    submit = co.wrap(function*(e){
	      var problem, data;
	      e.preventDefault();
	      problem = getFormValues();
	      log({
	        problem: problem
	      });
	      if (this$.pid === "") {
	        data = (yield this$.$http.post("problem", problem)).data;
	      } else {
	        data = (yield this$.$http.put("problem/" + this$.pid, problem)).data;
	      }
	      if (data.errors !== void 8) {
	        return log(data.errors);
	      }
	    });
	    $form = $('#problem-modify');
	    $form.form({
	      on: 'blur',
	      inline: true,
	      fields: {
	        title: {
	          identifier: 'title',
	          rules: [
	            {
	              type: 'minLength[2]',
	              prompt: 'title minimum length is 2'
	            }, {
	              type: 'maxLength[63]',
	              prompt: 'title length cannot exceed 63'
	            }
	          ]
	        },
	        rid: {
	          identifier: 'rid',
	          optional: true,
	          rules: [{
	            type: 'integer[1..]',
	            prompt: '#rid must be a positive integer'
	          }]
	        },
	        judger: {
	          identifier: 'judger',
	          rules: [{
	            type: 'empty',
	            prompt: 'please choose your judger'
	          }]
	        },
	        timeLmt: {
	          identifier: 'timeLimit',
	          rules: [{
	            type: 'positive',
	            prompt: 'time limit must be positive'
	          }]
	        },
	        spaceLmt: {
	          identifier: 'spaceLimit',
	          rules: [{
	            type: 'positive',
	            prompt: 'space limit must be positive'
	          }]
	        },
	        stkLmt: {
	          identifier: 'stkLimit',
	          rules: [{
	            type: 'positive',
	            prompt: "stack limit must be positive"
	          }]
	        },
	        outLmt: {
	          identifier: 'outLimit',
	          rules: [{
	            type: 'positive',
	            prompt: "output limit must be positive"
	          }]
	        },
	        desc: {
	          identifier: 'description',
	          rules: [{
	            type: "maxLength[65535]",
	            prompt: "description cannot be longer than 65535"
	          }]
	        },
	        inFmt: {
	          identifier: 'inputFormat',
	          rules: [{
	            type: "maxLength[65535]",
	            prompt: "input format cannot be longer than 65535"
	          }]
	        },
	        outFmt: {
	          identifier: 'outputFormat',
	          rules: [{
	            type: "maxLength[65535]",
	            prmopt: "output format cannot be longer than 65535"
	          }]
	        },
	        sampleIn: {
	          identifier: 'sampleInput',
	          rules: [{
	            type: "maxLength[65535]",
	            prompt: "sample input cannot be longer than 65535"
	          }]
	        },
	        sampleOut: {
	          identifier: 'sampleOutput',
	          rules: [{
	            type: "maxLength[65535]",
	            prompt: "sample output cannot be longer than 65535"
	          }]
	        },
	        owner: {
	          identifier: 'owner',
	          rules: [{
	            type: 'isUserId',
	            prompt: 'owner should be valid'
	          }]
	        },
	        group: {
	          identifier: 'group',
	          rules: [{
	            type: 'isUserId',
	            prompt: 'group should be valid'
	          }]
	        },
	        access: {
	          identifier: 'access',
	          rules: [{
	            type: 'isAccess',
	            prompt: 'access code should be /^([r-][w-][x-]){3}$/'
	          }]
	        }
	      },
	      onSuccess: submit
	    });
	    if (this.pid === "") {
	      return setFormValues({
	        owner: this.uid,
	        group: 'problems',
	        access: 'rwxrw-r--'
	      });
	    }
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var pid, response, problem;
	      pid = arg$.to.params.pid;
	      if (pid !== void 8) {
	        response = (yield vue.http.get("problem/" + pid)).data;
	        if (response.errors) {
	          this$.raiseError(response);
	          return null;
	        }
	        problem = response.data;
	        setFormValues(problem);
	        return {
	          pid: pid,
	          problem: problem
	        };
	      }
	    })
	  }
	};
	function import$(obj, src){
	  var own = {}.hasOwnProperty;
	  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
	  return obj;
	}
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/problem/modify.vue.map


/***/ },
/* 152 */
/***/ function(module, exports) {

	module.exports = "<div id=\"problem-modify\" class=\"ui form\"><h2 class=\"ui dividing header\">{{title}}</h2><div class=\"ui error message\"></div><h3 class=\"ui dividing header\">Configuration</h3><div class=\"ui three fields\"><div class=\"ui field eight wide\"><label>title</label><div class=\"ui input\"><input name=\"title\"/></div></div><div class=\"ui field four wide\"><label>round</label><div class=\"ui input\"><input name=\"rid\" type=\"number\" placeholder=\"optional\"/></div></div><div class=\"ui field four wide\"><label>judger</label><div class=\"ui dropdown icon selection\"><input type=\"hidden\" name=\"judger\"/><div class=\"default text\">choose a judger</div><i class=\"dropdown icon\"></i><div class=\"menu\"><div v-for=\"item in judgers\" data-value=\"{{item}}\" class=\"item\">{{item}}</div></div></div></div></div><div class=\"ui four fields\"><div class=\"ui field\"><label>time limit (s)</label><div class=\"ui input\"><input name=\"timeLimit\" type=\"number\"/></div></div><div class=\"ui field\"><label>space limit (MB)</label><div class=\"ui input\"><input name=\"spaceLimit\" type=\"number\"/></div></div><div class=\"ui field\"><label>stack limit (MB)</label><div class=\"ui input\"><input name=\"stkLimit\" type=\"number\"/></div></div><div class=\"ui field\"><label>output limit (MB)</label><div class=\"ui input\"><input name=\"outLimit\" type=\"number\"/></div></div></div><h3 class=\"ui dividing header\">Description</h3><div class=\"ui field\"><div class=\"ui field\"><label>description</label><textarea name=\"description\"></textarea></div></div><div class=\"ui two fields\"><div class=\"ui field\"><label>input format</label><textarea name=\"inputFormat\"></textarea></div><div class=\"ui field\"><label>output format</label><textarea name=\"outputFormat\"></textarea></div></div><div class=\"ui two fields\"><div class=\"ui field\"><label>sample input</label><textarea name=\"sampleInput\"></textarea></div><div class=\"ui field\"><label>sample output</label><textarea name=\"sampleOutput\"></textarea></div></div><h3 class=\"ui dividing header\">Permission</h3><div class=\"ui four fields\"><div class=\"ui field\"><label>owner</label><div class=\"ui input\"><input name=\"owner\"/></div></div><div class=\"ui field\"><label>group</label><div class=\"ui input\"><input name=\"group\"/></div></div><div class=\"ui field\"><label>access</label><div class=\"ui input\"><input name=\"access\"/></div></div></div><div class=\"ui field\"><div class=\"ui icon labeled button primary submit\"><i class=\"icon save\"></i>Save</div><div href=\"#/problem/{{pid}}\" class=\"ui icon labeled button secondary\"><i class=\"icon reply\"></i>Back</div><a v-if=\"pid != 0\" href=\"#/problem/{{pid}}/data\" class=\"ui icon labeled button secondary\"><i class=\"icon archive\"></i>Dataset Manage</a></div></div>";

/***/ },
/* 153 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(154)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/problem/show.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(155)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/problem/show.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 154 */
/***/ function(module, exports, __webpack_require__) {

	var co, debug, vue, raiseError, log;
	co = __webpack_require__(142);
	debug = __webpack_require__(29);
	vue = __webpack_require__(1);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:problem:show');
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      problem: {
	        config: {},
	        outlook: {},
	        permit: {}
	      }
	    };
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var pid, response, problem;
	      pid = arg$.to.params.pid;
	      response = (yield vue.http.get("problem/" + pid)).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      problem = response.data;
	      return {
	        problem: problem
	      };
	    })
	  },
	  watch: {
	    'problem.outlook.desc': function(){
	      var this$ = this;
	      return this.$nextTick(function(){
	        return MathJax.Hub.Queue(['Typeset', MathJax.Hub]);
	      });
	    }
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/problem/show.vue.map


/***/ },
/* 155 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui dividing header\">Problem {{problem._id}}. {{problem.outlook.title}}</h1><div :class=\"{loading: $loadingRouteData}\" class=\"ui segment\"><div class=\"ui olive labels\"><div class=\"ui label\">{{problem.config.timeLimit}} s<div class=\"detail\">time limit</div></div><div class=\"ui label\">{{problem.config.spaceLimit}} MB<div class=\"detail\">space limit</div></div><div class=\"ui label\">{{problem.permit.owner}}<div class=\"detail\">owner</div></div><div class=\"ui label\">{{problem.permit.group}}<div class=\"detail\">group</div></div></div><div class=\"ui segment\"><div class=\"ui top left attached label teal\">description</div><p mathjax=\"mathjax\" v-html=\"problem.outlook.description\"></p></div><div class=\"ui two column grid\"><div class=\"row\"><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">input format</div><p v-html=\"problem.outlook.inputFormat\"></p></div></div><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">output format</div><p v-html=\"problem.outlook.outputFormat\"></p></div></div></div><div class=\"row\"><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">sample input</div><pre>{{problem.outlook.sampleInput}}</pre></div></div><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">sample output</div><pre>{{problem.outlook.sampleOutput}}</pre></div></div></div></div></div><div class=\"ui header\"></div><a href=\"#/solution/submit/{{problem._id}}\" class=\"ui icon labeled primary button\"><i class=\"icon rocket\"></i>submit</a><a href=\"#/problem/{{problem._id}}/modify\" class=\"ui icon labeled button\"><i class=\"icon edit\"></i>modify</a><a href=\"#/problem/{{problem._id}}/stat\" class=\"ui icon labeled button\"><i class=\"icon chart bar\"></i>statistics</a>";

/***/ },
/* 156 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(157)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/problem/stat.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(174)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/problem/stat.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 157 */
/***/ function(module, exports, __webpack_require__) {

	var vue, debug, co, ref$, average, map, filter, format, raiseError, log, generateStat;
	vue = __webpack_require__(1);
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	ref$ = __webpack_require__(158), average = ref$.average, map = ref$.map, filter = ref$.filter;
	format = __webpack_require__(164);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:problem:stat');
	generateStat = function(sols){
	  var scores, res$, i$, len$, sol, mean, median, variance, stddev, solved, this$ = this;
	  if (sols.length === 0) {
	    return {
	      solved: 0,
	      mean: 0,
	      median: 0,
	      stddev: 0
	    };
	  }
	  res$ = [];
	  for (i$ = 0, len$ = sols.length; i$ < len$; ++i$) {
	    sol = sols[i$];
	    res$.push(sol.doc.final.score || 0);
	  }
	  scores = res$;
	  mean = average(scores);
	  median = scores[Math.floor(scores.length / 2)];
	  variance = average(map(function(it){
	    return it * it;
	  }, scores)) - mean * mean;
	  stddev = Math.sqrt(variance);
	  solved = function(it){
	    return it.length;
	  }(
	  filter((function(it){
	    return it === 1;
	  }))(
	  scores));
	  return {
	    solved: solved,
	    mean: mean,
	    median: median,
	    stddev: stddev
	  };
	};
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      stat: [],
	      problem: {}
	    };
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var pid, response, ref$, sols, prob, stat;
	      pid = arg$.to.params.pid;
	      response = (yield vue.http.get("problem/" + pid + "/stat")).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      ref$ = response.data, sols = ref$.sols, prob = ref$.prob;
	      stat = generateStat(sols);
	      return {
	        stat: {
	          "accepted users": stat.solved,
	          mean: stat.mean,
	          median: stat.median,
	          "standard deviation": stat.stddev
	        },
	        problem: prob
	      };
	    })
	  },
	  components: {
	    problem: format.problem
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/problem/stat.vue.map


/***/ },
/* 158 */,
/* 159 */,
/* 160 */,
/* 161 */,
/* 162 */,
/* 163 */,
/* 164 */
/***/ function(module, exports, __webpack_require__) {

	var codeLink, problem, round, user;
	codeLink = __webpack_require__(165);
	problem = __webpack_require__(143);
	round = __webpack_require__(168);
	user = __webpack_require__(171);
	module.exports = {
	  codeLink: codeLink,
	  problem: problem,
	  round: round,
	  user: user,
	  formatter: {
	    problem: function(prob){
	      return prob._id + ". " + prob.outlook.title;
	    },
	    round: function(rnd){
	      return rnd._id + ". " + rnd.title;
	    },
	    user: function(user){
	      return user + "";
	    }
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/client/components/format/index.ls.map


/***/ },
/* 165 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(166)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/format/code-link.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(167)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/format/code-link.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 166 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    sid: Number
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/format/code-link.vue.map


/***/ },
/* 167 */
/***/ function(module, exports) {

	module.exports = "<a href=\"#/solution/{{sid}}\" class=\"ui label grey\">{{sid}}</a>";

/***/ },
/* 168 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(169)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/format/round.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(170)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/format/round.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 169 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    rnd: Object
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/format/round.vue.map


/***/ },
/* 170 */
/***/ function(module, exports) {

	module.exports = "<a v-if=\"rnd &amp;&amp; rnd._id &gt; 0\" href=\"#/round/{{rnd._id}}\" class=\"ui label light teal\">{{rnd._id}}. {{rnd.title}}</a><a v-else=\"v-else\" class=\"ui label light teal\">hidden</a>";

/***/ },
/* 171 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(172)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/format/user.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(173)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/format/user.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 172 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    uid: String
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/format/user.vue.map


/***/ },
/* 173 */
/***/ function(module, exports) {

	module.exports = "<a href=\"#/user/{{uid}}\" class=\"ui label\">{{uid}}</a>";

/***/ },
/* 174 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui header dividing\">Statistics for Problem {{problem._id}}</h1><problem :prob=\"problem\"></problem><h3 class=\"ui header dividing\">numbers</h3><div class=\"ui statistics\"><div v-for=\"(key, val) in stat\" class=\"statistic\"><div class=\"value\">{{val}}</div><div class=\"label\">{{key}}</div></div></div>";

/***/ },
/* 175 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(176)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/problem/data.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(177)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/problem/data.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 176 */
/***/ function(module, exports, __webpack_require__) {

	var vue, debug, co, raiseError, log, this$ = this;
	vue = __webpack_require__(1);
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:components:problems:data');
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      problem: {
	        _id: 0,
	        outlook: {
	          title: ""
	        },
	        config: {
	          dataset: []
	        }
	      }
	    };
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var pid, response, problem;
	      pid = arg$.to.params.pid;
	      response = (yield vue.http.get("problem/" + pid)).data;
	      if (response.errors) {
	        this$.raiseError(response);
	        return null;
	      }
	      problem = response.data;
	      return {
	        problem: problem
	      };
	    })
	  },
	  methods: {
	    repair: co.wrap(function*(){
	      var ref$, data;
	      return ref$ = (yield this.$http.get("problem/" + this.problem._id + "/repair")), data = ref$.data, ref$;
	    }),
	    select: function(){
	      return $('#upload').click();
	    },
	    upload: co.wrap(function*(){
	      var files, formData, i$, len$, file, data;
	      files = $('#upload')[0].files;
	      formData = new FormData();
	      for (i$ = 0, len$ = files.length; i$ < len$; ++i$) {
	        file = files[i$];
	        formData.append(file.name, file);
	      }
	      data = (yield this.$http.post("data/" + this.problem._id + "/upload", formData)).data;
	      return this.problem.config.dataset = data.pairs;
	    })
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/problem/data.vue.map


/***/ },
/* 177 */
/***/ function(module, exports) {

	module.exports = "<div id=\"form-data\" class=\"ui form\"><h2 class=\"ui dividing header\">Problem {{problem._id}}. {{problem.outlook.title}}</h2><h3 class=\"ui dividing header\">Dataset Management</h3><input id=\"upload\" type=\"file\" style=\"display:none\" name=\"upload\"/><div class=\"ui field\"><a @click=\"select\" class=\"ui icon button labeled\"><i class=\"icon file\"></i>select</a><a @click=\"upload\" class=\"ui icon button labeled green\"><i class=\"icon upload\"></i>upload</a><a :click=\"refresh\" class=\"ui icon button labeled teal\"><i class=\"icon refresh\"></i>refresh</a><a :click=\"repair\" class=\"ui icon button labeled teal\"><i class=\"icon retweet\"></i>repair</a></div><div class=\"ui two fields\"><div class=\"ui field twelve wide\"><table class=\"ui table segment\"><thead><tr><th>input</th><th>output</th><th>weight</th><th></th></tr></thead><tbody><tr v-for=\"atom in problem.config.dataset\"><td>{{atom.input}}</td><td>{{atom.output}}</td><td>{{atom.weight}}</td><td><a :click=\"remove\" class=\"ui icon labeled button right floated mini\"><i class=\"icon remove\"></i>remove</a></td></tr></tbody></table></div></div></div>";

/***/ },
/* 178 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(179)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/solution/list.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(180)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/solution/list.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 179 */
/***/ function(module, exports, __webpack_require__) {

	var debug, co, vue, format, raiseError, log, this$ = this;
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	vue = __webpack_require__(1);
	format = __webpack_require__(164);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:solution:list');
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      solutions: []
	    };
	  },
	  route: {
	    data: co.wrap(function*(){
	      var response, solutions;
	      response = (yield vue.http.get('solution')).data;
	      if (response.errors) {
	        this$.raiseError(response);
	        return null;
	      }
	      solutions = response.data;
	      return {
	        solutions: solutions
	      };
	    })
	  },
	  components: format
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/solution/list.vue.map


/***/ },
/* 180 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui dividing header\">Status</h1><div :class=\"{loading: false}\" class=\"ui segment\"><table class=\"ui table large green selectable very basic\"><thead><tr><th class=\"collapsing right\">sol id</th><th>problem</th><th>user</th><th>status</th><th>score</th><th>time(s)</th><th>space(MB)</th><th class=\"collapsing\">lang</th><th class=\"collapsing\">round</th></tr></thead><tbody><tr v-for=\"sol in solutions\" class=\"red\"><td><code-link :sid=\"sol._id\"></code-link></td><td><problem :prob=\"sol.prob\"></problem></td><td><user :uid=\"sol.user\"></user></td><td>{{sol.final.status}}</td><td>{{sol.final.score}}</td><td>{{sol.final.time}}</td><td>{{sol.final.space}}</td><td>{{sol.lang}}</td><td v-if=\"sol.round\"><round :rnd=\"sol.round\"></round></td><td v-else=\"v-else\"></td></tr></tbody></table></div><div class=\"ui icon labeled button floated right primary\"><i class=\"icon refresh\"></i>refresh</div>";

/***/ },
/* 181 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(182)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/solution/submit.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(183)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/solution/submit.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 182 */
/***/ function(module, exports, __webpack_require__) {

	var debug, co, ref$, pairsToObj, objToPairs, flatten, log, this$ = this;
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	ref$ = __webpack_require__(158), pairsToObj = ref$.pairsToObj, objToPairs = ref$.objToPairs, flatten = ref$.flatten;
	log = debug('dollast:components:solution:submit');
	module.exports = {
	  vuex: {
	    getters: {
	      uid: function(it){
	        return it.session.uid;
	      }
	    }
	  },
	  data: function(){
	    return {
	      pid: parseInt(this.$route.params.pid),
	      languages: ['cpp', 'java', 'pas']
	    };
	  },
	  computed: {
	    permit: function(){
	      return {
	        owner: this.uid,
	        group: 'solutions',
	        access: 'rwxrw-r--'
	      };
	    }
	  },
	  ready: function(){
	    var submit, $form, this$ = this;
	    $('.dropdown').dropdown();
	    submit = co.wrap(function*(e){
	      var $form, allValues, permit, data, response, errors, i$, ref$, len$, error;
	      $form = $('#submit-form');
	      allValues = $form.form('get values');
	      permit = {
	        owner: allValues.owner,
	        group: allValues.group,
	        access: allValues.access
	      };
	      data = Object.assign({
	        code: allValues.code,
	        language: allValues.language
	      }, {
	        pid: this$.pid,
	        permit: permit
	      });
	      response = (yield this$.$http.post('solution/submit', data)).data;
	      if (response.errors) {
	        errors = {};
	        for (i$ = 0, len$ = (ref$ = response.errors).length; i$ < len$; ++i$) {
	          error = ref$[i$];
	          Object.assign(errors, error);
	        }
	        return $form.form('add errors', errors);
	      }
	    });
	    $form = $('#submit-form');
	    $form.form({
	      on: 'blur',
	      debug: true,
	      fields: {
	        code: {
	          identifier: 'code',
	          rules: [
	            {
	              type: 'minLength[4]',
	              prompt: 'code minimum length is 4'
	            }, {
	              type: 'maxLength[65535]',
	              prompt: 'code length cannot exceed 65535'
	            }
	          ]
	        },
	        lang: {
	          identifier: 'language',
	          rules: [{
	            type: 'empty',
	            prompt: 'language cannot be empty'
	          }]
	        },
	        owner: {
	          identifier: 'owner',
	          rules: [{
	            type: 'isUserId',
	            prompt: 'wrong user id'
	          }]
	        },
	        group: {
	          identifier: 'group',
	          rules: [{
	            type: 'isUserId',
	            prompt: 'wrong group id'
	          }]
	        },
	        access: {
	          identifier: 'access',
	          rules: [{
	            type: 'isAccess',
	            prompt: 'wrong access code'
	          }]
	        }
	      },
	      onSuccess: submit,
	      inline: true
	    });
	    return $form.form('set values', this.permit);
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/solution/submit.vue.map


/***/ },
/* 183 */
/***/ function(module, exports) {

	module.exports = "<div id=\"submit-form\" class=\"ui form segment\"><h1 class=\"ui header dividing\">problem: {{pid}}</h1><div class=\"ui success message\"><div class=\"header\">Submit successful. Redirect to status in 3 seconds...</div></div><div class=\"ui field\"><label>code</label><textarea name=\"code\"></textarea></div><div class=\"ui two fields\"><div class=\"ui field\"><label>language</label><div class=\"ui dropdown icon selection\"><input type=\"hidden\" name=\"language\"/><div class=\"default text\">select your language</div><i class=\"dropdown icon\"></i><div class=\"menu\"><div v-for=\"item in languages\" data-value=\"{{item}}\" class=\"item\">{{item}}</div></div></div></div></div><h2 class=\"ui dividing header\">permission</h2><div class=\"ui four fields\"><div class=\"ui field\"><label>owner</label><div class=\"ui input\"><input name=\"owner\"/></div></div><div class=\"ui field\"><label>group</label><div class=\"ui input\"><input name=\"group\"/></div></div><div class=\"ui field\"><label>access</label><div class=\"ui input\"><input name=\"access\"/></div></div></div><div class=\"ui field\"><a class=\"ui button primary floated submit\">Submit</a></div></div>";

/***/ },
/* 184 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(185)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/solution/show.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(186)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/solution/show.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 185 */
/***/ function(module, exports, __webpack_require__) {

	var debug, co, vue, raiseError, log;
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	vue = __webpack_require__(1);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:solution:show');
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      sol: {
	        final: {},
	        results: [],
	        prob: {
	          _id: 0
	        },
	        permit: {
	          owner: "",
	          group: ""
	        }
	      }
	    };
	  },
	  computed: {
	    pid: function(){
	      return this.sol.prob._id;
	    }
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var sid, response, solution;
	      sid = arg$.to.params.sid;
	      response = (yield vue.http.get("solution/" + sid)).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      solution = response.data;
	      return {
	        sol: solution
	      };
	    })
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/solution/show.vue.map


/***/ },
/* 186 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui header dividing\">Solution {{$route.params.sid}}</h1><div class=\"ui olive labels\"><div class=\"ui label\">{{sol.permit.owner}}<div class=\"detail\">owner</div></div><div class=\"ui label\">{{sol.permit.group}}<div class=\"detail\">group</div></div><div class=\"ui label\">{{sol.lang}}<div class=\"detail\">language</div></div><div class=\"ui label\">{{sol.prob._id}}<div class=\"detail\">problem</div></div></div><h2 class=\"ui header dividing\">code</h2><div class=\"ui segment\"><div class=\"ui top attached label\">code</div><pre>{{sol.code}}</pre></div><p v-if=\"sol.final.status == 'private'\">this code is private</p><div v-if=\"sol.final.status == 'CE'\" class=\"ui segment\"><div class=\"ui top attached label\">Error message</div><pre>{{sol.final.message}}</pre></div><div v-if=\"sol.final.status == 'running'\" class=\"ui\">running</div><div v-if=\"sol.final.status == 'finished'\"><div class=\"ui\"><h1 class=\"ui header dividing\">details</h1><table class=\"ui table segment\"><thead><tr><th>input</th><th>status</th><th>time</th><th>space</th><th>score</th><th>message</th></tr></thead><tbody><tr v-for=\"result in sol.results\" class=\"positive\"><td>{{result.input}}</td><td>{{result.status}}</td><td>{{result.time}}</td><td>{{result.space}}</td><td>{{result.score}}</td><td>{{result.message}}</td></tr></tbody><tfoot><tr><th>final result</th><th>{{sol.final.status}}</th><th>{{sol.final.time}}</th><th>{{sol.final.space}}</th><th>{{sol.final.score}}</th><th>{{sol.final.message}}</th></tr></tfoot></table></div></div>";

/***/ },
/* 187 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(188)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/round/list.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(189)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/round/list.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 188 */
/***/ function(module, exports, __webpack_require__) {

	var vue, debug, co, format, raiseError, log;
	vue = __webpack_require__(1);
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	format = __webpack_require__(164);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:round:list');
	module.exports = {
	  components: {
	    round: format.round
	  },
	  data: function(){
	    return {
	      options: {
	        'all': 'all',
	        'past': 'past',
	        'running': 'running',
	        'pending': 'pending'
	      },
	      rounds: []
	    };
	  },
	  route: {
	    data: co.wrap(function*(){
	      var response, rounds;
	      response = (yield vue.http.get("round")).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      rounds = response.data;
	      return {
	        rounds: rounds
	      };
	    })
	  },
	  ready: function(){
	    var $filter;
	    $filter = $('.dropdown');
	    $filter.dropdown({
	      on: 'hover',
	      onChange: function(value, text, $choice){
	        return log({
	          value: value,
	          text: text,
	          $choice: $choice
	        });
	      }
	    });
	    return $filter.dropdown('set text', 'all');
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/round/list.vue.map


/***/ },
/* 189 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui header dividing\">Rounds</h1><div class=\"ui dropdown floated pointing button labeled icon\"><input type=\"hidden\" name=\"filter\"/><div class=\"default text\">please select filter</div><i class=\"dropdown icon\"></i><div class=\"menu\"><div v-for=\"item in options\" data-value=\"{{item}}\" class=\"item\">{{item}}</div></div></div><a href=\"#/round/create\" class=\"ui icon labeled button launch primary right floated\"><i class=\"icon plus\"></i>create</a><div :class=\"{loading: $loadingRouteData}\" class=\"ui segment\"><div class=\"ui very relxed divided link list\"><div v-for=\"round in rounds\" class=\"item\"><div class=\"ui right floated\">{{round.beginTime, round.endTime}}</div><div class=\"description\"><round :rnd=\"round\"></round></div></div></div></div>";

/***/ },
/* 190 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(191)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/round/modify.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(192)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/round/modify.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 191 */
/***/ function(module, exports, __webpack_require__) {

	var vue, co, moment, debug, ref$, map, pairsToObj, objToPairs, flatten, formatter, raiseError, log, getFormValues, setFormValues, this$ = this;
	vue = __webpack_require__(1);
	co = __webpack_require__(142);
	moment = __webpack_require__(32);
	debug = __webpack_require__(29);
	ref$ = __webpack_require__(158), map = ref$.map, pairsToObj = ref$.pairsToObj, objToPairs = ref$.objToPairs, flatten = ref$.flatten;
	formatter = __webpack_require__(164).formatter;
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:round:modify');
	getFormValues = function(){
	  var $form, values, permit, probs, data;
	  $form = $('#form-round');
	  values = $form.form('get values');
	  permit = {
	    owner: values.owner,
	    group: values.group,
	    access: values.access
	  };
	  probs = map(parseInt, values.probs.split(','));
	  return data = Object.assign({
	    title: values.title,
	    beginTime: values.beginTime,
	    endTime: values.endTime
	  }, {
	    probs: probs,
	    permit: permit
	  });
	};
	setFormValues = function(round){
	  var $form, title, begTime, endTime, permit, probs;
	  $form = $('#form-round');
	  title = round.title, begTime = round.begTime, endTime = round.endTime, permit = round.permit, probs = round.probs;
	  probs = map(function(it){
	    return it._id + "";
	  }, probs);
	  $form.form('set values', {
	    title: title,
	    beginTime: beginTime ? moment(beginTime).format('YYYY-MM-DD HH:mm:ss') : void 8,
	    endTime: endTime ? moment(endTime).format('YYYY-MM-DD HH:mm:ss') : void 8,
	    probs: problems
	  });
	  return $form.form('set values', permit);
	};
	module.exports = {
	  data: function(){
	    return {
	      rid: 0,
	      rnd: {
	        _id: void 8,
	        problems: []
	      }
	    };
	  },
	  computed: {
	    dropdownProblems: function(){
	      var i$, ref$, len$, x, resultObj$ = {};
	      for (i$ = 0, len$ = (ref$ = this.rnd.problems).length; i$ < len$; ++i$) {
	        x = ref$[i$];
	        resultObj$[x._id] = formatter.problem(x);
	      }
	      return resultObj$;
	    },
	    formattedTitle: function(){
	      if (this.rnd._id === void 8) {
	        return "Create new Round";
	      } else {
	        return "Round " + this.rnd._id + ". " + this.rnd.title;
	      }
	    }
	  },
	  vuex: {
	    getters: {
	      uid: function(it){
	        return it.session.uid;
	      }
	    },
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  ready: function(){
	    var $dropdown, submit, $form, this$ = this;
	    $dropdown = $('.ui.selection.dropdown');
	    $dropdown.dropdown({
	      dataType: 'jsonp',
	      apiSettings: {
	        onResponse: function(response){
	          var title, id;
	          if (!response.outlook) {
	            return {
	              results: []
	            };
	          }
	          title = response.outlook.title;
	          id = response._id;
	          return {
	            results: [{
	              value: id,
	              name: formatter.problem(response)
	            }]
	          };
	        },
	        url: "/api/problem/{query}",
	        onChange: function(value){
	          return log({
	            value: value
	          });
	        }
	      }
	    });
	    submit = co.wrap(function*(e){
	      var data, response;
	      e.preventDefault();
	      data = getFormValues();
	      response = (yield vue.http.post("round/" + this$.rid, data)).data;
	      if (response.errors) {
	        return log({
	          errors: response.errors
	        });
	      }
	    });
	    $form = $('#form-round');
	    $form.form({
	      on: 'blur',
	      inline: true,
	      onSuccess: submit,
	      fields: {
	        title: {
	          identifier: 'title',
	          rules: [
	            {
	              type: 'minLength[4]',
	              prompt: 'title has minimum length of 4'
	            }, {
	              type: 'maxLength[63]',
	              prompt: 'title has maximum length of 63'
	            }
	          ]
	        },
	        begTime: {
	          identifier: 'beginTime',
	          rules: [{
	            type: 'isTime',
	            prompt: 'start time should be valid'
	          }]
	        },
	        endTime: {
	          identifier: 'endTime',
	          rules: [{
	            type: 'isTime',
	            prompt: 'start time should be valid'
	          }]
	        },
	        owner: {
	          identifier: 'owner',
	          rules: [{
	            type: 'isUserId',
	            prompt: 'owner should be valid'
	          }]
	        },
	        group: {
	          identifier: 'group',
	          rules: [{
	            type: 'isUserId',
	            prompt: 'group should be valid'
	          }]
	        },
	        access: {
	          identifier: 'access',
	          rules: [{
	            type: 'isAccess',
	            prompt: 'access code should be /^[0-7]{3}$/'
	          }]
	        }
	      }
	    });
	    if (this.rnd._id === void 8) {
	      this.rnd.permit = {
	        owner: this.uid,
	        group: 'rounds',
	        access: 'rwxr--r--'
	      };
	      return setFormValues(this.rnd);
	    }
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var rid, response, round;
	      rid = arg$.to.params.rid;
	      if (rid !== void 8) {
	        response = (yield vue.http.get("round/" + rid)).data;
	        if (response.errors) {
	          this.raiseError(response);
	          return null;
	        }
	        round = response.data;
	        return {
	          rid: rid,
	          rnd: round
	        };
	      }
	    })
	  },
	  watch: {
	    'rnd._id': function(){
	      var this$ = this;
	      return this.$nextTick(function(){
	        $('.ui.selection.dropdown').dropdown('refresh');
	        return setFormValues(this$.rnd);
	      });
	    }
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/round/modify.vue.map


/***/ },
/* 192 */
/***/ function(module, exports) {

	module.exports = "<div id=\"form-round\" class=\"ui form\"><h2 class=\"ui dividing header\">{{formattedTitle}}</h2><div class=\"ui success message\"><div class=\"header\">Changes saved.</div></div><h3 class=\"ui dividing header\">Configuration</h3><div class=\"ui fields three\"><div class=\"ui field\"><label>title</label><div class=\"ui input\"><input name=\"title\"/></div></div><div class=\"ui field\"><label>start from</label><div class=\"ui input\"><input name=\"beginTime\" placeholder=\"YYYY-MM-DD HH:mm:ss\"/></div></div><div class=\"ui field\"><label>end at</label><div class=\"ui input\"><input name=\"endTime\" placeholder=\"YYYY-MM-DD HH:mm:ss\"/></div></div></div><h3 class=\"ui dividing header\">Permission</h3><div class=\"ui four fields\"><div class=\"ui field\"><label>owner</label><div class=\"ui input\"><input name=\"owner\"/></div></div><div class=\"ui field\"><label>group</label><div class=\"ui input\"><input name=\"group\"/></div></div><div class=\"ui field\"><label>access</label><div class=\"ui input\"><input name=\"access\"/></div></div></div><h3 class=\"ui dividing header\">Problemset</h3><div class=\"ui field\"><div class=\"ui dropdown icon selection fluid multiple search\"><input type=\"hidden\" name=\"problems\"/><div class=\"default text\">problems</div><i class=\"dropdown icon\"></i><div class=\"menu\"><div v-for=\"(key, value) of dropdownProblems\" data-value=\"{{key}}\" class=\"item\">{{value}}</div></div></div></div><br/><div class=\"ui field\"><a :click=\"delete\" class=\"icon ui labeled button floated red\"><i class=\"icon delete\"></i>delete</a><a class=\"icon ui labeled button floated secondary\"><i class=\"icon cancel\"></i>undo</a><a class=\"icon ui labeled button floated primary submit\"><i class=\"icon save\"></i>save</a></div></div>";

/***/ },
/* 193 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(194)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/round/show.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(195)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/round/show.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 194 */
/***/ function(module, exports, __webpack_require__) {

	var vue, co, debug, moment, format, raiseError, log;
	vue = __webpack_require__(1);
	co = __webpack_require__(142);
	debug = __webpack_require__(29);
	moment = __webpack_require__(32);
	format = __webpack_require__(164);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:component:round:show');
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  components: {
	    problem: format.problem
	  },
	  data: function(){
	    return {
	      rnd: {
	        begTime: 0,
	        endTime: 0,
	        _id: 0,
	        problems: [],
	        permit: {
	          owner: "",
	          group: ""
	        }
	      }
	    };
	  },
	  computed: {
	    started: function(){
	      return moment().isAfter(this.rnd.begTime);
	    }
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var rid, response, round;
	      rid = arg$.to.params.rid;
	      response = (yield vue.http.get("round/" + rid)).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      round = response.data;
	      return {
	        rnd: round
	      };
	    })
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/round/show.vue.map


/***/ },
/* 195 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui dividing header\">Round {{rnd._id}}. {{rnd.title}}</h1><div class=\"ui olive labels\"><div class=\"ui label\">{{rnd.permit.owner}}<div class=\"detail\">owner</div></div><div class=\"ui label\">{{rnd.permit.group}}<div class=\"detail\">group</div></div></div><p>{{rnd.beginTime}} -- {{rnd.endTime}}</p><br/><div v-if=\"started\"><h2 class=\"ui dividing header\">Problemset</h2><div :class=\"{loading: $loadingRouteData}\" class=\"ui segment\"><div class=\"ui relaxed divided link list\"><div v-for=\"prob in rnd.probs\" class=\"item\"><div class=\"ui right floated\">??</div><div class=\"description\"><problem :prob=\"prob\"></problem></div></div></div></div><br/></div><div v-else=\"v-else\"><p>Sorry, this round has not started.</p></div><a v-if=\"started\" href=\"#/round/{{rnd._id}}/board\" class=\"ui labeled button purple\"><i class=\"icon trophy\"></i>board</a><a href=\"#/round/{{rnd._id}}/modify\" class=\"ui labeled button orange\"><i class=\"icon edit\"></i>modify</a>";

/***/ },
/* 196 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(197)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/round/board.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(198)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/round/board.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 197 */
/***/ function(module, exports, __webpack_require__) {

	var debug, vue, co, format, ref$, objToPairs, sort, reverse, log, generateBoard;
	debug = __webpack_require__(29);
	vue = __webpack_require__(1);
	co = __webpack_require__(142);
	format = __webpack_require__(164);
	ref$ = __webpack_require__(158), objToPairs = ref$.objToPairs, sort = ref$.sort, reverse = ref$.reverse;
	log = debug('dollast:component:round:board');
	generateBoard = function(solutions){
	  var board, i$, len$, sol, ref$, user, prob;
	  board = {};
	  for (i$ = 0, len$ = solutions.length; i$ < len$; ++i$) {
	    sol = solutions[i$];
	    ref$ = sol._id, user = ref$.user, prob = ref$.prob;
	    board[user] || (board[user] = {
	      total: 0
	    });
	    board[user][prob] = {
	      score: sol.score,
	      sid: sol.sid
	    };
	    board[user].total += sol.score;
	  }
	  return board;
	};
	module.exports = {
	  components: {
	    problem: format.problem,
	    codeLink: format.codeLink,
	    user: format.user
	  },
	  data: function(){
	    return {
	      board: []
	    };
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var rid, response, round, solutions, board;
	      rid = arg$.to.params.rid;
	      response = (yield vue.http.get("round/" + rid)).data;
	      if (reseponse.errors) {
	        this.raiseError(reseponse);
	        return null;
	      }
	      round = reseponse.data;
	      response = (yield vue.http.get("round/" + rid + "/board")).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      solutions = response.data;
	      board = reverse(
	      sort(
	      objToPairs(
	      generateBoard(solutions))));
	      return {
	        board: board
	      };
	    })
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/round/board.vue.map


/***/ },
/* 198 */
/***/ function(module, exports) {

	module.exports = "<table class=\"ui table segment large green selectable\"><thead><tr><th>user</th><th>total</th><th v-for=\"problem in problems\"><problem :prob=\"problem\"></problem></th></tr></thead><tbody><tr v-for=\"[user, score] in board\"><td><user :uid=\"user\"></user></td><td>{{score.total}}</td><td v-for=\"problem in problems\"><code-link :sid=\"score[pid].sid\"></code-link></td></tr></tbody></table>";

/***/ },
/* 199 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(200)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/user/profile.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(201)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/user/profile.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 200 */
/***/ function(module, exports, __webpack_require__) {

	var vue, co, debug, format, raiseError, log;
	vue = __webpack_require__(1);
	co = __webpack_require__(142);
	debug = __webpack_require__(29);
	format = __webpack_require__(164);
	raiseError = __webpack_require__(146).raiseError;
	log = debug('dollast:components:user:profile');
	module.exports = {
	  vuex: {
	    actions: {
	      raiseError: raiseError
	    }
	  },
	  data: function(){
	    return {
	      uid: this.$route.params.uid,
	      profile: {},
	      solvedProblems: [],
	      ownedProblems: [],
	      ownedRounds: []
	    };
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var uid, response, profile;
	      uid = arg$.to.params.uid;
	      response = (yield vue.http.get("user/" + uid)).data;
	      if (response.errors) {
	        this.raiseError(response);
	        return null;
	      }
	      profile = data.data;
	      return profile;
	    })
	  },
	  components: {
	    problem: format.problem,
	    round: format.round
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/user/profile.vue.map


/***/ },
/* 201 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui dividing header\">Details of {{uid}}</h1><div class=\"ui segment\"><div class=\"ui top attached label large\">registered since</div><p>unimplemented</p></div><div class=\"ui segment\"><div class=\"ui large top attached label\">description</div><p>{{profile.desc}}</p></div><div class=\"ui segment\"><div class=\"ui top attached label large\">Groups</div><div v-for=\"group in profile.groups\" class=\"ui olive label\">{{group}}</div></div><div class=\"ui segment\"><div class=\"ui top attached label large\">Problems solved</div><div class=\"ui relaxed divided link list\"><div v-for=\"prob in solveProblems\" class=\"item\"><div class=\"description\"><problem :prob=\"prob\"></problem></div></div></div></div><div class=\"ui segment\"><div class=\"ui top attached label large\">Problems owned</div><div class=\"ui relaxed divided link list\"><div v-for=\"prob in ownedProblems\" class=\"item\"><div class=\"description\"><problem :prob=\"prob\"></problem></div></div></div></div><div class=\"ui segment\"><div class=\"ui top attached label large\">Rounds owned</div><div class=\"ui relaxed divided link list\"><div v-for=\"rnd in ownedRounds\" class=\"item\"><div class=\"ui right floated\">{{rnd.begTime}} {{rnd.endTime}}</div><div class=\"description\"><round :rnd=\"rnd\"></round></div></div></div></div><a href=\"#/user/{{uid}}/modify\" class=\"ui button icon labeled text primary\"><i class=\"icon edit\"></i>modify</a>";

/***/ },
/* 202 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(203)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/user/login.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(204)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/user/login.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 203 */
/***/ function(module, exports, __webpack_require__) {

	var debug, login, log;
	debug = __webpack_require__(29);
	login = __webpack_require__(146).login;
	log = debug('dollast:component:login');
	module.exports = {
	  vuex: {
	    actions: {
	      login: login
	    }
	  },
	  data: function(){
	    return {
	      success: false,
	      loading: false
	    };
	  },
	  ready: function(){
	    var $form, submit, this$ = this;
	    $form = $('#login-form');
	    submit = co.wrap(function*(e){
	      var $form, values, data;
	      e.preventDefault();
	      $form = $('#login-form');
	      values = $form.form('get values');
	      data = (yield vue.http.post('/site/login', values)).data;
	      localStorage.token = data.payload.token;
	      this$.login(data.payload.token);
	      return this$.success = true;
	    });
	    return $form.form({
	      on: 'blur',
	      inline: true,
	      fields: {
	        uid: {
	          identifier: 'uid',
	          rules: [
	            {
	              type: 'minLength[6]',
	              prompt: "User name must be longer than 5"
	            }, {
	              type: 'maxLength[16]',
	              prompt: "User name must be shorter than 15"
	            }
	          ]
	        },
	        pswd: {
	          identifier: 'pswd',
	          rules: [
	            {
	              type: 'minLength[6]',
	              prompt: 'password length must be longer than 5'
	            }, {
	              type: 'maxLength[16]',
	              prompt: 'password length must be shorter than 15'
	            }
	          ]
	        }
	      },
	      onSuccess: submit,
	      debug: true
	    });
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/user/login.vue.map


/***/ },
/* 204 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui\"><h1 class=\"ui dividing header\">Login</h1><form id=\"login-form\" :class=\"{loading: loading, success: success}\" class=\"ui form segment\"><div class=\"ui error message\"></div><div class=\"ui success message\"><div class=\"header\">Login successfully. Redirect to problem list in 3 seconds.</div></div><div class=\"ui field\"><div class=\"ui icon input left\"><i class=\"icon user\"></i><input name=\"uid\" placeholder=\"user id\"/></div></div><div class=\"ui field\"><div class=\"ui icon input left\"><i class=\"icon lock\"></i><input name=\"pswd\" placeholder=\"password\" type=\"password\"/></div></div><div class=\"ui icon labeled button left primary submit\"><i class=\"icon sign in\"></i>Login</div></form></div>";

/***/ },
/* 205 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(206)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/user/register.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(207)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/user/register.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 206 */
/***/ function(module, exports, __webpack_require__) {

	var debug, co, log;
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	log = debug('dollast:component:login');
	module.exports = {
	  ready: function(){
	    var submit, this$ = this;
	    submit = co.wrap(function*(e){
	      var $form, allValues;
	      e.preventDefault();
	      $form = $('#register-form');
	      allValues = $form.form('get values');
	      return (yield this$.$http.post('user/register', allValues));
	    });
	    return $('#register-form').form({
	      on: 'blur',
	      fields: {
	        uid: {
	          identifier: 'uid',
	          rules: [
	            {
	              type: 'minLength[3]',
	              prompt: "User name must be longer than 5"
	            }, {
	              type: 'maxLength[16]',
	              prompt: "User name must be shorter than 15"
	            }
	          ]
	        },
	        pswd: {
	          identifier: 'pswd',
	          rules: [{
	            type: 'isPassword',
	            prompt: 'password length must be longer than 5'
	          }]
	        },
	        email: {
	          identifier: 'email',
	          rules: [{
	            type: 'email',
	            prompt: 'please enter a valid email address'
	          }]
	        }
	      },
	      onSuccess: submit,
	      debug: true
	    });
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/user/register.vue.map


/***/ },
/* 207 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui dividing header\">Register</h1><form id=\"register-form\" class=\"ui form segment\"><div class=\"ui error message\"></div><div class=\"ui success message\"><h2>Register successful. Login please.</h2></div><div class=\"ui field\"><a class=\"ui input icon left\"><i class=\"icon user\"></i><input placeholder=\"user id\" name=\"uid\"/></a></div><div class=\"ui field\"><a class=\"ui input icon left\"><i class=\"icon lock\"></i><input placeholder=\"password\" name=\"pswd\" type=\"password\"/></a></div><div class=\"ui field\"><a class=\"ui input icon left\"><i class=\"icon mail\"></i><input placeholder=\"abc@xyz\" name=\"email\" type=\"email\"/></a></div><a class=\"ui icon labeled button left primary submit\"><i class=\"icon sign in\"></i>Register</a></form>";

/***/ },
/* 208 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(209)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/user/modify.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(210)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/user/modify.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 209 */
/***/ function(module, exports, __webpack_require__) {

	var co, vue, debug, log;
	co = __webpack_require__(142);
	vue = __webpack_require__(1);
	debug = __webpack_require__(29);
	log = debug('dollast:components:user:modify');
	module.exports = {
	  data: function(){
	    return {
	      groups: ['problems', 'solutions', 'admin', 'rounds'],
	      user: {
	        profile: {
	          _id: "",
	          groups: []
	        }
	      }
	    };
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var uid, user;
	      uid = arg$.to.params.uid;
	      user = (yield vue.http.get("user/" + uid)).data;
	      return {
	        user: user
	      };
	    })
	  },
	  ready: function(){
	    var $dropdown, submit, $form, this$ = this;
	    $dropdown = $('.ui.dropdown');
	    $dropdown.dropdown({
	      allowAdditions: true
	    });
	    submit = co.wrap(function*(e){
	      var $form, ref$, groups, oldPassword, newPassword, confirmPassword, desc, _id, updated, response;
	      e.preventDefault();
	      $form = $('#form-user');
	      ref$ = $form.form('get values'), groups = ref$.groups, oldPassword = ref$.oldPassword, newPassword = ref$.newPassword, confirmPassword = ref$.confirmPassword, desc = ref$.desc;
	      groups = groups.split(',');
	      _id = this$.user.profile._id;
	      if (oldPassword === "" || newPassword === "") {
	        updated = {
	          _id: _id,
	          groups: groups,
	          desc: desc
	        };
	      } else {
	        updated = {
	          _id: _id,
	          groups: groups,
	          desc: desc,
	          oldPassword: oldPassword,
	          newPassword: newPassword
	        };
	      }
	      return response = (yield vue.http.post("user/" + _id, updated));
	    });
	    $form = $('#form-user');
	    return $form.form({
	      onSuccess: submit,
	      on: 'blur',
	      inline: true,
	      fields: {
	        oldPassword: {
	          identifier: 'oldPassword',
	          optional: true,
	          rules: [{
	            type: 'isPassword',
	            prompt: "must be password"
	          }]
	        },
	        newPassword: {
	          identifier: 'newPassword',
	          optional: true,
	          rules: [{
	            type: 'isPassword',
	            prompt: "must be password"
	          }]
	        },
	        confirmation: {
	          identifier: 'confirmPassword',
	          optional: true,
	          rules: [
	            {
	              type: 'isPassword',
	              prompt: "must be password"
	            }, {
	              type: "match[newPassword]",
	              prompt: "password must match"
	            }
	          ]
	        }
	      }
	    });
	  },
	  watch: {
	    'user.profile._id': function(){
	      var $form, this$ = this;
	      $form = $('#form-user');
	      return this.$nextTick(function(){
	        return $form.form('set values', {
	          groups: this$.user.profile.groups,
	          desc: this$.user.profile.desc
	        });
	      });
	    }
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/user/modify.vue.map


/***/ },
/* 210 */
/***/ function(module, exports) {

	module.exports = "<div id=\"form-user\" class=\"ui form\"><h2 class=\"ui dividing header\">{{user.profile._id}}</h2><div class=\"ui success message\"><div class=\"header\">Changes saved.</div></div><div class=\"ui field\"><label>groups</label><div class=\"ui dropdown icon selection search multiple\"><input type=\"hidden\" name=\"groups\"/><div class=\"default text\">select proper access</div><i class=\"dropdown icon\"></i><div class=\"menu\"><div v-for=\"item in groups\" data-value=\"{{item}}\" class=\"item\">{{item}}</div></div></div></div><h3 class=\"ui dividing header\">Description</h3><div class=\"ui two fields\"><div class=\"ui field\"><label>describe yourself</label><textarea name=\"desc\"></textarea></div></div><h3 class=\"ui dividing header\">Password</h3><div class=\"four fields wide\"><div class=\"ui field\"><label>old password</label><div class=\"ui icon input left\"><i class=\"icon lock\"></i><input placeholder=\"old password\" name=\"oldPassword\" type=\"password\"/></div></div></div><div class=\"four fields wide\"><div class=\"ui field\"><label>new password</label><div class=\"ui icon input left\"><i class=\"icon lock\"></i><input placeholder=\"new  password\" name=\"newPassword\" type=\"password\"/></div></div></div><div class=\"four fields wide\"><div class=\"ui field\"><label>confirm new password</label><div class=\"ui icon input left\"><i class=\"icon lock\"></i><input placeholder=\"confirmation\" name=\"confirmPassword\" type=\"password\"/></div></div></div><a class=\"ui icon labeled button submit primary\"><i class=\"icon save\"></i>submit</a></div>";

/***/ },
/* 211 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(212)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/app.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(221)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/app.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 212 */
/***/ function(module, exports, __webpack_require__) {

	var vue, vueRouter, foot, navbar, error, login;
	vue = __webpack_require__(1);
	vueRouter = __webpack_require__(4);
	foot = __webpack_require__(213);
	navbar = __webpack_require__(215);
	error = __webpack_require__(218);
	login = __webpack_require__(146).login;
	module.exports = {
	  vuex: {
	    actions: {
	      login: login
	    }
	  },
	  components: {
	    navbar: navbar,
	    foot: foot,
	    error: error
	  },
	  ready: function(){
	    return this.login();
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/app.vue.map


/***/ },
/* 213 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_template__ = __webpack_require__(214)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/site/foot.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 214 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui divider horizontal\">Yuping Luo @ 2016</div>";

/***/ },
/* 215 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(216)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/site/navbar.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(217)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/site/navbar.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 216 */
/***/ function(module, exports, __webpack_require__) {

	var debug, logout, log, this$ = this;
	debug = __webpack_require__(29);
	logout = __webpack_require__(146).logout;
	log = debug('dollast:navbar');
	module.exports = {
	  vuex: {
	    getters: {
	      uid: function(it){
	        return it.session.uid;
	      }
	    },
	    actions: {
	      logout: logout
	    }
	  },
	  methods: {
	    logout: function(){
	      return this.logout();
	    }
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/site/navbar.vue.map


/***/ },
/* 217 */
/***/ function(module, exports) {

	module.exports = "<div class=\"row\"><div class=\"ui blue inverted page grid borderless menu\"><div class=\"header item\">dollast</div><a href=\"#/\" class=\"item labeled\"><i class=\"icon home\"></i>Home</a><a href=\"#/problem\" class=\"item labeled\"><i class=\"icon browser\"></i>Problem</a><a href=\"#/solution\" class=\"item labeled\"><i class=\"icon info circle\"></i>Status</a><a href=\"#/round\" class=\"item labeled\"><i class=\"icon users\"></i>Contest</a><div class=\"right menu\"><div class=\"item\"><div class=\"ui input icon inverted small\"><i class=\"icon search link\"></i><input placeholder=\"ID or Search\"/></div></div><a v-if=\"uid != undefined\" href=\"#/user/{{uid}}\" class=\"item labeled\"><i class=\"icon user\"></i>{{uid}}</a><a v-else=\"v-else\" href=\"#/user/login\" class=\"item labeled\"><i class=\"icon sign in\"></i>Sign in</a><a v-if=\"uid != undefined\" @click=\"logout\" class=\"item labeled\"><i class=\"icon sign out\"></i>Logout</a><a v-else=\"v-else\" href=\"#/user/register\" class=\"item labeled\"><i class=\"icon signup\"></i>Register</a></div></div></div>";

/***/ },
/* 218 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(219)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] client/components/site/error.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(220)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/roosephu/Desktop/dollast/client/components/site/error.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 219 */
/***/ function(module, exports, __webpack_require__) {

	var vue, debug, co, resolveError, log, this$ = this;
	vue = __webpack_require__(1);
	debug = __webpack_require__(29);
	co = __webpack_require__(142);
	resolveError = __webpack_require__(146).resolveError;
	log = debug('dollast:error');
	module.exports = {
	  vuex: {
	    getters: {
	      error: function(it){
	        return it.error;
	      }
	    },
	    actions: {
	      resolveError: resolveError
	    }
	  },
	  computed: {
	    message: function(){
	      if (this.error === void 8) {
	        return "";
	      } else {
	        return this.error.detail + "";
	      }
	    },
	    object: function(){
	      if (this.error === void 8) {
	        return "";
	      } else {
	        return this.error.type + " " + this.error.id;
	      }
	    }
	  },
	  ready: function(){
	    var $modal;
	    $modal = $('.modal');
	    return $modal.modal('setting', 'closable', false);
	  },
	  methods: {
	    back: function(){
	      this.resolveError();
	      return this.$route.router.go(window.history.back());
	    },
	    home: function(){
	      this.resolveError();
	      return this.$route.router.go('/');
	    }
	  },
	  watch: {
	    error: function(val){
	      log({
	        val: val
	      });
	      if (val !== void 8) {
	        return $('.modal').modal('show');
	      } else {
	        return $('.modal').modal('hide');
	      }
	    }
	  }
	};
	//# sourceMappingURL=/home/roosephu/Desktop/dollast/node_modules/vue-livescript-loader/index.js!/home/roosephu/Desktop/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/home/roosephu/Desktop/dollast/client/components/site/error.vue.map


/***/ },
/* 220 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui basic modal small\"><div class=\"ui icon header\"><i class=\"icon announcement\"></i>Error on {{ object }}</div><div class=\"content\"><h4>{{ message }}</h4></div><div class=\"actions\"><div @click=\"home\" class=\"ui red basic inverted button\"><i class=\"icon home\"></i>Home</div><div @click=\"back\" class=\"ui green basic inverted button\"><i class=\"icon arrow left\"></i>Back</div></div></div>";

/***/ },
/* 221 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui grid\"><error></error><navbar></navbar><div class=\"row\"><div class=\"three wide column\"></div><div class=\"ten wide column\"><router-view></router-view></div></div><div class=\"row\"><div class=\"twelve wide column centered\"><foot></foot></div></div></div>";

/***/ }
]);