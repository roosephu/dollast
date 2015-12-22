'use strict';

exports.__esModule = true;
exports['default'] = handleAction;

var _fluxStandardAction = require('flux-standard-action');

function isFunction(val) {
  return typeof val === 'function';
}

function handleAction(type, reducers) {
  return function (state, action) {
    // If action type does not match, return previous state
    if (action.type !== type) return state;

    var handlerKey = _fluxStandardAction.isError(action) ? 'throw' : 'next';

    // If function is passed instead of map, use as reducer
    if (isFunction(reducers)) {
      reducers.next = reducers['throw'] = reducers;
    }

    // Otherwise, assume an action map was passed
    var reducer = reducers[handlerKey];

    return isFunction(reducer) ? reducer(state, action) : state;
  };
}

module.exports = exports['default'];