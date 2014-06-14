ClangFlagsView = require './clang-flags-view'

module.exports =
  clangFlagsView: null

  activate: (state) ->
    @clangFlagsView = new ClangFlagsView(state.clangFlagsViewState)

  deactivate: ->
    @clangFlagsView.destroy()

  serialize: ->
    clangFlagsViewState: @clangFlagsView.serialize()
