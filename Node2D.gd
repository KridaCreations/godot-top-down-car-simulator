extends Node2D


func _draw():
#	print("here")
	for i in get_parent().get_node("k_car").lines_to_draw:
#		print(i)
		draw_line(get_parent().get_node("k_car").global_position+i[0],(get_parent().get_node("k_car").global_position+i[0])+i[1],"ff6d66",5)
