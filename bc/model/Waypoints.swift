//
//  Waypoints.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 19, 2020

import Foundation
import SwiftyJSON


class Waypoints : NSObject, NSCoding{

    var waypoints : [Waypoint]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        waypoints = [Waypoint]()
        let waypointsArray = json["Waypoints"].arrayValue
        for waypointsJson in waypointsArray{
            let value = Waypoint(fromJson: waypointsJson)
            waypoints.append(value)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if waypoints != nil{
        var dictionaryElements = [[String:Any]]()
        for waypointsElement in waypoints {
        	dictionaryElements.append(waypointsElement.toDictionary())
        }
        dictionary["waypoints"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		waypoints = aDecoder.decodeObject(forKey: "Waypoints") as? [Waypoint]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if waypoints != nil{
			aCoder.encode(waypoints, forKey: "Waypoints")
		}

	}

}
