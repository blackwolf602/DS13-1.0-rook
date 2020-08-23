/*
	The Rivet Gun, patron exclusive.  pistol, high firing rate

	Primary Fire:
		Semi automatic, high firing rate. Very poor damage and range. Repairs instead of damaging non-organic objects.
		Leaves embedded rivets in mobs and surfaces

		The gun only tracks up to five embedded rivets, and only for one minute

	Secondary Fire:
		Detonates all tracked embedded rivets, causing them to create a very weak shrapnel explosion dealing minor aoe damage.
		Easy to hit and reliable, but not powerful
*/

/obj/item/weapon/gun/projectile/rivet
	name = "711-MarkCL Rivet Gun"
	desc = "The 711-MarkCL Rivet Gun is the latest refinement from Timson Tools' long line of friendly tools."
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "rivetgun"
	magazine_type = /obj/item/ammo_magazine/rivet
	allowed_magazines = /obj/item/ammo_magazine/rivet
	caliber = "rivet"
	accuracy = 0
	fire_delay = 1
	burst_delay = 1
	w_class = ITEM_SIZE_SMALL
	handle_casings = CLEAR_CASINGS
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

	mag_insert_sound = 'sound/weapons/guns/interaction/divet_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/divet_magout.ogg'

	//How many we can track
	var/max_rivets = 5
	var/list/rivets = list()


	firemodes = list(
		list(mode_name = "rivet", mode_type = /datum/firemode),
		list(mode_name = "fragmentate", mode_type = /datum/firemode/rivet_frag)
		)

/obj/item/weapon/gun/projectile/rivet/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "rivetgun"
	else
		icon_state = "rivetgun_e"


//Adds a rivet to our internal tracking list so we can detonate it later
/obj/item/weapon/gun/projectile/rivet/proc/register_rivet(var/obj/item/embedded_rivet/ER)
	//If we have too many, delete them
	if (rivets.len >= max_rivets)

		var/obj/item/embedded_rivet/redundant = rivets[1]
		unregister_rivet(redundant)
		if (!QDELETED(redundant))
			qdel(redundant)

	rivets += ER

//Remove from our list, called when a rivet is deleted. We don't actually delete it here though
/obj/item/weapon/gun/projectile/rivet/proc/unregister_rivet(var/obj/item/embedded_rivet/ER)
	rivets -= ER
	if (ER.rivetgun == src)
		ER.rivetgun = null


/obj/item/weapon/gun/projectile/rivet/Destroy()
	for (var/obj/item/embedded_rivet/r in rivets)
		unregister_rivet(r)
		if (!QDELETED(r))
			qdel(r)
	.=..()



/*
	Firemode
	Detonates all rivets
*/
/datum/firemode/rivet_frag/on_fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0, var/fired = TRUE)
	var/obj/item/weapon/gun/projectile/rivet/R = gun
	if (R.rivets.len)
		for (var/obj/item/embedded_rivet/ER in R.rivets)
			ER.detonate()
/*
	Ammo Magazine
*/
/obj/item/ammo_magazine/rivet
	name = "rivet bolts"
	icon_state = "rivet"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/rivet
	matter = list(MATERIAL_STEEL = 1000) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = "rivet"
	max_ammo = 16
	multiple_sprites = 0

/obj/item/ammo_magazine/rivet/empty
	ammo_type = null

/obj/item/ammo_magazine/rivet/update_icon()
	if (stored_ammo.len)
		icon_state = "rivet"
	else
		icon_state = "rivet_empty"


/*
	Casing
*/
/obj/item/ammo_casing/rivet
	desc = "rivet"
	caliber = "rivet"
	projectile_type = /obj/item/projectile/bullet/rivet



/*
	Projectile
*/
/obj/item/projectile/bullet/rivet
	damage = 5	//Slightly weaker than a pulse rifle shot, and lacks full auto
	expiry_method = EXPIRY_FADEOUT
	muzzle_type = /obj/effect/projectile/pulse/muzzle/light
	//fire_sound='sound/weapons/guns/fire/divet_fire.ogg'
	structure_damage_factor = 1
	penetration_modifier = 0
	penetrating = FALSE
	var/repair_power = 15



/*
	Special Effect:
	When the rivet gun is fired into non organic objects or turfs, it repairs instead of damaging them
*/
/obj/item/projectile/bullet/rivet/attack_atom(var/atom/A,  var/distance, var/miss_modifier=0)
	var/cached_damage = damage

	//If the atom is inorganic, we briefly set our damage to 0 before hitting it
	if (!A.is_organic())
		damage = 0
	. = ..()	//Parent calls bullet act which will return a flag

	//Continue means that we missed the object
	if (. == PROJECTILE_CONTINUE)
		damage = cached_damage
		return	//We're done here

	else
		//Alright, we hit it
		//Lets fix up that thing
		A.repair(repair_power, src, firer)

		//And a sound
		playsound(A, pick(list('sound/weapons/guns/rivet1.ogg','sound/weapons/guns/rivet2.ogg','sound/weapons/guns/rivet3.ogg')), VOLUME_MID, TRUE)

		//And we also embed a rivet
		var/obj/item/embedded_rivet/ER = new /obj/item/embedded_rivet(get_turf(A), src)
		ER.pixel_x = src.pixel_x
		ER.pixel_y = src.pixel_y






/*
	Embedded_rivet:
	Object created on hit which can be detonated
*/
/obj/item/embedded_rivet
	name = "rivet"
	mouse_opacity = 0
	var/obj/item/weapon/gun/projectile/rivet/rivetgun
	var/lifetime = 1 MINUTE
	var/detonated = FALSE

/obj/item/embedded_rivet/New(var/atom/loc, var/obj/item/projectile/bullet/rivet/rivet)
	if (istype(rivet.shot_from, /obj/item/weapon/gun/projectile/rivet))
		rivetgun = rivet.shot_from
		rivetgun.register_rivet(src)
	QDEL_IN(src, lifetime)
	.=..()

/obj/item/embedded_rivet/proc/detonate()
	if (!QDELETED(src) && !detonated)
		detonated = TRUE
		fragmentate(T=get_turf(src), fragment_number = 30, spreading_range = 4, fragtypes=list(/obj/item/projectile/bullet/pellet/fragment/rivet))
		qdel(src)

/obj/item/embedded_rivet/Destroy()
	if (rivetgun)
		rivetgun.unregister_rivet(src)

	.=..()



/*
	Fragmentation
*/
/obj/item/projectile/bullet/pellet/fragment/rivet
	damage = 2
	range_step = 1 //controls damage falloff with distance. projectiles lose a "pellet" each time they travel this distance. Can be a non-integer.

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = 1
	fire_sound = null
	no_attack_log = 1
	muzzle_type = null








