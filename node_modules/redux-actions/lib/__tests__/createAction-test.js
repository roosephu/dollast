'use strict';

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _ = require('../');

var _lodashIsplainobject = require('lodash.isplainobject');

var _lodashIsplainobject2 = _interopRequireDefault(_lodashIsplainobject);

describe('createAction()', function () {
  describe('resulting action creator', function () {
    var type = 'TYPE';

    it('returns plain object', function () {
      var actionCreator = _.createAction(type, function (b) {
        return b;
      });
      var foobar = { foo: 'bar' };
      var action = actionCreator(foobar);
      expect(_lodashIsplainobject2['default'](action)).to.be['true'];
    });

    it('uses return value as payload', function () {
      var actionCreator = _.createAction(type, function (b) {
        return b;
      });
      var foobar = { foo: 'bar' };
      var action = actionCreator(foobar);
      expect(action.payload).to.equal(foobar);
    });

    it('has no extraneous keys', function () {
      var actionCreator = _.createAction(type, function (b) {
        return b;
      });
      var foobar = { foo: 'bar' };
      var action = actionCreator(foobar);
      expect(action).to.deep.equal({
        type: type,
        payload: foobar
      });
    });

    it('uses identity function if actionCreator is not a function', function () {
      var actionCreator = _.createAction(type);
      var foobar = { foo: 'bar' };
      var action = actionCreator(foobar);
      expect(action).to.deep.equal({
        type: type,
        payload: foobar
      });
    });

    it('accepts a second parameter for adding meta to object', function () {
      var actionCreator = _.createAction(type, null, function (_ref) {
        var cid = _ref.cid;
        return { cid: cid };
      });
      var foobar = { foo: 'bar', cid: 5 };
      var action = actionCreator(foobar);
      expect(action).to.deep.equal({
        type: type,
        payload: foobar,
        meta: {
          cid: 5
        }
      });
    });

    it('sets error to true if payload is an Error object', function () {
      var actionCreator = _.createAction(type);
      var errObj = new TypeError('this is an error');

      var errAction = actionCreator(errObj);
      expect(errAction).to.deep.equal({
        type: type,
        payload: errObj,
        error: true
      });

      var foobar = { foo: 'bar', cid: 5 };
      var noErrAction = actionCreator(foobar);
      expect(noErrAction).to.deep.equal({
        type: type,
        payload: foobar
      });
    });
  });
});