/datum/reagent
	var/name = "Reagent"
	var/description = "A non-descript chemical."
	var/taste_description = "old rotten bandaids"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/datum/reagents/holder = null
	var/reagent_state = SOLID
	var/list/data = null
	var/volume = 0
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/overdose = 0
	var/scannable = 0 // Shows up on health analyzers.
	var/color = "#000000"
	var/color_weight = 1
	var/flags = 0
	var/biomass = 0	//How much biomass one unit of this reagent is worth.
	//Since biomass is measured in kg, and one reagent unit is 10ml, this value should usually not be above 0.01

	/*
		The higher the volume of a chemical in the body, the faster it metabolises.
		Each volume unit adds this percent bonus to the metabolism rate.
	*/
	var/volume_metabolism_mult	=	0.075

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	// GAS DATA, generic values copied from base XGM datum type.
	var/gas_specific_heat = 20
	var/gas_molar_mass =    0.032
	var/gas_overlay_limit = 0.7
	var/gas_flags =         0
	var/gas_burn_product
	var/gas_overlay = "generic"
	// END GAS DATA


	//If true, this extension is applied to the mob while they have any quantity of this reagent in their system
	var/extension_type
	var/datum/extension/reagent/effect_extension


/datum/reagent/New(var/datum/reagents/holder)
	if(!istype(holder) && holder != TRUE)
		CRASH("Invalid reagents holder: [log_info_line(holder)]")
	src.holder = holder
	..()

/datum/reagent/get_biomass()
	return biomass*volume

//Called to change (generally adding to) the volume of this reagent. It is called FROM a reagent holder so it doesn't need to callback to that
/datum/reagent/proc/modify_volume(var/amount, var/newdata)

	if (newdata)
		mix_data(newdata, amount)
	volume += amount
	if (effect_extension && amount > 0)
		effect_extension.volume_increased()


/datum/reagent/proc/remove_self(var/amount) // Shortcut
	holder.remove_reagent(type, amount)

// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/datum/reagent/proc/touch_mob(var/mob/M, var/amount)
	return

/datum/reagent/proc/touch_obj(var/obj/O, var/amount) // Acid melting, cleaner cleaning, etc
	return

/datum/reagent/proc/touch_turf(var/turf/T, var/amount) // Cleaner cleaning, lube lubbing, etc, all go here
	return

/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/location) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(!istype(M))
		return
	if(!(flags & AFFECTS_DEAD) && M.stat == DEAD && (world.time - M.timeofdeath > 150))
		return
	if(overdose && (location != CHEM_TOUCH))
		var/overdose_threshold = overdose * (flags & IGNORE_MOB_SIZE? 1 : MOB_MEDIUM/M.mob_size)
		if(volume > overdose_threshold)
			overdose(M, alien)

	//determine the metabolism rate
	var/removed = metabolism
	if(ingest_met && (location == CHEM_INGEST))
		removed = ingest_met
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met
	removed = M.get_adjusted_metabolism(removed)

	//Adjust for volume, large volumes infuse faster into the patient
	removed *= 1 + (volume * volume_metabolism_mult)

	//adjust effective amounts - removed, dose, and max_dose - for mob size
	var/effective = removed
	if(!(flags & IGNORE_MOB_SIZE) && location != CHEM_TOUCH)
		effective *= (MOB_MEDIUM/M.mob_size)



	M.chem_doses[type] = M.chem_doses[type] + effective
	if(effective >= (metabolism * 0.1) || effective >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(location)
			if(CHEM_BLOOD)
				affect_blood(M, alien, effective)
			if(CHEM_INGEST)
				affect_ingest(M, alien, effective)
			if(CHEM_TOUCH)
				affect_touch(M, alien, effective)

	if(volume)
		remove_self(removed)
	return

/datum/reagent/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed * 0.5)
	return

/datum/reagent/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/overdose(var/mob/living/carbon/M, var/alien) // Overdose effect. Doesn't happen instantly.
	M.add_chemical_effect(CE_TOXIN, 0.5)
	M.adjustToxLoss(REM)
	if (effect_extension)
		effect_extension.overdose()
	return

/datum/reagent/proc/initialize_data(var/newdata) // Called when the reagent is created.

	if(!isnull(newdata))
		data = newdata
	if (extension_type)
		//Mobs only
		var/mob/living/carbon/C = holder.my_atom
		if (istype(C))
			apply_extension(C)

	return

//This can be overridden if you want to do fancy things like applying a different effect to a crewman or a necro
//Since this is called once when creating, you should only base such code on unchangeable factors like species
/datum/reagent/proc/apply_extension(var/atom/target)

	effect_extension = set_extension(target, extension_type, holder)
	effect_extension.Initialize()

/datum/reagent/proc/mix_data(var/newdata, var/newamount) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	return

/datum/reagent/proc/get_data() // Just in case you have a reagent that handles data differently.
	if(data && istype(data, /list))
		return data.Copy()
	else if(data)
		return data
	return null

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	holder = null
	if (effect_extension)
		effect_extension.reagent_expired()
		effect_extension = null	//The extension will continue to exist if it wants to, but its not our responsibility anymore.
		//It is set free to clean itself up. we just null our reference to it to conclude our business
	. = ..()

/* DEPRECATED - TODO: REMOVE EVERYWHERE */

/datum/reagent/proc/reaction_turf(var/turf/target)
	touch_turf(target)

/datum/reagent/proc/reaction_obj(var/obj/target)
	touch_obj(target)

/datum/reagent/proc/reaction_mob(var/mob/target)
	touch_mob(target)
