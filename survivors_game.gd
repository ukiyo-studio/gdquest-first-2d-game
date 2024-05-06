extends Node2D

var score = 0
var difficulty_level = 1
var spawn_counter = 0
var spawn_timer_increase_threshold = 5

func _ready():
	spawn_mob()
	spawn_mob()
	spawn_mob()

func spawn_mob():
	const MOB_SCENE = preload("res://mob.tscn")
	var new_mob = MOB_SCENE.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.speed += 50 * difficulty_level
	add_child(new_mob)
	new_mob.enemy_defeated.connect(_on_mob_enemy_defeated)
	spawn_counter += 1


func _on_timer_timeout():
	spawn_mob()
	if spawn_counter > spawn_timer_increase_threshold:
		if %SpawnTimer.wait_time > 0.5:
			increase_difficulty()
	
func increase_difficulty():
	%SpawnTimer.wait_time -= 0.5
	spawn_timer_increase_threshold += 5
	difficulty_level += 1


func _on_player_health_depleted():
	%Score.visible = false
	%GameOverScreen.visible = true
	get_tree().paused = true
	%GameOverScore.text = "Score: " + str(score)


func _on_mob_enemy_defeated():
	score += 1
	%ScoreLabel.text = "Score: " + str(score)
	
