class_name Multiplier
extends Area2D

signal multiplier_out_of_scope(coal: Coal)

@export var speed: float = 500.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += delta*speed
	if (position.y > get_viewport().get_visible_rect().size.y + get_node("image").texture.get_height()):
		emit_signal("multiplier_out_of_scope", self)
	pass

func get_class(): return "Multiplier"
