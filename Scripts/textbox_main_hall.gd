extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TextQueue.text_queue.push_back("Wha... what?")
	TextQueue.text_queue.push_back("What happened? Where am I?")
	TextQueue.text_queue.push_back("I remember falling asleep during class... but...")
	TextQueue.text_queue.push_back("Is this really the HSD? It looks different somehow...")
