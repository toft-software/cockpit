//
//  Rotation.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on March 5, 2020

import Foundation
import SwiftyJSON


class Rotation : NSObject, NSCoding{

    var rx : String!
    var ry : String!
    var rz : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        rx = json["rx"].stringValue
        ry = json["ry"].stringValue
        rz = json["rz"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if rx != nil{
        	dictionary["rx"] = rx
        }
        if ry != nil{
        	dictionary["ry"] = ry
        }
        if rz != nil{
        	dictionary["rz"] = rz
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		rx = aDecoder.decodeObject(forKey: "rx") as? String
		ry = aDecoder.decodeObject(forKey: "ry") as? String
		rz = aDecoder.decodeObject(forKey: "rz") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if rx != nil{
			aCoder.encode(rx, forKey: "rx")
		}
		if ry != nil{
			aCoder.encode(ry, forKey: "ry")
		}
		if rz != nil{
			aCoder.encode(rz, forKey: "rz")
		}

	}

}
