extends Node
@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	get_tree().call_group('mobs', 'queue_free')
	
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message('Get ready!')


func _on_mob_timer_timeout():
	# instantiate mob
	var mob = mob_scene.instantiate()
	
	# get spawn loc node
	var mob_spawn_location = get_node('MobPath/MobSpawnLocation')
	
	# set rand pos
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	# set rand rot
	mob.rotation = mob_spawn_location.rotation + PI/2 + randf_range(-PI/4, PI/4)
	
	# set rand vel
	mob.linear_velocity = (randf_range(150, 250) * Vector2(1.0, 0.0)).rotated(mob.rotation)
	
	add_child(mob)
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
