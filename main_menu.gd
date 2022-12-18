extends TextureRect

@onready var music_slider: HSlider = get_node("HSlider") 


# Called when the node enters the scene tree for the first time.
func _ready():
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")


func _on_h_slider_drag_ended(value_changed):
	if value_changed:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_slider.value))
	pass # Replace with function body.
