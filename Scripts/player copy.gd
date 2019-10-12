extends KinematicBody2D

# mouvement
var max_speed: int = 200
var accel: int = 5
var vel : Vector2
var dirx:int = 0
var snap: Vector2
# gravity
const gravity: int = 15
var jump_height : int = -300
var jump_count:int = 0
var jump_max:int = 2
var slope_angle : float

func _process(delta: float) -> void:
	# movement Input
	dirx = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if dirx < 0 : $Sprite.flip_h = true
	if dirx > 0 : $Sprite.flip_h = false
		

	if dirx != 0:
		vel.x = lerp(vel.x, max_speed * dirx, 0.1)
	else:
		vel.x = lerp(vel.x, 0, 0.1)
	
	# gravity and Jump Input
	if not is_on_floor():
		vel.y += gravity 

	if jump_count!=0 && is_on_floor():
		jump_count = 0
		snap = Vector2(0, 32)
		
	for i in get_slide_count():
		if  get_slide_collision(i).collider.is_in_group("floor"):
			var normal = get_slide_collision(i).normal
			slope_angle = rad2deg(acos(normal.dot(Vector2(0, -1))))
			$Label.text = ("ground angle: " + str(int(slope_angle)))
			
	if is_on_wall() and slope_angle >= 45.0 and slope_angle <90:
		jump_count = 0
	
	if Input.is_action_just_pressed("jump") and jump_count < jump_max:
		if jump_count==0:vel.y = jump_height        # First Jump
		if jump_count==1:vel.y = jump_height * 1.2  # Second Jump
		jump_count+= 1
		snap = Vector2.ZERO
		
	if dirx == 0 && abs(vel.x) <24:
		vel.x = 0
	
	
	var slope = true if get_floor_velocity().x ==0 else false
	
	# movement
#	vel = move_and_slide(vel, Vector2.UP)
	vel = move_and_slide_with_snap(vel, snap, Vector2.UP, slope)
	print(vel)
	