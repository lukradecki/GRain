class_name Gift
extends Area2D

signal gift_out_of_scope(gift: Gift)

@export var point_count: int = 1
@export var speed: float = 500.0

var freeze = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = (randi() % 10) + 1
	point_count = 11-i
	get_node("CollisionShape2D").scale = Vector2(i/10.0,i/10.0)
	get_node("image").scale = Vector2(i/10.0,i/10.0)
	speed += float((10-i)*200)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += delta*speed
	if (position.y > get_viewport().get_visible_rect().size.y + get_node("image").texture.get_height()):
		emit_signal("gift_out_of_scope", self)
		freeze = true
	pass

func get_class(): return "Gift"
