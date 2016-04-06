function clinkz_strafe_om(keys)
	local target = keys.target
	local caster = keys.caster 
	local targets = keys.target_entities

	local attack = caster:GetAttackDamage()/2

	for i,unit in pairs(targets) do
		if unit ~= target then
			--print(attack)
			local damageTable = {
						victim = unit,    --受到伤害的单位
                        attacker = caster,          --造成伤害的单位
                        damage = attack,        --在这里面必须技能等级减1
                        damage_type = DAMAGE_TYPE_PHYSICAL}    --获取技能伤害类型，就是AbilityUnitDamageType的值
    		ApplyDamage(damageTable)    --造成伤害
		end
	end
end