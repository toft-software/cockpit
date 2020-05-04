import UIKit
import ARKit;
import SceneKit;
import SwiftyJSON;
import Foundation;
import Darwin

protocol SavedPressedDelegate {
    func Update(wayPoint : String);
}



enum selectedFile: Int{
    case waypoint = 1001, mapobject, matterport, QR, notSelected
}


 class ImportViewController: UIViewController{


    internal var searchdelegate : SavedPressedDelegate? = nil
    
    @IBOutlet weak var Add3D: UIButton!
    @IBOutlet weak var AddWaypoint: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var AddMapObjects: UIButton!
    
    @IBOutlet weak var butSaveWaypoints: UIButton!
       
    
    @IBOutlet weak var QR: UITextField!
    @IBOutlet weak var matterPort: UITextField!
    @IBOutlet weak var mapObject: UITextField!
    @IBOutlet weak var wayPoint: UITextField!
    @IBOutlet weak var matterPortNode: UITextField!
    
    private var selected : selectedFile!
    private var child : SpinnerViewController!
    
    
    @IBAction func saveWaypoint(_ sender: Any) {
        if (searchdelegate != nil) {
            searchdelegate!.Update(wayPoint:  "");
        }
    }
    
    
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        matterPortNode.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        
        if (GlobalVariables.NSMapObjects != nil) {
            self.mapObject.text = GlobalVariables.NSMapObjects
        }
        
        if (GlobalVariables.NSQr != nil) {
            self.QR.text = GlobalVariables.NSQr
        }

        if (GlobalVariables.NSMatterport != nil) {
            self.matterPort.text = GlobalVariables.NSMatterport
        }
        
        if (GlobalVariables.NSWaypoint != nil) {
            self.wayPoint.text = GlobalVariables.NSWaypoint
        }
        
        if (GlobalVariables.NSMapObjectsItem != nil) {
            self.matterPortNode.text = GlobalVariables.NSMapObjectsItem
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        GlobalVariables.NSMapObjectsItem = self.matterPortNode.text 
    }
    
    @IBAction func addMapObjects(_ sender: Any) {
        self.selected = selectedFile.mapobject;
        self.DoPick();
    }
    
    @IBAction func addQR(_ sender: Any) {
        self.selected = selectedFile.QR;
        self.DoPick();
    }
    
    @IBAction func add3D(_ sender: Any) {
        self.selected = selectedFile.matterport;
        self.DoPick();
    }
    
    @IBAction func addWaypoints(_ sender: Any) {
        self.selected = selectedFile.waypoint;
        self.DoPick();
    }
    
    func createSpinnerView() {
        child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

        }
    }
    
    func DoPick () {
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)

        documentPicker.delegate = (self as UIDocumentPickerDelegate)
        present(documentPicker, animated: true, completion: nil)

        
    }
}

extension ImportViewController: UIDocumentPickerDelegate{


    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        createSpinnerView();
              let cico = url as URL
              print(cico)
        print(url.absoluteURL)

              print(url.lastPathComponent)

              print(url.pathExtension)
        self.storeAndShare(withURLString: url.absoluteURL.absoluteString);
             }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string : withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                if (self.selected == selectedFile.waypoint)
                {
                    self.wayPoint.text = tmpURL.lastPathComponent
                    GlobalVariables.NSWaypoint = tmpURL.lastPathComponent
                    
                }
                else if (self.selected == selectedFile.matterport)
                {
                    self.matterPort.text = tmpURL.lastPathComponent
                    GlobalVariables.NSMatterport = tmpURL.lastPathComponent
                }
                else if (self.selected == selectedFile.mapobject)
                {
                    self.mapObject.text = tmpURL.lastPathComponent
                    GlobalVariables.NSMapObjects = tmpURL.lastPathComponent
                }
                else if (self.selected == selectedFile.QR)
                {
                    self.QR.text = tmpURL.lastPathComponent
                    GlobalVariables.NSQr = tmpURL.lastPathComponent
                }
                            // then remove the spinner view controller
                self.child.willMove(toParent: nil)
                self.child.view.removeFromSuperview()
                self.child.removeFromParent()
            }
            }.resume()
    }
 }






