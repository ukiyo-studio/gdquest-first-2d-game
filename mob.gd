extends CharacterBody2D

signal enemy_defeated

var health = 3
var speed = 150

@onready var player = get_node("/root/Game/Player")

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	
func take_damage():
	health -= 1
	%Slime.play_hurt()
	stun()
	if health <= 0:
		queue_free()
		
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
		enemy_defeated.emit()
		
func stun():
	var opposite_direction = global_position.direction_to(player.global_position) * -1
	velocity = opposite_direction * speed * 10
	move_and_slide()
