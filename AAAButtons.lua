
-- Edit Box
AAAUI.editBox1 = CreateFrame("EditBox", "AAAEditBox", AAAUI, "InputBoxTemplate")
AAAUI.editBox1:SetSize(35,20)
AAAUI.editBox1:SetAutoFocus(false)
AAAUI.editBox1:ClearFocus()
AAAUI.editBox1:SetPoint("BOTTOM", 302, 350)
AAAUI.editBox1Text = AAAUI.editBox1:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
AAAUI.editBox1Text:SetHeight(50)
AAAUI.editBox1Text:SetWidth(50)
AAAUI.editBox1Text:SetPoint("LEFT", 0, 20)
AAAUI.editBox1Text:SetText("DKP")


AAAUI.editBox2 = CreateFrame("EditBox", "AAAEditBox", AAAUI, "InputBoxTemplate")
AAAUI.editBox2:SetSize(90,20)
AAAUI.editBox2:SetAutoFocus(false)
AAAUI.editBox2:SetPoint("BOTTOM", 330, 300)
AAAUI.editBox2Text = AAAUI.editBox2:CreateFontString(AAAUI, "OVERLAY", "GameTooltipText")
AAAUI.editBox2Text:SetHeight(60)
AAAUI.editBox2Text:SetWidth(50)
AAAUI.editBox2Text:SetPoint("LEFT", 0, 20)
AAAUI.editBox2Text:SetText("Reason")

AAAUI.rosterUpdateBtn1 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.rosterUpdateBtn1:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 190);
AAAUI.rosterUpdateBtn1:SetSize(140, 40);
AAAUI.rosterUpdateBtn1:SetText("Update Roster");
AAAUI.rosterUpdateBtn1:SetNormalFontObject("GameFontNormalLarge");
AAAUI.rosterUpdateBtn1:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.rosterUpdateBtn1:SetScript("OnClick", function()
	rosterRaid, rosterGuild, rosterRaidClone = SaveRaid(rosterDetails, rosterGuild)
	UpdateDisplay(false)
end)

AAAUI.changelogBtn1 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.changelogBtn1:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 670);
AAAUI.changelogBtn1:SetSize(140, 40);
AAAUI.changelogBtn1:SetText("Export bids");
AAAUI.changelogBtn1:SetNormalFontObject("GameFontNormalLarge");
AAAUI.changelogBtn1:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.changelogBtn1:SetScript("OnClick", function()
	ExportChangelog(changelog_items)
end)

AAAUI.changelogBtn2 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.changelogBtn2:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 630);
AAAUI.changelogBtn2:SetSize(140, 40);
AAAUI.changelogBtn2:SetText("Export DKP");
AAAUI.changelogBtn2:SetNormalFontObject("GameFontNormalLarge");
AAAUI.changelogBtn2:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.changelogBtn2:SetScript("OnClick", function()
	ExportChangelog(changelog_dkp)
end)

AAAUI.changelogBtn3 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.changelogBtn3:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 590);
AAAUI.changelogBtn3:SetSize(140, 40);
AAAUI.changelogBtn3:SetText("Export Roster");
AAAUI.changelogBtn3:SetNormalFontObject("GameFontNormalLarge");
AAAUI.changelogBtn3:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.changelogBtn3:SetScript("OnClick", function()
	ExportRoster(rosterDetails, rosterGuild)
end)

AAAUI.changelogBtn4 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.changelogBtn4:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 510);
AAAUI.changelogBtn4:SetSize(140, 40);
AAAUI.changelogBtn4:SetText("New changelog");
AAAUI.changelogBtn4:SetNormalFontObject("GameFontNormalLarge");
AAAUI.changelogBtn4:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.changelogBtn4:SetScript("OnClick", function()
	changelog_items, changelog_items_backup = RefreshChangelogs(changelog_items, changelog_items_backup)
	changelog_dkp, changelog_dkp_backup = RefreshChangelogs(changelog_dkp, changelog_dkp_backup)
end)

AAAUI.wipeDKPBtn1 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.wipeDKPBtn1:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 270);
AAAUI.wipeDKPBtn1:SetSize(140, 40);
AAAUI.wipeDKPBtn1:SetText("Wipe DKP");
AAAUI.wipeDKPBtn1:SetNormalFontObject("GameFontNormalLarge");
AAAUI.wipeDKPBtn1:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.wipeDKPBtn1:SetScript("OnClick", PopupWipeDKP)

AAAUI.wipeDKPBtn1 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.wipeDKPBtn1:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 230);
AAAUI.wipeDKPBtn1:SetSize(140, 40);
AAAUI.wipeDKPBtn1:SetText("Weekly decay");
AAAUI.wipeDKPBtn1:SetNormalFontObject("GameFontNormalLarge");
AAAUI.wipeDKPBtn1:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.wipeDKPBtn1:SetScript("OnClick", PopupWeeklyDKPDecay)

AAAUI.reloadBtn = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.reloadBtn:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 70);
AAAUI.reloadBtn:SetSize(140, 40);
AAAUI.reloadBtn:SetText("Reload UI");
AAAUI.reloadBtn:SetNormalFontObject("GameFontNormalLarge");
AAAUI.reloadBtn:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.reloadBtn:SetScript("OnClick", ReloadUI)

AAAUI.addRaidDKPBtn = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.addRaidDKPBtn:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 150);
AAAUI.addRaidDKPBtn:SetSize(140, 40);
AAAUI.addRaidDKPBtn:SetText("Add Raid DKP");
AAAUI.addRaidDKPBtn:SetNormalFontObject("GameFontNormalLarge");
AAAUI.addRaidDKPBtn:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.addRaidDKPBtn:SetScript("OnClick", function()
	local number = AAAUI.editBox1:GetText()
	local reason = AAAUI.editBox2:GetText()
	AdjustRaidDKP(number, reason)
end)

AAAUI.refreshBtn = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.refreshBtn:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 30);
AAAUI.refreshBtn:SetSize(140, 40);
AAAUI.refreshBtn:SetText("Refresh roster");
AAAUI.refreshBtn:SetNormalFontObject("GameFontNormalLarge");
AAAUI.refreshBtn:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.refreshBtn:SetScript("OnClick", function()
	UpdateDisplay(true)end)

AAAUI.wipeRosterBtn = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.wipeRosterBtn:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 110);
AAAUI.wipeRosterBtn:SetSize(140, 40);
AAAUI.wipeRosterBtn:SetText("Wipe Roster");
AAAUI.wipeRosterBtn:SetNormalFontObject("GameFontNormalLarge");
AAAUI.wipeRosterBtn:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.wipeRosterBtn:SetScript("OnClick", PopupWipeRoster)

AAAUI.ImportBtn1 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.ImportBtn1:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 550);
AAAUI.ImportBtn1:SetSize(140, 40);
AAAUI.ImportBtn1:SetText("Import");
AAAUI.ImportBtn1:SetNormalFontObject("GameFontNormalLarge");
AAAUI.ImportBtn1:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.ImportBtn1:SetScript("OnClick", CreateImportFrame)

AAAUI.testBtn1 = CreateFrame("Button", nil, AAAUI, "GameMenuButtonTemplate");
AAAUI.testBtn1:SetPoint("CENTER", AAAUI, "BOTTOM", 350, 450);
AAAUI.testBtn1:SetSize(140, 40);
AAAUI.testBtn1:SetText("Test");
AAAUI.testBtn1:SetNormalFontObject("GameFontNormalLarge");
AAAUI.testBtn1:SetHighlightFontObject("GameFontHighlightLarge");
AAAUI.testBtn1:SetScript("OnClick", TestFunction)

CurrentBiddingItem.nextStep = CreateFrame("Button", nil, CurrentBiddingItem, "GameMenuButtonTemplate");
CurrentBiddingItem.nextStep:SetPoint("LEFT", CurrentBiddingItem, "LEFT", -50, 4);
CurrentBiddingItem.nextStep:SetSize(50, 40);
CurrentBiddingItem.nextStep:SetText("Next");
CurrentBiddingItem.nextStep:SetNormalFontObject("GameFontNormalSmall");
CurrentBiddingItem.nextStep:SetHighlightFontObject("GameFontHighlightSmall");
CurrentBiddingItem.nextStep:SetScript("OnClick", function()
	EndTimers()
	BiddingTimerHasEnded()
end)

CurrentBiddingItem.Cancel = CreateFrame("Button", nil, CurrentBiddingItem, "GameMenuButtonTemplate");
CurrentBiddingItem.Cancel:SetPoint("LEFT", CurrentBiddingItem, "LEFT", -50, -32);
CurrentBiddingItem.Cancel:SetSize(50, 40);
CurrentBiddingItem.Cancel:SetText("Cancel");
CurrentBiddingItem.Cancel:SetNormalFontObject("GameFontNormalSmall");
CurrentBiddingItem.Cancel:SetHighlightFontObject("GameFontHighlightSmall");
CurrentBiddingItem.Cancel:SetScript("OnClick", function()
	BiddingSequenceCanceled("been canceled.")
end)

CurrentBiddingItem.Extend = CreateFrame("Button", nil, CurrentBiddingItem, "GameMenuButtonTemplate");
CurrentBiddingItem.Extend:SetPoint("LEFT", CurrentBiddingItem, "LEFT", -50, -68);
CurrentBiddingItem.Extend:SetSize(50, 40);
CurrentBiddingItem.Extend:SetText("Extend");
CurrentBiddingItem.Extend:SetNormalFontObject("GameFontNormalSmall");
CurrentBiddingItem.Extend:SetHighlightFontObject("GameFontHighlightSmall");
CurrentBiddingItem.Extend:SetScript("OnClick", function()
	RefreshTimers()
end)

CurrentBiddingItem.Undo = CreateFrame("Button", nil, CurrentBiddingItem, "GameMenuButtonTemplate");
CurrentBiddingItem.Undo:SetPoint("LEFT", CurrentBiddingItem, "LEFT", -50, -104);
CurrentBiddingItem.Undo:SetSize(50, 40);
CurrentBiddingItem.Undo:SetText("Undo");
CurrentBiddingItem.Undo:SetNormalFontObject("GameFontNormalSmall");
CurrentBiddingItem.Undo:SetHighlightFontObject("GameFontHighlightSmall");
CurrentBiddingItem.Undo:SetScript("OnClick", function()
	UndoLastBid()
	RefreshTimers()
end)

CurrentBiddingItem.Reset = CreateFrame("Button", nil, CurrentBiddingItem, "GameMenuButtonTemplate");
CurrentBiddingItem.Reset:SetPoint("LEFT", CurrentBiddingItem, "LEFT", -50, -140);
CurrentBiddingItem.Reset:SetSize(50, 40);
CurrentBiddingItem.Reset:SetText("Reset");
CurrentBiddingItem.Reset:SetNormalFontObject("GameFontNormalSmall");
CurrentBiddingItem.Reset:SetHighlightFontObject("GameFontHighlightSmall");
CurrentBiddingItem.Reset:SetScript("OnClick", function()
	BiddingSequenceCanceled("been canceled.")
	ResetBidding()
end)

CurrentBiddingItem.Close = CreateFrame("Button", nil, CurrentBiddingItem, "UIPanelCloseButton");
CurrentBiddingItem.Close:SetPoint("LEFT", CurrentBiddingItem, "LEFT", 20, 34);
CurrentBiddingItem.Close:SetSize(30, 30);
CurrentBiddingItem.Close:SetScript("OnClick", function()
	BiddingSequenceCanceled()
	CloseBiddingControl()
end)

-- ---------------------------------
-- -- Sliders
-- ---------------------------------
-- -- Slider 1:
-- UIConfig.slider1 = CreateFrame("SLIDER", nil, UIConfig, "OptionsSliderTemplate");
-- UIConfig.slider1:SetPoint("TOP", UIConfig.loadBtn, "BOTTOM", 0, -20);
-- UIConfig.slider1:SetMinMaxValues(1, 100);
-- UIConfig.slider1:SetValue(50);
-- UIConfig.slider1:SetValueStep(30);
-- UIConfig.slider1:SetObeyStepOnDrag(true);

-- -- Slider 2:
-- UIConfig.slider2 = CreateFrame("SLIDER", nil, UIConfig, "OptionsSliderTemplate");
-- UIConfig.slider2:SetPoint("TOP", UIConfig.slider1, "BOTTOM", 0, -20);
-- UIConfig.slider2:SetMinMaxValues(1, 100);
-- UIConfig.slider2:SetValue(40);
-- UIConfig.slider2:SetValueStep(30);
-- UIConfig.slider2:SetObeyStepOnDrag(true);

-- ---------------------------------
-- -- Check Buttons
-- ---------------------------------
-- -- Check Button 1:
-- UIConfig.checkBtn1 = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
-- UIConfig.checkBtn1:SetPoint("TOPLEFT", UIConfig.slider1, "BOTTOMLEFT", -10, -40);
-- UIConfig.checkBtn1.text:SetText("My Check Button!");

-- -- Check Button 2:
-- UIConfig.checkBtn2 = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
-- UIConfig.checkBtn2:SetPoint("TOPLEFT", UIConfig.checkBtn1, "BOTTOMLEFT", 0, -10);
-- UIConfig.checkBtn2.text:SetText("Another Check Button!");
-- UIConfig.checkBtn2:SetChecked(true);