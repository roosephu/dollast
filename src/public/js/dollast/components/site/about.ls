require! {
  \react/addons : R
  \prelude-ls : P
}

hidden-items = R.create-class do
  dispay-name: \hidden-items
  render: ->
    _div {},
      for text in @props.text
        _p key: text.id, text

faq-item = R.create-class do
  dispay-name: \faq-item
  render: ->
    _div {},
      _h3 {}, @props.question
      _h4 {}, @props.answer
      _ hidden-items, text: @props.hidden
      _br {}

module.exports = R.create-class do
  display-name: \about
  render: ->
    todos =
      * "user register"
      * "sols for a prob"
      * "user profile"
      * "request system"
      * "comment system(disqus)"
      * "test a program"

    _div {},
      _p {}, "Hi 小朋友们大家好，还记得我是谁吗，对了我就是青年理论计算机科学家 BBL ！（背景音乐：我可是世界上最厉害的……）"
      _p {}, "为了答谢广大人民群众对我的厚爱，以及老师们拉着我非要我写一个 OJ 出来，我就花了几个星期码了这样一个网站出来 →_→ "

      _ faq-item,
        question: "Q: 为何这网站如此具有朴素简洁美？"
        answer: "A: 朴实沉毅乃校训，不可忘怀。（其实是我懒得做 UI 了 = =）"
        hidden:
          * "有兴趣的同学可以自己设计一套 UI 给我……聪明的同学已经发现了我网站的架构了：每次 get 一个网页作为模板，所以只需要写一套 partials 里面的东西就可以了……"
          * "我才不会告诉你们我早就写好了 theme 功能，就差一个美工了 →_→"

      _ faq-item,
        question: "Q: 为什么要起一个 dollast 这种中二的名字？"
        answer: "A: 我也不知道你快来咬我呀哈哈哈哈…… 因为这边儿名字是 YXJ 起的 →_→"
        hidden:
          * "其实我早就做好了准备，要改名字只要一行命令就可以了 233"
          ...

      _ faq-item,
        question: "Q: 那请问贵站有哪些特性？"
        answer: "A: 终于有人肯问一个正常点的问题了！我们目前只支持两个特性：1. 朴素 2. 不能评测……因为没写完。"
        hidden:
          * "我的美妙的寒假全葬送在这个网站上了……说好的青年理论计算机科学家呢 →_→"
          ...

      _ faq-item,
        question: "Q: 你写这个 OJ ，是不是要钦点成为 CJ 的校内 OJ？"
        answer: "A: 我没有任何这个意思。你们有一个好，刷题刷的比谁都快，但是问来问去的问题，too simple。西方的那个 OJ 我没用过？美国的 SPOJ，不知道比你们快到哪去了，我用的谈笑风生。你们啊，too young，sometimes naive。"
        hidden:
          * "再问我就烂尾啦 = ="
          ...

      _ faq-item,
        question: "Q: 那么具体说来你用的是怎样一个架构？"
        answer: "A: M(ongoDB)A(ngularjs)N(odejs)K(oa) ，外加一个 cpp 作为沙盒。目前发现没什么代码量……"
        hidden:
          * "据说码代码的时间只要学习新姿势的一半，学习新姿势的时间只要调试的一半"
          ...

      _h3 {}, "todo list"
      _ul {},
        for todo in todos
          _li key: todo.id, todo
