<template lang="jade">
window
  div(slot="main")
    p Hi 小朋友们大家好，还记得我是谁吗，对了我就是青年理论计算机科学家 BBL ！（背景音乐：我可是世界上最厉害的……
    p 为了答谢广大人民群众对我的厚爱，以及老师们拉着我非要我写一个 OJ 出来，我就花了几个星期码了这样一个网站出来 →_→

    .ui.styled.accordion
      .title
        i.dropdown.icon
        | 为何这网站如此具有朴素简洁美？
      .content
        .transition.hidden
          p 朴实沉毅乃校训，不可忘怀。（其实是我懒得做 UI 了 = =）
          p 有兴趣的同学可以自己设计一套 UI 给我……聪明的同学已经发现了我网站的架构了：每次 get 一个网页作为模板，所以只需要写一套 partials 里面的东西就可以了……
          p 我才不会告诉你们我早就写好了 theme 功能，就差一个美工了 →_→

      .title
        i.dropdown.icon
        | 为什么要起一个 dollast 这种中二的名字？
      .content
        .transition.hidden
          p 我也不知道你快来咬我呀哈哈哈哈…… 因为这边儿名字是 YXJ 起的 →_→
          p 其实我早就做好了准备，要改名字只要一行命令就可以了 233

      .title
        i.dropdown.icon
        | 那请问贵站有哪些特性？
      .content
        .transition.hidden
          p 终于有人肯问一个正常点的问题了！我们目前只支持两个特性：1. 朴素 2. 不能评测……因为没写完。
          p 我的美妙的寒假全葬送在这个网站上了……说好的青年理论计算机科学家呢 →_→

      .title
        i.dropdown.icon
        | 你写这个 OJ ，是不是要钦点成为 CJ 的校内 OJ？
      .content
        .transition.hidden
          p 我没有任何这个意思。你们有一个好，刷题刷的比谁都快，但是问来问去的问题，too simple。西方的那个 OJ 我没用过？美国的 SPOJ，不知道比你们快到哪去了，我用的谈笑风生。你们啊，too young，sometimes naive。
          p 再问我就烂尾啦 = =

      .title
        i.dropdown.icon
        | 那么具体说来你用的是怎样一个架构？
      .content
        .transition.hidden
          p
            del M(ongoDB)A(ngularjs)N(odejs)K(oa) ，外加一个 cpp 作为沙盒。目前发现没什么代码量……
            | I used months to refactor the code from Angular.js to
            del React.js
            | Vue.js. The backend remains to be Koa.js
          p 据说码代码的时间只要学习新姿势的一半，学习新姿势的时间只要调试的一半

      .title
        i.dropdown.icon
        | 你旁边那个 Function 到底是个什么东西啊，怎么点进去一点反应也没有？
      .content
        .transition.hidden
          p 根据上下文。在某些界面有，某些界面没有。
          p 试图搞出一个提示出来，但是失败了就懒得去搞了。
          p bbl 尽力啦，逗比不怪他。你说他不行，你行你上啊。
</template>

<script>
import window from '../window'

export default {
  components: {
    window
  },

  mounted () {
    $('.accordion').accordion()
  }
}
</script>
