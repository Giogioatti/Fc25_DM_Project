db.players.aggregate([{
  "_id": 0,
  "name": "$Name",
  "rank": "$Rank",
  "info": {
    "age": "$Age",
    "nation": "$Nation",
    "team": "$Team",
    "league": "$League",
    "position": "$Position",
    "foot": "$Preferred foot",
    "height": "$Height",
    "weight": "$Weight",
    "alternative_positions": {
      "$cond": {
         "if": { "$eq": ["$Alternative positions", ""] }, 
         "then": [],                                      
         "else": { "$split": ["$Alternative positions", ", "] } 
      }
    }
  },

  "playstyles": {
      "$cond": {
         "if": { "$eq": ["$play style", ""] },
         "then": [],
         "else": { "$split": ["$play style", ", "] } 
      }
  },
  
  "base_stats": {
    "pace": "$PAC",
    "shooting": "$SHO",
    "passing": "$PAS",
    "dribbling": "$DRI",
    "defending": "$DEF",
    "physical": "$PHY"
  },

  "goalkeeping": {
    "$cond": {
      "if": { "$eq": ["$Position", "GK"] },
      "then": {
        "diving": "$GK Diving",
        "handling": "$GK Handling",
        "kicking": "$GK Kicking",
        "reflexes": "$GK Reflexes",
        "positioning": "$GK Positioning"
      },
      "else": "$$REMOVE"
    }
  },

  "detailed_attributes": {
    "movement": {
      "acceleration": "$Acceleration",
      "sprint_speed": "$Sprint Speed",
      "agility": "$Agility",
      "balance": "$Balance",
      "reactions": "$Reactions"
    },
    "power": {
      "shot_power": "$Shot Power",
      "jumping": "$Jumping",
      "stamina": "$Stamina",
      "strength": "$Strength",
      "aggression": "$Aggression"
    },
    "technical": {
      "ball_control": "$Ball Control",
      "dribbling": "$Dribbling",
      "finishing": "$Finishing",
      "heading": "$Heading Accuracy",
      "short_passing": "$Short Passing",
      "long_passing": "$Long Passing",
      "penalties": "$Penalties"
    },
    "defensive": {
      "interceptions": "$Interceptions",
      "awareness": "$Def Awareness",
      "standing_tackle": "$Standing Tackle",
      "sliding_tackle": "$Sliding Tackle"
    }
  },
  "overall_rating": "$OVR"
}
])