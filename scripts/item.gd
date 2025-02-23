extends Interactible

class_name Item

@export var itemSpriteFrames: SpriteFrames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite3D.sprite_frames = itemSpriteFrames
	$AnimatedSprite3D.set_frame(0)


func _on_item_interacted_with() -> void:
	break_item()


func break_item() -> void:
	$AnimatedSprite3D.play("default")


func _on_animated_sprite_3d_animation_finished() -> void:
	queue_free()


func _on_area_entered(area: Area3D) -> void:
	super._on_area_entered(area)
