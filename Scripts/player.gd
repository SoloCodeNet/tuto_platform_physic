extends KinematicBody2D

# mouvement
var max_speed: int = 200
var vel : Vector2
var dirx:int = 0
var snap: Vector2
# gravity
const gravity: int = 800
var jump_height : int = -300
var is_jumping:bool
var jump_count:int = 0
var jump_max:int = 2
var slope_angle : float

func _physics_process(delta):
	# movement Input
	_input_loop()
	if dirx < 0 : $Sprite.flip_h = true
	if dirx > 0 : $Sprite.flip_h = false
	

	if dirx != 0:
		vel.x = lerp(vel.x, max_speed * dirx, 0.2)
	else:
		vel.x = lerp(vel.x, 0, 0.1)
		
	if dirx == 0 and abs(vel.x) < 1:
		vel.x = 0
	
	# gravity and Jump Input
	if not is_on_floor():
		vel.y += gravity * delta

	if is_on_floor():
		jump_count = 0
		snap = Vector2(0, 16)
		
	for i in get_slide_count():
		if  get_slide_collision(i).collider.is_in_group("floor"):
			var normal = get_slide_collision(i).normal
			slope_angle = rad2deg(acos(normal.dot(Vector2(0, -1))))
			$Label.text = ("angle: " + str(int(slope_angle)))
			
	if is_on_wall() and slope_angle >= 45.0 and slope_angle <90:
		jump_count = 0
	
	if is_jumping and jump_count < jump_max:
		if jump_count==0:vel.y = jump_height        # First Jump
		if jump_count==1:vel.y = jump_height * 1.2  # Second Jump
		jump_count+= 1
		snap = Vector2.ZERO

	var slope_stop = false if get_floor_velocity().x == 0 else true

	# movement
#	vel = move_and_slide(vel, Vector2.UP)
	vel = move_and_slide_with_snap(vel, snap, Vector2.UP, slope_stop)
	
	print(vel)
	
func _input_loop():
	dirx = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	is_jumping =Input.is_action_just_pressed("jump")