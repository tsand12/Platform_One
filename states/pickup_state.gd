extends Node2D
class_name PickupState

# default values of enums are ints, not sure if this will be a problem later or not
enum States {PICKUP_AVAILABLE, PICKUP_EQUIPPED, PICKUP_ACTIVE, PICKUP_EXPIRED}
var initial_state = States.PICKUP_AVAILABLE
var current_state
var pickupCount: int = 0

func is_equipped() -> bool:
	return current_state == States.PICKUP_EQUIPPED
	
func is_active() -> bool:
	return current_state == States.PICKUP_ACTIVE
	
func is_available() -> bool:
	return current_state == States.PICKUP_AVAILABLE
	
func is_expired() -> bool:
	return current_state == States.PICKUP_EXPIRED
	
func get_current_pickup_state() -> States:
	assert(current_state in States.values(),
		 "Pickup state hasn't been properly set. Current State value: " + str(current_state)
	)
	return current_state

func get_current_pickup_state_name() -> String:
	assert(current_state in States.values(),
		 "Pickup state hasn't been properly set. Current State value: " + str(current_state)
	)
	return States.find_key(current_state)
	
func update_pickup_state(state: States)-> void:
	assert(state in PickupState.States.values(), 
		"Invalid Pickup State detected. Expected: " + str(States.values())+ "but got: " + str(state) + " instead"
	)
	current_state = state


### Default functions generated upon script creation. Keeping in case they are useful later
### Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = initial_state
	GameManager.update_coin_state(current_state)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
