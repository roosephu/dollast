import Vue from 'vue'
import Router from 'vue-router'
import Index from '@/components/Site/Index'
import About from '@/components/Site/About'

import RoundShow from '@/components/Round/Show'
import RoundDefault from '@/components/Round/Default'
import RoundUpdate from '@/components/Round/Update'
import RoundBoard from '@/components/Round/Board'
import RoundList from '@/components/Round/List'
import RoundCreate from '@/components/Round/Create'

import ProblemShow from '@/components/Problem/Show'
import ProblemCreate from '@/components/Problem/Create'
import ProblemUpdate from '@/components/Problem/Update'
import ProblemStat from '@/components/Problem/Stat'
import ProblemData from '@/components/Problem/Data'

import SubmissionShow from '@/components/Submission/Show'
import SubmissionList from '@/components/Submission/List'

import UserShow from '@/components/User/Profile'
import UserLogin from '@/components/User/Login'
import UserRegister from '@/components/User/Register'
import UserUpdate from '@/components/User/Update'

Vue.use(Router)

export default new Router({
  routes: [
    { path: '/', component: Index },
    { path: '/about', component: About },

    { path: '/problem', redirect: '/round/default' },
    { path: '/problem/create', component: ProblemCreate },
    { path: '/problem/:problemId', name: 'problem', component: ProblemShow },
    { path: '/problem/:problemId/update', component: ProblemUpdate },
    { path: '/problem/:problemId/stat', component: ProblemStat },
    { path: '/problem/:problemId/data', component: ProblemData },

    { path: '/submission', name: 'submissions', component: SubmissionList },
    { path: '/submission/:submissionId', component: SubmissionShow },

    { path: '/round', component: RoundList },
    { path: '/round/create', component: RoundCreate },
    { path: '/round/default', component: RoundDefault },
    { path: '/round/:roundId', name: 'round', component: RoundShow },
    { path: '/round/:roundId/update', component: RoundUpdate },
    { path: '/round/:roundId/board', component: RoundBoard },

    { path: '/user', component: UserShow },
    { path: '/user/login', component: UserLogin },
    { path: '/user/register', component: UserRegister },
    { path: '/user/:userId', component: UserShow },
    { path: '/user/:userId/update', component: UserUpdate },

    { path: '*', redirect: '/' }
  ]
})
