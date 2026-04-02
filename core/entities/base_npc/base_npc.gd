extends BaseAIEntity
class_name BaseNPC

@export var dialog_file_path:String
@onready var dialog:DialogControl=$DialogControl

func _ready() -> void:
	if not dialog.load_from_csv(dialog_file_path):
		print("ERROR: load dialog file ",dialog_file_path)
		return
	super._ready()
	
