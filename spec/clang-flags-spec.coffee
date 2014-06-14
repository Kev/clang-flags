{WorkspaceView} = require 'atom'
ClangFlags = require '../lib/clang-flags'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ClangFlags", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('clang-flags')

  describe "when the clang-flags:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.clang-flags')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'clang-flags:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.clang-flags')).toExist()
        atom.workspaceView.trigger 'clang-flags:toggle'
        expect(atom.workspaceView.find('.clang-flags')).not.toExist()
