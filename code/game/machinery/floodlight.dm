//these are probably broken

/obj/machinery/floodlight
	name = "emergency floodlight"
	desc = "A battery-powered lighting machine. Useful for blackouts."
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/obj/item/cell/cell = null
	var/use = 200 // 200W light
	var/unlocked = 0
	var/open = 0

	light_power = 1 //brightness of light when on, can be negative
	light_range = 6 //outer range of light when on, can be negative

	can_block_movement = TRUE

/obj/machinery/floodlight/New(var/atom/location, var/direction, var/nocircuit = FALSE)
	cell = new/obj/item/cell/crap(src)
	..()

/obj/machinery/floodlight/update_icon()
	overlays.Cut()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/Process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light_power(initial(light_power)/2)
		spawn(20)
			if(on)
				set_light_power(initial(light_power)*2)

	cell.use(use*CELLRATE)


// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/proc/turn_on(var/loud = 0)
	if(!cell)
		return 0
	if(cell.charge < (use * CELLRATE))
		return 0

	on = 1
	set_light_on(TRUE)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
		playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)
	return 1

/obj/machinery/floodlight/proc/turn_off(var/loud = 0)
	on = 0
	set_light_on(FALSE)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")
		playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)

/obj/machinery/floodlight/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")
			playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)


/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.forceMove(user.loc)
		else
			cell.forceMove(loc)

		cell.add_fingerprint(user)
		cell.update_icon()

		src.cell = null
		on = 0
		set_light_on(FALSE)
		to_chat(user, "You remove the power cell")
		update_icon()
		return

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")
			playsound(src.loc, 'sound/effects/flashlight.ogg', 50, 0)

	update_icon()

/obj/machinery/floodlight/meddle()
	if(on)
		turn_off(1)
	else
		turn_on(1)

/obj/machinery/floodlight/attackby(obj/item/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		if (!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = 1
				to_chat(user, "You unscrew the battery panel.")

	if(isCrowbar(W))
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = 1
					to_chat(user, "You remove the battery panel.")

	if (istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else
				if(!user.unEquip(W, src))
					return
				cell = W
				to_chat(user, "You insert the power cell.")
	update_icon()

/obj/machinery/floodlight/verb/rotate()
	set name = "Rotate Light"
	set category = "Object"
	set src in oview(1)

	if(!usr || !Adjacent(usr))
		return

	if(usr.stat == DEAD)
		if(!round_is_spooky())
			to_chat(src, "<span class='warning'>The veil is not thin enough for you to do that.</span>")
			return
	else if(usr.incapacitated())
		return

	src.set_dir(turn(src.dir, 90))
	return

/obj/machinery/floodlight/AltClick()
	rotate()

/obj/machinery/floodlight/on
    use = 50

/obj/machinery/floodlight/on/Initialize()
	. = ..()
	turn_on()
