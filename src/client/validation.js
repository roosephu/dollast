import moment from 'moment'
import { debug } from 'debug'

const log = debug('dollast:validation')

const extraRules = {
  positive (text) {
    return parseFloat(text) > 0
  },

  isTime (text) {
    return moment(text, 'YYYY-MM-DD HH:mm:ss').isValid()
  },

  isPassword (text) {
    return text.length >= 4 && text.length <= 15
  },

  isUserId (text) {
    return /^[a-zA-Z0-9._]*$/.test(text)
  },

  isObjectId (text) {
    return /^[0-9a-f]{24}$/.test(text)
  },

  isAccess (text) {
    return /^([r-][w-][x-]){3}$/.test(text)
  }
}

const extraPrompts = {
  positive: '{name} must be greater than 0',
  isTime: '{name} must indicate a valid time',
  // isPassword: '{name} must be '
  isUserId: '{name} must contain only numbers, alphabets or underscore (_)',
  isObjectId: '{name} must contain only numbers and lowercase a-f'
}

$.fn.form.settings.inline = true
$.fn.form.settings.on = 'blur'
$.extend($.fn.form.settings.rules, extraRules)
$.extend($.fn.form.settings.prompt, extraPrompts)

// for (const [key, val] of Object.entries(extraRules)) {
//   $.fn.form.settings.rules[key] = val
// }

// $.fn.form.settings.defaults = {
//   user: ['minLength[6]', 'maxLength[16]', 'isUserId'],
//   round: ['exactLength[24]', 'isObjectId'],
//   problem: ['exactLength[24]', 'isObjectId'],
//   password: ['minLength[6]', 'maxLength[16]', 'isPassword'],
//   email: 'email',

//   // permit
//   owner: ['minLength[6]', 'maxLength[16]', 'isUserId'],
//   group: ['minLength[6]', 'maxLength[16]', 'isUserId'],
//   access: 'isAccess'
// }
