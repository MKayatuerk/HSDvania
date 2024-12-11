extends Node

var _collectibles: Array = []
var _equipped_weapon: Weapon = null

func add(new_collectible: Collectible) -> void:
	if new_collectible is Weapon:
		_equip_weapon(new_collectible as Weapon)
	else:
		_collectibles.append(new_collectible)

		if new_collectible.get_parent():
			new_collectible.get_parent().remove_child(new_collectible)

func _equip_weapon(new_weapon: Weapon) -> void:
	if _equipped_weapon:
		_drop_weapon(_equipped_weapon)
	_equipped_weapon = new_weapon
	Signalhive.emit_signal("weapon_equipped", new_weapon)

func _drop_weapon(current_weapon: Weapon) -> void:
	Signalhive.emit_signal("weapon_dropped", current_weapon)
	#print("Weapon dropped: ", current_weapon.item_name)
	pass

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
