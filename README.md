## AnimController
**[Important]:** Change location of 'Animations' Folder on code!

#### Type?
- There have "Play", "Stop", "Speed" to manage animation track!
#### Name?
- The animation name on animation folder!
#### Value?
- The default roblox animation play/stop and adjustspeed value (number)
#### Reset?
- For play animation once like jump, attack, else that don't need to be save timeposition
#### Overwrite?
- Stop all playing animation from **'AnimController'** and play selected animation!

Example is down blow.

```luau
local AnimController = require("ModuleLocation")

local Track : AnimationTrack = AnimController.Control(Animator, {
	["Type"] = "Play", 
	["Name"] = "Attack", -- Animation name!
	["Value"] = 0,
	["Reset"] = true, -- For no sync timeposition.
	["Overwrite"] = true, -- Stop all playing animation on AnimController
})
```
