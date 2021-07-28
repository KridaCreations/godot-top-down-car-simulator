#	lines_to_draw.append([pos,impulse*500])
	var d_angular_velocity = impulse.cross(pos)/10#(moi+(mass*(pos.length_squared())))
	
	var n_a_vel = angular_velcity + d_angular_velocity
	if (n_a_vel * angular_velcity <0) :#or (angular_velcity == 0):
		angular_velcity = 0
	else:
		angular_velcity = n_a_vel
	
	var d_velocity = impulse/mass
	var nv_x = velocity.x + d_velocity.x
	if (nv_x * velocity.x < 0) :#or (velocity.x == 0):
		velocity.x = 0
	else:
		velocity.x += d_velocity.x
	var nv_y = velocity.y + d_velocity.y
	if (nv_y * velocity.y < 0) :#or (velocity.y == 0):
		velocity.y = 0
	else:
		velocity.y += d_velocity.y


mass = 1
kf = 2
rf = 0.5
e_force = -5
maxspeed = 900


mass = 1
kf = 3
rf = 0.1
e_force = -5
maxspeed = 1000
