'use strict';

var _ = require('../');

describe('handleAction()', function () {
  var type = 'TYPE';
  var prevState = { counter: 3 };

  describe('single handler form', function () {
    describe('resulting reducer', function () {
      it('returns previous state if type does not match', function () {
        var reducer = _.handleAction('NOTTYPE', function () {
          return null;
        });
        expect(reducer(prevState, { type: type })).to.equal(prevState);
      });

      it('accepts single function as handler', function () {
        var reducer = _.handleAction(type, function (state, action) {
          return {
            counter: state.counter + action.payload
          };
        });
        expect(reducer(prevState, { type: type, payload: 7 })).to.deep.equal({
          counter: 10
        });
      });
    });
  });

  describe('map of handlers form', function () {
    describe('resulting reducer', function () {
      it('returns previous state if type does not match', function () {
        var reducer = _.handleAction('NOTTYPE', { next: function next() {
            return null;
          } });
        expect(reducer(prevState, { type: type })).to.equal(prevState);
      });

      it('uses `next()` if action does not represent an error', function () {
        var reducer = _.handleAction(type, {
          next: function next(state, action) {
            return {
              counter: state.counter + action.payload
            };
          }
        });
        expect(reducer(prevState, { type: type, payload: 7 })).to.deep.equal({
          counter: 10
        });
      });

      it('uses `throw()` if action represents an error', function () {
        var reducer = _.handleAction(type, {
          'throw': function _throw(state, action) {
            return {
              counter: state.counter + action.payload
            };
          }
        });
        expect(reducer(prevState, { type: type, payload: 7, error: true })).to.deep.equal({
          counter: 10
        });
      });

      it('returns previous state if matching handler is not function', function () {
        var reducer = _.handleAction(type, { next: null, error: 123 });
        expect(reducer(prevState, { type: type, payload: 123 })).to.equal(prevState);
        expect(reducer(prevState, { type: type, payload: 123, error: true })).to.equal(prevState);
      });
    });
  });
});