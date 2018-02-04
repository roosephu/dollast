import Vue from 'vue'
import Router from 'vue-router'
import index from '@/components/site/index'
import about from '@/components/site/about'

import roundShow from '@/components/round/show'
import roundDefault from '@/components/round/default'
import roundUpdate from '@/components/round/update'
import roundBoard from '@/components/round/board'
import roundList from '@/components/round/list'
import roundCreate from '@/components/round/create'

import problemShow from '@/components/problem/show'
import problemCreate from '@/components/problem/create'
import problemUpdate from '@/components/problem/update'
import problemStat from '@/components/problem/stat'
import problemData from '@/components/problem/data'

import submissionShow from '@/components/submission/show'
import submissionList from '@/components/submission/list'

import userShow from '@/components/user/profile'
import userLogin from '@/components/user/login'
import userRegister from '@/components/user/register'
import userUpdate from '@/components/user/update'

Vue.use(Router)

export default new Router({
  routes: [
    { path: '/', component: index },
    { path: '/about', component: about },

    { path: '/problem', redirect: '/round/default' },
    { path: '/problem/create', component: problemCreate },
    { path: '/problem/:problemId', name: 'problem', component: problemShow },
    { path: '/problem/:problemId/update', component: problemUpdate },
    { path: '/problem/:problemId/stat', component: problemStat },
    { path: '/problem/:problemId/data', component: problemData },

    { path: '/submission', name: 'submissions', component: submissionList },
    { path: '/submission/:submissionId', component: submissionShow },

    { path: '/round', component: roundList },
    { path: '/round/create', component: roundCreate },
    { path: '/round/default', component: roundDefault },
    { path: '/round/:roundId', name: 'round', component: roundShow },
    { path: '/round/:roundId/update', component: roundUpdate },
    { path: '/round/:roundId/board', component: roundBoard },

    { path: '/user', component: userShow },
    { path: '/user/login', component: userLogin },
    { path: '/user/register', component: userRegister },
    { path: '/user/:userId', component: userShow },
    { path: '/user/:userId/update', component: userUpdate },

    { path: '*', redirect: '/' }
  ]
})
