extends CharacterBody2D
## How to document GODOT functions: 
## @tutorial: https://docs.godotengine.org/en/4.3/tutorials/scripting/gdscript/gdscript_documentation_comments.html
var inputDict: Dictionary = {"D":"move_right", "A":"move_left"}

const WALK_SPEED = 140.0
const RUN_SPEED = 215.0
const JUMP_VELOCITY = -300.0
const DOUBLE_PRESS_TIMEOUT := 0.7

# --- movement
var move_speed: float = 150.0
var direction: float = 0
var canJumpAgain: bool = false
var isDoubleTap: bool = false
var isMegaStompEnabled: bool = true  # TODO hard coded for now. Will implement this properly later
var isMegaStompWindow: bool = false
var isMegaStompActive: bool = false
var lastAnimation: String = "idle"
var currentAnimation: String = "idle"
# --- event monitoring vars
var currentEvent: InputEvent = null
var lastEvent: InputEvent = null
var keyPressIter: int = 0 # TODO no longer needed. REMOVE
var elapsedKeyTime: float = 0.0
var keyDoublePressed: bool = false
var isKeyHeld: bool = false

# --- Game-Defined Actions. FIXME turn into ENUM class?
#var move_left: String = "move_left";
#var move_right: String = "move_right"

# --- Animations
@onready var player_animation: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	elapsedKeyTime += delta
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		canJumpAgain = true
		isMegaStompActive = false
		
	# Handle mega stomp
	if(detectedMegaStomp()):
		velocity.y -= JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	
	
	handleAnimations()	
	handleDoubleJump()

	move_and_slide()

## Handles game-defined player actions.
##
## PARAMS: 
##	- [code]event[\code]: the user input (type: InputEvent)
##	unused event param must remain as this is an overriden native godot method
##RETURNS: None		
func _input(event: InputEvent) -> void:
	currentEvent = event
	currentAnimation = $AnimatedSprite2D.animation
	handleMovementSpeed()
	
	# sets "current" event to "last" event on key release
	if(currentEvent.is_released()):
		lastEvent = event
		lastAnimation = currentAnimation
		player_animation.play("idle")

## Increases player movement speed when left/right buttons are double tapped, set to default speed otherwise
##
func handleMovementSpeed() -> void:
	if(Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left")):
		if(detectedDoubleTap()):
			move_speed = RUN_SPEED
		else:
			move_speed = WALK_SPEED
			elapsedKeyTime = 0
	

## Detects if any key was pressed twice
## [b]Parameters:[/b]: none
## RETURNS: bool -> returns true if a key has been pressed twice.
func keyPressedTwice() -> bool:
	if(lastEvent.as_text() != currentEvent.as_text()):
		elapsedKeyTime = 0
		return false;
	else:
		return true

## checks if a Time component falls within a boundary/limit.
##PARAMS: 
##	timeElapsed (float): The delta from some native process function
##	timeout (float): The boundary/limit, can be custom 
##RETURNS: bool -> true if timeElapsed is less than or equal to the set timeout value
func isWithinTimeLimit(timeElapsed: float, timeout: float) -> bool:
	return timeElapsed <= timeout


## Determines which animation to play based on user input and player state
##			
func handleAnimations() -> void:			# Play animations
	# TODO create player state to build this out more	
	if is_on_floor():
		if direction == 0:
			player_animation.play("idle")
		else:
			if(direction > 0):
				player_animation.flip_h = false
			else:
				player_animation.flip_h = true
			player_animation.play("run")
	else:
		if(isMegaStompWindow):
			player_animation.play("airSpin")
		else:
			player_animation.play("jump")

## Detects if any key has been hit twice within a short timeframe
##
## RETURNS: boolean if a key was double tapped					
func detectedDoubleTap() -> bool:
	if(keyPressedTwice()):
		if(isWithinTimeLimit(elapsedKeyTime, DOUBLE_PRESS_TIMEOUT)):				
			isDoubleTap = true;
			return true
		else:
			elapsedKeyTime = 0
			isDoubleTap = false;
			return false
	else:
		isDoubleTap = false;
		return false

## Adjusts jump height if double jump is detected
##						
func handleDoubleJump() -> void:	
	if(canJumpAgain):
		if(Input.is_action_just_pressed("jump") and detectedDoubleTap()):
			if(!is_on_floor()):
				handleAnimations()
				velocity.y = JUMP_VELOCITY
				canJumpAgain = false

## Detects if user input initiates mega stomp
##
## RETURNS: boolean if mega stomp can be performed				
func detectedMegaStomp() -> bool:	
	if(!isMegaStompEnabled):
		return false
	elif(Input.is_action_just_pressed("jump")):
		if(isMegaStompWindow and !is_on_floor()):
			isMegaStompWindow = false
			return true
		elif(detectedDoubleTap()):
			isMegaStompWindow = true
			return false
		else:
			isMegaStompWindow = false
			return false
	else:
		return false
