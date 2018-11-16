/* Pens!
 * Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 */


/*
 * Pens
 */
/obj/item/weapon/pen
	desc = "It's a normal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(DEFAULT_WALL_MATERIAL = 10)
	var/colour = "black"	//what colour the ink is!
	pressure_resistance = 2
	var/color_description = "black ink"


/obj/item/weapon/pen/blue
	desc = "It's a normal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"
	color_description = "blue ink"

/obj/item/weapon/pen/red
	desc = "It's a normal red ink pen."
	icon_state = "pen_red"
	colour = "red"
	color_description = "red ink"

/obj/item/weapon/pen/fountain
	desc = "A well made fountain pen."
	icon_state = "pen_fountain"

/obj/item/weapon/pen/multi
	desc = "It's a pen with multiple colors of ink!"
	var/selectedColor = 1
	var/colors = list("black","blue","red")
	var/color_descriptions = list("black ink", "blue ink", "red ink")

/obj/item/weapon/pen/multi/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1

	colour = colors[selectedColor]
	color_description = color_descriptions[selectedColor]

	if(colour == "black")
		icon_state = "pen"
	else
		icon_state = "pen_[colour]"

	user << "<span class='notice'>Changed color to '[colour].'</span>"

/obj/item/weapon/pen/invisible
	desc = "It's an invisble pen marker."
	icon_state = "pen"
	colour = "white"
	color_description = "transluscent ink"

/obj/item/weapon/pen/attack(atom/A, mob/user as mob, target_zone)
	if(ismob(A))
		var/mob/M = A
		if(ishuman(A) && user.a_intent == I_HELP && target_zone == BP_HEAD)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/head/head = H.organs_by_name[BP_HEAD]
			if(istype(head))
				head.write_on(user, src.color_description)
		else
			to_chat(user, "<span class='warning'>You stab [M] with the pen.</span>")
			add_attack_logs(user, M, "Stabbed using \a [src]", "Was stabbed with \a [src]", "used \a [src] to stab")
	else if(istype(A, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = A
		head.write_on(user, src.color_description)



/*
 * Reagent pens
 */

/obj/item/weapon/pen/reagent
	flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/weapon/pen/reagent/New()
	..()
	create_reagents(30)

/obj/item/weapon/pen/reagent/attack(mob/living/M as mob, mob/user as mob)

	if(!istype(M))
		return

	. = ..()

	if(M.can_inject(user,1))
		if(reagents.total_volume)
			if(M.reagents)
				var/contained = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(M, 30, CHEM_BLOOD)
				add_attack_logs(user,M,"Injected with [src.name] containing [contained], trasferred [trans] units")

/*
 * Sleepy Pens
 */
/obj/item/weapon/pen/reagent/sleepy
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\""
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/weapon/pen/reagent/sleepy/New()
	..()
	reagents.add_reagent("chloralhydrate", 22)	//Used to be 100 sleep toxin//30 Chloral seems to be fatal, reducing it to 22./N


/*
 * Parapens
 */
/obj/item/weapon/pen/reagent/paralysis
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/weapon/pen/reagent/paralysis/New()
	..()
	reagents.add_reagent("zombiepowder", 5)
	reagents.add_reagent("cryptobiolin", 10)

/*
 * Chameleon pen
 */
/obj/item/weapon/pen/chameleon
	var/signature = ""

/obj/item/weapon/pen/chameleon/attack_self(mob/user as mob)
	/*
	// Limit signatures to official crew members
	var/personnel_list[] = list()
	for(var/datum/data/record/t in data_core.locked) //Look in data core locked.
		personnel_list.Add(t.fields["name"])
	personnel_list.Add("Anonymous")

	var/new_signature = input("Enter new signature pattern.", "New Signature") as null|anything in personnel_list
	if(new_signature)
		signature = new_signature
	*/
	signature = sanitize(input("Enter new signature. Leave blank for 'Anonymous'", "New Signature", signature))

/obj/item/weapon/pen/proc/get_signature(var/mob/user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/weapon/pen/chameleon/get_signature(var/mob/user)
	return signature ? signature : "Anonymous"

/obj/item/weapon/pen/chameleon/verb/set_colour()
	set name = "Change Pen Colour"
	set category = "Object"

	var/list/possible_colours = list ("Yellow", "Green", "Pink", "Blue", "Orange", "Cyan", "Red", "Invisible", "Black")
	var/selected_type = input("Pick new colour.", "Pen Colour", null, null) as null|anything in possible_colours

	if(selected_type)
		switch(selected_type)
			if("Yellow")
				colour = COLOR_YELLOW
				color_description = "yellow ink"
			if("Green")
				colour = COLOR_LIME
				color_description = "green ink"
			if("Pink")
				colour = COLOR_PINK
				color_description = "pink ink"
			if("Blue")
				colour = COLOR_BLUE
				color_description = "blue ink"
			if("Orange")
				colour = COLOR_ORANGE
				color_description = "orange ink"
			if("Cyan")
				colour = COLOR_CYAN
				color_description = "cyan ink"
			if("Red")
				colour = COLOR_RED
				color_description = "red ink"
			if("Invisible")
				colour = COLOR_WHITE
				color_description = "transluscent ink"
			else
				colour = COLOR_BLACK
				color_description = "black ink"
		usr << "<span class='info'>You select the [lowertext(selected_type)] ink container.</span>"


/*
 * Crayons
 */

/obj/item/weapon/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEMSIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	color_description = "red crayon"

/obj/item/weapon/pen/crayon/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << "<font color='red'><b>[user] is jamming the [src.name] up [TU.his] nose and into [TU.his] brain. It looks like [TU.he] [TU.is] trying to commit suicide.</b></font>"
	return (BRUTELOSS|OXYLOSS)

/obj/item/weapon/pen/crayon/New()
	name = "[colourName] crayon"

/obj/item/weapon/pen/crayon/marker
	name = "marker"
	desc = "A chisel-tip permanent marker. Hopefully non-toxic."
	icon_state = "markerred"

/obj/item/weapon/pen/crayon/marker/New()
	name = "[colourName] marker"
