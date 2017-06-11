stamps = {
	[1] = {
		image = images.stamps[1],
		userdata = {
			type = "stamp",
			value = 1,
			w = 64,
			h = 64
		}
	},
	[2] = {
		image = images.stamps[2],
		userdata = {
			type = "stamp",
			value = 2,
			w = 64,
			h = 64
		}
	}
}

food = {
	sammich = {
		image = images.food.sammich,
		userdata = {
			type = "food",
			value = 3,
			w = 64,
			h = 64
		}
	}
}

alterers = {
	beer = {
		image = images.alterers.beer,
		userdata = {
			type = "alterer",
			effect = "drunk",
			power = math.pi,		--rotation will start from sin(6pi) = 0
			w = 95,
			h = 42
		}
	},
	
	acid = {
		image = images.alterers.acid,
		userdata = {
			type = "alterer",
			effect = "high",
			power = 3,
			w = 64,
			h = 64
		}
	}
}
