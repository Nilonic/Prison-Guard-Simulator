extends Control

var frame_count : int = 0
var fps_timer : float = 0.0

func _process(delta: float) -> void:
	frame_count += 1
	fps_timer += delta

	# Update FPS every second
	if fps_timer >= 1.0:
		update_fps()
		fps_timer = 0.0

func update_fps() -> void:
	var fps : int = frame_count
	frame_count = 0

	# Find the node named "fpsCounter" and update its text and color
	var fps_counter : Label = globalFunctions.find_node_by_name(get_tree().get_root(), "fpsCounter")
	
	if fps_counter != null:
		fps_counter.text = "FPS: " + str(fps)
		fps_counter.modulate = determine_color(fps)
	else:
		print("Node named 'fpsCounter' not found.")

func determine_color(fps: int) -> Color:
	if fps < 10:
		return Color(1, 0, 0)  # Red
	elif fps <= 20:
		return Color(1, 1, 0)  # Yellow
	else:
		return Color(0, 1, 0)  # Green
