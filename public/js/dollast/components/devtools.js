// Generated by LiveScript 1.3.1
(function(){
  var createDevTools, LogMonitor, DockMonitor;
  createDevTools = require('redux-devtools').createDevTools;
  LogMonitor = require('redux-devtools-log-monitor')['default'];
  DockMonitor = require('redux-devtools-dock-monitor')['default'];
  module.exports = createDevTools(_(DockMonitor, {
    toggleVisibilityKey: 'ctrl-h',
    changePositionKey: 'ctrl-q'
  }, _(LogMonitor)));
}).call(this);