/obj/item/rig/zealot
	name = "Zealot RIG"
	desc = "An security rig, it has been repainted in black and crimson colours. There are unitologist markings across the suit."
	icon_state = "zealot_rig"
	armor = list(melee = 60, bullet = 64, laser = 60, energy = 0, bomb = 60, bio = 100, rad = 60)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/zealot
	helm_type =  /obj/item/clothing/head/helmet/space/rig/zealot
	boot_type =  /obj/item/clothing/shoes/magboots/rig/zealot
	glove_type = /obj/item/clothing/gloves/rig/zealot

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/military,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/nvgsec
		)

/obj/item/clothing/head/helmet/space/rig/zealot
	light_overlay = "zealothelm_light"

/obj/item/clothing/suit/space/rig/zealot
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/zealot

/obj/item/clothing/shoes/magboots/rig/zealot
/obj/item/rig/zealot/flesh
	name = "Bloated RIG"
	desc = "A horrifying amalgamation of flesh and a sparse amount of mechanical components, loosely resembling a rig."
	icon_state = "flesh"

