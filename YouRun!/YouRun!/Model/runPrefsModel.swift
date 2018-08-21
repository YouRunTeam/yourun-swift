//
//  runPrefsModel.swift
//  YouRun!
//
//  Created by Anna Bartlett on 8/18/18.
//  Copyright © 2018 Anna Bartlett. All rights reserved.
//

import Foundation
import GoogleMaps

/* Class runPrefs
 * purpose: store user criteria for route (from user input)
 *          update coordinates for route (from server)
 */
class runPrefs {
    
    // contains values for user preferences
    // (types of preferences currently placeholders)
    struct prefOptions: Codable {
        var hills       : Int
        var greenspace  : Int
        var water       : Int
        var trails      : Int
    }   
    var userPrefs: prefOptions?
    
    // HELP would love to use dictionary for this but couldn't figure out how to init while offline
    //var userPrefs: Dictionary <String, Int>
    
    // array of route coordinates
    var runCoords: [CLLocationCoordinate2D]
    
    init() {
        userPrefs = prefOptions.init(hills: 0, greenspace: 0, water: 0, trails: 0)
        runCoords = []
    }
    
    // HELP what do we want to return?
    public func getPrefs() {}
    
    // HELP how do we receive info / what types are lat/lon vals?
    // insert a single coordinate into runCoords array
    public func insertCoordinate(lat: Double, lon: Double) {
        runCoords.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
    }
    
}
