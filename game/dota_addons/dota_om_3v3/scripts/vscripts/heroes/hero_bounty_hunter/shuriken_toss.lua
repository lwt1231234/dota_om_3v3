function bounty_hunter_shuriken_toss_om_start(keys)
	local ability = keys.ability
	ability.count = 0
	print(ability.count)
end

function bounty_hunter_shuriken_toss_om(keys)
	local target = keys.target
	local caster = keys.caster 
	local targets = keys.target_entities
	local al = keys.ability:GetLevel() - 1
	local ability = keys.ability
	print(ability.count)
	if ability.count == 0 then
		ability.count = 1
		for i,unit in pairs(targets) do
			if unit ~= target then
				local info = 
				{
					Target = unit,
					Source = target,
					Ability = ability,	
					EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
				    iMoveSpeed = keys.ability:GetLevelSpecialValueFor("speed", al),
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
	end
	
end