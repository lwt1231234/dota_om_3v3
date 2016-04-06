if CDotaom3v3 == nil then
    CDotaom3v3 = class({})
end

function CDotaom3v3:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

    --调试参数
    pre_time = 45       --游戏准备时间
    spawn_time = 30     --刷兵间隔

	--设置游戏准备时间
    GameRules:SetPreGameTime(pre_time)
    --监听游戏进度
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(CDotaom3v3,"OnGameRulesStateChange"), self)

    --设置触发器
    --推塔
    ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(CDotaom3v3, "OnTowerKilled"), self)
end

-- Evaluate the state of the game
function CDotaom3v3:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CDotaom3v3:OnGameRulesStateChange( keys )
    print("OnGameRulesStateChange")
 
    --获取游戏进度
    local newState = GameRules:State_Get()
 
    --游戏开始
    if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        start_spawn_creep()
    end
end

function CDotaom3v3:OnTowerKilled( keys )--推塔后近远程兵+1
    print("OnTowerKilled")
    CreepSpawner.__melee_count = CreepSpawner.__melee_count + 1
    CreepSpawner.__range_count = CreepSpawner.__range_count + 1
end