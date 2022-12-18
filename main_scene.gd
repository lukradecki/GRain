extends Node2D

@onready var objects = get_node("objects")

@onready var score_label: Label = get_node("score")
@onready var heart_label: Label = get_node("heart/heart_count")
@onready var multiplier_label: Label = get_node("multiplier/multiplier")

@onready var hurt_sound: AudioStreamPlayer = get_node("sounds/hurt")
@onready var pickup_sound: AudioStreamPlayer = get_node("sounds/pickup")
@onready var powerup_sound: AudioStreamPlayer = get_node("sounds/powerup")

@onready var GameOver = get_node("GameOver")
@onready var final_score = get_node("GameOver/final_score")

@onready var gift_scene = load("res://gift.tscn")
@onready var coal_scene = load("res://coal.tscn")
@onready var heart_scene = load("res://heart.tscn")

var score: int = 0;
var heart_count: int = 0;

var max_number_of_objects = 32
var number_of_objects = 0;
var score_multiplier: int = 1

func spawn(count: int):
	number_of_objects += count
	for i in range(count):
		var y_pos = - (randi() % (500-50) + 50)
		var width = get_viewport().get_visible_rect().size.x
		var x_pos = randi() % int((width-100)) + 100
		
		var spawn_chance = randf()
		
		var instance = null
		
		if spawn_chance < 0.005:
			instance = heart_scene.instantiate()
			instance.heart_out_of_scope.connect(_on_heart_out_of_scope)
		elif spawn_chance < 0.4:
			instance = coal_scene.instantiate()
			instance.coal_out_of_scope.connect(_on_coal_out_of_scope)
		else:
			instance = gift_scene.instantiate()
			instance.gift_out_of_scope.connect(_on_gift_out_of_scope)
			
		if score > 100:
			instance.speed *= 1.1
			set_multiplier(3)	
		elif score > 10000:
			instance.speed *= 1.2
			set_multiplier(4)
		elif score > 1000000:
			instance.speed *= 1.3
			set_multiplier(5)
			
		instance.position.y = y_pos
		instance.position.x = x_pos
		objects.add_child(instance)
		
		
func set_multiplier(num: int):
	score_multiplier = num
	multiplier_label.text = str(score_multiplier)

func change_heart(num: int):
	if heart_count + num <= 0:
		heart_count = 0
		heart_label.text = str(heart_count)
		get_tree().paused = true
		final_score.text = "Final Score: " + str(score)
		GameOver.show()
	heart_count += num;
	heart_label.text = str(heart_count)

func add_score(num: int):
	if score + num*score_multiplier < 0:
		score = 0
		score_label.text = "Score: %010d" % score
		return
	score += num*score_multiplier
	score_label.text = "Score: %010d" % score
	var tmp = floori(score/5000)
	if tmp > max_number_of_objects:
		max_number_of_objects = tmp
	
	
	
	
func set_score(num: int):
	score = num*score_multiplier
	score_label.text = "Score: %010d" % score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_score(0)
	change_heart(5)
	set_multiplier(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



	
func _on_gift_out_of_scope(gift: Gift):
	objects.remove_child(gift)
	number_of_objects -= 1
	

func _on_coal_out_of_scope(coal: Coal):
	objects.remove_child(coal)
	number_of_objects -= 1
	
func _on_heart_out_of_scope(heart: Heart):
	objects.remove_child(heart)
	number_of_objects -= 1

func _on_bag_area_entered(area):
	if area.get_class() == "Gift":
		pickup_sound.play()
		if area.point_count == 0: breakpoint
		add_score(area.point_count)
	if area.get_class() == "Coal":
		hurt_sound.play()
		add_score(-area.point_count)
		change_heart(-1)
	if area.get_class() == "Heart":
		powerup_sound.play()
		change_heart(1)
		
	objects.remove_child(area)
	number_of_objects -= 1


func _on_timer_timeout():
	if number_of_objects < max_number_of_objects:
		spawn(randi() % 8 + 1);




func _on_quit_pressed():
	get_tree().quit()


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn")
	get_tree().paused = false
