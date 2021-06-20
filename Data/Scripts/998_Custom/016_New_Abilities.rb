BattleHandlers::StatusImmunityAbility.add(:IMMUNITY,
  proc { |ability,battler,status|
    next true if status == :POISON
  }
)
