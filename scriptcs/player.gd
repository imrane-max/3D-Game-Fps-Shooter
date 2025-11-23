extends CharacterBody3D


@export var speed = 7
@export var jump_velocity = 10
@export var gravity = -9.8
# body #
@onready var head: Node3D = $head
@onready var camera_3d: Camera3D = $head/Camera3D
 # SENSEVITY #
var SENSEVITY = 0.004

# Shoot Varaiables #
var Bullet_Scene = preload("res://scense/bullet.tscn")
var Bullets_left = 40
# Gun varaiabels #
@onready var Gun_Ray: RayCast3D = $head/Camera3D/Gun/RayCast3D
@onready var Gun_Animation: AnimationPlayer = $head/Camera3D/Gun/AnimationPlayer
# healt #
var hp = 100
@onready var healt_bar: ProgressBar = %Healt_Bar




# Hide The mouse #
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass






# mous Motion #
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSEVITY)
		camera_3d.rotate_x(-event.relative.y * SENSEVITY)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	pass








func _physics_process(delta: float) -> void:
	healt_bar.value = hp
	$head/Camera3D/Bullets_Left_Label.text = str(Bullets_left) + "/40"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if hp <= 0:
		get_tree().reload_current_scene()
	# Shoot Condition #
	if Input.is_action_pressed("shoot") and Bullets_left > 0:
		if !Gun_Animation.is_playing():
			$Shoot.play()
			Gun_Animation.play("shoot")
			shoot()
			
	if Input.is_action_just_pressed("reload"):
		Bullets_left = 40
		Gun_Animation.play("reload")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_pressed("Sprint"):
		speed = 10
		camera_3d.fov = 120.0
	else :
		camera_3d.fov = 75.0
		speed = 7
	if Input.is_action_pressed("Zoom"):
		camera_3d.fov = 60
	else :
		camera_3d.fov = 75.0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

# Shoot Function #
func shoot():
	Bullets_left -= 1
	var bullet_clone = Bullet_Scene.instantiate()
	bullet_clone.position = Gun_Ray.global_position
	bullet_clone.transform.basis = Gun_Ray.global_transform.basis
	get_parent().add_child(bullet_clone)
	


func _on_kile_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		hp -= 10
	pass # Replace with function body.
