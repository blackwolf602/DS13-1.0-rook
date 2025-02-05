/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/tool/multitool
	name = "multitool"
	desc = "Used for pulsing wires to test which to cut. You can use this on airlocks or APCs to try to hack them."
	icon_state = "multitool"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_HARMLESS
	worksound = WORKSOUND_PULSING
	throw_range = 15

	tool_qualities = list(QUALITY_PULSING = 30)
	matter = list(MATERIAL_PLASTIC = 200, MATERIAL_GLASS = 100)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

	var/buffer_name
	var/atom/buffer_object

/obj/item/tool/multitool/Destroy()
	unregister_buffer(buffer_object)
	return ..()

/obj/item/tool/multitool/proc/get_buffer(var/typepath)
	// Only allow clearing the buffer name when someone fetches the buffer.
	// Means you cannot be sure the source hasn't been destroyed until the very moment it's needed.
	get_buffer_name(TRUE)
	if(buffer_object && (!typepath || istype(buffer_object, typepath)))
		return buffer_object

/obj/item/tool/multitool/proc/get_buffer_name(var/null_name_if_missing = FALSE)
	if(buffer_object)
		buffer_name = buffer_object.name
	else if(null_name_if_missing)
		buffer_name = null
	return buffer_name

/obj/item/tool/multitool/proc/set_buffer(var/atom/buffer)
	if(!buffer || istype(buffer))
		buffer_name = buffer ? buffer.name : null
		if(buffer != buffer_object)
			unregister_buffer(buffer_object)
			buffer_object = buffer
			if(buffer_object)
				RegisterSignal(buffer_object, COMSIG_PARENT_QDELETING, .proc/unregister_buffer)

/obj/item/tool/multitool/proc/unregister_buffer(var/atom/buffer_to_unregister)
	SIGNAL_HANDLER
	// Only remove the buffered object, don't reset the name
	// This means one cannot know if the buffer has been destroyed until one attempts to use it.
	if(buffer_to_unregister == buffer_object && buffer_object)
		UnregisterSignal(buffer_object, COMSIG_PARENT_QDELETING)
		buffer_object = null

/obj/item/tool/multitool/resolve_attackby(atom/A, mob/user)
	if(!isobj(A))
		return ..(A, user)

	var/obj/O = A
	var/datum/extension/interactive/multitool/MT = get_extension(O, /datum/extension/interactive/multitool)
	if(!MT)
		return ..(A, user)

	user.AddTopicPrint(src)
	MT.interact(src, user)
	return 1
