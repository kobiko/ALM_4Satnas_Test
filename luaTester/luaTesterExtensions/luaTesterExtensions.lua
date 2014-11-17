local configurationMockFileName = "configurationReal.lua"
local persistencyMockFileName = "persistencyMock.lua"
local manifestParserFileName = "manifestParser.lua"
local messageBoxMockFileName = "messageBoxMock.lua"
luaTesterExtensionsPath = "luaTester.luaTesterExtensions."

require(luaTesterExtensionsPath..string.gsub(configurationMockFileName, ".lua", ""))
require(luaTesterExtensionsPath..string.gsub(persistencyMockFileName,".lua",""))
require(luaTesterExtensionsPath..string.gsub(manifestParserFileName, ".lua", ""))
require(luaTesterExtensionsPath..string.gsub(messageBoxMockFileName, ".lua", ""))
manifestParser.executeRequires("res/TabTale.manifest")

