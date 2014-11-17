createLibPersistencyMock = function()
  
	local persistencyMock = {}
  
  local m_values = {}
  
  function persistencyMock:getValue(key)
    
    if (m_values[key] == nil) then
      return 0
    else
      return m_values[key]
    end
    
  end

  function persistencyMock:setValue(key, value)
    
    m_values[key] = value
    
  end

  return persistencyMock
end

persistency = {}

function persistency:getPackagePersistency(package, fileName)
  return createLibPersistencyMock()
end