--[[Author: Pizzalol
	Date: 10.01.2015.
	It applies a slow of a different duration depending on the time of the day]]
function Void( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier
	local playerid = caster:GetPlayerOwnerID()

	local duration_day = ability:GetLevelSpecialValueFor("duration_day", (ability:GetLevel() - 1))
	local duration_night = ability:GetLevelSpecialValueFor("duration_night", (ability:GetLevel() - 1))
	local duration = 0

	if GameRules:IsDaytime() then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration_day})
		duration = duration_day
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration_night})
		duration = duration_night
	end

	if night_stalker_void_om_target == nil then
		night_stalker_void_om_target = {}
	end

	if night_stalker_void_om_target[playerid] == nil then
		night_stalker_void_om_target[playerid] = {}
	end

	night_stalker_void_om_target[playerid].target = target
	night_stalker_void_om_target[playerid].origin = target:GetAbsOrigin()
	night_stalker_void_om_target[playerid].count = duration * 2
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("night_stalker_void_target_update"),
        function()
        	if night_stalker_void_om_target[playerid].target ~= nil and night_stalker_void_om_target[playerid].count > 0 then
	                night_stalker_void_om_target[playerid].origin = night_stalker_void_om_target[playerid].target:GetAbsOrigin()
	                night_stalker_void_om_target[playerid].count = night_stalker_void_om_target[playerid].count - 1
	                return 0.5
        	else
        		return nil
	            
	        end
        end
       , 0)
end

function void_death_om( keys )
	local caster = keys.caster
	local playerid = caster:GetPlayerOwnerID()
	local ability = keys.ability
	local al = keys.ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor( "radius", al )
	local damage = ability:GetLevelSpecialValueFor( "damage", al )
print(damage)
	local units = FindUnitsInRadius(
					caster:GetTeam(), 
					night_stalker_void_om_target[playerid].origin, 
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
		damage_table.damage_type = DAMAGE_TYPE_MAGICAL
		damage_table.damage = damage
	for _, unit in pairs(units) do
		damage_table.victim = unit
		ApplyDamage(damage_table)
	end
end
