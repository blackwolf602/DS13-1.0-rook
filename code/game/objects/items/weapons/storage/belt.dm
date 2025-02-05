#define BELT_OVERLAY_ITEMS		1
#define BELT_OVERLAY_HOLSTER	2

/obj/item/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	storage_slots = 7
	item_flags = ITEM_FLAG_IS_BELT
	max_w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	var/overlay_flags
	attack_verb = list("whipped", "lashed", "disciplined")

/obj/item/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	use_alt_layer = !use_alt_layer
	update_icon()

/obj/item/storage/belt/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

	overlays.Cut()
	if(overlay_flags & BELT_OVERLAY_ITEMS)
		for(var/obj/item/I in contents)
			overlays += image('icons/obj/clothing/belts_overlays.dmi', "[I.icon_state]")

/obj/item/storage/belt/get_mob_overlay(mob/user_mob, slot)
	var/mutable_appearance/ret = ..()
	if(slot == slot_belt_str && contents.len)
		var/list/ret_overlays = list()
		for(var/obj/item/I in contents)
			var/use_state = (I.item_state ? I.item_state : I.icon_state)
			if(ishuman(user_mob))
				var/mob/living/carbon/human/H = user_mob
				ret_overlays += H.species.get_offset_overlay_image(FALSE, 'icons/mob/onmob/belt.dmi', use_state, I.color, slot)
			else
				ret_overlays += overlay_image('icons/mob/onmob/belt.dmi', use_state, I.color, RESET_COLOR)
			ret.overlays += ret_overlays
	return ret

/obj/item/storage/belt/holster
	name = "holster belt"
	icon_state = "holsterbelt"
	item_state = "holster"
	desc = "Can holster various things."
	storage_slots = 2
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	var/list/can_holster //List of objects which this item can store in the designated holster slot(if unset, it will default to any holsterable items)
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'
	can_hold = list(
		/obj/item
		)

/obj/item/storage/belt/holster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/holster, src, sound_in, sound_out, can_holster)

/obj/item/storage/belt/holster/attackby(obj/item/W as obj, mob/user as mob)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.holster(W, user))
		return
	else
		. = ..(W, user)

/obj/item/storage/belt/holster/attack_hand(mob/user as mob)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.unholster(user))
		return
	else
		. = ..(user)

/obj/item/storage/belt/holster/examine(mob/user)
	. = ..(user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	H.examine_holster(user)

/obj/item/storage/belt/holster/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

	overlays.Cut()
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(overlay_flags)
		for(var/obj/item/I in contents)
			if(I == H.holstered)
				if(overlay_flags & BELT_OVERLAY_HOLSTER)
					overlays += image('icons/obj/clothing/belts_overlays.dmi', "[I.icon_state]")
			else if(overlay_flags & BELT_OVERLAY_ITEMS)
				overlays += image('icons/obj/clothing/belts_overlays.dmi', "[I.icon_state]")

/obj/item/storage/belt/utility
	name = "tool belt"
	desc = "A belt of durable leather, festooned with hooks, slots, and pouches."
	description_info = "The tool-belt has enough slots to carry a full engineer's toolset: screwdriver, crowbar, wrench, welder, cable coil, and multitool. Simply click the belt to move a tool to one of its slots."
	description_fluff = "Good hide is hard to come by in certain regions of the galaxy. When they can't come across it, most TSCs will outfit their crews with toolbelts made of synthesized leather."
	description_antag = "Only amateurs skip grabbing a tool-belt."
	icon_state = "utilitybelt"
	item_state = "utility"
	overlay_flags = BELT_OVERLAY_ITEMS
	can_hold = list(
		/obj/item/tool,
		/obj/item,/obj/item/material,
		/obj/item/tool/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/taperoll/engineering,
		/obj/item/robotanalyzer,
		/obj/item/material/minihoe,
		/obj/item/material/hatchet,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/taperoll,
		/obj/item/extinguisher/mini,
		/obj/item/marshalling_wand,
		/obj/item/hand_labeler
		)


/obj/item/storage/belt/utility/full/New()
	..()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/stack/cable_coil(src,30,pick("red","yellow","orange"))
	update_icon()

/obj/item/storage/belt/utility/makeshift/New()
	..()
	new /obj/item/tool/screwdriver/improvised(src)
	new /obj/item/tool/wrench/improvised(src)
	new /obj/item/tool/weldingtool/improvised(src)
	new /obj/item/tool/crowbar/improvised(src)
	new /obj/item/tool/wirecutters/improvised(src)
	new /obj/item/tool/saw/improvised(src)
	update_icon()


/obj/item/storage/belt/utility/atmostech/New()
	..()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/tool/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/t_scanner(src)
	update_icon()



/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		/obj/item/healthanalyzer,
		/obj/item/adv_health_analyzer,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/flame/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/tool/crowbar,
		/obj/item/flashlight,
		/obj/item/taperoll,
		/obj/item/extinguisher/mini,
		/obj/item/storage/med_pouch,
		/obj/item,/obj/item/material,
		/obj/item/bodybag
		)

/obj/item/storage/belt/holster/security
	name = "security holster belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "securitybelt"
	item_state = "security"
	storage_slots = 7
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/tool/crowbar,
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/clothing/glasses,
		/obj/item/clothing/mask/gas,
		/obj/item/ammo_casing/shotgun,
		/obj/item/ammo_magazine,
		/obj/item/reagent_containers/food/snacks/donut/,
		/obj/item,/obj/item/material,
		/obj/item/flame/lighter,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/hailer,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/magnetic_ammo,
		/obj/item/binoculars
		)

/obj/item/storage/belt/general
	name = "equipment belt"
	desc = "Can hold general equipment such as tablets, folders, and other office supplies."
	icon_state = "gearbelt"
	item_state = "gear"
	overlay_flags = BELT_OVERLAY_ITEMS
	can_hold = list(
		/obj/item/flash,
		/obj/item/taperecorder,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/modular_computer/tablet,
		/obj/item/flash,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/radio,
		/obj/item/tape,
		/obj/item/pen,
		/obj/item/stamp,
		/obj/item/stack/package_wrap,
		/obj/item/binoculars,
		/obj/item/marshalling_wand,
		/obj/item/camera,
		/obj/item/hand_labeler,
		/obj/item/destTagger
		)

/obj/item/storage/belt/holster/general
	name = "holster belt"
	desc = "Can hold general equipment such as tablets, folders, and other office supplies. Comes with a holster."
	icon_state = "commandbelt"
	item_state = "command"
	storage_slots = 6
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/flash,
		/obj/item,/obj/item/material,
		/obj/item/taperecorder,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/clipboard,
		/obj/item/modular_computer/tablet,
		/obj/item/flash,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/radio,
		/obj/item/tape,
		/obj/item/pen,
		/obj/item/stamp,
		/obj/item/stack/package_wrap,
		/obj/item/binoculars,
		/obj/item/marshalling_wand,
		/obj/item/camera,
		/obj/item/destTagger
		)

/obj/item/storage/belt/holster/general/command
	name = "holster belt"
	desc = "Can hold general equipment such as tablets, folders, and other office supplies. Comes with a holster."
	icon_state = "commandbelt"
	item_state = "command"
	storage_slots = 6
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/flash,
		/obj/item/taperecorder,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item,/obj/item/material,
		/obj/item/clipboard,
		/obj/item/modular_computer/tablet,
		/obj/item/flash,
		/obj/item/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/radio/headset,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/holowarrant,
		/obj/item/radio,
		/obj/item/tape,
		/obj/item/pen,
		/obj/item/stamp,
		/obj/item/stack/package_wrap,
		/obj/item/binoculars,
		/obj/item/marshalling_wand,
		/obj/item/camera,
		/obj/item/destTagger
		)

/obj/item/storage/belt/holster/general/command/New()
	..()
	new /obj/item/gun/projectile/divet(src)
	update_icon()

/obj/item/storage/belt/holster/forensic
	name = "forensic belt"
	desc = "Can hold forensic gear like fingerprint powder and luminol."
	icon_state = "forensicbelt"
	item_state = "forensic"
	storage_slots = 7
	overlay_flags = BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/uv_light,
		/obj/item/reagent_containers/syringe,
		/obj/item/forensics/swab,
		/obj/item/sample/print,
		/obj/item/sample/fibers,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/forensic,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/forensics/sample_kit,
		/obj/item/camera,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item
		)

/obj/item/storage/belt/holster/machete
	name = "machete belt"
	desc = "Can hold general surveying equipment used for exploration, as well as your very own machete."
	icon_state = "machetebelt"
	item_state = "machetebelt"
	storage_slots = 6
	overlay_flags = BELT_OVERLAY_HOLSTER
	can_hold = list(
		/obj/item/binoculars,
		/obj/item/camera,
		/obj/item/stack/flag,
		/obj/item/geiger,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/gps,
		/obj/item/mining_scanner,
		/obj/item/slime_scanner,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/folder,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/radio/beacon,
		/obj/item/pinpointer/radio,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/analyzer
		)
	can_holster = list(/obj/item/material/hatchet/machete)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	storage_slots = 6
	can_hold = list(
		/obj/item/soulstone
		)

/obj/item/storage/belt/soulstone/full/New()
	..()
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)
	new /obj/item/soulstone(src)


/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1

/obj/item/storage/belt/holster/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swatbelt"
	item_state = "swatbelt"
	storage_slots = 10

/obj/item/storage/belt/waistpack
	name = "waist pack"
	desc = "A small bag designed to be worn on the waist. May make your butt look big."
	icon_state = "fannypack_white"
	item_state = "fannypack_white"
	storage_slots = null
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = ITEM_SIZE_SMALL * 4
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/storage/belt/waistpack/big
	name = "large waist pack"
	desc = "An bag designed to be worn on the waist. Definitely makes your butt look big."
	icon_state = "fannypack_big_white"
	item_state = "fannypack_big_white"
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = ITEM_SIZE_NORMAL * 4

/obj/item/storage/belt/waistpack/big/New()
	..()
	slowdown_per_slot[slot_belt] = 3

/obj/item/storage/belt/holster/muramasa
	name = "ceremonial sheath"
	desc = "A lavishly decorated ceremonial sheath, looks oddly gun-shaped."
	icon_state = "mura_sheath"
	item_state = "mura_sheath"
	storage_slots = 3
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	can_holster = list(
		/obj/item/material/twohanded/muramasa
	)
	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/reagent_containers/food/snacks,
		)

/obj/item/storage/belt/holster/sheath
	name = "lavish sheath"
	desc = "A sheath wrapped in a gold ribbon, someone went wacko in the workshop for sure to make this."
	icon_state = "sheath"
	item_state = "sheath"
	storage_slots = 3
	overlay_flags = BELT_OVERLAY_ITEMS|BELT_OVERLAY_HOLSTER
	can_holster = list(
		/obj/item/material/twohanded/muramasa/plasmasword
	)
	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/reagent_containers/food/snacks,
		)
