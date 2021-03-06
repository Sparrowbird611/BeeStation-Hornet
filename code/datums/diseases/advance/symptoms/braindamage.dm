/datum/symptom/braindamage
	name = "Neural Decay"
	desc = "Causes the host's brain cells to naturally die off, causing severe brain damage."
	stealth = 1
	resistance = -2
	stage_speed = -3
	transmittable = -1
	level = 8
	severity = 3
	symptom_delay_min = 15
	symptom_delay_max = 60
	var/fastdamage = FALSE
	var/moretrauma = FALSE
	threshold_desc = "<b>Resistance 10:</b> Causes the host's brain cells to die off quicker.<br>\
					  <b>Speed 9:</b> Host's brain develops even more traumas than normal."

/datum/symptom/braindamage/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.properties["transmission"] >= 12)
		fastdamage = TRUE
	if(A.properties["speed"] >= 9)
		moretrauma = TRUE

/datum/symptom/braindamage/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(1)
			if(prob(10))
				to_chat(M, "<span class='notice'>Your head feels strange...</span>")
		if(2, 3)
			if(prob(10))
				to_chat(M, "<span class='danger'>Your brain begins hurting...</span>")
		if(4, 5)
			if(fastdamage)
				if(prob(30))
					M.adjustBrainLoss(5, 90)
					to_chat(M, "<span class='danger'>Your brain hurts immensely!</span>")
			else
				if(prob(15))
					M.adjustBrainLoss(5, 90)
					to_chat(M, "<span class='danger'>Your head hurts immensely!</span>")
			if(moretrauma && A.stage == 5)
				givetrauma(A, 10)

/datum/symptom/braindamage/proc/givetrauma(datum/disease/advance/A, chance)
	if(prob(chance))
		if(ishuman(A.affected_mob))
			var/mob/living/carbon/human/M = A.affected_mob 
			M?.gain_trauma(BRAIN_TRAUMA_MILD)
