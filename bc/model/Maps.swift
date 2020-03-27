//
//  Maps.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 16, 2020

import Foundation
import SwiftyJSON


class Maps : NSObject, NSCoding{

    var maps : [Map]!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        maps = [Map]()
        let mapArray = json["Maps"].arrayValue
        for mapJson in mapArray{
            let value = Map(fromJson: mapJson)
            maps.append(value)
        }
        
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if maps != nil{
        var dictionaryElements = [[String:Any]]()
        for mapElement in maps {
        	dictionaryElements.append(mapElement.toDictionary())
        }
        dictionary["map"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		maps = aDecoder.decodeObject(forKey: "Map") as? [Map]
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if maps != nil{
			aCoder.encode(maps, forKey: "Map")
		}

	}

}
