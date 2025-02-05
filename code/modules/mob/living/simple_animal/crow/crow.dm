/obj/item/storage/messenger
	name = "messenger bag"
	desc = "A small green-grey messenger bag with a blue Corvid Couriers logo on it."
	icon = 'icons/mob/crow.dmi'
	icon_state = "messenger_bag"
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL

/mob/living/simple_animal/crow
	name = "crow"
	desc = "A large crow. Caw caw."
	icon = 'icons/mob/crow.dmi'
	icon_state = "crow"
	icon_living = "crow"
	icon_dead = "crow_dead"
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SMALL

	speak = list("Caw.", "Caw?", "Caw!", "CAW.")
	speak_emote = list("caws")
	emote_hear = list("caws")
	emote_see = list("hops")

	melee_damage_lower = 5
	melee_damage_upper = 10

	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"
	stop_automated_movement = TRUE
	universal_speak = TRUE
	pass_flags = PASS_FLAG_TABLE

	var/obj/item/storage/messenger/messenger_bag
	var/obj/item/card/id/access_card

/mob/living/simple_animal/crow/New()
	..()
	messenger_bag = new(src)
	update_icon()

/mob/living/simple_animal/crow/GetIdCard()
	return access_card

/mob/living/simple_animal/crow/show_inv(var/mob/user)
	if(user.incapacitated())
		return
	var/list/dat = list()
	if(access_card)
		dat += "<b>ID:</b> [access_card] (<a href='?src=\ref[src];remove_inv=access cuff'>Remove</a>)"
	else
		dat += "<b>ID:</b> <a href='?src=\ref[src];add_inv=access cuff'>Nothing</a>"
	if(messenger_bag)
		dat += "<b>Back:</b> [messenger_bag] (<a href='?src=\ref[src];remove_inv=back'>Remove</a>)"
	else
		dat += "<b>Back:</b> <a href='?src=\ref[src];add_inv=back'>Nothing</a>"
	var/datum/browser/popup = new(user, "[name]", "Inventory of \the [name]", 350, 150, src)
	popup.set_content(jointext(dat, "<br>"))
	popup.open()

/mob/living/simple_animal/crow/Topic(href, href_list)
	. = ..()
	if(!.)
		if(!ishuman(usr) || usr.incapacitated() || !usr.Adjacent(src))
			return .
		if(href_list["remove_inv"])
			var/obj/item/removed
			switch(href_list["remove_inv"])
				if("access cuff")
					removed = access_card
					access_card = null
				if("back")
					removed = messenger_bag
					messenger_bag = null
			if(removed)
				removed.forceMove(get_turf(src))
				usr.put_in_hands(removed)
				visible_message("<span class='notice'>\The [usr] removes \the [removed] from \the [src]'s [href_list["remove_inv"]].</span>")
				show_inv(usr)
				update_icon()
			else
				to_chat(usr, "<span class='warning'>There is nothing to remove from \the [src]'s [href_list["remove_inv"]].</span>")
			return 1
		if(href_list["add_inv"])
			var/obj/item/equipping = usr.get_active_hand()
			if(!equipping)
				to_chat(usr, "<span class='warning'>You have nothing in your hand to put on \the [src]'s [href_list["add_inv"]].</span>")
				return 0
			var/obj/item/equipped
			var/checktype
			switch(href_list["add_inv"])
				if("access cuff")
					equipped = access_card
					checktype = /obj/item/card/id
				if("back")
					equipped = messenger_bag
					checktype = /obj/item/storage/messenger
			if(equipped)
				to_chat(usr, "<span class='warning'>There is already something worn on \the [src]'s [href_list["add_inv"]].</span>")
				return 0
			if(!istype(equipping, checktype))
				to_chat(usr, "<span class='warning'>\The [equipping] won't fit on \the [src]'s [href_list["add_inv"]].</span>")
				return 0
			switch(href_list["add_inv"])
				if("access cuff")
					access_card = equipping
				if("back")
					messenger_bag = equipping
			if(!usr.unEquip(equipping, src))
				return 0
			visible_message("<span class='notice'>\The [usr] places \the [equipping] on to \the [src]'s [href_list["add_inv"]].</span>")
			update_icon()
			show_inv(usr)
			return 1

/mob/living/simple_animal/crow/examine(var/mob/user)
	. = ..()
	if(Adjacent(src))
		if(messenger_bag)
			if(messenger_bag.contents.len)
				to_chat(user, "It's wearing a little messenger bag with a Corvid Couriers logo on it. There's something stuffed inside.")
			else
				to_chat(user, "It's wearing a little messenger bag with a Corvid Couriers logo on it. It seems to be empty.")
		if(access_card)
			to_chat(user, "It has an access cuff with \the [access_card] inserted.")

/mob/living/simple_animal/crow/update_icon()
	..()
	overlays -= "bag"
	overlays -= "bag_dead"
	if(messenger_bag)
		if(icon_state != icon_dead)
			overlays |= "bag"
		else
			overlays |= "bag_dead"

/mob/living/simple_animal/crow/cyber
	name = "cybercrow"
	desc = "A large cybercrow. k4w k4w."
	speak_emote = list("beeps")

/mob/living/simple_animal/crow/cyber/update_icon()
	..()
	overlays -= "cyber"
	overlays -= "cyber_dead"
	if(icon_state != icon_dead)
		overlays |= "cyber"
	else
		overlays |= "cyber_dead"

