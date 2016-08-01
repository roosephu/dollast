require! {
  \debug
  \co
  \../server/models
}

log = debug \dollast:migrate

co ->*
  try
    # for pack in yield models.packs.find!.exec!
      # permit = new models.permit pack.permit
      # permit.src-id = pack._id
      # permit.src-type = \Pack
      # permit.save!
      # log permit
      # pack.permit = pack.permit._id
      # pack.save!
    
    # def-pack = yield models.packs.find-by-id \0 .exec!
    # def-permit = def-pack.permit

    # for problem in yield models.problems.find!.exec!
      # permit = new models.permit problem.permit
      # permit.src-id = problem._id
      # permit.src-type = \Problem
      # permit.save!
      # problem.permit.parent = def-permit._id
      # problem.permit.mark-modified \_id
      # problem.save!

    # for submission in yield models.submissions.find!.exec!
      # permit = new models.permit submission.permit
      # permit.src-id = submission._id
      # permit.src-type = \Submission
      # permit.save!
      # submission.permit .= _id
      # submission.save!

    # for user in yield models.users.find!.exec!
    #   permit = new models.permit user.permit
    #   permit.src-id = user._id
    #   permit.src-type = \User
    #   permit.save!
    #   user.permit = permit._id
    #   user.save!

    log \done
  catch e
    log e