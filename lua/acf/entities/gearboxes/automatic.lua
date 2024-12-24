local ACF       = ACF
local Gearboxes = ACF.Classes.Gearboxes

-- Weight
--local wmul = 1.5
local Gear3SW = 60 --* wmul

-- Torque Rating
local Gear3ST = 675

-- Straight through bonuses
local StWB = 0.75 --straight weight bonus mulitplier
local StTB = 1.25 --straight torque bonus multiplier

-- Shift Time
local ShiftS = 0.25

local function InitGearbox(Gearbox)
	local Gears = Gearbox.Gears

	Gearbox.Automatic  = true
	Gearbox.ShiftScale = 1
	Gearbox.Hold       = false
	Gearbox.Drive      = 0
	Gearbox.GearCount  = Gearbox.MaxGear + 1

	Gears[Gearbox.GearCount] = Gearbox.Reverse

	Gearbox:ChangeDrive(1)
end

Gearboxes.Register("Auto", {
	Name		= "Automatic",
	CreateMenu	= ACF.AutomaticGearboxMenu,
	CanSetGears = true,
	Gears = {
		Min	= 0,
		Max	= 8,
	},
	IsScalable = true,
	OnSpawn = InitGearbox,
	OnUpdate = InitGearbox,
	VerifyData = function(Data, Class)
		do -- Shift point table verification
			local Points = Data.ShiftPoints
			local Mult = Data.ShiftUnit or 1
			local Max = Class.Gears.Max

			if not istable(Points) then
				local Encoded = Data.Gear9 and tostring(Data.Gear9)

				Points = { [0] = -1 }

				if Encoded then
					local Count = 0

					for Point in string.gmatch(Encoded, "[^,]+") do
						Count = Count + 1

						if Count > Max then break end

						Points[Count] = ACF.CheckNumber(Point, Count * 100)
					end
				end

				Data.ShiftPoints = Points
			else
				Points[0] = -1
			end

			for I = 1, Max do
				local Point = ACF.CheckNumber(Points[I])

				if not Point then
					Point = ACF.CheckNumber(Data["Shift" .. I], I * 100) * Mult

					Data["Shift" .. I] = nil
				end

				Points[I] = math.Clamp(Point, 0, 9999)
			end
		end

		do -- Reverse gear verification
			local Reverse = ACF.CheckNumber(Data.Reverse)

			if not Reverse then
				Reverse = ACF.CheckNumber(Data.Gear8, -1)

				Data.Gear8 = nil
			end

			Data.Reverse = math.Clamp(Reverse, -1, 1)
		end
	end,
	SetupInputs = function(_, List)
		local Count = #List

		List[Count + 1] = "Hold Gear (If set to a non-zero value, it'll prevent the gearbox from shifting gears.)"
		List[Count + 2] = "Shift Speed Scale (Scales the speeds set for the automatic shifting.)"
	end,
	OnLast = function(Gearbox)
		Gearbox.Automatic  = nil
		Gearbox.ShiftScale = nil
		Gearbox.Drive      = nil
		Gearbox.Hold       = nil
	end,
	GetGearsText = function(Gearbox)
		local GearText  = "Gear %s: %s, Upshift @ %s kph / %s mph\n"
		local Text      = "%sReverse Gear: %s\n"
		local Points    = Gearbox.ShiftPoints
		local Gears     = Gearbox.Gears
		local GearsText = ""

		for I = 1, Gearbox.MaxGear do
			local Ratio = math.Round(Gears[I], 2)
			local KPH = math.Round(Points[I] / 10.936, 1)
			local MPH = math.Round(Points[I] / 17.6, 1)

			GearsText = GearsText .. GearText:format(I, Ratio, KPH, MPH)
		end

		return Text:format(GearsText, math.Round(Gearbox.Reverse, 2))
	end,
})

do -- Scalable Gearboxes
	Gearboxes.RegisterItem("Auto-L", "Auto", {
		Name			= "Automatic, Inline",
		Description		= "An inline gearbox capable of automatically shifting gears based on speed.",
		Model			= "models/engines/linear_s.mdl",
		Mass			= Gear3SW,
		Switch			= ShiftS,
		MaxTorque		= Gear3ST,
		CanDualClutch	= true,
		Preview = {
			FOV = 125,
		},
	})

	Gearboxes.RegisterItem("Auto-T", "Auto", {
		Name			= "Automatic, Transaxial",
		Description		= "A transaxial gearbox capable of automatically shifting gears based on speed.",
		Model			= "models/engines/transaxial_s.mdl",
		Mass			= Gear3SW,
		Switch			= ShiftS,
		MaxTorque		= Gear3ST,
		CanDualClutch	= true,
		Preview = {
			FOV = 85,
		},
	})

	Gearboxes.RegisterItem("Auto-ST", "Auto", {
		Name		= "Automatic, Straight",
		Description	= "A straight-through gearbox capable of automatically shifting gears based on speed.",
		Model		= "models/engines/t5small.mdl",
		Mass		= math.floor(Gear3SW * StWB),
		Switch		= ShiftS,
		MaxTorque	= math.floor(Gear3ST * StTB),
		Preview = {
			FOV = 105,
		},
	})
end