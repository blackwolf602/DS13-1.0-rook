/obj/item/material/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "butterflyknife"
	item_state = null
	hitsound = null
	var/active = 0
	w_class = ITEM_SIZE_SMALL
	tool_qualities = list(QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 10)
	attack_verb = list("patted", "tapped")
	force = 3
	edge = 0
	sharp = 0
	force_divisor = 0.27 // 12 when wielded with hardness 40 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	attack_cooldown_modifier = -1
	tool_qualities = list(QUALITY_CUTTING, 20)
	unbreakable = 1

/obj/item/material/butterfly/update_force()
	if(active)
		edge = 1
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = ITEM_SIZE_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		attack_noun = list("attack", "slash", "stab", "slice", "tear", "rip", "dice", "cut")
	else
		force = initial(force)
		edge = initial(edge)
		sharp = initial(sharp)
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/material/butterfly/attack(mob/living/M, mob/user, var/target_zone)
	..()
	if(ismob(M))
		backstab(M, user, 60, BRUTE, DAM_SHARP, target_zone, TRUE)


/obj/item/material/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "switchblade"
	unbreakable = 1

/obj/item/material/butterfly/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, "<span class='notice'>You flip out \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
	update_force()
	add_fingerprint(user)

/*
 * Kitchen knives
 */
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "kitchenknife"
	item_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	sharp = 1
	edge = 1
	tool_qualities = list(QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 15)
	force_divisor = 0.3 // 13 when wielded with hardness 40 (steel)
	matter = list(MATERIAL_STEEL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_noun = list("attack", "slash", "stab", "slice", "tear", "rip", "dice", "cut")
	unbreakable = 1
	tool_qualities = list(QUALITY_CUTTING, 30)
	unbreakable = 1

/obj/item/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon_state = "hook_knife"
	item_state = "hook_knife"
	tool_qualities = list(QUALITY_CUTTING = 10)
	unbreakable = 1

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	tool_qualities = list(QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20)
	applies_material_colour = 0
	unbreakable = 1

/obj/item/material/knife/butch
	name = "butcher's cleaver"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_noun = list("attack", "slash", "stab", "slice", "tear", "rip", "dice", "cut")
	tool_qualities = list(QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 15)
	unbreakable = 1


