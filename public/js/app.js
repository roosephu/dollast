webpackJsonp([0],[
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var vue, vuex, vueRouter, vueResource, debug, router, x$, app;
	vue = __webpack_require__(1);
	vuex = __webpack_require__(3);
	vueRouter = __webpack_require__(4);
	vueResource = __webpack_require__(5);
	debug = __webpack_require__(29);
	vue.use(vuex);
	vue.use(vueResource);
	vue.config.debug = true;
	debug.enable("dollast:*");
	vue.use(vueRouter);
	router = __webpack_require__(32);
	x$ = app = __webpack_require__(75);
	x$.store = __webpack_require__(72);
	app = vue.extend(app);
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
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/main.ls.map


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
/* 32 */
/***/ function(module, exports, __webpack_require__) {

	var vueRouter, router;
	vueRouter = __webpack_require__(4);
	router = new vueRouter();
	router.map({
	  "/": {
	    component: __webpack_require__(33)
	  },
	  "/about": {
	    component: __webpack_require__(35)
	  },
	  "/problem": {
	    component: __webpack_require__(37)
	  },
	  "/problem/create": {
	    component: __webpack_require__(33)
	  },
	  "/problem/:pid": {
	    component: __webpack_require__(44)
	  },
	  "/problem/:pid/modify": {
	    component: __webpack_require__(33)
	  },
	  "/problem/:pid/stat": {
	    component: __webpack_require__(47)
	  },
	  "/solution": {
	    component: __webpack_require__(66)
	  },
	  "/solution/submit/:pid": {
	    component: __webpack_require__(33)
	  },
	  "/solution/user/:uid": {
	    component: __webpack_require__(33)
	  },
	  "/solution/:sid": {
	    component: __webpack_require__(33)
	  },
	  "/round": {
	    component: __webpack_require__(33)
	  },
	  "/round/create": {
	    component: __webpack_require__(33)
	  },
	  "/round/:rid": {
	    component: __webpack_require__(33)
	  },
	  "/round/:rid/modify": {
	    component: __webpack_require__(33)
	  },
	  "/round/:rid/board": {
	    component: __webpack_require__(33)
	  },
	  "/user": {
	    component: __webpack_require__(33)
	  },
	  "/user/login": {
	    component: __webpack_require__(69)
	  },
	  "/user/register": {
	    component: __webpack_require__(33)
	  },
	  "/user/:uid": {
	    component: __webpack_require__(33)
	  },
	  "/user/:uid/modify": {
	    component: __webpack_require__(33)
	  }
	});
	module.exports = router;
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/router.ls.map


/***/ },
/* 33 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_template__ = __webpack_require__(34)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/site/index.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 34 */
/***/ function(module, exports) {

	module.exports = "<div><h1 class=\"ui dividing header\">welcome</h1><h3 class=\"ui\">this is dollast, an buggy online judge.</h3></div>";

/***/ },
/* 35 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_template__ = __webpack_require__(36)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/site/about.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 36 */
/***/ function(module, exports) {

	module.exports = "<div><p>Hi 小朋友们大家好，还记得我是谁吗，对了我就是青年理论计算机科学家 BBL ！（背景音乐：我可是世界上最厉害的……</p><p>为了答谢广大人民群众对我的厚爱，以及老师们拉着我非要我写一个 OJ 出来，我就花了几个星期码了这样一个网站出来 →_→</p><div><h2>Q: 为何这网站如此具有朴素简洁美？</h2><h3>A: 朴实沉毅乃校训，不可忘怀。（其实是我懒得做 UI 了 = =）</h3><div><p>有兴趣的同学可以自己设计一套 UI 给我……聪明的同学已经发现了我网站的架构了：每次 get 一个网页作为模板，所以只需要写一套 partials 里面的东西就可以了……</p><p>\"我才不会告诉你们我早就写好了 theme 功能，就差一个美工了 →_→</p></div><br/></div><div><h2>\"Q: 为什么要起一个 dollast 这种中二的名字？\"</h2><h3>\"A: 我也不知道你快来咬我呀哈哈哈哈…… 因为这边儿名字是 YXJ 起的 →_→\"</h3><div><p>\"其实我早就做好了准备，要改名字只要一行命令就可以了 233\"</p></div><br/></div><div><h2>\"Q: 那请问贵站有哪些特性？\"</h2><h3>\"A: 终于有人肯问一个正常点的问题了！我们目前只支持两个特性：1. 朴素 2. 不能评测……因为没写完。\"</h3><div><p>\"我的美妙的寒假全葬送在这个网站上了……说好的青年理论计算机科学家呢 →_→\"</p></div><br/></div><div><h2>\"Q: 你写这个 OJ ，是不是要钦点成为 CJ 的校内 OJ？\"</h2><h3>\"A: 我没有任何这个意思。你们有一个好，刷题刷的比谁都快，但是问来问去的问题，too simple。西方的那个 OJ 我没用过？美国的 SPOJ，不知道比你们快到哪去了，我用的谈笑风生。你们啊，too young，sometimes naive。\"</h3><div><p>\"再问我就烂尾啦 = =\"</p></div><br/></div><div><h2>\"Q: 那么具体说来你用的是怎样一个架构？\"</h2><h3>\"A: \"<del>\"M(ongoDB)A(ngularjs)N(odejs)K(oa) ，外加一个 cpp 作为沙盒。目前发现没什么代码量……\"</del>\"I used months to refactor the code from Angular.js to React.js. The backend remains to be Koa.js\"</h3><div><p>\"据说码代码的时间只要学习新姿势的一半，学习新姿势的时间只要调试的一半\"</p></div><br/></div></div>";

/***/ },
/* 37 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(38)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/problem/list.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(43)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/problem/list.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 38 */
/***/ function(module, exports, __webpack_require__) {

	var vue, co, debug, problem, log;
	vue = __webpack_require__(1);
	co = __webpack_require__(39);
	debug = __webpack_require__(29);
	problem = __webpack_require__(40);
	log = debug('dollast:component:problem:list');
	module.exports = {
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
	  created: function(){
	    var this$ = this;
	    return co(function*(){
	      var ref$;
	      return ref$ = (yield vue.http.get('/problem')), this$.problems = ref$.data, ref$;
	    });
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
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/problem/list.vue.map


/***/ },
/* 39 */,
/* 40 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(41)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/format/problem.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(42)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/problem.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 41 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    prob: Object
	  }
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/problem.vue.map


/***/ },
/* 42 */
/***/ function(module, exports) {

	module.exports = "<a v-if=\"prob &amp;&amp; prob._id &gt; 0\" href=\"#/problem/{{prob._id}}\" class=\"ui label green\">{{prob._id}}. {{prob.outlook.title}}</a><a v-else=\"v-else\" class=\"ui label green\">hidden</a>";

/***/ },
/* 43 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui\"><h1 class=\"ui dividing header\">Problem List</h1><div class=\"ui dropdown floated pointing button labeled icon\"><input type=\"hidden\" name=\"filter\"/><div class=\"default text\">please select filter</div><i class=\"dropdown icon\"></i><div class=\"menu\"><div v-for=\"item in options\" data-value=\"{{item}}\" class=\"item\">{{item}}</div></div></div><a href=\"#/problem/create\" class=\"ui icon labeled button right floated primary\"><i class=\"icon plus\"></i>create</a><div class=\"ui very relaxed divided link list\"><div v-for=\"prob in problems\" class=\"item\"><div class=\"ui right floated\">??</div><div class=\"ui description\"><problem :prob=\"prob\"></problem></div></div></div></div>";

/***/ },
/* 44 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(45)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/problem/show.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(46)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/problem/show.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 45 */
/***/ function(module, exports, __webpack_require__) {

	var co, debug, vue, log, this$ = this;
	co = __webpack_require__(39);
	debug = __webpack_require__(29);
	vue = __webpack_require__(1);
	log = debug('dollast:component:problem:show');
	module.exports = {
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
	      var pid, data;
	      pid = arg$.to.params.pid;
	      data = (yield vue.http.get("/problem/" + pid)).data;
	      return {
	        problem: data
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
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/problem/show.vue.map


/***/ },
/* 46 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui dividing header\">Problem {{problem._id}}. {{problem.outlook.title}}</h1><div :class=\"{loading: $loadingRouteData}\" class=\"ui segment\"><div class=\"ui olive labels\"><div class=\"ui label\">{{problem.config.timeLmt}} s<div class=\"detail\">time limit</div></div><div class=\"ui label\">{{problem.config.spaceLmt}} MB<div class=\"detail\">space limit</div></div><div class=\"ui label\">{{problem.permit.owner}}<div class=\"detail\">owner</div></div><div class=\"ui label\">{{problem.permit.group}}<div class=\"detail\">group</div></div></div><div class=\"ui segment\"><div class=\"ui top left attached label teal\">description</div><p mathjax=\"mathjax\">{{problem.outlook.desc}}</p></div><div class=\"ui two column grid\"><div class=\"row\"><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">input format</div><p>{{problem.outlook.inFmt}}</p></div></div><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">output format</div><p>{{problem.outlook.outFmt}}</p></div></div></div><div class=\"row\"><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">sample input</div><p>{{problem.outlook.sampleIn}}</p></div></div><div class=\"column\"><div class=\"ui segment\"><div class=\"ui top left attached label teal\">sample output</div><p>{{problem.outlook.sampleOut}}</p></div></div></div></div></div><div class=\"ui header\"></div><a href=\"#/solution/submit/{{problem._id}}\" class=\"ui icon labeled primary button\"><i class=\"icon rocket\"></i>Submit</a><a href=\"#/problem/{{problem._id}}/modify\" class=\"ui icon labeled orange button\"><i class=\"icon edit\"></i>Modify</a><a href=\"#/problem/{{problem._id}}/stat\" class=\"ui icon labeled purple button\"><i class=\"icon chart bar\"></i>statistics</a>";

/***/ },
/* 47 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(48)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/problem/stat.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(65)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/problem/stat.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 48 */
/***/ function(module, exports, __webpack_require__) {

	var vue, debug, co, format, ref$, average, map, filter, log, generateStat;
	vue = __webpack_require__(1);
	debug = __webpack_require__(29);
	co = __webpack_require__(39);
	format = __webpack_require__(49);
	ref$ = __webpack_require__(59), average = ref$.average, map = ref$.map, filter = ref$.filter;
	log = debug('dollast:component:problem:stat');
	generateStat = function(sols){
	  var scores, res$, i$, len$, sol, mean, median, variance, stddev, solved;
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
	  data: function(){
	    return {
	      stat: [],
	      problem: {}
	    };
	  },
	  route: {
	    data: co.wrap(function*(arg$){
	      var pid, ref$, sols, prob, stat;
	      pid = arg$.to.params.pid;
	      ref$ = (yield vue.http.get("/problem/" + pid + "/stat")).data, sols = ref$.sols, prob = ref$.prob;
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
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/problem/stat.vue.map


/***/ },
/* 49 */
/***/ function(module, exports, __webpack_require__) {

	var codeLink, problem, round, user;
	codeLink = __webpack_require__(50);
	problem = __webpack_require__(40);
	round = __webpack_require__(53);
	user = __webpack_require__(56);
	module.exports = {
	  codeLink: codeLink,
	  problem: problem,
	  round: round,
	  user: user
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/index.ls.map


/***/ },
/* 50 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(51)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/format/code-link.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(52)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/code-link.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 51 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    sid: Number
	  }
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/code-link.vue.map


/***/ },
/* 52 */
/***/ function(module, exports) {

	module.exports = "<a href=\"#/solution/{{sid}}\" class=\"ui label grey\">{{sid}}</a>";

/***/ },
/* 53 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(54)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/format/round.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(55)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/round.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 54 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    rnd: Object
	  }
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/round.vue.map


/***/ },
/* 55 */
/***/ function(module, exports) {

	module.exports = "<a v-if=\"rnd &amp;&amp; rnd._id &gt; 0\" href=\"#/round/{{rnd._id}}\" class=\"ui label light teal\">{{rnd._id}}. {{rnd.title}}</a><a v-else=\"v-else\" class=\"ui label light teal\">hidden</a>";

/***/ },
/* 56 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(57)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/format/user.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(58)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/user.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 57 */
/***/ function(module, exports) {

	module.exports = {
	  props: {
	    uid: String
	  }
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/format/user.vue.map


/***/ },
/* 58 */
/***/ function(module, exports) {

	module.exports = "<a href=\"#/user/{{uid}}\" class=\"ui label\">{{uid}}</a>";

/***/ },
/* 59 */,
/* 60 */,
/* 61 */,
/* 62 */,
/* 63 */,
/* 64 */,
/* 65 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui header dividing\">Statistics for Problem {{problem._id}}</h1><problem :prob=\"problem\"></problem><h3 class=\"ui header dividing\">numbers</h3><div class=\"ui statistics\"><div v-for=\"(key, val) in stat\" class=\"statistic\"><div class=\"value\">{{val}}</div><div class=\"label\">{{key}}</div></div></div>";

/***/ },
/* 66 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(67)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/solution/list.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(68)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/solution/list.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 67 */
/***/ function(module, exports, __webpack_require__) {

	var debug, co, vue, format, log, this$ = this;
	debug = __webpack_require__(29);
	co = __webpack_require__(39);
	vue = __webpack_require__(1);
	format = __webpack_require__(49);
	log = debug('dollast:component:solution:list');
	module.exports = {
	  data: function(){
	    return {
	      solutions: []
	    };
	  },
	  route: {
	    data: co.wrap(function*(){
	      var data;
	      data = (yield vue.http.get('/solution')).data;
	      log({
	        data: data,
	        prob: data[0].prob
	      });
	      return {
	        solutions: data
	      };
	    })
	  },
	  components: format
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/solution/list.vue.map


/***/ },
/* 68 */
/***/ function(module, exports) {

	module.exports = "<h1 class=\"ui dividing header\">status</h1><div :class=\"{loading: false}\" class=\"ui segment\"><table class=\"ui table large green selectable very basic\"><thead><tr><th class=\"collapsing right\">sol id</th><th>problem</th><th>user</th><th>status</th><th>score</th><th>time(s)</th><th>space(MB)</th><th class=\"collapsing\">lang</th><th class=\"collapsing\">round</th></tr></thead><tbody><tr v-for=\"sol in solutions\" class=\"red\"><td><code-link :sid=\"sol._id\"></code-link></td><td><problem :prob=\"sol.prob\"></problem></td><td><user :uid=\"sol.user\"></user></td><td>{{sol.final.status}}</td><td>{{sol.final.score}}</td><td>{{sol.final.time}}</td><td>{{sol.final.space}}</td><td>{{sol.lang}}</td><td v-if=\"sol.round\"><round :rnd=\"sol.round\"></round></td><td v-else=\"v-else\"></td></tr></tbody></table></div><div class=\"ui icon labeled button floated right primary\"><i class=\"icon refresh\"></i>refresh</div>";

/***/ },
/* 69 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(70)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/user/login.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(74)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/user/login.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 70 */
/***/ function(module, exports, __webpack_require__) {

	var debug, login, log;
	debug = __webpack_require__(29);
	login = __webpack_require__(71).login;
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
	    submit = function(e){
	      var $form, values;
	      e.preventDefault();
	      $form = $('#login-form');
	      values = $form.form('get values');
	      this$.login(values);
	      return this$.success = true;
	    };
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
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/user/login.vue.map


/***/ },
/* 71 */
/***/ function(module, exports, __webpack_require__) {

	var vue, store, co, debug, log, login, logout, out$ = typeof exports != 'undefined' && exports || this;
	vue = __webpack_require__(1);
	store = __webpack_require__(72);
	co = __webpack_require__(39);
	debug = __webpack_require__(29);
	log = debug('dollast:actions');
	out$.login = login = co.wrap(function*(arg$, info){
	  var dispatch, data;
	  dispatch = arg$.dispatch;
	  data = (yield vue.http.post('/site/login', info)).data;
	  return dispatch('loadFromToken', data.payload.token);
	});
	out$.logout = logout = function(arg$){
	  var dispatch;
	  dispatch = arg$.dispatch;
	  return dispatch('logout');
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/actions/index.ls.map


/***/ },
/* 72 */
/***/ function(module, exports, __webpack_require__) {

	var vue, vuex, auth, state, mutations;
	vue = __webpack_require__(1);
	vuex = __webpack_require__(3);
	auth = __webpack_require__(73);
	state = {
	  session: {
	    guest: true
	  }
	};
	mutations = {
	  loadFromToken: function(state, token){
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
	  }
	};
	module.exports = new vuex.Store({
	  state: state,
	  mutations: mutations
	});
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/store/index.ls.map


/***/ },
/* 73 */
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
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/store/auth.ls.map


/***/ },
/* 74 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui\"><h1 class=\"ui dividing header\">Login</h1><form id=\"login-form\" :class=\"{loading: loading, success: success}\" class=\"ui form segment\"><div class=\"ui error message\"></div><div class=\"ui success message\"><div class=\"header\">Login successfully. Redirect to problem list in 3 seconds.</div></div><div class=\"ui field\"><div class=\"ui icon input left\"><i class=\"icon user\"></i><input name=\"uid\" placeholder=\"user id\"/></div></div><div class=\"ui field\"><div class=\"ui icon input left\"><i class=\"icon lock\"></i><input name=\"pswd\" placeholder=\"password\" type=\"password\"/></div></div><div class=\"ui icon labeled button left primary submit\"><i class=\"icon sign in\"></i>Login</div></form></div>";

/***/ },
/* 75 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(76)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/app.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(82)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/app.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 76 */
/***/ function(module, exports, __webpack_require__) {

	var foot, navbar, vueRouter, vue;
	foot = __webpack_require__(77);
	navbar = __webpack_require__(79);
	vueRouter = __webpack_require__(4);
	vue = __webpack_require__(1);
	module.exports = {
	  components: {
	    navbar: navbar,
	    foot: foot
	  }
	};
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/app.vue.map


/***/ },
/* 77 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_template__ = __webpack_require__(78)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/site/foot.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 78 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui divider horizontal\">Yuping Luo @ 2016</div>";

/***/ },
/* 79 */
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(80)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] src/public/js/dollast/components/site/navbar.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(81)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/site/navbar.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 80 */
/***/ function(module, exports, __webpack_require__) {

	var debug, logout, log;
	debug = __webpack_require__(29);
	logout = __webpack_require__(71).logout;
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
	//# sourceMappingURL=/Users/roosephu/Desktop/git/dollast/node_modules/vue-livescript-loader/index.js!/Users/roosephu/Desktop/git/dollast/node_modules/vue-loader/lib/selector.js?type=script&index=0!/Users/roosephu/Desktop/git/dollast/src/public/js/dollast/components/site/navbar.vue.map


/***/ },
/* 81 */
/***/ function(module, exports) {

	module.exports = "<div class=\"row\"><div class=\"ui blue inverted page grid borderless menu\"><div class=\"header item\">dollast</div><a href=\"#/\" class=\"item labeled\"><i class=\"icon home\"></i>Home</a><a href=\"#/problem\" class=\"item labeled\"><i class=\"icon browser\"></i>Problem</a><a href=\"#/solution\" class=\"item labeled\"><i class=\"icon info circle\"></i>Status</a><a href=\"#/round\" class=\"item labeled\"><i class=\"icon users\"></i>Contest</a><div class=\"right menu\"><div class=\"item\"><div class=\"ui input icon inverted small\"><i class=\"icon search link\"></i><input placeholder=\"ID or Search\"/></div></div><a v-if=\"uid != undefined\" href=\"#/user/{{uid}}\" class=\"item labeled\"><i class=\"icon user\"></i>{{uid}}</a><a v-else=\"v-else\" href=\"#/user/login\" class=\"item labeled\"><i class=\"icon sign in\"></i>Sign in</a><a v-if=\"uid != undefined\" @click=\"logout\" class=\"item labeled\"><i class=\"icon sign out\"></i>Logout</a><a v-else=\"v-else\" href=\"#/register\" class=\"item labeled\"><i class=\"icon signup\"></i>Register</a></div></div></div>";

/***/ },
/* 82 */
/***/ function(module, exports) {

	module.exports = "<div class=\"ui grid\"><navbar></navbar><div class=\"row\"><div class=\"three wide column\"></div><div class=\"ten wide column\"><router-view></router-view></div></div><div class=\"row\"><div class=\"twelve wide column centered\"><foot></foot></div></div></div>";

/***/ }
]);