extends Node2D

@export var message1 : String
@export var message2 : String
@export var message3 : String
var enter_for_first_time : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_for_first_time = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("lol")
	if(enter_for_first_time && body is MainCharacter):
		enter_for_first_time = false
		if(!message1.is_empty()):
			Signalhive.emit_signal("queued_message",message1)
		if(!message2.is_empty()):
			Signalhive.emit_signal("queued_message",message2)
		if(!message3.is_empty()):
			Signalhive.emit_signal("queued_message",message3)
