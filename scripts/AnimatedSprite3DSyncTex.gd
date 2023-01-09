extends AnimatedSprite3D

#export(SpatialMaterial) var base_material: SpatialMaterial = null
export(SpatialMaterial) var behind_material: SpatialMaterial = null

func _on_Sprite_frame_changed():
	if not material_override:
		material_override = behind_material.duplicate()
		material_override.next_pass = material_override.next_pass.duplicate()
		#material_override.next_pass = base_material.duplicate()
		#material_override.render_priority = -1
	material_override.albedo_texture = frames.get_frame(animation, frame)
	material_override.next_pass.albedo_texture = frames.get_frame(animation, frame)


