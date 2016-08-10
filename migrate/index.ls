require! {
  \debug
  \co
  \../server/models
  \../server/models/conn : {conn}
  \mongoose : {Schema}
}

log = debug \dollast:migrate

convert = co.wrap (permit) ->*
  new-permit = permit{owner, group, access}
  if permit.parent
    parent = yield permit-model.find-by-id permit.parent .lean! .exec!
    new-permit.parent-id = parent.src-id
    new-permit.parent-type = parent.src-type
  new-permit

co ->*
  try
    for pack in yield models.Packs.find!.exec!
      pack.flag = true
      yield pack.save!
      # permit-id = pack.permit
      # permit = yield permit-model.find-by-id permit-id .lean! .exec!
      # new-permit = yield convert permit
      # log permit, new-permit
      # pack.permit = new-permit
      # yield pack.save!

      # permit = new models.permit pack.permit
      # permit.src-id = pack._id
      # permit.src-type = \Pack
      # permit.save!
      # log permit
      # pack.permit = pack.permit._id
      # pack.save!
    
    # def-pack = yield models.packs.find-by-id \0 .exec!
    # def-permit = def-pack.permit

    # for problem in yield models.Problems.find!.exec!
    #   permit-id = problem.permit
    #   permit = yield permit-model.find-by-id permit-id .lean! .exec!
    #   new-permit = yield convert permit
    #   log permit, new-permit
    #   problem.permit = new-permit
    #   problem.save!

    # for submission in yield models.Submissions.find!.exec!
    #   submission.hidden = true
    #   log submission
      # permit-id = submission.permit
      # permit = yield permit-model.find-by-id permit-id .lean! .exec!
      # new-permit = yield convert permit
      # log permit, new-permit
      # submission.permit = new-permit
      # submission.save!

    # for user in yield models.Users.find!.exec!
    #   permit-id = user.permit
    #   permit = yield permit-model.find-by-id permit-id .lean! .exec!
    #   new-permit = yield convert permit
    #   log permit, new-permit
    #   user.permit = new-permit
    #   yield user.save!

    log \done
  catch e
    log e