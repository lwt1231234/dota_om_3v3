function phantom_lancer_spirit_lance_om(keys)
	local target = keys.target
	local caster = keys.caster 
	local player = caster:GetPlayerID()
	local targets = keys.target_entities
	local ability = keys.ability
	local al = keys.ability:GetLevel() - 1
	
	local playerid = caster:GetPlayerOwnerID()
	local unit_name = caster:GetUnitName()

	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", al )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_damage_out_pct", al )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_damage_in_pct", al )

	if phantom_lancer_spirit_lance_om_last_time == nil then
		phantom_lancer_spirit_lance_om_last_time = {}
	end

	if phantom_lancer_spirit_lance_om_last_time[playerid] == nil then
		phantom_lancer_spirit_lance_om_last_time[playerid] = 0
	end

	if target:FindModifierByName("modifier_phantom_lancer_spirit_lance_om_main_target") ~= nil then
    	target:RemoveModifierByName("modifier_phantom_lancer_spirit_lance_om_main_target")
    	--创建幻象
		local location = target:GetAbsOrigin()
		local illusion = CreateUnitByName(unit_name, location, true, caster, nil, caster:GetTeamNumber())
		illusion:SetPlayerID(caster:GetPlayerID())
		illusion:SetControllableByPlayer(player, true)

		local casterLevel = caster:GetLevel()
		for i=1,casterLevel-1 do
			illusion:HeroLevelUp(false)
		end
		illusion:SetAbilityPoints(0)
		for abilitySlot=0,15 do
			local ability = caster:GetAbilityByIndex(abilitySlot)
			if ability ~= nil then 
				local abilityLevel = ability:GetLevel()
				local abilityName = ability:GetAbilityName()
				local illusionAbility = illusion:FindAbilityByName(abilityName)
				illusionAbility:SetLevel(abilityLevel)
			end
		end
		-- Recreate the items of the caster
		for itemSlot=0,5 do
			local item = caster:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, illusion, illusion)
				illusion:AddItem(newItem)
			end
		end
		keys.ability:ApplyDataDrivenModifier(caster, illusion, "modifier_phantom_lancer_spirit_lance_om_illusion", {})
		illusion:AddNewModifier(caster, keys.ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		
		illusion:MakeIllusion()
		illusion:SetHealth(caster:GetHealth())
    end

	local damageTable = {victim=target,    --受到伤害的单位
                       attacker=caster,          --造成伤害的单位
                       damage=keys.ability:GetLevelSpecialValueFor("damage", al),        --在这里面必须技能等级减1
                       damage_type=keys.ability:GetAbilityDamageType()}    --获取技能伤害类型，就是AbilityUnitDamageType的值
    ApplyDamage(damageTable)    --造成伤害


	if GameRules:GetGameTime() - phantom_lancer_spirit_lance_om_last_time[playerid] > 10 then
		--散射
		for i,unit in pairs(targets) do
			if unit ~= target then
				local info = 
				{
					Target = unit,
					Source = target,
					Ability = caster:GetAbilityByIndex(0),	
					EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
				    iMoveSpeed = keys.ability:GetLevelSpecialValueFor("lance_speed", al),
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
	    phantom_lancer_spirit_lance_om_last_time[playerid] = GameRules:GetGameTime()
	end
	
end
