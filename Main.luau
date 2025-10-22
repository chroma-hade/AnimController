local AnimController = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = ReplicatedStorage:WaitForChild("Animations") -- change this if it need to be change.

local AnimationStore = {}

type AnimTrack = {
	["Time"] : number,
	["Track"] : AnimationTrack,
}

type ControlData = {
	["Type"] : string,
	["Name"] : string,
	["Value"] : number,
	["Reset"] : boolean,
	["Overwrite"] : boolean,
}

type TypeData = {
	["Type"] : string,
	["TrackData"] : AnimTrack,
	["SyncData"] : AnimTrack,
	["Value"] : number,
}

local function GetAnimationFromName(Name : string)
	local Animation : Animation = Animations:FindFirstChild(Name, true)
	if Animation and Animation:IsA("Animation") then
		return Animation
	end
end

local function GetTrackFromName(Animator : Animator, Name : string)
	local Store = AnimationStore[Animator]
	if not Store then
		AnimationStore[Animator] = {}
		Store = AnimationStore[Animator]
	end
	local TrackData = Store[Name]
	if TrackData then
		return TrackData
	else
		local Animation = GetAnimationFromName(Name)
		if Animation then
			local Track : AnimationTrack = Animator:LoadAnimation(Animation)
			Store[Name] = {}
			Store[Name]["Time"] = 0
			Store[Name]["Track"] = Track
			return Store[Name]
		end
	end
end

local function StopAllAnimations(Animator : Animator, Value : number)
	local Tracks = Animator:GetPlayingAnimationTracks()
	for Index, Track : AnimationTrack in Tracks do
		AnimController.Control(Animator,
			{
				["Type"] = "Stop",
				["Name"] = Track.Name,
				["Value"] = Value
			}
		)
	end
end

local function AdjustType(Data : TypeData)
	local Type = Data["Type"]

	local TrackData = Data["TrackData"]
	local SyncData = Data["SyncData"]

	local MainTrack : AnimationTrack = TrackData["Track"]
	local SyncTrack : AnimationTrack = SyncData and SyncData["Track"]

	if Type == "Play" then
		if not MainTrack.IsPlaying then
			MainTrack:Play(Data["Value"])
			MainTrack.TimePosition = TrackData["Time"]
		end
	elseif Type == "Stop" then
		if MainTrack.IsPlaying then
			TrackData["Time"] = MainTrack.TimePosition
			MainTrack:Stop(Data["Value"])
		end
	elseif Type == "Speed" then
		MainTrack:AdjustSpeed(Data["Value"])
	elseif Type == "SetSync" then
		MainTrack.TimePosition = SyncTrack["Time"]
	end 
end

local function ControlAnimation(Animator : Animator, Data : ControlData)
	local TrackData : AnimTrack = GetTrackFromName(Animator, Data["Name"])
	local SyncData : AnimTrack = GetTrackFromName(Animator, Data["TimeSync"] or "")
	if TrackData then
		if Data["Overwrite"] then
			StopAllAnimations(Animator, Data["Value"])
		end
		if Data["Reset"] then
			TrackData["Time"] = 0
		end
		AdjustType({
			["Type"] = Data["Type"],
			["TrackData"] = TrackData,
			["SyncData"] = SyncData,
			["Value"] = Data["Value"]
		})
		return TrackData["Track"]
	end
end

AnimController.Control = ControlAnimation
AnimController.GetAnimation = GetAnimationFromName
AnimController.GetTrackFromName = GetTrackFromName
AnimController.StopAllAnimations = StopAllAnimations

return AnimController
