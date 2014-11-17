
if services == nil then 
  services = {}
  
end
local counter = 0
function services:debugMessageBox(title, text)
  counter = counter + 1
  local bool = os.execute("terminal-notifier -message \""..text.."\" -title \"luaTester:"..title.."\"")
  
  print(text)
  if bool == nil then
    local text = "luaTester: Cannot display messages. please run the following command: sudo gem install terminal-notifier"
    print(text)
    os.execute("osascript -e 'tell app \"System Events\" to display dialog \""..text.."\"'")
  end
  
end
