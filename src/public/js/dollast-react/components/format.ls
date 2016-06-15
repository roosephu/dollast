require! {
  \react : {create-class}
  \classnames
  \./elements : {icon-text}
  \moment
}

export prob-fmt = (prob) ->
  "#{prob._id}. #{prob.outlook.title}"

export code-link = create-class do
  display-name: \code

  render: ->
    class-name = classnames @props.class-name, 'ui label grey'
    _ \a, class-name: class-name, href: "#/solution/#{@props.sid}", @props.text || "#{@props.sid}"
    # _ icon-text,
    #   class-name: class-name
    #   icon: \code
    #   text: @props.text || "#{@props.sid}"
    #   href: "#/solution/#{@props.sid}"

export prob-link = create-class do
  display-name: \problem

  render: ->
    class-name = classnames @props.class-name, 'ui label green'
    id = @props.prob._id

    if id > 0
      title = @props.prob.outlook.title
      _ \a, class-name: class-name, href: "#/problem/#{id}", "#{id}. #{title}"
      # _ icon-text,
      #   class-name: class-name
      #   icon: \puzzle
      #   text: "#{id}. #{title}"
      #   href: "#/problem/#{id}"
    else
      _ \a, class-name: class-name, \hidden
      # _ icon-text,
      #   class-name: class-name
      #   icon: \puzzle
      #   text: \hidden

export rnd-link = create-class do
  display-name: \round

  render: ->
    class-name = classnames @props.class-name, 'ui label light teal'
    if @props.no-title == true
      text = "#{@props.rnd._id}"
    else
      text = "#{@props.rnd._id}. #{@props.rnd.title}"

    _ \a, class-name: class-name, href: "#/round/#{@props.rnd._id}", text
    # _ icon-text,
    #   class-name: class-name
    #   icon: \idea
    #   text: text
    #   href: "#/round/#{@props.rnd._id}"

export user-link = create-class do
  display-name: \user

  render: ->
    class-name = classnames @props.class-name, 'ui label'
    _ \a, class-name: class-name, href: "#/user/#{@props.user}", "#{@props.user}"
    # _ icon-text,
    #   class-name: class-name
    #   icon: \user
    #   text: "#{@props.user}"
    #   href: "#/user/#{@props.user}"

export round-time = create-class do
  display-name: \round-time

  render: ->
    style =
      if moment!.is-before @props.beg-time
        \green
      else if moment!.is-after @props.end-time
        \grey
      else
        \red
    _ \div, null,
      " from "
      _ \div, class-name: "ui label #{style}",
        moment @props.beg-time .format 'YYYY-MM-DD hh:mm:ss'
      " to "
      _ \div, class-name: "ui label #{style}",
        moment @props.end-time .format 'YYYY-MM-DD hh:mm:ss'
