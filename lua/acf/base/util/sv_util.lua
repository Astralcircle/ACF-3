do -- Serverside console log messages
	local Types = {
		Normal = {
			Prefix = "",
			Color = Color(80, 255, 80)
		},
		Info = {
			Prefix = " - Info",
			Color = Color(0, 233, 255)
		},
		Warning = {
			Prefix = " - Warning",
			Color = Color(255, 160, 0)
		},
		Error = {
			Prefix = " - Error",
			Color = Color(255, 80, 80)
		}
	}

	function ACF.AddLogType(Name, Prefix, TitleColor)
		if not Name then return end

		Types[Name] = {
			Prefix = Prefix and (" - " .. Prefix) or "",
			Color = TitleColor or Color(80, 255, 80),
		}
	end

	function ACF.PrintLog(Type, ...)
		if not ... then return end

		local Data = Types[Type] or Types.Normal
		local Prefix = "[ACF" .. Data.Prefix .. "] "
		local Message = istable(...) and ... or { ... }

		Message[#Message + 1] = "\n"

		MsgC(Data.Color, Prefix, color_white, unpack(Message))
	end
end

do -- Clientside message delivery
	util.AddNetworkString("ACF_ChatMessage")

	function ACF.SendMessage(Player, Type, ...)
		if not ... then return end

		local Message = istable(...) and ... or { ... }

		net.Start("ACF_ChatMessage")
			net.WriteString(Type or "Normal")
			net.WriteTable(Message)
		if IsValid(Player) then
			net.Send(Player)
		else
			net.Broadcast()
		end
	end
end

do -- Tool data functions
	local ToolData = {}

	do -- Data syncronization
		util.AddNetworkString("ACF_ToolData")

		net.Receive("ACF_ToolData", function(_, Player)
			if not IsValid(Player) then return end

			local Key = net.ReadString()
			local Value = net.ReadType()

			ToolData[Player][Key] = Value

			print("Received", Player, Key, Value, type(Value))
		end)

		hook.Add("PlayerInitialSpawn", "ACF Tool Data", function(Player)
			ToolData[Player] = {}
		end)

		hook.Add("PlayerDisconnected", "ACF Tool Data", function(Player)
			ToolData[Player] = nil
		end)
	end

	do -- Read functions
		function ACF.GetToolData(Player)
			if not IsValid(Player) then return {} end
			if not ToolData[Player] then return {} end

			local Result = {}

			for K, V in pairs(ToolData[Player]) do
				Result[K] = V
			end

			return Result
		end

		local function ReadData(Player, Key, Default)
			if not IsValid(Player) then return end
			if not ToolData[Player] then return end
			if Key == nil then return end

			local Value = ToolData[Key]

			return Value ~= nil and Value or Default
		end

		function ACF.ReadBool(Player, Key, Default)
			return tobool(ReadData(Player, Key, Default))
		end

		function ACF.ReadNumber(Player, Key, Default)
			local Value = ReadData(Player, Key, Default)

			return Value ~= nil and tonumber(Value) or 0 -- tonumber can't handle nil values
		end

		function ACF.ReadString(Player, Key, Default)
			local Value = ReadData(Player, Key, Default)

			return Value ~= nil and tostring(Value) or "" -- tostring can't handle nil values
		end

		ACF.ReadData = ReadData
		ACF.ReadRaw = ReadData
	end
end

do -- Entity saving and restoring
	local Constraints = duplicator.ConstraintType
	local Saved = {}

	function ACF.SaveEntity(Entity)
		if not IsValid(Entity) then return end

		local PhysObj = Entity:GetPhysicsObject()

		if not IsValid(PhysObj) then return end

		Saved[Entity] = {
			Constraints = constraint.GetTable(Entity),
			Gravity = PhysObj:IsGravityEnabled(),
			Motion = PhysObj:IsMotionEnabled(),
			Contents = PhysObj:GetContents(),
			Material = PhysObj:GetMaterial(),
		}

		Entity:CallOnRemove("ACF_RestoreEntity", function()
			Saved[Entity] = nil
		end)
	end

	function ACF.RestoreEntity(Entity)
		if not IsValid(Entity) then return end
		if not Saved[Entity] then return end

		local PhysObj = Entity:GetPhysicsObject()
		local EntData = Saved[Entity]

		PhysObj:EnableGravity(EntData.Gravity)
		PhysObj:EnableMotion(EntData.Motion)
		PhysObj:SetContents(EntData.Contents)
		PhysObj:SetMaterial(EntData.Material)

		for _, Data in ipairs(EntData.Constraints) do
			local Constraint = Constraints[Data.Type]
			local Args = {}

			for Index, Name in ipairs(Constraint.Args) do
				Args[Index] = Data[Name]
			end

			Constraint.Func(unpack(Args))
		end

		Saved[Entity] = nil

		Entity:RemoveCallOnRemove("ACF_RestoreEntity")
	end
end

do -- Entity linking
	local EntityLink = {}
	local function GetEntityLinks(Entity, VarName, SingleEntry)
		if not Entity[VarName] then return {} end

		if SingleEntry then
			return { [Entity[VarName]] = true }
		end

		local Result = {}

		for K in pairs(Entity[VarName]) do
			Result[K] = true
		end

		return Result
	end

	-- If your entity can link/unlink other entities, you should use this
	function ACF.RegisterLinkSource(Class, VarName, SingleEntry)
		local Data = EntityLink[Class]

		if not Data then
			EntityLink[Class] = {
				[VarName] = function(Entity)
					return GetEntityLinks(Entity, VarName, SingleEntry)
				end
			}
		else
			Data[VarName] = function(Entity)
				return GetEntityLinks(Entity, VarName, SingleEntry)
			end
		end
	end

	function ACF.GetAllLinkSources(Class)
		if not EntityLink[Class] then return {} end

		local Result = {}

		for K, V in pairs(EntityLink[Class]) do
			Result[K] = V
		end

		return Result
	end

	function ACF.GetLinkSource(Class, VarName)
		if not EntityLink[Class] then return end

		return EntityLink[Class][VarName]
	end

	local ClassLink = { Link = {}, Unlink = {} }
	local function RegisterNewLink(Action, Class1, Class2, Function)
		if not isfunction(Function) then return end

		local Target = ClassLink[Action]
		local Data1 = Target[Class1]

		if not Data1 then
			Target[Class1] = {
				[Class2] = function(Ent1, Ent2)
					return Function(Ent1, Ent2)
				end
			}
		else
			Data1[Class2] = function(Ent1, Ent2)
				return Function(Ent1, Ent2)
			end
		end

		if Class1 == Class2 then return end

		local Data2 = Target[Class2]

		if not Data2 then
			Target[Class2] = {
				[Class1] = function(Ent2, Ent1)
					return Function(Ent1, Ent2)
				end
			}
		else
			Data2[Class1] = function(Ent2, Ent1)
				return Function(Ent1, Ent2)
			end
		end
	end

	function ACF.RegisterClassLink(Class1, Class2, Function)
		RegisterNewLink("Link", Class1, Class2, Function)
	end

	function ACF.GetClassLink(Class1, Class2)
		if not ClassLink.Link[Class1] then return end

		return ClassLink.Link[Class1][Class2]
	end

	function ACF.RegisterClassUnlink(Class1, Class2, Function)
		RegisterNewLink("Unlink", Class1, Class2, Function)
	end

	function ACF.GetClassUnlink(Class1, Class2)
		if not ClassLink.Unlink[Class1] then return end

		return ClassLink.Unlink[Class1][Class2]
	end
end

do -- Entity inputs
	local Inputs = {}

	local function GetClass(Class)
		if not Inputs[Class] then
			Inputs[Class] = {}
		end

		return Inputs[Class]
	end

	function ACF.AddInputAction(Class, Name, Action)
		if not Class then return end
		if not Name then return end
		if not isfunction(Action) then return end

		local Data = GetClass(Class)

		Data[Name] = Action
	end

	function ACF.GetInputAction(Class, Name)
		if not Class then return end
		if not Name then return end

		local Data = GetClass(Class)

		return Data[Name]
	end

	function ACF.GetInputActions(Class)
		if not Class then return end

		return GetClass(Class)
	end
end

do -- Extra overlay text
	local Classes = {}

	function ACF.RegisterOverlayText(ClassName, Identifier, Function)
		if not isstring(ClassName) then return end
		if Identifier == nil then return end
		if not isfunction(Function) then return end

		local Class = Classes[ClassName]

		if not Class then
			Classes[ClassName] = {
				[Identifier] = Function
			}
		else
			Class[Identifier] = Function
		end
	end

	function ACF.RemoveOverlayText(ClassName, Identifier)
		if not isstring(ClassName) then return end
		if Identifier == nil then return end

		local Class = Classes[ClassName]

		if not Class then return end

		Class[Identifier] = nil
	end

	function ACF.GetOverlayText(Entity)
		local Class = Classes[Entity:GetClass()]

		if not Class then return "" end

		local Result = ""

		for _, Function in pairs(Class) do
			local Text = Function(Entity)

			if Text and Text ~= "" then
				Result = Result .. "\n\n" .. Text
			end
		end

		return Result
	end
end

function ACF_GetHitAngle(HitNormal, HitVector)
	local Ang = math.deg(math.acos(HitNormal:Dot(-HitVector:GetNormalized()))) -- Can output nan sometimes on extremely small angles

	if Ang ~= Ang then -- nan is the only value that does not equal itself
		return 0 -- return 0 instead of nan
	else
		return Ang
	end
end