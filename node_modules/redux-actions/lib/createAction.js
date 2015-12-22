'use strict';

exports.__esModule = true;
exports['default'] = createAction;
function identity(t) {
  return t;
}

function createAction(type, actionCreator, metaCreator) {
  var finalActionCreator = typeof actionCreator === 'function' ? actionCreator : identity;

  return function () {
    for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    var action = {
      type: type,
      payload: finalActionCreator.apply(undefined, args)
    };

    if (args.length === 1 && args[0] instanceof Error) {
      // Handle FSA errors where the payload is an Error object. Set error.
      action.error = true;
    }

    if (typeof metaCreator === 'function') {
      action.meta = metaCreator.apply(undefined, args);
    }

    return action;
  };
}

module.exports = exports['default'];