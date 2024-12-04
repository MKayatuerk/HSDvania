#This node represents the Signalhive or Signalbus for the game

extends Node

signal collected(collectible: Collectible)
signal weapon_equipped(new_weapon: Weapon)
signal weapon_dropped(old_weapon: Weapon)

signal player_entered
signal player_exited
signal player_damaged(damage_taken)
signal player_healed(damage_healed)
signal player_died

signal transported_player(pos: Vector2)
signal retry

signal collected_bafoeg
signal collected_double_jump

signal queued_message(message: String)
signal entered_cutsene()
signal exited_cutscene()

signal heart_demanded(pos: Vector2)
