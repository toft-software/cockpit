import UIKit
import ARKit;
import SceneKit;
import SwiftyJSON;
import Foundation;
import Darwin

protocol SavedPressedDelegate {
    func Update(wayPoint : String);
}


class ImportViewController: UIViewController{


    internal var searchdelegate : SavedPressedDelegate? = nil
    
    @IBOutlet weak var Add3D: UIButton!
    @IBOutlet weak var AddWaypoint: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var AddMapObjects: UIButton!
    
    @IBOutlet weak var butSaveWaypoints: UIButton!
    
    @IBOutlet weak var wayPoints: UITextView!
   
    public var wayPoint : String;
    
    @IBAction func saveWaypoint(_ sender: Any) {
        if (searchdelegate != nil) {
            searchdelegate!.Update(wayPoint:  wayPoints.text);
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           self.wayPoints.text = "te";
        
        
        
    }
    
    
    
    
    
    @IBAction func addMapObjects(_ sender: Any) {
        
        
        
    }
    
    @IBAction func addQR(_ sender: Any) {
        
        
    }
    
    @IBAction func add3D(_ sender: Any) {
        
        
    }
    
    @IBAction func addWaypoints(_ sender: Any) {
        
        
    }
    
}








