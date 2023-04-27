extends CharacterBody2D

const SPEED = 500.0
const SPEEDMAX = 500
const JUMP_velocity = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1000
#ProjectSettings.get_setting("physics/2d/default_gravity")
var jetpack = true
var saltodoble = true
var estado: String = ""
var dirH = true #false es que mira a la izquierda y true derecha
var acceleration = 300



func _physics_process(delta):
	
	print_debug($duracion_jet.time_left)
	
	if velocity.x > SPEED:
		velocity.x = SPEED
	
	if is_on_floor():
		saltodoble = true
		estado = "parado"
	if not is_on_floor():
		
		if estado == "jetpackeando":
			velocity.y = 0
			
			if Input.is_action_just_released("ui_accept"):
				_Desactivar_timer_jet()
				estado = "cayendo"
		else:
			velocity.y += gravity * delta
			if velocity.y >= 0:
				estado = "cayendo"
				if Input.is_action_pressed("ui_accept") and jetpack == true:
					estado = "jetpackeando"
					jetpack = false 
					_Activar_timer_jet()
	#>< para copiar y pegar
	# Animations
	if Input.is_action_just_pressed("ui_left"):
		$Sprite2D.flip_v = true
	if Input.is_action_just_pressed("ui_right"):
		$Sprite2D.flip_v = false
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_velocity
			estado = "saltando"
			jetpack = true
		if !is_on_floor() and saltodoble:
			velocity.y = JUMP_velocity
			saltodoble = false
			jetpack = true
			estado = "saltando"
	if Input.is_action_just_released("ui_accept") and !is_on_floor() and estado == "saltando":
		velocity.y = 0
		estado = "cayendo"
		if saltodoble == false:
			jetpack = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == 1:
		velocity.x = min(velocity.x + acceleration,SPEED) #ANTES: direction * SPEED
	if direction == -1:
		velocity.x = max(velocity.x - acceleration,-SPEED) #ANTES: direction * SPEED
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED * 2 *delta)

	move_and_slide()
	
func _on_duracion_jet_timeout():
	estado = "cayendo"
	pass
func _Activar_timer_jet():
	$"duracion_jet".start()
	pass
func _Desactivar_timer_jet():
	$"duracion_jet".stop() 
	pass
