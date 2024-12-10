extends CanvasLayer

@onready
var textbox_container = $TextboxContainer
@onready
var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready
var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready
var label = $TextboxContainer/MarginContainer/HBoxContainer/Label
@onready
var tween = get_tree().create_tween()

#Textbox ist ein Automat mit drei Zuständen, je nach Zustand werden entsprechende Funktionen aufgerufen.
enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hide_textbox()
	Signalhive.connect("queued_message",_queue_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				_display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				tween.kill()
				label.visible_characters = -1
				end_symbol.text = "Press SPACE"
				$"../AudioStreamPlayer".play()
				_change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				_change_state(State.READY)
				$"../AudioStreamPlayer".play()
				_hide_textbox()
				

func _queue_text(next_text) -> void: #"Liste" mit Dialogoptionen wird appended.
	text_queue.push_back(next_text)

func _hide_textbox() -> void: # versteckt und resettet Textbox Container, wenn Programm gestartet wird oder die Queue zuende ist.
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()
	if text_queue.is_empty():
		Signalhive.emit_signal("exited_cutscene")

func _show_textbox() -> void: #Zeigt die Textbox im Ready-State an.
	start_symbol.text = ">"
	textbox_container.show()

func _display_text() -> void: # Iteriert über die Queue. Text wird mittels eines Tweens angezeigt d.h. Text wird nachgezogen
	Signalhive.emit_signal("entered_cutsene")
	tween = get_tree().create_tween()
	var next_text = text_queue.pop_front()
	label.text = next_text
	_change_state(State.READING)
	_show_textbox()
	tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * 0.05).from(0).finished
	tween.connect("finished", _on_tween_finished)
	end_symbol.text = "..." 


func _change_state(next_state) -> void: #Aendert die State der Textbox
	current_state = next_state

func _on_tween_finished() -> void: #Signal um Tween zu beenden
	end_symbol.text = "press SPACE"
	_change_state(State.FINISHED)
