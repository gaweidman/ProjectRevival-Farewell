ix.effects = {}

ix.effects.list = {
    -- lengths are in seconds

    -- this is the debuff in the Easily Distracted trait
    distracted = {
        name = "Distracted",
        attribs = {},
        skills = {
            engineering = -10,
            cooking = -10,
            medical = -10,
            fabrication = -10
        },
        length = 60
    },

    alcohol = {
        name = "Alcohol",
        attribs = {
            agility = -1
        },
        skills = {

        },
        length = 60*5
    },

    morphine = {
        name = "Morphine",
        attribs = {
            agility = -1
        },
        partyanimal = {
            attribs = {
                constitution = 1
            }
        },
        length = 60*5
    }
}

for k, v in pairs(ix.effects.list) do
    if !v.attribs then ix.effects.list[k].attribs = {} end
    if !v.skills then ix.effects.list[k].skills = {} end
end