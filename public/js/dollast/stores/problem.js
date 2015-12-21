// Generated by LiveScript 1.4.0
(function(){
  var reflux, co, U, actions, store, out$ = typeof exports != 'undefined' && exports || this;
  reflux = require('reflux');
  co = require('co');
  U = require('../components/utils');
  out$.actions = actions = reflux.createActions(['read', 'update', 'delete', 'nextCount']);
  store = reflux.createStore({
    listenables: actions,
    onRead: function(){},
    onUpdate: function(allValues){
      console.log(allValues);
      return co(function*(){
        return $;
      });
    },
    onDelete: function(){},
    onNextCount: co.wrap(function*(){
      return $.get("/problem/next-count");
    })
  });
}).call(this);