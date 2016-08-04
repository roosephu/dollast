<template lang="jade">
  .ui.dropdown
    input(type="hidden", name="???")
    .default.text
    i.dropdown.icon
    .menu
      .item(v-for="(key, item) of " data-value="")
export dropdown = create-class do
  display-name: \dropdown

  component-did-mount: ->
    $ ".dropdown.ui" .dropdown!

  render: ->
    classes = add-class-name @props, "dropdown"
    _ ui, classes,
      _ \input, type: \hidden, name: @props.name
      _ \div, class-name: "default text", @props.default
      _ \i, class-name: "dropdown icon"
      _ \div, class-name: "menu",
        for key, val of @props.options
          _ \div, class-name: "item", "data-value": key, key: key,
            val

</template>

<script lang="livescript">
</script>
