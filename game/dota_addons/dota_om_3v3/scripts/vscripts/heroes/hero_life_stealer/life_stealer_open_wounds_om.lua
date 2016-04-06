function open_wounds_start_om( keys )
	local caster = keys.caster
	local playerid = caster:GetPlayerOwnerID()
	local target = keys.target
	local ability = keys.ability
	local al = keys.ability:GetLevel() - 1

	if life_stealer_open_wounds_om_target == nil then
		life_stealer_open_wounds_om_target = {}
	end

	if life_stealer_open_wounds_om_target[playerid] == nil then
		life_stealer_open_wounds_om_target[playerid] = {}
	end
	life_stealer_open_wounds_om_target[playerid].target = target
	if(target:IsHero()) then
		life_stealer_open_wounds_om_target[playerid].rates = ability:GetLevelSpecialValueFor( "hero_damage_rates", al )
	else
		life_stealer_open_wounds_om_target[playerid].rates = ability:GetLevelSpecialValueFor( "creep_damage_rates", al )
	end
	life_stealer_open_wounds_om_target[playerid].life = target:GetMaxHealth()
	life_stealer_open_wounds_om_target[playerid].origin = target:GetAbsOrigin()
	life_stealer_open_wounds_om_target[playerid].count = ability:GetLevelSpecialValueFor( "duration", al )

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("open_wounds_target_update"),
        function()
        	if life_stealer_open_wounds_om_target[playerid].target ~= nil and life_stealer_open_wounds_om_target[playerid].count > 0 then
	                life_stealer_open_wounds_om_target[playerid].origin = life_stealer_open_wounds_om_target[playerid].target:GetAbsOrigin()
	                life_stealer_open_wounds_om_target[playerid].count = life_stealer_open_wounds_om_target[playerid].count - 1
	                return 1 
        	else
        		return nil
	            
	        end
        end
       , 0)


end

function open_wounds_death_om( keys )
	local caster = keys.caster
	local playerid = caster:GetPlayerOwnerID()
	local targets = keys.target_entities
	local ability = keys.ability
	local al = keys.ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor( "radius", al )

	local damage = life_stealer_open_wounds_om_target[playerid].life * life_stealer_open_wounds_om_target[playerid].rates / 100
print(damage)
	local units = FindUnitsInRadius(
					caster:GetTeam(), 
					life_stealer_open_wounds_om_target[playerid].origin, 
					nil, 
					radius, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					ability:GetAbilityTargetType(), 
					0, 
					0, 
					false)

	local damage_table = {}
		damage_table.attacker = caster
		damage_table.ability = ability
		damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
		damage_table.damage = damage
	for _, unit in pairs(units) do
		damage_table.victim = unit
		ApplyDamage(damage_table)
	end
end
