local Ammo = ACF.RegisterAmmoType("AP")

function Ammo:OnLoaded()
	self.Name		 = "Armor Piercing"
	self.Model		 = "models/munitions/round_100mm_shot.mdl"
	self.Description = "A shell made out of a solid piece of steel, meant to penetrate armor."
	self.Blacklist = {
		MO = true,
		SB = true,
		SL = true,
	}
end

function Ammo:GetDisplayData(BulletData)
	local Energy = ACF_Kinetic(BulletData.MuzzleVel * 39.37, BulletData.ProjMass, BulletData.LimitVel)

	return {
		MaxPen = (Energy.Penetration / BulletData.PenArea) * ACF.KEtoRHA
	}
end

function Ammo:UpdateRoundData(ToolData, Data, GUIData)
	GUIData = GUIData or Data

	ACF.UpdateRoundSpecs(ToolData, Data, GUIData)

	Data.ProjMass  = Data.FrArea * Data.ProjLength * 0.0079 --Volume of the projectile as a cylinder * density of steel
	Data.MuzzleVel = ACF_MuzzleVelocity(Data.PropMass, Data.ProjMass)
	Data.DragCoef  = Data.FrArea * 0.0001 / Data.ProjMass
	Data.CartMass  = Data.PropMass + Data.ProjMass

	for K, V in pairs(self:GetDisplayData(Data)) do
		GUIData[K] = V
	end
end

function Ammo:BaseConvert(ToolData)
	local Data, GUIData = ACF.RoundBaseGunpowder(ToolData, {})

	Data.ShovePower	 = 0.2
	Data.PenArea	 = Data.FrArea ^ ACF.PenAreaMod
	Data.LimitVel	 = 800 --Most efficient penetration speed in m/s
	Data.KETransfert = 0.1 --Kinetic energy transfert to the target for movement purposes
	Data.Ricochet	 = 60 --Base ricochet angle

	self:UpdateRoundData(ToolData, Data, GUIData)

	return Data, GUIData
end

function Ammo:VerifyData(ToolData)
	if not ToolData.Projectile then
		local Projectile = ToolData.RoundProjectile

		ToolData.Projectile = Projectile and tonumber(Projectile) or 0
	end

	if not ToolData.Propellant then
		local Propellant = ToolData.RoundPropellant

		ToolData.Propellant = Propellant and tonumber(Propellant) or 0
	end

	if ToolData.Tracer == nil then
		local Data10 = ToolData.RoundData10

		ToolData.Tracer = Data10 and tobool(tonumber(Data10)) or false -- Haha "0.00" is true but 0 isn't
	end
end

if SERVER then
	ACF.AddEntityArguments("acf_ammo", "Projectile", "Propellant", "Tracer") -- Adding extra info to ammo crates

	function Ammo:OnLast(Entity)
		Entity.Projectile = nil
		Entity.Propellant = nil
		Entity.Tracer = nil

		-- Cleanup the leftovers aswell
		Entity.RoundProjectile = nil
		Entity.RoundPropellant = nil
		Entity.RoundData10 = nil
	end

	function Ammo:Create(_, BulletData)
		ACF_CreateBullet(BulletData)
	end

	function Ammo:ServerConvert(ToolData)
		self:VerifyData(ToolData)

		local Data = self:BaseConvert(ToolData)

		Data.Id = ToolData.Weapon
		Data.Type = ToolData.AmmoType

		return Data
	end

	function Ammo:Network(Entity, BulletData)
		Entity:SetNW2String("AmmoType", "AP")
		Entity:SetNW2String("AmmoID", BulletData.Id)
		Entity:SetNW2Float("Caliber", BulletData.Caliber)
		Entity:SetNW2Float("ProjMass", BulletData.ProjMass)
		Entity:SetNW2Float("PropMass", BulletData.PropMass)
		Entity:SetNW2Float("DragCoef", BulletData.DragCoef)
		Entity:SetNW2Float("Tracer", BulletData.Tracer)
	end

	function Ammo:GetCrateName()
	end

	function Ammo:GetCrateText(BulletData)
		local Data = self:GetDisplayData(BulletData)
		local Text = "Muzzle Velocity: %s m/s\nMax Penetration: %s mm"

		return Text:format(math.Round(BulletData.MuzzleVel, 2), math.Round(Data.MaxPen, 2))
	end

	function Ammo:PropImpact(_, Bullet, Target, HitNormal, HitPos, Bone)
		if ACF_Check(Target) then
			local Speed  = Bullet.Flight:Length() / ACF.Scale
			local Energy = ACF_Kinetic(Speed, Bullet.ProjMass, Bullet.LimitVel)
			local HitRes = ACF_RoundImpact(Bullet, Speed, Energy, Target, HitPos, HitNormal, Bone)

			if HitRes.Overkill > 0 then
				table.insert(Bullet.Filter, Target) --"Penetrate" (Ingoring the prop for the retry trace)

				Bullet.Flight = Bullet.Flight:GetNormalized() * (Energy.Kinetic * (1 - HitRes.Loss) * 2000 / Bullet.ProjMass) ^ 0.5 * 39.37

				return "Penetrated"
			elseif HitRes.Ricochet then
				return "Ricochet"
			else
				return false
			end
		else
			table.insert(Bullet.Filter, Target)

			return "Penetrated"
		end
	end

	function Ammo:WorldImpact(_, Bullet, HitPos, HitNormal)
		local Energy = ACF_Kinetic(Bullet.Flight:Length() / ACF.Scale, Bullet.ProjMass, Bullet.LimitVel)
		local HitRes = ACF_PenetrateGround(Bullet, Energy, HitPos, HitNormal)

		if HitRes.Penetrated then
			return "Penetrated"
		elseif HitRes.Ricochet then
			return "Ricochet"
		else
			return false
		end
	end

	function Ammo:OnFlightEnd(Index)
		ACF_RemoveBullet(Index)
	end
else
	ACF.RegisterAmmoDecal("AP", "damage/ap_pen", "damage/ap_rico")

	local DecalIndex = ACF.GetAmmoDecalIndex

	function Ammo:ClientConvert(ToolData)
		self:VerifyData(ToolData)

		local Data, GUIData = self:BaseConvert(ToolData)

		if GUIData then
			for K, V in pairs(GUIData) do
				Data[K] = V
			end
		end

		return Data
	end


	function Ammo:ImpactEffect(_, Bullet)
		local Effect = EffectData()
		Effect:SetOrigin(Bullet.SimPos)
		Effect:SetNormal(Bullet.SimFlight:GetNormalized())
		Effect:SetRadius(Bullet.Caliber)
		Effect:SetDamageType(DecalIndex(Bullet.AmmoType))

		util.Effect("ACF_Impact", Effect)
	end

	function Ammo:PenetrationEffect(_, Bullet)
		local Effect = EffectData()
		Effect:SetOrigin(Bullet.SimPos)
		Effect:SetNormal(Bullet.SimFlight:GetNormalized())
		Effect:SetScale(Bullet.SimFlight:Length())
		Effect:SetMagnitude(Bullet.RoundMass)
		Effect:SetRadius(Bullet.Caliber)
		Effect:SetDamageType(DecalIndex(Bullet.AmmoType))

		util.Effect("ACF_Penetration", Effect)
	end

	function Ammo:RicochetEffect(_, Bullet)
		local Effect = EffectData()
		Effect:SetOrigin(Bullet.SimPos)
		Effect:SetNormal(Bullet.SimFlight:GetNormalized())
		Effect:SetScale(Bullet.SimFlight:Length())
		Effect:SetMagnitude(Bullet.RoundMass)
		Effect:SetRadius(Bullet.Caliber)
		Effect:SetDamageType(DecalIndex(Bullet.AmmoType))

		util.Effect("ACF_Ricochet", Effect)
	end

	function Ammo:MenuAction(Menu, ToolData, Data)
		local Tracer = Menu:AddCheckBox("Tracer")
		Tracer:SetDataVar("Tracer", "OnChange")
		Tracer:SetValueFunction(function(Panel)
			ToolData.Tracer = ACF.ReadBool("Tracer")

			self:UpdateRoundData(ToolData, Data)

			ACF.WriteValue("Projectile", Data.ProjLength)
			ACF.WriteValue("Propellant", Data.PropLength)

			Panel:SetText("Tracer : " .. Data.Tracer .. " cm")
			Panel:SetValue(ToolData.Tracer)

			return ToolData.Tracer
		end)

		local RoundStats = Menu:AddLabel()
		RoundStats:TrackDataVar("Projectile", "SetText")
		RoundStats:TrackDataVar("Propellant")
		RoundStats:SetValueFunction(function()
			self:UpdateRoundData(ToolData, Data)

			local Text		= "Muzzle Velocity : %s m/s\nProjectile Mass : %s\nPropellant Mass : %s"
			local MuzzleVel	= math.Round(Data.MuzzleVel * ACF.Scale, 2)
			local ProjMass	= ACF.GetProperMass(Data.ProjMass)
			local PropMass	= ACF.GetProperMass(Data.PropMass)

			return Text:format(MuzzleVel, ProjMass, PropMass)
		end)

		local PenStats = Menu:AddLabel()
		PenStats:TrackDataVar("Projectile", "SetText")
		PenStats:TrackDataVar("Propellant")
		PenStats:SetValueFunction(function()
			self:UpdateRoundData(ToolData, Data)

			local Text	   = "Penetration : %s mm RHA\nAt 300m : %s mm RHA @ %s m/s\nAt 800m : %s mm RHA @ %s m/s"
			local MaxPen   = math.Round(Data.MaxPen, 2)
			local R1V, R1P = ACF.PenRanging(Data.MuzzleVel, Data.DragCoef, Data.ProjMass, Data.PenArea, Data.LimitVel, 300)
			local R2V, R2P = ACF.PenRanging(Data.MuzzleVel, Data.DragCoef, Data.ProjMass, Data.PenArea, Data.LimitVel, 800)

			return Text:format(MaxPen, R1P, R1V, R2P, R2V)
		end)

		Menu:AddLabel("Note: The penetration range data is an approximation and may not be entirely accurate.")
	end
end
