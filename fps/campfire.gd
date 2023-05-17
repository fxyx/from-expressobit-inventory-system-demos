extends Workbench
class_name Campfire

@onready var input_inventory : Inventory = $InputInventory
@export var wood_item : InventoryItem
@onready var gpu_particles_3d = $Node/GPUParticles3D
@onready var craft_station : CraftStation = $CraftStation

@export var decrease_fuel_multiplier = 1

var fuel := 0.0:
	set(new_value):
		fuel = new_value
		$Node.visible = fuel > 0.0
		check()
		print(fuel)
#		gpu_particles_3d.amount = clamp(seconds, 1, 32)
		craft_station.auto_craft = fuel > 0.0
		craft_station.can_processing_craftings = fuel > 0.0
var max_seconds := 120.0

func _ready():
	$Node.visible = fuel > 0.0

func _on_craft_station_crafting_added(_crafting_index):
	pass # Replace with function body.


func _on_craft_station_crafting_removed(_crafting_index):
	pass # Replace with function body.


func _on_input_inventory_item_added(_item, _amount):
	check()


func _on_input_inventory_item_removed(_item, _amount):
	check()


func check():
	if input_inventory.contains(wood_item):
		input_inventory.remove(wood_item)
		if wood_item.properties.has("fuel"):
			fuel += wood_item.properties["fuel"]


func _process(delta):
	if fuel > 0.0:
		fuel -= delta * decrease_fuel_multiplier
