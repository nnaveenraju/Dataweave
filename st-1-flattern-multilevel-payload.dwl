%dw 2.0
output application/json

var sites = payload.Sites

fun fieldName (firstPart, index, secPart) = firstPart ++ index ++ secPart
fun getEntries(arrayData) = arrayData map $ reduce ((item, accumulator = {}) -> item ++ accumulator )
---
sites map (site, siteIndex) -> {
    id: site."Site ID",
    uid: site."Site UID",
    desc: site.Description,
    //Antenna's
    (getEntries((payload.Antennas filter ($."Site ID" == site."Site ID")  map (antenna, antIndex) -> {
        (fieldName('Antenna_Azimuth_', antenna['Antenna ID'], '_c')) : antenna["Antenna ID"],
        (fieldName('Antenna_Height_', antenna['Antenna ID'], '_c')): antenna['Height (m)'],
        (fieldName('Mechanical_Tilt_', antenna['Antenna ID'], '_c')): antenna['Mechanical Tilt']
    }))),
    //Sectors
    (getEntries((payload.Sectors filter ($."Site ID" == site."Site ID")  map (sector, secIndex) -> {
        (fieldName('Flag: 50_Technologie_', sector['Sector ID'], '_c')) : sector["Flag: 50_Technologie"]
    })))
}
