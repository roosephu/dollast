'use strict';

var _ = require('../');

describe('handleActions', function () {
  it('create a single handler from a map of multiple action handlers', function () {
    var reducer = _.handleActions({
      INCREMENT: function INCREMENT(_ref, _ref2) {
        var counter = _ref.counter;
        var amount = _ref2.payload;
        return {
          counter: counter + amount
        };
      },

      DECREMENT: function DECREMENT(_ref3, _ref4) {
        var counter = _ref3.counter;
        var amount = _ref4.payload;
        return {
          counter: counter - amount
        };
      }
    });

    expect(reducer({ counter: 3 }, { type: 'INCREMENT', payload: 7 })).to.deep.equal({
      counter: 10
    });
    expect(reducer({ counter: 10 }, { type: 'DECREMENT', payload: 7 })).to.deep.equal({
      counter: 3
    });
  });

  it('works with symbol action types', function () {
    var _handleActions;

    var INCREMENT = Symbol();

    var reducer = _.handleActions((_handleActions = {}, _handleActions[INCREMENT] = function (_ref5, _ref6) {
      var counter = _ref5.counter;
      var amount = _ref6.payload;
      return {
        counter: counter + amount
      };
    }, _handleActions));

    expect(reducer({ counter: 3 }, { type: INCREMENT, payload: 7 })).to.deep.equal({
      counter: 10
    });
  });

  it('accepts a default state as the second parameter', function () {
    var reducer = _.handleActions({
      INCREMENT: function INCREMENT(_ref7, _ref8) {
        var counter = _ref7.counter;
        var amount = _ref8.payload;
        return {
          counter: counter + amount
        };
      },

      DECREMENT: function DECREMENT(_ref9, _ref10) {
        var counter = _ref9.counter;
        var amount = _ref10.payload;
        return {
          counter: counter - amount
        };
      }
    }, { counter: 3 });

    expect(reducer(undefined, { type: 'INCREMENT', payload: 7 })).to.deep.equal({
      counter: 10
    });
  });
});