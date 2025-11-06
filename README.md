## AnimController

#### Type?
- There have "Play", "Stop", "Speed" type to manage animation track!
#### Animation?
- The "Animation" Object for control!
#### Value?
- The default roblox animation play/stop and adjustspeed value (number)
#### Reset?
- For play animation once like jump, attack, else that don't need to be save timeposition
#### Overwrite?
- Stop all playing animation from **'AnimController'** and play selected animation!

Example is down below.

```luau
-- [ Basic Usage ] --
local AnimController = require("ModuleLocation")

local Track : AnimationTrack = AnimController.Control(Animator, {
	["Type"] = "Play", -- (Play, Stop, Speed)
	["Animation"] = PunchAnim, -- Animation Object!
	["Value"] = 0, -- Value for fade time (Play, Stop), and "Speed"
	["Reset"] = true, -- For no loop/sync timeposition.
	["Overwrite"] = true, -- Stop all playing animation on AnimController
})

-- [ Check is Animation are Playing ] --
local IsDancePlaying = AnimController.IsThesePlaying(Animator, {"Dance"})
-- you can add more names for multiple check!
-- like {"Idle", "Eating", "Run"}
if IsDancePlaying then -- check is that animation playing
	print("Animation is Playing!")
else
	warn("Not Dancing!")
end

-- Check is Animator Playing any "Action" (Include 2~4) Priority Animation
local IsActionPlaying = AnimController.IsActionPlaying(Animator)
if not IsActionPlaying then
	print("[Idle Animation]: Can i join?")
else
	warn("Bam! some high priority animation are playing!")
end

-- Stop All Animations
AnimController.StopAllAnimations(Animator, Value) -- "Value" is "number" of fade time!
```
