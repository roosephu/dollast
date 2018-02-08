import moment from 'moment'
import Vue from 'vue'
import codeLink from './codeLink'
import problem from './problem'
import user from './user'
import round from './round'

Vue.filter('problem', problem => {
  if (problem) {
    return `${problem._id}. ${problem.title}`
  }
  return ''
})

Vue.filter('round', round => {
  // if (round._id == 0) {
  //   return 'Problemset'
  // } else {
  return `${round._id}. ${round.title}`
  // }
})

Vue.filter('user', user => user._id)

Vue.filter('time', time => moment(time).format('YYYY MMM Do HH:mm:ss'))

Vue.filter('decimal', (value, fixed) => {
  if (typeof value !== 'number') {
    return ''
  } else {
    return Number(value).toFixed(fixed)
  }
})

Vue.filter('conciseTime', time => moment(time).format('YYYY-MM_DD HH:mm:ss'))

export default {
  codeLink,
  problem,
  round,
  user
}
