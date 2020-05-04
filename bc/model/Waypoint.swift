//
//  Waypoint.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 19, 2020

import Foundation
import SwiftyJSON


class Waypoint : NSObject, NSCoding{

    var title : String!
    var index : Int!
    var neighbors : [Int]!
    var position : Position!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        title = json["Title"].stringValue
        index = json["Index"].intValue
        neighbors = [Int]()
        let neighborsArray = json["Neighbors"].arrayValue
        for neighborsJson in neighborsArray{
            neighbors.append(neighborsJson.intValue)
        }
        let positionJson = json["Position"]
        if !positionJson.isEmpty{
            position = Position(fromJson: positionJson)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if title != nil{
            dictionary["Title"] = title
        }
        if index != nil{
        	dictionary["Index"] = index
        }
        if neighbors != nil{
        	dictionary["Neighbors"] = neighbors
        }
        if position != nil{
        	dictionary["position"] = position.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        title = aDecoder.decodeObject(forKey: "Title") as? String
		index = aDecoder.decodeObject(forKey: "Index") as? Int
		neighbors = aDecoder.decodeObject(forKey: "Neighbors") as? [Int]
		position = aDecoder.decodeObject(forKey: "Position") as? Position
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
        if title != nil{
            aCoder.encode(title, forKey: "Title")
        }
		if index != nil{
			aCoder.encode(index, forKey: "Index")
		}
		if neighbors != nil{
			aCoder.encode(neighbors, forKey: "Neighbors")
		}
		if position != nil{
			aCoder.encode(position, forKey: "Position")
		}

	}
       
    var WorldY : Double {
    get {
        return (self.position.z as NSString).doubleValue;
        }
    }

}
