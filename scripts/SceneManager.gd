# SceneManager.gd
extends Node

var saved_scene: Node = null

# Call this from your main level to switch to a secondary scene (e.g., a menu or battle)
func switch_to_temporary_scene(next_scene_path: String):
	var root = get_tree().root
	# Get the current active game scene (usually the last child of root)
	saved_scene = root.get_child(root.get_child_count() - 1)
	
	# Remove it from the tree so it stops processing, but DO NOT free it
	root.remove_child(saved_scene)
	
	# Load and instance the new temporary scene
	var next_scene = load(next_scene_path).instantiate()
	root.add_child(next_scene)

# Call this from the temporary scene to go back to the exact state of your original level
func return_to_saved_scene():
	var root = get_tree().root
	var temp_scene = root.get_child(root.get_child_count() - 1)
	
	# Delete the temporary scene completely
	temp_scene.queue_free()
	
	# Put the original scene back into the visual tree
	if saved_scene != null:
		root.add_child(saved_scene)
		saved_scene = null
