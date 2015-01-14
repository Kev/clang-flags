# ClangFlagsView = require './clang-flags-view'
path = require 'path'
{readFileSync} = require 'fs'
{File, Directory} = require 'pathwatcher'

module.exports =
  getClangFlags: (fileName) ->
    flags = getClangFlagsCompDB(fileName)
    if flags.length == 0
      flags = getClangFlagsDotClangComplete(fileName)
    return flags
  activate: (state) ->

getFileContents = (startFile, fileName) ->
  searchDir = path.dirname startFile
  args = []
  while searchDir.length
    searchFilePath = path.join searchDir, fileName
    searchFile = new File(searchFilePath)
    if searchFile.exists()
      try
        contents = readFileSync(searchFilePath, 'utf8')
        return [searchDir, contents]
      catch error
        console.log "clang-flags for " + fileName + " couldn't read file " + searchFilePath
        console.log error
      return [null, null]
    thisDir = new Directory(searchDir)
    if thisDir.isRoot()
      break
    searchDir = thisDir.getParent().getPath()
  return [null, null]

getClangFlagsCompDB = (fileName) ->
  [searchDir, compDBContents] = getFileContents(fileName, "compile_commands.json")
  args = []
  if compDBContents != null && compDBContents.length > 0
    compDB = JSON.parse(compDBContents)
    for config in compDB
      if fileName == path.join config['directory'], config['file']
        #Find the file here
        args = args.concat ["-working-directory=#{config['directory']}"]
  return args

getClangFlagsDotClangComplete = (fileName) ->
  [searchDir, clangCompleteContents] = getFileContents(fileName, ".clang_complete")
  args = []
  if clangCompleteContents != null && clangCompleteContents.length > 0
    args = clangCompleteContents.trim().split("\n")
    args = args.concat ["-working-directory=#{searchDir}"]
  return args
