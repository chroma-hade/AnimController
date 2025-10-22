## AnimController
**[Important]:** Change location of 'Animations' Folder on code!

#### Type?
- There have "Play", "Stop", "Speed" type to manage animation track!
#### Name?
- The animation name on animation folder!
#### Value?
- The default roblox animation play/stop and adjustspeed value (number)
#### Reset?
- For play animation once like jump, attack, else that don't need to be save timeposition
#### Overwrite?
- Stop all playing animation from **'AnimController'** and play selected animation!

Example is down below.

```luau
-- [ Basic Usage ]
local AnimController = require("ModuleLocation")

local Track : AnimationTrack = AnimController.Control(Animator, {
	["Type"] = "Play", 
	["Name"] = "Attack", -- Animation name!
	["Value"] = 0,
	["Reset"] = true, -- For no sync timeposition.
	["Overwrite"] = true, -- Stop all playing animation on AnimController
})

-- [ Check is animation playing ]
-- you can add more names for multiple check! (like {"Idle", "Eating", "Lying"})
local IsDancePlaying = AnimController.IsThesePlaying(Animator, {"Dance"})
if IsDancePlaying then -- check is that animation playing
	print("Playing!")
else
	warn("Not Dancing!")
end

-- Check is animator playing any "Action" (include 2~4) priority animation
local IsActionPlaying = AnimController.IsActionPlaying(Animator)
if not IsActionPlaying then
	-- Do stuff
else
	warn("Bam! some action priority animation are playing!")
end
-- []
```
