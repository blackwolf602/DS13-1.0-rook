/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures.dmi'
	icon_state = "latticefull"
	density = 0
	anchored = 1.0
	w_class = ITEM_SIZE_NORMAL
	layer = LATTICE_LAYER
	plane = FLOOR_PLANE
	obj_flags = OBJ_FLAG_NOFALL

/obj/structure/lattice/Initialize()
	.=..()
	return INITIALIZE_HINT_LATELOAD
/obj/structure/lattice/LateInitialize()
	. = ..()
///// Z-Level Stuff
	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open)))
///// Z-Level Stuff
		qdel(src)
		return
	if (!QDELETED(src))
		for(var/obj/structure/lattice/LAT in loc)
			if(LAT != src && !QDELETED(LAT))
				crash_with("Found multiple lattices at '[log_info_line(loc)]'")
				qdel(LAT)
	icon = 'icons/obj/smoothlattice.dmi'
	icon_state = "latticeblank"
	updateOverlays()
	for (var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays()

/obj/structure/lattice/Destroy()
	for (var/dir in GLOB.cardinal)
		var/obj/structure/lattice/L
		if(locate(/obj/structure/lattice, get_step(src, dir)))
			L = locate(/obj/structure/lattice, get_step(src, dir))
			L.updateOverlays(src.loc)
	. = ..()

/obj/structure/lattice/ex_act(severity)
	if(atom_flags & ATOM_FLAG_INDESTRUCTIBLE)
		return
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(isWelder(C))
		to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
		if(C.use_tool(user, src, WORKTIME_SLOW, QUALITY_WELDING, FAILCHANCE_NORMAL))
			new /obj/item/stack/rods(loc)
			qdel(src)
	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.use(2))
			src.alpha = 0
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/catwalk(src.loc)
			qdel(src)
			return
		else
			to_chat(user, "<span class='notice'>You require at least two rods to complete the catwalk.</span>")
			return
	return

/obj/structure/lattice/proc/updateOverlays()
	//if(!(istype(src.loc, /turf/space)))
	//	qdel(src)
	spawn(1)
		overlays = list()

		var/dir_sum = 0

		var/turf/T
		for (var/direction in GLOB.cardinal)
			T = get_step(src, direction)
			if(locate(/obj/structure/lattice, T) || locate(/obj/structure/catwalk, T))
				dir_sum += direction
			else
				if(!(istype(get_step(src, direction), /turf/space)) && !(istype(get_step(src, direction), /turf/simulated/open)))
					dir_sum += direction

		icon_state = "lattice[dir_sum]"
		return
