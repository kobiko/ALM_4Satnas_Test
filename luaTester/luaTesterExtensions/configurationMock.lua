
m_configurationTables = {}

function createPackageConfigMock(package, fileName, table)
  
  if (fileName == nil) then
    fileName = "!withoutFileName"
  end
  
  if (m_configurationTables[package] == nil) then
    m_configurationTables[package] = {}
  end
  
  m_configurationTables[package][fileName] = table
  
end

function getPackageConfig(package, fileName)
  
  if (fileName == nil) then
    fileName = "!withoutFileName"
  end  
  
  return m_configurationTables[package][fileName]
  
end

