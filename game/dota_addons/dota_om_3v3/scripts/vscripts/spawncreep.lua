function start_spawn_creep( )

    if CreepSpawner == nil then
        CreepSpawner = { }
    end
    -- 初始刷近战3个，远程1个,车一个，0分钟刷兵时会全部+1的
    CreepSpawner.__melee_count = 2      --近战兵数量
    CreepSpawner.__range_count = 0      --远程兵数量
    CreepSpawner.__siege_count = 0      --车子数量
    CreepSpawner.__wave = 0             --波数
    -- 记录开始刷兵时间
    CreepSpawner.__spawn_start_time = GameRules:GetGameTime()
    CreepSpawner.__spawn_add_time = CreepSpawner.__spawn_start_time
    -- 记录小兵升级
    CreepSpawner.__creature_levelup = 0


    -- 之后每30秒刷一波兵
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_creep_loop"),
        function()
            -- 确保游戏正在进行中（游戏结束后在面板不再刷怪）
            if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
                -- 获取当前游戏事件，来判断是否需要增加小兵个数和对小兵进行升级
                local now = GameRules:GetGameTime()
                local game_time = now - CreepSpawner.__spawn_add_time + 0.1

                -- 每5分钟小兵数量+1
                if (CreepSpawner.__wave % 10) == 0 then
                    CreepSpawner.__melee_count = CreepSpawner.__melee_count + 1
                    CreepSpawner.__range_count = CreepSpawner.__range_count + 1
                end
                -- 每7分钟车子数量+1
                if (CreepSpawner.__wave % 14) == 0 then
                    CreepSpawner.__siege_count = CreepSpawner.__siege_count + 1
                end
     
                -- 每5分钟小兵等级增加1级
                local upgrade_level = math.floor(CreepSpawner.__wave / 10)
                if upgrade_level > CreepSpawner.__creature_levelup then 
                    CreepSpawner.__creature_levelup = upgrade_level 
                end

                CreepSpawner.__wave = CreepSpawner.__wave + 1
                print(CreepSpawner.__wave)
                spawn_creep(CreepSpawner.__creature_levelup)
                --每4波兵刷一个车
                if((CreepSpawner.__wave % 4) == 0 and CreepSpawner.__wave > 1) then
                    spawn_siege()
                end
            end
            --print(spawn_time)
            if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
                return spawn_time
            else
                return nil
            end
        end
       , 0)
    -- 控制小兵前进
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("keep_creep_move"),
        function()
            radiant_start = Entities:FindByName(nil,"radiant_start")
            radiant_end = Entities:FindByName(nil,"radiant_end")
            dire_start = Entities:FindByName(nil,"dire_start")
            dire_end = Entities:FindByName(nil,"dire_end")
            left = Entities:FindByName(nil,"line_left")
            right = Entities:FindByName(nil,"line_right")
            
            local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, --天辉
                                            radiant_start:GetAbsOrigin(), --初始刷兵
                                            nil,
                                            300, 
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                            DOTA_UNIT_TARGET_CREEP,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)
            for _, target in pairs( units ) do
                target:MoveToPositionAggressive(right:GetAbsOrigin()) --走向右边
                target:SetContext("move to", "right", 0)
            end

            local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, --天辉
                                            right:GetAbsOrigin(), --初始刷兵
                                            nil,
                                            300, 
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                            DOTA_UNIT_TARGET_CREEP,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)
            for _, target in pairs( units ) do
                if target:GetContext("move to") ~= "left" then
                    target:MoveToPositionAggressive(left:GetAbsOrigin()) --走向右边
                    target:SetContext("move to", "left", 0)
                end
            end

            local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, --天辉
                                            left:GetAbsOrigin(), --初始刷兵
                                            nil,
                                            300, 
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                            DOTA_UNIT_TARGET_CREEP,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)
            for _, target in pairs( units ) do
                if target:GetContext("move to") ~= "radiant_end" then
                    target:MoveToPositionAggressive(radiant_end:GetAbsOrigin()) --走向右边
                    target:SetContext("move to", "radiant_end", 0)
                end
            end

            local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, --天辉
                                            dire_start:GetAbsOrigin(), --初始刷兵
                                            nil,
                                            300, 
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                            DOTA_UNIT_TARGET_CREEP,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)
            for _, target in pairs( units ) do
                target:MoveToPositionAggressive(left:GetAbsOrigin()) --走向右边
                target:SetContext("move to", "left", 0)
            end

            local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, --天辉
                                            left:GetAbsOrigin(), --初始刷兵
                                            nil,
                                            300, 
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                            DOTA_UNIT_TARGET_CREEP,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)
            for _, target in pairs( units ) do
                if target:GetContext("move to") ~= "right" then
                    target:MoveToPositionAggressive(right:GetAbsOrigin()) --走向右边
                    target:SetContext("move to", "right", 0)
                end
            end

            local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, --天辉
                                            right:GetAbsOrigin(), --初始刷兵
                                            nil,
                                            300, 
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                            DOTA_UNIT_TARGET_CREEP,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)
            for _, target in pairs( units ) do
                if target:GetContext("move to") ~= "dire_end" then
                    target:MoveToPositionAggressive(dire_end:GetAbsOrigin()) --走向右边
                    target:SetContext("move to", "dire_end", 0)
                end
            end

            return 0.1
        end
        , 0)

end

function spawn_unit(name, level, locat, team)
    local ShuaGuai_entity = Entities:FindByName(nil,locat)
    if locat ~= nil then
        local LuXian_entity = Entities:FindByName(nil,locat)
    end

    local creep = CreateUnitByName(name,ShuaGuai_entity:GetOrigin()+RandomVector(100),true,nil,nil,team)
 
    creep:SetMaxHealth(creep:GetHealth() + 40 * level)
    creep:SetBaseMaxHealth(creep:GetHealth() + 40 * level)
    creep:SetHealth(creep:GetHealth() + 40 * level)
    creep:SetBaseDamageMin(creep:GetBaseDamageMin() + 7 * level)
    creep:SetBaseDamageMax(creep:GetBaseDamageMax() + 7 * level)

    --禁止单位寻找最短路径
    creep:SetMustReachEachGoalEntity(true)
 
    --让单位沿着设置好的路线开始行动
    --if locat ~= nil then
    --    creep:SetInitialGoalEntity(LuXian_entity)
    --end
 
    --添加相位移动的modifier，持续时间0.1秒
    --当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
    creep:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
end

function spawn_creep(level)
     
    ------------------------------------------------------------------------------------------天辉

    for i = 1, CreepSpawner.__melee_count do
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_unit_loop"), 
            function()
                spawn_unit("npc_dota_creep_radiant_melee", level, "radiant_start", DOTA_TEAM_GOODGUYS)
                return nil
            end
            , 0)
    end

    for i = 1, CreepSpawner.__range_count do
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_unit_loop"), 
            function()
                spawn_unit("npc_dota_creep_radiant_range", level, "radiant_start", DOTA_TEAM_GOODGUYS)
                return nil
            end
            , 0)
    end
    ------------------------------------------------------------------------------------------夜魇
    for i = 1, CreepSpawner.__melee_count do
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_unit_loop"), 
            function()
                spawn_unit("npc_dota_creep_dire_melee", level, "dire_start", DOTA_TEAM_BADGUYS)
                return nil
            end
            , i/5)
    end

    for i = 1, CreepSpawner.__range_count do
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_unit_loop"), 
            function()
                spawn_unit("npc_dota_creep_dire_range", level, "dire_start", DOTA_TEAM_BADGUYS)
                return nil
            end
            , (i+CreepSpawner.__melee_count)/5)
    end
end

function spawn_siege()
    for i = 1, CreepSpawner.__siege_count do
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_unit_loop"), 
            function()
                spawn_unit("npc_dota_creep_radiant_siege", 0, "radiant_start", DOTA_TEAM_GOODGUYS)
                return nil
            end
            , (i+CreepSpawner.__melee_count+CreepSpawner.__range_count)/10)
    end

    for i = 1, CreepSpawner.__siege_count do
        GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("spawn_unit_loop"), 
            function()
                spawn_unit("npc_dota_creep_dire_siege", 0, "dire_start", DOTA_TEAM_BADGUYS)
                return nil
            end
            , (i+CreepSpawner.__melee_count+CreepSpawner.__range_count)/10)
    end
end