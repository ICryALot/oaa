﻿LinkLuaModifier("modifier_intrinsic_multiplexer", "modifiers/modifier_intrinsic_multiplexer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spiked_mail_stacking_stats", "items/spiked_mail.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spiked_mail_passive_return", "items/spiked_mail.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spiked_mail_active_return", "items/spiked_mail.lua", LUA_MODIFIER_MOTION_NONE)

item_spiked_mail_1 = class(ItemBaseClass)

function item_spiked_mail_1:GetIntrinsicModifierName()
  return "modifier_intrinsic_multiplexer"
end

function item_spiked_mail_1:GetIntrinsicModifierNames()
  return {
    "modifier_item_spiked_mail_stacking_stats",
    "modifier_item_spiked_mail_passive_return",
  }
end

function item_spiked_mail_1:OnSpellStart()
  local caster = self:GetCaster()
  -- Sound
  caster:EmitSound("DOTA_Item.BladeMail.Activate")
  -- Get duration
  local buff_duration = self:GetSpecialValueFor("duration")
  -- Apply modifier
  caster:AddNewModifier(caster, self, "modifier_item_spiked_mail_active_return", {duration = buff_duration})
end

function item_spiked_mail_1:ProcsMagicStick()
  return false
end

-- upgrades
item_spiked_mail_2 = item_spiked_mail_1
item_spiked_mail_3 = item_spiked_mail_1
item_spiked_mail_4 = item_spiked_mail_1
item_spiked_mail_5 = item_spiked_mail_1

---------------------------------------------------------------------------------------------------

modifier_item_spiked_mail_stacking_stats = class(ModifierBaseClass)

function modifier_item_spiked_mail_stacking_stats:IsHidden()
  return true
end

function modifier_item_spiked_mail_stacking_stats:IsDebuff()
  return false
end

function modifier_item_spiked_mail_stacking_stats:IsPurgable()
  return false
end

function modifier_item_spiked_mail_stacking_stats:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_spiked_mail_stacking_stats:OnCreated()
  local ability = self:GetAbility()
  if ability and not ability:IsNull() then
    self.dmg = ability:GetSpecialValueFor("bonus_damage")
    self.armor = ability:GetSpecialValueFor("bonus_armor")
    self.int = ability:GetSpecialValueFor("bonus_intellect")
  end
end

function modifier_item_spiked_mail_stacking_stats:OnRefresh()
  local ability = self:GetAbility()
  if ability and not ability:IsNull() then
    self.dmg = ability:GetSpecialValueFor("bonus_damage")
    self.armor = ability:GetSpecialValueFor("bonus_armor")
    self.int = ability:GetSpecialValueFor("bonus_intellect")
  end
end

function modifier_item_spiked_mail_stacking_stats:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  }
end

function modifier_item_spiked_mail_stacking_stats:GetModifierPreAttack_BonusDamage()
  return self.dmg or self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_spiked_mail_stacking_stats:GetModifierPhysicalArmorBonus()
  return self.armor or self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_item_spiked_mail_stacking_stats:GetModifierBonusStats_Intellect()
  return self.int or self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

---------------------------------------------------------------------------------------------------

modifier_item_spiked_mail_passive_return = class(ModifierBaseClass)

function modifier_item_spiked_mail_passive_return:IsHidden()
  return true
end

function modifier_item_spiked_mail_passive_return:IsDebuff()
  return false
end

function modifier_item_spiked_mail_passive_return:IsPurgable()
  return false
end

function modifier_item_spiked_mail_passive_return:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
  }
end

function modifier_item_spiked_mail_passive_return:OnTakeDamage(event)
  if not IsServer() then
    return
  end

  local parent = self:GetParent()

  -- Trigger only for this modifier
  if parent ~= event.unit then
    return
  end

  -- Don't trigger on illusions
  if parent:IsIllusion() then
    return
  end

  -- If there is a stronger reflection modifier, don't continue
  if parent:HasModifier("modifier_item_spiked_mail_active_return") or parent:HasModifier("modifier_item_blade_mail_reflect") then
    return
  end

  -- Damage before reductions
  local damage = event.original_damage

  -- If damage is negative or 0, don't continue
  if damage <= 0 then
    return
  end

  local damage_flags = event.damage_flags
  local attacker = event.attacker

  -- Don't continue if damage has HP removal flag
  if bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
    return
  end

  -- Don't continue if damage has Reflection flag
  if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
    return
  end

  -- Don't continue if attacker doesn't exist or if attacker is about to be deleted
  if not attacker or attacker:IsNull() then
    return
  end

  -- Don't trigger on self damage or on damage originating from allies
  if attacker == parent or attacker:GetTeamNumber() == parent:GetTeamNumber() then
    return
  end

  -- Don't trigger if attacker is dead, invulnerable or banished
  if not attacker:IsAlive() or attacker:IsInvulnerable() or attacker:IsOutOfGame() then
    return
  end

  -- Don't trigger on buildings, towers and wards
  if attacker:IsBuilding() or attacker:IsTower() or attacker:IsOther() then
    return
  end

  local ability = self:GetAbility()
  if not ability then
    return
  end

  -- Fetch the damage return amount/percentage
  local damage_return = ability:GetSpecialValueFor("passive_reflection_pct")

  -- Calculating damage that will be returned to attacker
  local new_damage = damage * damage_return / 100

  local damage_table = {}
  damage_table.victim = attacker
  damage_table.attacker = parent
  damage_table.damage_type = event.damage_type -- Same damage type as original damage
  damage_table.ability = ability
  damage_table.damage = new_damage
  damage_table.damage_flags = bit.bor(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)

  ApplyDamage(damage_table)
end

---------------------------------------------------------------------------------------------------

modifier_item_spiked_mail_active_return = class(ModifierBaseClass)

function modifier_item_spiked_mail_active_return:IsHidden()
  return false
end

function modifier_item_spiked_mail_active_return:IsDebuff()
  return false
end

function modifier_item_spiked_mail_active_return:IsPurgable()
  return false
end

function modifier_item_spiked_mail_active_return:GetEffectName()
  return "particles/items_fx/blademail.vpcf"
end

function modifier_item_spiked_mail_active_return:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW -- follow_origin
end

function modifier_item_spiked_mail_active_return:GetStatusEffectName()
  return "particles/status_fx/status_effect_blademail.vpcf"
end

function modifier_item_spiked_mail_active_return:OnCreated()
  local parent = self:GetParent()
  if IsServer() then
    -- If there is a Blade Mail modifier, remove it
    if parent:HasModifier("modifier_item_blade_mail_reflect") then
      parent:RemoveModifierByName("modifier_item_blade_mail_reflect")
    end
  end
end

function modifier_item_spiked_mail_active_return:OnDestroy()
  if IsServer() then
    self:GetParent():EmitSound("DOTA_Item.BladeMail.Deactivate")
  end
end

function modifier_item_spiked_mail_active_return:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_TAKEDAMAGE,
  }
end

function modifier_item_spiked_mail_active_return:OnTakeDamage(event)
	if not IsServer() then
    return
  end

  local parent = self:GetParent()

  -- Trigger only for this modifier
  if parent ~= event.unit then
    return
  end

  -- Don't trigger on illusions (illusions can't get this modifier through normal means)
  if parent:IsIllusion() then
    return
  end

  -- If there is a Blade Mail modifier, remove it
  if parent:HasModifier("modifier_item_blade_mail_reflect") then
    parent:RemoveModifierByName("modifier_item_blade_mail_reflect")
  end

  -- Damage before reductions
  local damage = event.original_damage

  -- If damage is negative or 0, don't continue
  if damage <= 0 then
    return
  end

  local damage_flags = event.damage_flags
  local attacker = event.attacker

  -- Don't continue if damage has HP removal flag
  if bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
    return
  end

  -- Don't continue if damage has Reflection flag
  if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
    return
  end

  -- Don't continue if attacker doesn't exist or if attacker is about to be deleted
  if not attacker or attacker:IsNull() then
    return
  end

  -- Don't trigger on self damage or on damage originating from allies
  if attacker == parent or attacker:GetTeamNumber() == parent:GetTeamNumber() then
    return
  end

  -- Don't trigger if attacker is dead, invulnerable or banished
  if not attacker:IsAlive() or attacker:IsInvulnerable() or attacker:IsOutOfGame() then
    return
  end

  -- Don't trigger on buildings, towers and wards
  if attacker:IsBuilding() or attacker:IsTower() or attacker:IsOther() then
    return
  end

  local ability = self:GetAbility()
  if not ability then
    return
  end

  -- Fetch the damage return amount/percentage
  local damage_return = ability:GetSpecialValueFor("active_reflection_pct")

  -- Calculating damage that will be returned to attacker
  local new_damage = damage * damage_return / 100

  local damage_table = {}
  damage_table.victim = attacker
  damage_table.attacker = parent
  damage_table.damage_type = DAMAGE_TYPE_PURE
  damage_table.ability = ability
  damage_table.damage = new_damage
  damage_table.damage_flags = bit.bor(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)

  ApplyDamage(damage_table)

  EmitSoundOnClient("DOTA_Item.BladeMail.Damage", attacker:GetPlayerOwner())
end

function modifier_item_spiked_mail_active_return:GetTexture()
  return "custom/lionsmane_1"
end
