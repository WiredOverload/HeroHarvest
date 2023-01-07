tool
extends EditorPlugin

# Shamelessly copied (and modified) from: https://github.com/poohcom1/godot-animated-sprite-2-player

const SpriteFramesAnimatorEditor = preload("res://addons/sprite_frames_animator/SpriteFramesAnimatorEditor.gd")

var plugin: SpriteFramesAnimatorEditor

func _enter_tree():
	plugin = SpriteFramesAnimatorEditor.new()
	plugin.connect("animation_updated", self, "_refresh", [], CONNECT_DEFERRED)
	add_inspector_plugin(plugin)

func _refresh(anim_player):
	var interface = get_editor_interface()
	
	# Hacky way to force the editor to deselect and reselect
	#	the animation panel, as the panel won't update until then 
	interface.inspect_object(interface.get_edited_scene_root())
	interface.get_selection().clear()
	yield(get_tree().create_timer(0.05), "timeout")
	interface.inspect_object(anim_player)
	
func _exit_tree():
	remove_inspector_plugin(plugin)
