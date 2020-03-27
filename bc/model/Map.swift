//
//  Map.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 16, 2020

import Foundation
import SwiftyJSON


class Map : NSObject, NSCoding{

    var position : Position!
    var renderable : Int!
    var rotation : Rotation!
    var type : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        let positionJson = json["Position"]
        if !positionJson.isEmpty{
            position = Position(fromJson: positionJson)
        }
        renderable = json["Renderable"].intValue
        let rotationJson = json["Rotation"]
        if !rotationJson.isEmpty{
            rotation = Rotation(fromJson: rotationJson)
        }
        type = json["Type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if position != nil{
        	dictionary["position"] = position.toDictionary()
        }
        if renderable != nil{
        	dictionary["Renderable"] = renderable
        }
        if rotation != nil{
        	dictionary["rotation"] = rotation.toDictionary()
        }
        if type != nil{
        	dictionary["Type"] = type
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		position = aDecoder.decodeObject(forKey: "Position") as? Position
		renderable = aDecoder.decodeObject(forKey: "Renderable") as? Int
		rotation = aDecoder.decodeObject(forKey: "Rotation") as? Rotation
		type = aDecoder.decodeObject(forKey: "Type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if position != nil{
			aCoder.encode(position, forKey: "Position")
		}
		if renderable != nil{
			aCoder.encode(renderable, forKey: "Renderable")
		}
		if rotation != nil{
			aCoder.encode(rotation, forKey: "Rotation")
		}
		if type != nil{
			aCoder.encode(type, forKey: "Type")
		}

	}

}
