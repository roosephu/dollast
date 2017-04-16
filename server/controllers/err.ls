require! {
  \co
}

class Err extends Error
  (prop) ->
    @name = \RuntimeError
    @re = true
    @details = prop

action-name = 
  r: \read
  w: \write
  x: \execute

module.exports = 
  assert: (statement, _id, type, detail, field) ->
    return if statement
    if \string == typeof _id 
      throw new Err {_id, type, detail, field}
    else
      throw new Err _id
  
  assert-name: (name, statement, prop) ->
    return if statement
    err = new Err prop
    err.name = name
    throw err

  assert-permit: (statement, prop) ->
    return if statement
    err = new Err prop
    err.name = \PermissionDenied
    throw err
  
  assert-exist: co.wrap (obj, action, _id, type) ->*
    if obj
      result = yield obj.permit.check-access @state.user, action
      if !result
        throw new Err do
          _id: _id
          type: type 
          user: @state.user._id
          action: action-name[action]
          doc: obj.permit{owner, group, access}
    else
      err = new Err {_id, type}
      err.name = \Nonexistence
      throw err
