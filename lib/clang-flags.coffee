# ClangFlagsView = require './clang-flags-view'
path = require 'path'
{readFileSync} = require 'fs'
{File, Directory} = require 'pathwatcher'

module.exports =
  getClangFlags: (fileName) ->
    flags = getClangFlagsCompDB(fileName)
    if flags
      getClangFlagsDotClangComplete(fileName)
    return flags
  activate: (state) ->

getFileContents = (startFile, fileName) ->
  searchDir = path.dirname startFile
  args = []
  while searchDir.length
    searchFilePath = path.join searchDir, fileName
    searchFile = new File(searchFilePath)
    if searchFile.exists()
      contents = ""
      try
        contents = readFileSync(searchFilePath, 'utf8')
        return contents
      catch error
        console.log "clang-flags for " + fileName + " couldn't read file " + searchFilePath
        console.log error
      return null
    thisDir = new Directory(searchDir)
    if thisDir.isRoot()
      break
    searchDir = thisDir.getParent().getPath()
  return null

getClangFlagsCompDB = (fileName) ->
  compDBContents = getFileContents(fileName, "compile_commands.json")
  args = 0
  if compDBContents.length > 0
    compDB = JSON.parse(compDBContents)
    for config in compDB
      if fileName == path.join config['directory'], config['file']
        #Find the file here
        args = args.concat ["-working-directory=#{config['directory']}"]
  return args

getClangFlagsDotClangComplete = (fileName) ->
  clangCompleteContents = getFileContents(fileName, ".clang_complete")
  args = []
  if clangCompleteContents.length > 0
    args = clangCompleteContents.split("\n")
    args = args.concat ["-working-directory=#{searchDir}", "-c #{fileName}"]
  return args
