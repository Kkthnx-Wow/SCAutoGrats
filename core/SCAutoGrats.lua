SC = {};
------------------------------
-- Register Slash Commands! --
------------------------------
	SLASH_RELOADUI1 = "/rl";
	SlashCmdList.RELOADUI = ReloadUI;
	
	SLASH_FRAMESTK1 = "/fs";
	SlashCmdList.FRAMESTK = function()
		LoadAddOn("Blizzard_DebugTools");
		FrameStackTooltip_Toggle();
	end

	SLASH_SC1 = "/sc";
    SLASH_SC2 = "/autograts";
	SlashCmdList.SC = SC_Command;

-----------------------
-- On Load Functions --
-----------------------
	
function SC_OnLoad(self)
    self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_PARTY")
    self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("GUILD_ROSTER_UPDATE")
	
    if(SC_GratsMessage1 == nil or "")then
		SC_GratsMessage1 = "Grats!";
	end
	if(SC_GratsMessage2 == nil or "")then
		SC_GratsMessage2 = SC_GratsMessage1;
	end
	if(SC_GratsMessage3 == nil or "")then
		SC_GratsMessage3 = SC_GratsMessage1;
	end
	if(SC_GuildJoinMessageToggle == nil)then
		SC_GuildJoinMessageToggle = true;
	end
	if(SC_Guild == nil)then
		SC_Guild = true;
	end
	if(SC_Say == nil)then
		SC_Say = false;
	end
	if(SC_Party == nil)then
		SC_Party = true;
	end
	if(SC_Delay == nil)then
		SC_Delay=4000;
	end
	if(SC_GroupingTime == nil)then
		SC_GroupingTime=6000;
	end
	if(SC_GuildDisabledOverride == nil)then
		SC_GuildDisabledOverride = false;
	end
	if(SC_GuildWelcomeMessage1 == nil)then
		SC_GuildWelcomeMessage1 = "Welcome!";
	end
	if(SC_GuildWelcomeMessage2 == nil or "")then
		SC_GuildWelcomeMessage2 = SC_GuildWelcomeMessage1;
	end
		if(SC_GuildWelcomeMessage3 == nil or "")then
		SC_GuildWelcomeMessage3 = SC_GuildWelcomeMessage1;
	end
	SC_SetupOptionsUI();
	SC_Print("SC Auto Grats! Enabled");
end

-----------------------------
-- Interface Options Panel --
-----------------------------

function SC_SetupOptionsUI()
	SC_AutoGrats = {};
	SC_AutoGrats.ui = {};
	SC_AutoGrats.ui.panel = CreateFrame( "Frame", "SC_AutoGratsPanel", InterfaceOptionsFramePanelContainer );
	SC_AutoGrats.ui.panel:SetFrameLevel(0)
	SC_AutoGrats.ui.panel:SetAlpha(1)
	SC_AutoGrats.ui.panel.name = "SC Auto Grats!";

----------------------------------	
-- Shadow Collective Guild Logo --
----------------------------------

	SC_AutoGrats.ui.guildlogo = CreateFrame("Frame","guildlogo",SC_AutoGrats.ui.panel)
	SC_AutoGrats.ui.guildlogo:SetFrameLevel(100)
	SC_AutoGrats.ui.guildlogo:SetAlpha(0.75)
	SC_AutoGrats.ui.guildlogo:SetWidth(200)
	SC_AutoGrats.ui.guildlogo:SetHeight(200)
	SC_AutoGrats.ui.guildlogo:SetPoint("BOTTOMRIGHT",SC_AutoGrats.ui.panel,"BOTTOMRIGHT",-35,35)
	SC_AutoGrats.ui.guildlogo.text = SC_AutoGrats.ui.guildlogo:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SC_AutoGrats.ui.guildlogo.text:SetPoint("CENTER")
	SC_AutoGrats.ui.guildlogo.texture = SC_AutoGrats.ui.guildlogo:CreateTexture()
	SC_AutoGrats.ui.guildlogo.texture:SetAllPoints()
	SC_AutoGrats.ui.guildlogo.texture:SetTexture("Interface\\AddOns\\SCAutoGrats\\media\\logo.blp")
	SC_AutoGrats.ui.guildlogo.texture:Show()

------------------------
-- Guild Check Button --
------------------------

	SC_AutoGrats.ui.guildCheckButton = CreateFrame("CheckButton","SC_GuildCheckButton",SC_AutoGrats.ui.panel,"UICheckButtonTemplate") 
	SC_AutoGrats.ui.guildCheckButton:SetFrameLevel(300)
	SC_AutoGrats.ui.guildCheckButton:SetPoint("TOPLEFT",20,-20)
	SC_AutoGrats.ui.guildCheckButton.text:SetText("Guild Grats!")
	SC_AutoGrats.ui.guildCheckButton:SetScript("OnShow", function(self,event,arg1) 
		self:SetChecked(SC_Guild);
	end)
	SC_AutoGrats.ui.guildCheckButton:SetScript("OnClick", function(self,event,arg1) 
		SC_ToggleGuild();
	end)

------------------------
-- Party Check Button --
------------------------

	SC_AutoGrats.ui.partyCheckButton = CreateFrame("CheckButton","SC_PartyCheckButton",SC_AutoGrats.ui.panel,"UICheckButtonTemplate")
	SC_AutoGrats.ui.partyCheckButton:SetFrameLevel(300)
	SC_AutoGrats.ui.partyCheckButton:SetPoint("TOPLEFT",20,-50)
	SC_AutoGrats.ui.partyCheckButton.text:SetText("Party Grats!")
	SC_AutoGrats.ui.partyCheckButton:SetScript("OnShow", function(self,event,arg1) 
		self:SetChecked(SC_Party);
	end)
	SC_AutoGrats.ui.partyCheckButton:SetScript("OnClick", function(self,event,arg1) 
		SC_ToggleParty();
	end)
	
----------------------
-- Say Check Button --
----------------------

	SC_AutoGrats.ui.sayCheckButton = CreateFrame("CheckButton","SC_SayCheckButton",SC_AutoGrats.ui.panel,"UICheckButtonTemplate")
	SC_AutoGrats.ui.sayCheckButton:SetFrameLevel(300)
	SC_AutoGrats.ui.sayCheckButton:SetPoint("TOPLEFT",20,-80)
	SC_AutoGrats.ui.sayCheckButton.text:SetText("Say Grats!")
	SC_AutoGrats.ui.sayCheckButton:SetScript("OnShow", function(self,event,arg1) 
		self:SetChecked(SC_Say);
	end)
	SC_AutoGrats.ui.sayCheckButton:SetScript("OnClick", function(self,event,arg1) 
		SC_ToggleSay();
	end)

--------------------------------
-- Guild Welcome Check Button --
--------------------------------

	SC_AutoGrats.ui.guildWelcomeCheckButton = CreateFrame("CheckButton","SC_GuildWelcomeCheckButton",SC_AutoGrats.ui.panel,"UICheckButtonTemplate")
	SC_AutoGrats.ui.guildWelcomeCheckButton:SetFrameLevel(300)
	SC_AutoGrats.ui.guildWelcomeCheckButton:SetPoint("TOPLEFT",20,-110)
	SC_AutoGrats.ui.guildWelcomeCheckButton.text:SetText("Guild Member Welcome!")
	SC_AutoGrats.ui.guildWelcomeCheckButton:SetScript("OnShow", function(self,event,arg1) 
		self:SetChecked(SC_GuildJoinMessageToggle);
	end)
	SC_AutoGrats.ui.guildWelcomeCheckButton:SetScript("OnClick", function(self,event,arg1) 
		SC_ToggleGuildWelcome();
	end)

------------------
-- Delay Slider --
------------------

	SC_AutoGrats.ui.delaySlider = CreateBasicSlider(SC_AutoGrats.ui.panel, "SC_DelaySlider", "Message Send Delay", 0, 10000, 1000);
	SC_AutoGrats.ui.delaySlider:HookScript("OnValueChanged", function(self,value)
		SC_Delay = floor(value)
	end)
	SC_AutoGrats.ui.delaySlider:HookScript("OnShow", function(self,value)
		self:SetValue(SC_Delay);
		self.editbox:SetNumber(SC_Delay);
	end)
	SC_AutoGrats.ui.delaySlider.editbox:SetScript("OnShow", function(self,event,arg1)
		self:SetNumber(SC_Delay);
	end)
	SC_AutoGrats.ui.delaySlider:SetPoint("TOPRIGHT",-120,-20)

---------------------
-- Grouping Slider --
---------------------

	SC_AutoGrats.ui.groupingSlider = CreateBasicSlider(SC_AutoGrats.ui.panel, "SC_GroupingSlider", "After Message Send Delay", 0, 10000, 1000);
	SC_AutoGrats.ui.groupingSlider:HookScript("OnValueChanged", function(self,value)
		SC_GroupingTime = floor(value)
	end)
	SC_AutoGrats.ui.groupingSlider:HookScript("OnShow", function(self,value)
		self:SetValue(SC_GroupingTime);
		self.editbox:SetNumber(SC_GroupingTime);
	end)
	SC_AutoGrats.ui.groupingSlider.editbox:SetScript("OnShow", function(self,event,arg1)
		self:SetNumber(SC_GroupingTime);
	end)
	SC_AutoGrats.ui.groupingSlider:SetPoint("TOPRIGHT",-120,-100)

---------------------
-- Grats Message 1 --
---------------------

	SC_AutoGrats.ui.gratsMessageEditBox = CreateFrame("EditBox", "SC_GratsMessage1", SC_AutoGrats.ui.panel, "InputBoxTemplate")
	SC_AutoGrats.ui.gratsMessageEditBox:SetFrameLevel(300)
	SC_AutoGrats.ui.gratsMessageEditBox:SetSize(500,30)
	SC_AutoGrats.ui.gratsMessageEditBox:SetMultiLine(false)
    SC_AutoGrats.ui.gratsMessageEditBox:ClearAllPoints()
	SC_AutoGrats.ui.gratsMessageEditBox:SetPoint("TOPLEFT",20,-180)
	SC_AutoGrats.ui.gratsMessageEditBox:SetCursorPosition(0);
	SC_AutoGrats.ui.gratsMessageEditBox:ClearFocus();
    SC_AutoGrats.ui.gratsMessageEditBox:SetAutoFocus(false)
	SC_AutoGrats.ui.gratsMessageEditBox:SetScript("OnShow", function(self,event,arg1)
		self:SetText(SC_GratsMessage1)
		self:SetCursorPosition(0);
		self:ClearFocus();
	end)
	SC_AutoGrats.ui.gratsMessageEditBox:SetScript("OnTextChanged", function(self,value)
		SC_GratsMessage1 = self:GetText()
	end)
	SC_AutoGrats.ui.gratsMessageLabel = CreateBasicFontString(SC_AutoGrats.ui.gratsMessageEditBox,"SC_GratsMessageLabel","OVERLAY","GameFontNormal","Grats Message 1");
	SC_AutoGrats.ui.gratsMessageLabel:SetPoint("BOTTOMLEFT", SC_AutoGrats.ui.gratsMessageEditBox, "TOPLEFT", 0, 0)
	
---------------------
-- Grats Message 2 --
---------------------
	
	SC_AutoGrats.ui.gratsMessageEditBox = CreateFrame("EditBox", "SC_GratsMessage2", SC_AutoGrats.ui.panel, "InputBoxTemplate")
	SC_AutoGrats.ui.gratsMessageEditBox:SetFrameLevel(300)
	SC_AutoGrats.ui.gratsMessageEditBox:SetSize(500,30)
	SC_AutoGrats.ui.gratsMessageEditBox:SetMultiLine(false)
    SC_AutoGrats.ui.gratsMessageEditBox:ClearAllPoints()
	SC_AutoGrats.ui.gratsMessageEditBox:SetPoint("TOPLEFT",20,-240)
	SC_AutoGrats.ui.gratsMessageEditBox:SetCursorPosition(0);
	SC_AutoGrats.ui.gratsMessageEditBox:ClearFocus();
    SC_AutoGrats.ui.gratsMessageEditBox:SetAutoFocus(false)
	SC_AutoGrats.ui.gratsMessageEditBox:SetScript("OnShow", function(self,event,arg1)
		self:SetText(SC_GratsMessage2)
		self:SetCursorPosition(0);
		self:ClearFocus();
	end)
	SC_AutoGrats.ui.gratsMessageEditBox:SetScript("OnTextChanged", function(self,value)
		SC_GratsMessage2 = self:GetText()
	end)
	SC_AutoGrats.ui.gratsMessageLabel = CreateBasicFontString(SC_AutoGrats.ui.gratsMessageEditBox,"SC_GratsMessageLabel","OVERLAY","GameFontNormal","Grats Message 2");
	SC_AutoGrats.ui.gratsMessageLabel:SetPoint("BOTTOMLEFT", SC_AutoGrats.ui.gratsMessageEditBox, "TOPLEFT", 0, 0)

---------------------
-- Grats Message 3 --
---------------------

	SC_AutoGrats.ui.gratsMessageEditBox = CreateFrame("EditBox", "SC_GratsMessage3", SC_AutoGrats.ui.panel, "InputBoxTemplate")
	SC_AutoGrats.ui.gratsMessageEditBox:SetFrameLevel(300)
	SC_AutoGrats.ui.gratsMessageEditBox:SetSize(500,30)
	SC_AutoGrats.ui.gratsMessageEditBox:SetMultiLine(false)
    SC_AutoGrats.ui.gratsMessageEditBox:ClearAllPoints()
	SC_AutoGrats.ui.gratsMessageEditBox:SetPoint("TOPLEFT",20,-300)
	SC_AutoGrats.ui.gratsMessageEditBox:SetCursorPosition(0);
	SC_AutoGrats.ui.gratsMessageEditBox:ClearFocus();
    SC_AutoGrats.ui.gratsMessageEditBox:SetAutoFocus(false)
	SC_AutoGrats.ui.gratsMessageEditBox:SetScript("OnShow", function(self,event,arg1)
		self:SetText(SC_GratsMessage3)
		self:SetCursorPosition(0);
		self:ClearFocus();
	end)
	SC_AutoGrats.ui.gratsMessageEditBox:SetScript("OnTextChanged", function(self,value)
		SC_GratsMessage3 = self:GetText()
	end)
	SC_AutoGrats.ui.gratsMessageLabel = CreateBasicFontString(SC_AutoGrats.ui.gratsMessageEditBox,"SC_GratsMessageLabel","OVERLAY","GameFontNormal","Grats Message 3");
	SC_AutoGrats.ui.gratsMessageLabel:SetPoint("BOTTOMLEFT", SC_AutoGrats.ui.gratsMessageEditBox, "TOPLEFT", 0, 0)

-----------------------------
-- Guild Welcome Message 1 --
-----------------------------

	SC_AutoGrats.ui.guildWelcomeMessageEditBox = CreateFrame("EditBox", "SC_GuildWelcomeMessage1", SC_AutoGrats.ui.panel, "InputBoxTemplate")
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetFrameLevel(300)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetSize(500,30)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetMultiLine(false)
    SC_AutoGrats.ui.guildWelcomeMessageEditBox:ClearAllPoints()
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetPoint("TOPLEFT",20,-360)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetCursorPosition(0);
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:ClearFocus();
    SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetAutoFocus(false)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetScript("OnShow", function(self,event,arg1)
		self:SetText(SC_GuildWelcomeMessage1)
		self:SetCursorPosition(0);
		self:ClearFocus();
	end)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetScript("OnTextChanged", function(self,value)
		SC_GuildWelcomeMessage1 = self:GetText()
	end)
	SC_AutoGrats.ui.guildWelcomeMessageLabel = CreateBasicFontString(SC_AutoGrats.ui.guildWelcomeMessageEditBox,"SC_GuildWelcomeMessageLabel","OVERLAY","GameFontNormal","Guild Welcome Message 1");
	SC_AutoGrats.ui.guildWelcomeMessageLabel:SetPoint("BOTTOMLEFT", SC_AutoGrats.ui.guildWelcomeMessageEditBox, "TOPLEFT", 0, 0)

-----------------------------
-- Guild Welcome Message 2 --
-----------------------------

	SC_AutoGrats.ui.guildWelcomeMessageEditBox = CreateFrame("EditBox", "SC_GuildWelcomeMessage2", SC_AutoGrats.ui.panel, "InputBoxTemplate")
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetFrameLevel(300)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetSize(500,30)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetMultiLine(false)
    SC_AutoGrats.ui.guildWelcomeMessageEditBox:ClearAllPoints()
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetPoint("TOPLEFT",20,-420)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetCursorPosition(0);
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:ClearFocus();
    SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetAutoFocus(false)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetScript("OnShow", function(self,event,arg1)
		self:SetText(SC_GuildWelcomeMessage2)
		self:SetCursorPosition(0);
		self:ClearFocus();
	end)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetScript("OnTextChanged", function(self,value)
		SC_GuildWelcomeMessage2 = self:GetText()
	end)
	SC_AutoGrats.ui.guildWelcomeMessageLabel = CreateBasicFontString(SC_AutoGrats.ui.guildWelcomeMessageEditBox,"SC_GuildWelcomeMessageLabel","OVERLAY","GameFontNormal","Guild Welcome Message 2");
	SC_AutoGrats.ui.guildWelcomeMessageLabel:SetPoint("BOTTOMLEFT", SC_AutoGrats.ui.guildWelcomeMessageEditBox, "TOPLEFT", 0, 0)

-----------------------------
-- Guild Welcome Message 3 --
-----------------------------

	SC_AutoGrats.ui.guildWelcomeMessageEditBox = CreateFrame("EditBox", "SC_GuildWelcomeMessage3", SC_AutoGrats.ui.panel, "InputBoxTemplate")
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetFrameLevel(300)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetSize(500,30)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetMultiLine(false)
    SC_AutoGrats.ui.guildWelcomeMessageEditBox:ClearAllPoints()
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetPoint("TOPLEFT",20,-480)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetCursorPosition(0);
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:ClearFocus();
    SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetAutoFocus(false)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetScript("OnShow", function(self,event,arg1)
		self:SetText(SC_GuildWelcomeMessage3)
		self:SetCursorPosition(0);
		self:ClearFocus();
	end)
	SC_AutoGrats.ui.guildWelcomeMessageEditBox:SetScript("OnTextChanged", function(self,value)
		SC_GuildWelcomeMessage3 = self:GetText()
	end)
	SC_AutoGrats.ui.guildWelcomeMessageLabel = CreateBasicFontString(SC_AutoGrats.ui.guildWelcomeMessageEditBox,"SC_GuildWelcomeMessageLabel","OVERLAY","GameFontNormal","Guild Welcome Message 3");
	SC_AutoGrats.ui.guildWelcomeMessageLabel:SetPoint("BOTTOMLEFT", SC_AutoGrats.ui.guildWelcomeMessageEditBox, "TOPLEFT", 0, 0)
	
	InterfaceOptions_AddCategory(SC_AutoGrats.ui.panel);
	
end
		
 function SC_GetCmd(msg)
 	if msg then
 		local a=(msg);
 		if a then
 			return msg
 		else	
 			return "";
 		end
 	end
 end

function SC_ShowHelp()
	print("SC_AutoGrats usage:");
	print("'/sc' or '/sc options' to show options ui");
	print("'/sc {msg}' or '/autograts {msg}'");
	print("'/sc delay {delay}' or '/autograts {delay}', with delay in milliseconds to set delay");
	print("'/sc guild' or '/autograts guild' to enable/disable guild gratzing");
	print("'/sc say' or '/autograts say' to enable/disable say gratzing");
	print("'/sc party' or '/autograts party' to enable/disable say gratzing");
end

------------------------
-- Guild Grats Toggle --
------------------------

function SC_ToggleGuild()
	if(SC_Guild) then 
		SC_Guild = false; 
		SC_Print("Guild Grats! Off");
	else
		SC_Guild = true;    
		SC_Print("Guild Grats! On");
	end;
	SC_AutoGrats.ui.guildCheckButton:SetChecked(SC_Guild);
end

----------------------
-- Say Grats Toggle --
----------------------

function SC_ToggleSay()
	if(SC_Say) then 
		SC_Say = false; 
		SC_Print("Say Grats! Off");
	else
		SC_Say = true;
		SC_Print("Say Grats! On");
	end;
	SC_AutoGrats.ui.sayCheckButton:SetChecked(SC_Say);
end

------------------------
-- Party Grats Toggle --
------------------------

function SC_ToggleParty()
	if(SC_Party) then 
		SC_Party = false; 
		SC_Print("Party Grats! Off");
	else
		SC_Party = true; 
		SC_Print("Party Grats! On");
	end;
	SC_AutoGrats.ui.partyCheckButton:SetChecked(SC_Party);
end

--------------------------
-- Guild Welcome Toggle --
--------------------------

function SC_ToggleGuildWelcome()
	if(SC_GuildJoinMessageToggle) then 
		SC_GuildJoinMessageToggle = false; 
		SC_Print("Guild Welcome! Off");
	else
		SC_GuildJoinMessageToggle = true;    
		SC_Print("Guild Welcome! On");
	end;
	SC_AutoGrats.ui.guildWelcomeCheckButton:SetChecked(SC_GuildJoinMessageToggle);
end

-------------------
-- Message Delay --
-------------------

function SC_SetDelay(delay)
	if(delay ~= nill)then
		SC_Delay = tonumber(delay); 
		SC_Print("Grats message delay set to: " ..delay.."ms");	
	else
		SC_Print("Provide a number in ms, eg '/ag delay 5000' for 5 seconds");
	end
end

---------------------------
-- Slash Command Options --
---------------------------

function SC_Command(msg)
    local Cmd, SubCmd = SC_GetCmd(msg);
    if (Cmd == "")then
		InterfaceOptionsFrame_OpenToCategory(SC_AutoGrats.ui.panel);
    elseif (Cmd == "help")then
        SC_ShowHelp();
    elseif (Cmd == "options")then
        InterfaceOptionsFrame_OpenToCategory(SC_AutoGrats.ui.panel);
	elseif (Cmd == "guild")then
        SC_ToggleGuild();
    elseif (Cmd == "say")then
        SC_ToggleSay();
    elseif (Cmd == "party")then
        SC_ToggleParty();
	elseif (Cmd == "guildwelcome")then
        SC_ToggleGuildWelcome();
	elseif (string.find(Cmd,"delay") == 1)then
        SC_SetDelay(string.match(Cmd,"%d+"));
    else
        SC_GratsMessage = Cmd;
		SC_Print("Grats message set to: " .. Cmd);
    end
end

function SC_OnEvent(self,event,arg1,arg2)
	if(event == "GUILD_ROSTER_UPDATE")then SC_CheckOverride(); return end
	if(SC_GratsMessage1 == nil)then
		SC_GratsMessage1="Grats!";
    end
    if(not SC_IsMe(arg2))then
	    if(event == "CHAT_MSG_GUILD_ACHIEVEMENT" and not SC_GuildDisabledOverride)then SC_DoGrats("GUILD");
	    elseif(event == "CHAT_MSG_ACHIEVEMENT")then SC_DoGrats("SAY");
	    elseif(event == "CHAT_MSG_ACHIEVEMENT")then SC_DoGrats("PARTY");
	    elseif(event == "CHAT_MSG_SYSTEM" and not SC_GuildDisabledOverride) then
	    	if(arg1 ~= nil) then
				if(string.find(arg1,"has joined the guild.")) then SC_GuildWelcome();
				end
			end
	    end
	end
end

function SC_DoGrats(source)
	if((source == "SAY" and SC_Say == true) or (source == "GUILD" and SC_Guild == true) or (source == "PARTY" and SC_Party == true)) then
		CurTime=GetTime();
		if (SC_LastMessage == nil) then
			SC_LastMessage = 1;
		end
		if((CurTime - SC_LastMessage) > (SC_GroupingTime/1000))then
			SC_LastMessage = GetTime();
			if(SC_Delay > 0)then
				C_Timer.After((SC_Delay/1000), function() SendChatMessage(GetRandomArgument(SC_GratsMessage1,SC_GratsMessage2,SC_GratsMessage3), source); end)
			else
				SendChatMessage(GetRandomArgument(SC_GratsMessage1,SC_GratsMessage2,SC_GratsMessage3), source);
			end
		end
	end
end

function SC_GuildWelcome()
	if(SC_GuildJoinMessageToggle and (GetTime() - SC_LastMessage > (SC_GroupingTime/1000)))then
		SC_LastMessage = GetTime();
		if(SC_Delay > 0)then
			C_Timer.After((SC_Delay/1000), function() SendChatMessage(GetRandomArgument(SC_GuildWelcomeMessage1,SC_GuildWelcomeMessage2,SC_GuildWelcomeMessage3), "GUILD"); end)
		else
			SendChatMessage(GetRandomArgument(SC_GuildWelcomeMessage1,SC_GuildWelcomeMessage2,SC_GuildWelcomeMessage3), "GUILD");
		end
    end
end

function SC_IsMe(nameString)
	local name,server = split(nameString,"-")
	local myName, myServer = UnitName("player")
	if(myServer == nil)then
		myServer = GetRealmName();
	end
	if(server == nil and name == myName)then
		return true;
	elseif(server ~= nil and name == myName and server == myServer)then
		return true;
	else
		return false;
	end
end

function SC_CheckOverride()
	local myName = UnitName("player")
	for index=1, GetNumGuildMembers() do 
		
		 local name,_,_,_,_,_,note = GetGuildRosterInfo(index)
		 if SC_IsMe(name) then
			 note = note:lower()
			 if note:match("noag") then
				SC_GuildDisabledOverride = true;
				return true;
			 else
				SC_GuildDisabledOverride = false;
				return false;
			 end
			 break
		 end
	end
	return false;
end

function SC_Print(msg)
	print("\124cffffFF00[SC]\124r",msg);
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return unpack(t)
end
  
  function CreateBasicFontString(parent, name, layer, template, text)
    local fs = parent:CreateFontString(name,layer,template)
    fs:SetText(text)
    return fs
  end
  
  function CreateBasicSlider(parent, name, title, minVal, maxVal, valStep)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValue(minVal)
    slider:SetValueStep(1)
    slider.text = _G[name.."Text"]
    slider.text:SetText(title)
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.textLow:SetText(floor(minVal))
    slider.textHigh:SetText(floor(maxVal))
    slider.textLow:SetTextColor(0.4,0.4,0.4)
    slider.textHigh:SetTextColor(0.4,0.4,0.4)
    editbox:SetSize(50,30)
	editbox:SetNumeric(true)
	editbox:SetMultiLine(false)
	editbox:SetMaxLetters(5)
    editbox:ClearAllPoints()
    editbox:SetPoint("TOP", slider, "BOTTOM", 0, -5)
    editbox:SetNumber(slider:GetValue())
	editbox:SetCursorPosition(0);
	editbox:ClearFocus();
    editbox:SetAutoFocus(false)
    slider:SetScript("OnValueChanged", function(self,value)
		self.editbox:SetNumber(floor(value))
		if(not self.editbox:HasFocus())then
			self.editbox:SetCursorPosition(0);
			self.editbox:ClearFocus();
		end
    end)
    editbox:SetScript("OnTextChanged", function(self)
      local value = self:GetText()
      if tonumber(value) then
		if(floor(value) > maxVal)then
			self:SetNumber(maxVal)
		end
        if floor(self:GetParent():GetValue()) ~= floor(value) then
          self:GetParent():SetValue(floor(value))
        end
      end
    end)
    editbox:SetScript("OnEnterPressed", function(self)
      local value = self:GetText()
      if tonumber(value) then
        self:GetParent():SetValue(floor(value))
        self:ClearFocus()
      end
    end)
    slider.editbox = editbox
    return slider
  end