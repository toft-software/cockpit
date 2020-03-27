//
//    AugmentedImage.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON


class AugmentedImage : NSObject, NSCoding{

    var id : Int!
    var position : Position!
    var rotation : Rotation!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["Id"].intValue
        let positionJson = json["Position"]
        if !positionJson.isEmpty{
            position = Position(fromJson: positionJson)
        }
        let rotationJson = json["Rotation"]
        if !rotationJson.isEmpty{
            rotation = Rotation(fromJson: rotationJson)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["Id"] = id
        }
        if position != nil{
            dictionary["Position"] = position.toDictionary()
        }
        if rotation != nil{
            dictionary["Rotation"] = rotation.toDictionary()
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         id = aDecoder.decodeObject(forKey: "Id") as? Int
         position = aDecoder.decodeObject(forKey: "Position") as? Position
         rotation = aDecoder.decodeObject(forKey: "Rotation") as? Rotation

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "Id")
        }
        if position != nil{
            aCoder.encode(position, forKey: "Position")
        }
        if rotation != nil{
            aCoder.encode(rotation, forKey: "Rotation")
        }

    }

}
