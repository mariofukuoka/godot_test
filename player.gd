extends Area2D
signal hit

@export var speed = 800
@export var max_speed = 300
var screen_size
@export var velocity = Vector2.ZERO
var dash_multiplier = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var accel = Vector2.ZERO
	if Input.is_action_pressed('move_down'):
		accel.y += 1
	if Input.is_action_pressed('move_up'):
		accel.y -= 1
	if Input.is_action_pressed('move_right'):
		accel.x += 1
	if Input.is_action_pressed('move_left'):
		accel.x -= 1
		
	if Input.is_action_just_pressed('dash'):
		position += velocity.normalized() * max_speed * dash_multiplier
	
	if accel.length() > 0:
		accel = accel.normalized() * speed
	
	
	var new_velocity = velocity + (accel * delta)
	if new_velocity.length() < max_speed:
		velocity = new_velocity
	else:
		velocity = new_velocity.normalized() * max_speed
	position += velocity * delta
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if velocity.length() != 0:
		rotation = velocity.angle() + PI/2
	position.x = clamp(position.x, 0, screen_size.x) # clamp x between left and right edges
	position.y = clamp(position.y, 0, screen_size.y) # clamp y between up and down edges
	

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred('disabled', true) # defer the setter until safe to set var
	
func start(pos):
	position = pos
	velocity = Vector2.ZERO
	show()
	$CollisionShape2D.disabled = false
	
