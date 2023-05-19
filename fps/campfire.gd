extends Workbench
class_name Campfire

signal changed_burning_state(is_burning : bool)

@onready var input_inventory : Inventory = $InputInventory
@export var wood_item : InventoryItem
@onready var gpu_particles_3d = $Node/GPUParticles3D
@onready var craft_station : CraftStation = $CraftStation

@export var decrease_fuel_multiplier = 1

var fuel := 0.0:
	set(new_value):
		fuel = new_value
		is_burning = fuel > 0.0
		
var max_seconds := 120.0

var is_burning := false:
	set(new_value):
		if is_burning != new_value:
			is_burning = new_value
			check()
			emit_signal("changed_burning_state",is_burning)
			_update_is_burning()
			

func _ready():
	_update_is_burning()
	

func _update_is_burning():
	$Node.visible = is_burning
	craft_station.auto_craft = is_burning
	craft_station.can_processing_craftings = is_burning


func _on_input_inventory_item_added(_item, _amount):
	check()


func _on_input_inventory_item_removed(_item, _amount):
	check()


func check() -> bool:
	if is_burning:
		return false
	if not input_inventory.contains(wood_item):
		return false
	input_inventory.remove(wood_item)
	if wood_item.properties.has("fuel"):
		fuel += wood_item.properties["fuel"]
		return true
	return false


func _process(delta):
	if fuel > 0.0:
		fuel -= delta * decrease_fuel_multiplier
