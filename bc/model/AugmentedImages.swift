//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON


class AugmentedImages : NSObject, NSCoding{

    var augmentedImages : [AugmentedImage]!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        augmentedImages = [AugmentedImage]()
        let augmentedImagesArray = json["AugmentedImages"].arrayValue
        for augmentedImagesJson in augmentedImagesArray{
            let value = AugmentedImage(fromJson: augmentedImagesJson)
            augmentedImages.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if augmentedImages != nil{
            var dictionaryElements = [[String:Any]]()
            for augmentedImagesElement in augmentedImages {
                dictionaryElements.append(augmentedImagesElement.toDictionary())
            }
            dictionary["AugmentedImages"] = dictionaryElements
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         augmentedImages = aDecoder.decodeObject(forKey: "AugmentedImages") as? [AugmentedImage]

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if augmentedImages != nil{
            aCoder.encode(augmentedImages, forKey: "AugmentedImages")
        }

    }

}
