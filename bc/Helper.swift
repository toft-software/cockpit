//
//  Helper.swift
//  bc
//
//  Created by Christian Andersen on 01/05/2020.
//  Copyright © 2020 Christian Andersen. All rights reserved.
//

import UIKit
import Foundation


public class GlobalVariables {
    
    public static var matterPort : String = "matterport";
    public static var waypoint : String = "waypoint";
    public static var qr : String = "qr";
    public static var mapobjects : String = "mapobjects";
    public static var mapobjectsitem : String = "mapobjectsitem";
    
    
    
    public static var NSMatterport: String! {
        get {
            let defaults = UserDefaults.standard
            let value = defaults.string(forKey: matterPort);
            return value;
        }
        set {
             let defaults = UserDefaults.standard
             defaults.set(newValue, forKey: matterPort)
        }
    }
    
    public static var NSWaypoint: String! {
        get {
            let defaults = UserDefaults.standard
            let value = defaults.string(forKey: waypoint);
            return value
        }
        set {
             let defaults = UserDefaults.standard
             defaults.set(newValue, forKey: waypoint)
        }
    }
    
    public static var NSQr: String! {
        get {
            let defaults = UserDefaults.standard;
            let value = defaults.string(forKey: qr)
            return value;
        }
        set {
             let defaults = UserDefaults.standard
             defaults.set(newValue, forKey: qr)
        }
    }
    
    public static var NSMapObjects: String! {
        get {
            let defaults = UserDefaults.standard
            let value = defaults.string(forKey: mapobjects);
            return value
            }
        set {
             let defaults = UserDefaults.standard
             defaults.set(newValue, forKey: mapobjects)
        }
    }
    
    public static var NSMapObjectsItem: String! {
        get {
            let defaults = UserDefaults.standard
            let value = defaults.string(forKey: mapobjectsitem);
            return value
            }
        set {
             let defaults = UserDefaults.standard
             defaults.set(newValue, forKey: mapobjectsitem)
        }
    }
}
