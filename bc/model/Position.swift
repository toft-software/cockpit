//
//  Position.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 5, 2020

import Foundation
import SwiftyJSON


class Position : NSObject, NSCoding{

    var x : String!
    var y : String!
    var z : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        x = json["x"].stringValue
        y = json["y"].stringValue
        z = json["z"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if x != nil{
        	dictionary["x"] = x
        }
        if y != nil{
        	dictionary["y"] = y
        }
        if z != nil{
        	dictionary["z"] = z
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		x = aDecoder.decodeObject(forKey: "x") as? String
		y = aDecoder.decodeObject(forKey: "y") as? String
		z = aDecoder.decodeObject(forKey: "z") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if x != nil{
			aCoder.encode(x, forKey: "x")
		}
		if y != nil{
			aCoder.encode(y, forKey: "y")
		}
		if z != nil{
			aCoder.encode(z, forKey: "z")
		}

	}

}
