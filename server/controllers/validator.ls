require! {
  \koa-joi-router : {Joi}
  \../../common/options
}

export user = ->
  Joi .string! .required! .min options.user._id.$min .max options.user._id.$max

export problem = ->
  Joi .number! .required! .integer! .min 1

export round = ->
  Joi .number! .required! .integer! .min 0

export submission = ->
  Joi .number! .required! .integer! .min 1

export permit = ->
  Joi .object! .options presence: \required .keys do
    owner: user!
    group: Joi .string! .min options.permit.group.$min .max options.permit.group.$max
    access: Joi .string! .regex /^([r-][w-][x-]){3}$/

export email = ->
  Joi .string! .email!
