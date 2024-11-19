extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Signalhive.emit_signal("entered_cutsene")
	Signalhive.emit_signal("queued_message","Wha... what?")
	Signalhive.emit_signal("queued_message","What happened? Where am I?")
	Signalhive.emit_signal("queued_message","I remember falling asleep during class... but...")
	Signalhive.emit_signal("queued_message","Is this really the HSD? It looks different somehow...")
	
