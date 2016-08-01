require! {
  \debug
  \flat
  \../../models
  \../validator
}

log = debug \dollast:ctrl:pack:save 

handler = ->*
  # TODO: validation
  pack = @request.body
  log {pack}

  if pack._id == void
    pack._id = yield models.Packs.next-count!
    # TODO: can this user add a pack? 
  else
    existed = yield models.Packs.find-by-id pack._id, \permit .exec!
    @assert existed, _id: pack._id, type: \Pack, detail: "cannot find the original pack"
    yield existed.permit.check-access @state.user, \w

    delete pack.permit

    # flat it!
    pack |>= flat

  @body = yield models.Packs.update _id: pack._id, pack, upsert: true .exec!

  @body =
    _id: pack._id
    detail: "pack saved"

module.exports = 
  method: \POST
  path: \/pack
  validate:
    type: \json
    body:
      _id: validator.pack!
  handler: handler