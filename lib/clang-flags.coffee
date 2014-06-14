# ClangFlagsView = require './clang-flags-view'
path = require 'path'
{readFileSync} = require 'fs'
{File, Directory} = require 'pathwatcher'

module.exports =
  GetClangFlags: getClangFlags
  activate: (state) ->

getClangFlags = (fileName) ->
  getClangFlagsDotClangComplete(fileName)
    
getClangFlagsDotClangComplete = (fileName) ->
  # If someone already has a .clang_complete from vim configured, use that.
  searchDir = path.dirname fileName
  args = []
  while searchDir.length
    searchFilePath = path.join searchDir, ".clang_complete"
    searchFile = new File(searchFilePath)
    if searchFile.exists()
      contents = ""
      try
        contents = readFileSync(searchFilePath, 'utf8')
      catch error
        console.log "clang-flags for " + fileName + " couldn't read file " + searchFilePath
        console.log error
      contentsArray = contents.split("\n")
      args = args.concat contentsArray
      args = args.concat ["-working-directory=#{searchDir}"] # All the includes will be relative to the .clang_complete
      break
    thisDir = new Directory(searchDir)
    if thisDir.isRoot()
      break
    searchDir = thisDir.getParent().getPath()
  return args
