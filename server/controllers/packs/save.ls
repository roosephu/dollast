require! {
  \debug
  \flat
  \../../models
}

log = debug \dollast:ctrl:pack:save 

handler = ->*
  # TODO: validation
  pack = @request.body
  log {pack}

  if pack._id == void
    pack._id = yield models.packs.next-count!
    # throw new Error "pack must have its id"
  else
    existed = yield models.packs.find-by-id pack._id, \permit .exec!
    if not existed
      @body =
        status:
          type: \error
          message: "cannot find the original pack"
      return
    existed.permit.check-access @state.user, \w

    # TODO: check permit is not modified here
    # only owner can transfer owner

    # flat it!
    pack |>= flat

  @body = yield models.packs.update _id: pack._id, pack, upsert: true .exec!

  @body =
    _id: pack._id
    detail: "pack saved"

module.exports = 
  method: \POST
  path: \/pack
  handler: handler