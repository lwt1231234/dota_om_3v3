function phantom_assassin_stifling_dagger_om(keys)
	local target = keys.target
	local caster = keys.caster 
	local targets = keys.target_entities
	local al = keys.ability:GetLevel() - 1

	if phantom_assassin_stifling_dagger_om_last_time == nil then
		phantom_assassin_stifling_dagger_om_last_time = 0
	end



	if target:IsHero() == true then
		local damageTable = {victim=target,    --受到伤害的单位
                        attacker=caster,          --造成伤害的单位
                        damage=keys.ability:GetLevelSpecialValueFor("hero_damage", al),        --在这里面必须技能等级减1
                        damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
                ApplyDamage(damageTable)    --造成伤害
    
	else
		local damageTable = {victim=target,    --受到伤害的单位
                        attacker=caster,          --造成伤害的单位
                        damage=keys.ability:GetLevelSpecialValueFor("creep_damage", al),        --在这里面必须技能等级减1
                        damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
                ApplyDamage(damageTable)    --造成伤害
	end


	if GameRules:GetGameTime() - phantom_assassin_stifling_dagger_om_last_time > 10 then
		for i,unit in pairs(targets) do
			if unit ~= target then
				local info = 
				{
					Target = unit,
					Source = target,
					Ability = caster:GetAbilityByIndex(0),	
					EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
				    iMoveSpeed = keys.ability:GetLevelSpecialValueFor("dagger_speed", al),
				    bDodgeable = true,                                -- Optional
					--[====[vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
					bDrawsOnMinimap = false,                          -- Optional
				        
				        bIsAttack = false,                                -- Optional
				        bVisibleToEnemies = true,                         -- Optional
				        bReplaceExisting = false,                         -- Optional
				        flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
					bProvidesVision = true,                           -- Optional
					iVisionRadius = 400,                              -- Optional
					iVisionTeamNumber = caster:GetTeamNumber()        -- Optional]====]
				}
				projectile = ProjectileManager:CreateTrackingProjectile(info)
			end
	    end
	    phantom_assassin_stifling_dagger_om_last_time = GameRules:GetGameTime()
	end
	
end