tool
extends EditorInspectorPlugin

# Properties
var anim_player: AnimationPlayer

# Options
var spriteframes: SpriteFrames = null
var spritenodepath: NodePath = "Sprite"
var nameformat: String = "%s"

# Signals
signal animation_updated(animation_player)

func can_handle(object):
	if object is AnimationPlayer:
		anim_player = object
		return true
	return false

func parse_end():
	var headerstyle = StyleBoxFlat.new()
	headerstyle.bg_color = Color8(64, 69, 83)
	var header = Label.new()
	header.set("custom_styles/normal", headerstyle)
	header.margin_top = 10
	header.rect_min_size.y = 25
	header.text = "Import SpriteFrames"
	header.align = Label.ALIGN_CENTER
	header.valign = Label.VALIGN_CENTER
	add_custom_control(header)
	
	var spriteframes_label := SpriteFramesEditorProp.new()
	spriteframes_label.label = "Sprite Frames"
	var spriteframes_resourcepicker = EditorResourcePicker.new()
	spriteframes_resourcepicker.base_type = "SpriteFrames"
	spriteframes_resourcepicker.edited_resource = spriteframes
	spriteframes_resourcepicker.connect("resource_changed", self, "_on_spriteframes_set")
	spriteframes_label.add_child(spriteframes_resourcepicker)
	add_custom_control(spriteframes_label)
	
	var spritenodepath_label := SpriteNodePathEditorProp.new()
	spritenodepath_label.label = "Sprite NodePath"
	var spritenodepath_textedit = LineEdit.new()
	spritenodepath_textedit.text = spritenodepath
	spritenodepath_textedit.connect("text_changed", self, "_on_spritenodepath_set")
	spritenodepath_label.add_child(spritenodepath_textedit)
	add_custom_control(spritenodepath_label)
	
	var nameformat_label := NameFormatEditorProp.new()
	nameformat_label.label = "Name Format String"
	var nameformat_textedit = LineEdit.new()
	nameformat_textedit.text = nameformat
	nameformat_textedit.connect("text_changed", self, "_on_nameformat_set")
	nameformat_label.add_child(nameformat_textedit)
	add_custom_control(nameformat_label)
	
	var button := Button.new()
	button.text = "Import"
	button.rect_min_size.y = 26
	button.connect("button_down", self, "_convert_sprites")
	var buttonstyle = StyleBoxFlat.new()
	buttonstyle.bg_color = Color8(32, 37, 49)
	button.set("custom_styles/normal", buttonstyle)
	add_custom_control(button)


func _on_spriteframes_set(sf):
	spriteframes = sf

func _on_spritenodepath_set(s):
	spritenodepath = s

func _on_nameformat_set(s):
	nameformat = s

func _convert_sprites():
	var count = 0
	
	if not spriteframes:
		print("No SpriteFrames selected!")
		return
	
	for anim_name in spriteframes.get_animation_names():
		var frame_count = spriteframes.get_frame_count(anim_name)
		var fps = spriteframes.get_animation_speed(anim_name)
		var looping = spriteframes.get_animation_loop(anim_name)
		if _sync_animation(
			spritenodepath,
			anim_name,
			frame_count,
			fps,
			looping):
			count += 1
	
	print("Synchronized %d animations!" % [count])
	
	emit_signal("animation_updated", anim_player)

func _sync_animation(anim_sprite: NodePath, anim_name: String, count: int, fps: float, looping: bool):
	var animation: Animation = null
	
	var full_anim_name = nameformat % anim_name
	
	if anim_player.has_animation(full_anim_name):
		animation = anim_player.get_animation(full_anim_name)
	else:
		animation = Animation.new()
		anim_player.add_animation(full_anim_name, animation)
	
	var spf = 1/fps
	animation.length = spf * count
	animation.loop = looping
	
	var spriteframes_track = animation.find_track("%s:frames" % anim_sprite)
	var anim_track = animation.find_track("%s:animation" % anim_sprite)
	var frame_track = animation.find_track("%s:frame" % anim_sprite)
	
	if spriteframes_track == -1:
		spriteframes_track = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(spriteframes_track, "%s:frames" % anim_sprite)
	
	if anim_track == -1:
		anim_track = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(anim_track, "%s:animation" % anim_sprite)
	
	if frame_track == -1:
		frame_track = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(frame_track, "%s:frame" % anim_sprite)
	
	for i in range(0, animation.track_get_key_count(spriteframes_track)):
		animation.track_remove_key(spriteframes_track, 0)
	
	for i in range(0, animation.track_get_key_count(anim_track)):
		animation.track_remove_key(anim_track, 0)
	
	for i in range(0, animation.track_get_key_count(frame_track)):
		animation.track_remove_key(frame_track, 0)
	
	animation.value_track_set_update_mode(spriteframes_track, Animation.UPDATE_DISCRETE)
	animation.track_set_interpolation_type(spriteframes_track, Animation.INTERPOLATION_LINEAR)
	animation.track_insert_key(spriteframes_track, 0, spriteframes)
	
	animation.value_track_set_update_mode(anim_track, Animation.UPDATE_DISCRETE)
	animation.track_set_interpolation_type(anim_track, Animation.INTERPOLATION_LINEAR)
	animation.track_insert_key(anim_track, 0, anim_name)
	
	animation.value_track_set_update_mode(frame_track, Animation.UPDATE_CONTINUOUS)
	animation.track_set_interpolation_type(frame_track, Animation.INTERPOLATION_LINEAR)
	animation.track_set_interpolation_loop_wrap(frame_track, false)
	animation.track_insert_key(frame_track, 0, 0)
	animation.track_insert_key(frame_track, (count - 1) * spf, (count - 1))
	
	return true

class SpriteFramesEditorProp extends EditorProperty:
	func get_tooltip_text():
		return "SpriteFrames resource to load animation data from."

class SpriteNodePathEditorProp extends EditorProperty:
	func get_tooltip_text():
		return "Relative NodePath of the AnimatedSprite."

class NameFormatEditorProp extends EditorProperty:
	func get_tooltip_text():
		return "Format string for animation names."
