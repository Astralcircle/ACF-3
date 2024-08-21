local E2Desc = E2Helper.Descriptions

-- General Functions
E2Desc["acfDragDiv()"] = "Returns the current ACF drag divisor."
E2Desc["acfInfoRestricted()"] = "Returns 1 if functions are not returning sensitive information of entities you don't own."
E2Desc["acfName(e:)"] = "Returns the full name of an ACF entity."
E2Desc["acfNameShort(e:)"] = "Returns the short name of an ACF entity."
E2Desc["acfType(e:)"] = "Returns the type of ACF entity."
E2Desc["acfClass(e:)"] = "Returns the class of ACF entity."
E2Desc["acfIsEngine(e:)"] = "Returns 1 if the entity is an ACF engine."
E2Desc["acfIsGearbox(e:)"] = "Returns 1 if the entity is an ACF gearbox."
E2Desc["acfIsGun(e:)"] = "Returns 1 if the entity is an ACF gun."
E2Desc["acfIsTurret(e:)"] = "Returns 1 if the entity is an ACF turret."
E2Desc["acfIsAmmo(e:)"] = "Returns 1 if the entity is an ACF ammo crate."
E2Desc["acfIsFuel(e:)"] = "Returns 1 if the entity is an ACF fuel tank."
E2Desc["acfSoundPath(e:)"] = "Returns the sound path of an ACF entity."
E2Desc["acfActive(e:)"] = "Gets the Active value of an ACF entity."
E2Desc["acfActive(e:n)"] = "Sets the Active value of an ACF entity."
E2Desc["acfCapacity(e:)"] = "Returns the capacity of an ACF entity."

E2Desc["acfPropHealth(e:)"] = "Returns the current health of an entity."
E2Desc["acfPropHealthMax(e:)"] = "Returns the max health of an entity."
E2Desc["acfPropHealthPercent(e:)"] = "Returns the health percentage of an entity."
E2Desc["acfPropArmor(e:)"] = "Returns the current armor of an entity."
E2Desc["acfPropArmorMax(e:)"] = "Returns the max armor of an entity."
E2Desc["acfPropArmorPercent(e:)"] = "Returns the current armor percentage of an entity."
E2Desc["acfPropDuctility(e:)"] = "Returns the ductility of an entity."
E2Desc["acfEffectiveArmor(nn)"] = "Returns the effective armor of a given nominal armor value and angle."
E2Desc["acfEffectiveArmor(xrd:)"] = "Returns the effective armor from a trace hitting an entity."
E2Desc["acfHitClip(e:v)"] = "Returns 1 if hitpos is on a clipped part of an entity"

E2Desc["acfLinks(e:)"] = "Returns all the entities linked to this ACF entity."
E2Desc["acfLinkTo(e:en)"] = "Link two entities together. Set the second argument as 1 to receive chat feedback."
E2Desc["acfUnlinkFrom(e:en)"] = "Unlink two entities from each other. Set the second argument as 1 to receive chat feedback."

-- Mobility Functions
E2Desc["acfIsElectric(e:)"] = "Returns 1 if the ACF entity is electric."
E2Desc["acfMaxTorque(e:)"] = "Returns the maximum torque (in N/m) of an ACF entity."
E2Desc["acfMaxPower(e:)"] = "Returns the maximum power (in kW) of an ACF entity."
E2Desc["acfMaxTorqueWithFuel(e:)"] = "Returns the maximum torque (in N/m) of a fueled ACF entity."
E2Desc["acfMaxPowerWithFuel(e:)"] = "Returns the maximum power (in kW) of a fueled ACF entity."
E2Desc["acfIdleRPM(e:)"] = "Returns the idle RPM of an ACF entity."
E2Desc["acfPowerbandMin(e:)"] = "Returns the powerband minimum of an ACF entity."
E2Desc["acfPowerbandMax(e:)"] = "Returns the powerband maximum of an ACF entity."
E2Desc["acfRedline(e:)"] = "Returns the redline RPM of an ACF entity."
E2Desc["acfRPM(e:)"] = "Returns the current RPM of an ACF entity."
E2Desc["acfTorque(e:)"] = "Returns the current torque (in N/m) of an ACF entity."
E2Desc["acfFlyInertia(e:)"] = "Returns the inertia of an ACF entity's flywheel"
E2Desc["acfFlyMass(e:)"] = "Returns the mass of an ACF entity's flywheel."
E2Desc["acfPower(e:)"] = "Returns the current power (in kW) of an ACF entity."
E2Desc["acfInPowerband(e:)"] = "Returns 1 if the ACF entity's RPM is inside the powerband."
E2Desc["acfThrottle(e:)"] = "Gets the throttle input (0-100) of an ACF entity."
E2Desc["acfThrottle(e:n)"] = "Sets the throttle input (0-100) of an ACF entity."

E2Desc["acfGear(e:)"] = "Returns the current gear of an ACF entity."
E2Desc["acfNumGears(e:)"] = "Returns the number of gears of an ACF entity."
E2Desc["acfFinalRatio(e:)"] = "Returns the final ratio of an ACF entity."
E2Desc["acfTorqueRating(e:)"] = "Returns the maximum torque (in N/m) an ACF entity can handle."
E2Desc["acfIsDual(e:)"] = "Returns 1 if an ACF entity is dual clutch."
E2Desc["acfShiftTime(e:)"] = "Returns the time in ms an ACF entity takes to change gears."
E2Desc["acfInGear(e:)"] = "Returns 1 if an ACF entity is in gear."
E2Desc["acfTotalRatio(e:)"] = "Returns the total ratio (current gear * final) of an ACF entity."
E2Desc["acfGearRatio(e:n)"] = "Returns the ratio of a specified gear of an ACF entity."
E2Desc["acfTorqueOut(e:)"] = "Returns the current torque output (in N/m) an ACF entity. A bit jumpy due to how ACF applies power."
E2Desc["acfCVTRatio(e:n)"] = "Sets the gear ratio of a CVT. Passing 0 causes the CVT to resume using target min/max rpm calculation."
E2Desc["acfShift(e:n)"] = "Shift to the specified gear for an ACF entity."
E2Desc["acfShiftUp(e:)"] = "Set an ACF entity to shift up."
E2Desc["acfShiftDown(e:)"] = "Set an ACF entity to shift down."
E2Desc["acfBrake(e:n)"] = "Sets the brake for an ACF entity. Sets both sides of a dual clutch gearbox."
E2Desc["acfBrakeLeft(e:n)"] = "Sets the left brake for an ACF entity. Only works for dual clutch."
E2Desc["acfBrakeRight(e:n)"] = "Sets the right brake for an ACF entity. Only works for dual clutch."
E2Desc["acfClutch(e:n)"] = "Sets the clutch for an ACF entity. Sets both sides of a dual clutch gearbox."
E2Desc["acfClutchLeft(e:n)"] = "Sets the left clutch for an ACF entity. Only works for dual clutch."
E2Desc["acfClutchRight(e:n)"] = "Sets the right clutch for an ACF entity. Only works for dual clutch."
E2Desc["acfSteerRate(e:n)"] = "Sets the steer ratio for an ACF entity. Only works for double differential gearboxes."
E2Desc["acfHoldGear(e:n)"] = "Set to 1 to stop an ACF entity's upshifting. Only works for automatic gearboxes."
E2Desc["acfShiftPointScale(e:n)"] = "Sets the shift point scale for an ACF entity. Only works with automatic gearboxes."

E2Desc["acfFuel(e:)"] = "Returns the remaining liters of fuel or kilowatt hours in an ACF fuel tank, or available to an engine."
E2Desc["acfFuelLevel(e:)"] = "Returns the percent remaining fuel in an ACF fuel tank, or available to an engine."
E2Desc["acfRefuelDuty(e:)"] = "Sets an ACF fuel tank on refuel duty, causing it to supply other fuel tanks with fuel."
E2Desc["acfDisableRevLimiter(e:n)"] = "Disables the rev limiter on an ACF engine."
E2Desc["acfFuelUse(e:)"] = "Returns the current fuel consumption of an ACF entity in liters per minute or kilowatts."
E2Desc["acfPeakFuelUse(e:)"] = "Returns the peak fuel consumption of an ACF entity in liters per minute or kilowatts."

E2Desc["acfGetLinkedWheels(e:)"] = "Returns an array of all the wheels linked to this mobility setup."

-- Weaponry Functions
E2Desc["acfIsReloading(e:)"] = "Returns 1 if an ACF entity is reloading."
E2Desc["acfReady(e:)"] = "Returns 1 if an ACF entity is ready to fire."
E2Desc["acfState(e:)"] = "Returns the current status of an ACF entity."
E2Desc["acfMagSize(e:)"] = "Returns the magazine capacity of an ACF entity."
E2Desc["acfMagReloadTime(e:)"] = "Returns time it takes for an ACF entity to reload a magazine."
E2Desc["acfReloadTime(e:)"] = "Returns time to next shot of an ACF entity."
E2Desc["acfReloadProgress(e:)"] = "Returns number between 0 and 1 which represents reloading progress of an ACF entity. Useful for progress bars."
E2Desc["acfSpread(e:)"] = "Returns the spread of an ACF entity."
E2Desc["acfFireRate(e:)"] = "Returns the rate of fire of an ACF entity."
E2Desc["acfFire(e:n)"] = "Sets the firing state of an ACF entity. Kills are only attributed to gun owner. Use wire inputs on gun if you want to properly attribute kills to driver."
E2Desc["acfUnload(e:)"] = "Causes an ACF entity to unload."
E2Desc["acfReload(e:)"] = "Causes an ACF entity to reload."
E2Desc["acfMagRounds(e:)"] = "Returns the rounds remaining in the magazine of an ACF entity."

E2Desc["acfRounds(e:)"] = "Returns the number of rounds in a weapon or crate."
E2Desc["acfAmmoType(e:)"] = "Returns the type of ammo on an ACF entity."
E2Desc["acfRoundType(e:)"] = "Returns the type of weapon the ammo in an ACF ammo crate loads into."
E2Desc["acfCaliber(e:)"] = "Returns the caliber of an ACF entity."
E2Desc["acfMuzzleVel(e:)"] = "Returns the muzzle velocity of the ammo in an ACF entity."
E2Desc["acfProjectileMass(e:)"] = "Returns the mass of the projectile in an ACF entity."
E2Desc["acfDragCoef(e:)"] = "Returns the drag coefficient of the projectile in an ACF entity."
E2Desc["acfFinMul(e:)"] = "Returns the fin multiplier of the projectile in an ACF entity"
E2Desc["acfMissileWeight(e:)"] = "Returns the weight of the missile in an ACF entity"
E2Desc["acfMissileLength(e:)"] = "Returns the length of the missile in an ACF entity"
E2Desc["acfFLSpikes(e:)"] = "Returns the number of projectiles in a flechette round."
E2Desc["acfFLSpikeRadius(e:)"] = "Returns the radius (in mm) of the spikes in a flechette round."
E2Desc["acfFLSpikeMass(e:)"] = "Returns the mass of a single spike in a FL round in a crate or gun."

E2Desc["acfPenetration(e:)"] = "Returns the penetration of a round in an ACF entity."
E2Desc["acfBlastRadius(e:)"] = "Returns the blast radius of a round in an ACF entity."
E2Desc["acfAmmoCount(e:)"] = "Returns the number of rounds in active ammo crates linked to an ACF entity."
E2Desc["acfTotalAmmoCount(e:)"] = "Returns the number of rounds in all ammo crates linked to an ACF entity."

-- Turret functions
E2Desc["acfGetTurretAngle(e:)"] = "Returns the turret's current angle, relative to home."
E2Desc["acfGetTurretForward(e:)"] = "Returns the turret's forward direction."
E2Desc["acfGetTurretRotator(e:)"] = "Returns the turret's rotator."
E2Desc["acfGetTurretGyro(e:)"] = "Returns the turret's linked gyroscope, if available."
E2Desc["acfGetTurretMotor(e:)"] = "Returns the turret's linked motor, if available."
E2Desc["acfGetTurretMass(e:)"] = "Returns the turret's loaded mass, in kg."
E2Desc["acfGetTurretMassCenter(e:)"] = "Returns the turret's center of mass, local to the turret."
E2Desc["acfGetTurretSlewRate(e:)"] = "Returns the turret's slew rate, in degrees/second."
E2Desc["acfGetTurretMaxSlewRate(e:)"] = "Returns the turret's top slew rate, in degrees/second."
E2Desc["acfGetTurretSlewAccel(e:)"] = "Returns the turret's slew acceleration rate, in degrees/second ^ 2."
E2Desc["acfGetTurretStabilized(e:)"] = "Returns the turret's stabilizer percentage, if stabilized."
E2Desc["acfGetTurretData(e:)"] = "Returns the turret's data."
E2Desc["acfGetTurretMotorData(e:)"] = "Returns the turret motor's data."
E2Desc["acfIsGyroDual(e:)"] = "Returns whether or not the given gyroscope is dual or not."

E2Desc["acfCenterTurret(e:)"] = "Sets the turret to return to the home angle."
E2Desc["acfAimTurret(e:n)"] = "Sets the turret to attempt to aim at the input degree."
E2Desc["acfAimTurret(e:a)"] = "Sets the turret to attempt to aim at the input angle."
E2Desc["acfAimTurret(e:v)"] = "Sets the turret to attempt to aim at the input position."