{View} = require 'atom'

module.exports =
class ClangFlagsView extends View
  @content: ->
    @div class: 'clang-flags overlay from-top', =>
      @div "The ClangFlags package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "clang-flags:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "ClangFlagsView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
