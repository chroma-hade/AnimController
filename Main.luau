local AnimController = {}

local AnimationStore = {}

type TrackData = {
	["Time"] : number,
	["Track"] : AnimationTrack,
}

type ControlData = {
	["Type"] : string,
	["Animation"] : Animation,
	["Value"] : number,
	["Reset"] : boolean,
	["Overwrite"] : boolean,
}

type TypeData = {
	["Type"] : string,
	["TrackData"] : TrackData,
	["SyncData"] : TrackData,
	["Value"] : number,
}

local function GetTrack(Animator : Animator, Animation : Animation)
	local Store = AnimationStore[Animator]
	if not Store then
		AnimationStore[Animator] = {}
		Store = AnimationStore[Animator]
	end
	local TrackData = Store[Animation]
	if TrackData then
		return TrackData
	else
		if not Animation or not Animation:IsA("Animation") then
			return
		end
		local Track : AnimationTrack = Animator:LoadAnimation(Animation)
		Store[Animation] = {}
		Store[Animation]["Time"] = 0
		Store[Animation]["Track"] = Track
		return Store[Animation]
	end
end

local function FindSameName(Track : AnimationTrack, Names : {string})
	for Index, Name in Names do
		if Track.Name ~= Name or not Track.IsPlaying then
			continue
		end
		return true
	end
end

local function IsThesePlaying(Animator : Animator, Names : {string})
	local Tracks = Animator:GetPlayingAnimationTracks()
	local LocalStore = AnimationStore[Animator]
	local IsPlaying = nil
	if not LocalStore then
		return
	end
	for Index, Track : AnimationTrack in Tracks do
		IsPlaying = not IsPlaying and FindSameName(Track, Names)
		if not IsPlaying then
			continue
		end
		return true
	end
end

local function IsActionPlaying(Animator : Animator) : boolean
	local Tracks = Animator:GetPlayingAnimationTracks()
	local LocalStore = AnimationStore[Animator]
	if not LocalStore then
		return
	end
	for Index, Track : AnimationTrack in Tracks do
		local IsAction = string.find(Track.Priority.Name, "Action")
		if not LocalStore[Track.Name] or Track.IsPlaying and not IsAction then
			continue
		end
		return true
	end
end

local function StopAllAnimations(Animator : Animator, Value : number)
	local Tracks = Animator:GetPlayingAnimationTracks()
	for Index, Track : AnimationTrack in Tracks do
		AnimController.Control(Animator,{
			["Type"] = "Stop",
			["Animation"] = Track.Animation,
			["Value"] = Value
		})
	end
end

local function AdjustType(Data : TypeData)
	local Type = Data["Type"]

	local TrackData : TrackData = Data["TrackData"]
	local SyncData : TrackData = Data["SyncData"]

	local MainTrack : AnimationTrack = TrackData["Track"]
	local SyncTrack : AnimationTrack = SyncData and SyncData["Track"]

	if Type == "Play" and MainTrack.IsPlaying then
		MainTrack:Play(Data["Value"])
		MainTrack.TimePosition = TrackData["Time"]
	elseif Type == "Stop" and MainTrack.IsPlaying then
		TrackData["Time"] = MainTrack.TimePosition
		MainTrack:Stop(Data["Value"])
	elseif Type == "Speed" then
		MainTrack:AdjustSpeed(Data["Value"])
	elseif Type == "SetSync" then  
		MainTrack.TimePosition = SyncTrack["Time"]
	end 
end

local function ControlAnimation(Animator : Animator, Data : ControlData) : AnimationTrack
	local TrackData : TrackData = GetTrack(Animator, Data["Animation"])
	local SyncData : TrackData = GetTrack(Animator, Data["TimeSync"])
	if not TrackData then
		return
	end
	if Data["Overwrite"] then
		StopAllAnimations(Animator, Data["Value"])
	end
	if Data["Reset"] then
		TrackData["Time"] = 0
		TrackData["Track"]:Stop()
	end
	AdjustType({
		["Type"] = Data["Type"],
		["TrackData"] = TrackData,
		["SyncData"] = SyncData,
		["Value"] = Data["Value"]
	})
	return TrackData["Track"]
end

AnimController.Control = ControlAnimation
AnimController.StopAllAnimations = StopAllAnimations

AnimController.IsThesePlaying = IsThesePlaying
AnimController.IsActionPlaying = IsActionPlaying

return AnimController
