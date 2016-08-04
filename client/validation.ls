require! {
  \moment
}

extra-rules =
  positive: (text) ->
    0 < parse-float text
  is-time: (text) ->
    # log {text}
    moment text, 'YYYY-MM-DD HH:mm:ss' .is-valid!
  is-password: (text) ->
    4 <= text.length and text.length <= 15

  is-user-id: (text) ->
    # log {text}
    if 4 > text.length or text.length > 15
      false
    else
      /^[a-zA-Z0-9._]*$/.test text

  is-access: (text) ->
    /^([r-][w-][x-]){3}$/.test text

$.fn.form.settings.inline = true
$.fn.form.settings.on = \blur

for key, val of extra-rules
  # log key
  $.fn.form.settings.rules[key] = val

$.fn.form.settings.defaults = 
  user:
    identifier: \user
    rules:
      * type: 'minLength[6]'
        prompt: "User name must be longer than 5"
      * type: 'maxLength[16]'
        prompt: "User name must be shorter than 16"
  pack:
    identifier: \pack
    rules:
      * type: 'minLength[2]'
        prompt: 'pack id minimum length is 2'
      * type: 'maxLength[63]'
        prompt: 'pack id length cannot exceed 63'

  # permit
  owner:
    identifier: \owner
    rules:
      * type: \isUserId
        prompt: 'owner should be valid'
      ...
  group:
    identifier: \group
    rules:
      * type: \isUserId
        prompt: 'group should be valid'
      ...
  access:
    identifier: \access
    rules:
      * type: \isAccess
        prompt: 'access code should be /^([r-][w-][x-]){3}$/'
      ...

  # user
  password:
    identifier: \password
    rules:
      * type: 'minLength[6]'
        prompt: 'password length must be longer than 5'
      * type: 'maxLength[16]'
        prompt: 'password length must be shorter than 16'
  old-password:
    identifier: \oldPassword
    optional: true
    rules:
      * type: \isPassword
        prompt: "must be password"
      ...
  new-password:
    identifier: \newPassword
    optional: true
    rules:
      * type: \isPassword
        prompt: "must be password"
      ...
  confirmation:
    identifier: \confirmPassword
    optional: true
    rules:
      * type: \isPassword
        prompt: "must be password"
      * type: "match[newPassword]"
        prompt: "password must match"
  email:
    identifier: \email
    rules:
      * type: 'email'
        prompt: 'please enter a valid email address'
      ...

  # problem
  title:
    identifier: \title
    rules:
      * type: 'minLength[2]'
        prompt: 'title minimum length is 2'
      * type: 'maxLength[63]'
        prompt: 'title length cannot exceed 63'
  judger:
    identifier: \judger
    rules:
      * type: 'empty'
        prompt: 'please choose your judger'
      ...
  time-limit:
    identifier: \timeLimit
    rules:
      * type: 'positive'
        prompt: 'time limit must be positive'
      ...
  space-limit:
    identifier: \spaceLimit
    rules:
      * type: \positive
        prompt: 'space limit must be positive'
      ...
  stack-limit:
    identifier: \stackLimit
    rules:
      * type: \positive
        prompt: "stack limit must be positive"
      ...
  output-limit:
    identifier: \outputLimit
    rules:
      * type: \positive
        prompt: "output limit must be positive"
      ...
  description:
    identifier: \description
    rules:
      * type: "maxLength[65535]"
        prompt: "description cannot be longer than 65535"
      ...
  input-format:
    identifier: \inputFormat
    rules:
      * type: "maxLength[65535]"
        prompt: "input format cannot be longer than 65535"
      ...
  output-format:
    identifier: \outputFormat
    rules:
      * type: "maxLength[65535]"
        prmopt: "output format cannot be longer than 65535"
      ...
  sample-input:
    identifier: \sampleInput
    rules:
      * type: "maxLength[65535]"
        prompt: "sample input cannot be longer than 65535"
      ...
  sample-output:
    identifier: \sampleOutput
    rules:
      * type: "maxLength[65535]"
        prompt: "sample output cannot be longer than 65535"
      ...

  # upload
  upload:
    identifier: \upload
    rules:
      * type: 'empty'
        prompt: 'please select file first'
      ...

  # submission
  code:
    identifier: \code
    rules:
      * type: 'minLength[4]'
        prompt: 'code minimum length is 4'
      * type: 'maxLength[65535]'
        prompt: 'code length cannot exceed 65535'
  language:
    identifier: \language
    rules:
      * type: 'empty'
        prompt: 'language cannot be empty'
      ...

  # pack
  begin-time:
    identifier: \beginTime
    rules:
      * type: \isTime
        prompt: 'start time should be valid'
      ...
  end-time:
    identifier: \endTime
    rules:
      * type: \isTime
        prompt: 'start time should be valid'
      ...