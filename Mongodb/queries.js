// =============================================
// FC 25 BENCHMARK QUERIES (PostgreSQL)
// =============================================

// 1.
db.players_final.find(
    {
        "info.nation": "France",
        "info.team": "Real Madrid"
    },
    { "name": 1, "info.nation": 1, "info.team": 1 }
).explain("executionStats");


// 2.
db.players_final.aggregate([
    { "$group": {
        "_id": "$info.nation",
        "total": { "$sum": 1 },
        "avg_age": { "$avg": "$info.age" }
    }},
    { "$match": { "total": { "$gte": 30 } } },
    { "$sort": { "avg_age": 1 } },
    { "$limit": 5 }
]).explain("executionStats");


// 3.
var start = new Date();
db.players_final.updateMany(
    { "info.age": { "$gt": 30 } },
    { "$inc": { "detailed_attributes.power.stamina": 1 } }
);
var end = new Date();
print("Time taken: " + (end - start) + " ms");


// 4.
db.players_final.find(
    {
        "name": { "$regex": "^Ro" },
        "info.team": { "$regex": "United$" }
    },
    { "name": 1, "info.team": 1 }
).explain("executionStats");


// 5. 
db.players_final.find(
    {
        "$or": [
            { "goalkeeping.diving": { "$gt": 88 } },
            { "base_stats.dribbling": { "$gt": 90 } }
        ]
    },
    { "name": 1, "info.position": 1, "goalkeeping.diving": 1, "base_stats.dribbling": 1 }
).explain("executionStats");


// 6.
db.players_final.find(
    { "playstyles": { "$all": ["Flair", "Rapid"] } },
    { "name": 1, "playstyles": 1 }
).explain("executionStats");


// 7.
db.players_final.find(
    {
        "$expr": {
            "$gt": [
                "$base_stats.passing",
                { "$add": ["$base_stats.shooting", 15] }
            ]
        }
    },
    { "name": 1, "base_stats.passing": 1, "base_stats.shooting": 1 }
).explain("executionStats");


// 8.
db.players_final.aggregate([
    { "$sort": { "overall_rating": -1 } },
    { "$group": {
        "_id": "$info.league",
        "best_player": { "$first": "$name" },
        "max_ovr": { "$first": "$overall_rating" }
    }},
    { "$sort": { "max_ovr": -1 } }
]).explain("executionStats");


// 9.
var start = new Date(); 
db.players_final.updateMany(
    { "info.age": { "$lt": 21 } },              
    { "$set": { "scouting_status": "High Potential" } } 
);
var end = new Date(); 
print("Tempo Schema Evolution (Mongo): " + (end - start) + " ms");

// 10.
var start = new Date(); 
db.players_final.updateOne(
    { name: "Kylian Mbappé" },
    { $push: { 
        timeline: { 
            type: "Transfer", 
            fee: "100M", 
            from: "PSG" 
        } 
    }}
);
var end = new Date(); 
print("Tempo Schema Evolution (Mongo): " + (end - start) + " ms");

// 11.
db.players.find({
    "info.nation": "Brazil",
    "info.league": "Premier League",
    "playstyles": "Technical",        
    "base_stats.dribbling": { $gt: 85 }
}, 
{ 
    "name": 1, 
    "info.nation": 1, 
    "info.team": 1, 
    "info.league": 1, 
    "base_stats.dribbling": 1, 
    "playstyles": 1 
})
.hint({ $natural: 1 }) 
.explain("executionStats");

// index 11.  ESR (Equality, Sort, Range)
db.players.createIndex(
    {
        "info.nation": 1,        // Equality
        "info.league": 1,        // Equality
        "playstyles": 1,         // Equality
        "base_stats.dribbling": 1 // Range
    },
    { name: "idx_scout_optimized" }
);
