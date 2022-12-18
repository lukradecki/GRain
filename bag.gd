extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = get_viewport().get_visible_rect().size.y - (get_node("Sprite2D").texture.get_height()/2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = (get_viewport().get_mouse_position().x - (get_node("Sprite2D").texture.get_height()/2))
	position.y = get_viewport().get_visible_rect().size.y - (get_node("Sprite2D").texture.get_height()/2)
	pass
