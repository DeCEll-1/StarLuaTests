-- TYPE MOD_PLUGIN
function onApplicationLoad()
    print("Application Loading Loaded StarLua Test Mod")
end

-- these are all the possible functions

function afterGameSave()
end

function beforeGameSave()
end

function onGameSaveFailed()
end

function onEnabled(wasEnabledBefore)
end

function onGameLoad(newGame)
    print("Game Loading Loaded StarLua Test Mod")
end

function onNewGame()
end

function onNewGameAfterEconomyLoad()
end

function onNewGameAfterTimePass()
end

function configureXStream(x)
end

function onNewGameAfterProcGen()
end

function onDevModeF8Reload()
end

function onAboutToStartGeneratingCodex()
end

function onAboutToLinkCodexEntries()
end

function onCodexDataGenerated()
end
