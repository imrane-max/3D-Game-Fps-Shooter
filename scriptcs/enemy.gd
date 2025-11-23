extends CharacterBody3D

@export var speed = 5
@export var gravity = 10

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = get_node("/root/world/player")




func _physics_process(delta: float) -> void:
	velocity.y += gravity
	$holder.look_at(player.global_position)
	var dir = to_local(navigation_agent_3d.get_next_path_position()).normalized()
	velocity = dir * speed
	$holder.rotation.x = 0
	move_and_slide()
	pass


func make_path():
	navigation_agent_3d.target_position = player.global_position
	pass

func _on_timer_timeout() -> void:
	make_path()
	pass # Replace with function body.
