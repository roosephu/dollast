require! {
  \react/addons : {create-class}
  \react-redux : {connect}
  \immutable : I
  \../elements : {dropdown, icon-text}
}

log = debug \dollast:component:round:list

module.exports = create-class do
  display-name: \rnd-list
  
  filter: (value, text, $choice) ->
    log {value, text, $choice}
  
  component-did-mount: ->
    $filter = $ '.dropdown'
    log $filter
    $filter.dropdown do
      on: \hover
      on-change: @filter
    $filter.dropdown 'set text', \all
  
  render: ->
    
    _div class-name: \ui,
      _h1 class-name: "ui header dividing", \rounds
      _ dropdown,
        class-name: "floated pointing button labeled icon"
        name: \filter
        default: "please select filter"
        options: {\all, \past, \running, \pending}
      
      _ icon-text, 
        class-name: "launch primary right floated"
        text: \create
        icon: \plus
        href: \#/round/create
