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
    
    @IBOutlet weak var wayPoints: UITextView!
   
    
    @IBOutlet weak var matterPort: UITextField!
    @IBOutlet weak var mapObject: UITextField!
    @IBOutlet weak var wayPoint: UITextField!
    
    private var selected : selectedFile!
    private var child : SpinnerViewController!
    
    
    @IBAction func saveWaypoint(_ sender: Any) {
        if (searchdelegate != nil) {
            searchdelegate!.Update(wayPoint:  wayPoints.text);
        }
        
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()

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
                }
                else if (self.selected == selectedFile.matterport)
                {
                    self.matterPort.text = tmpURL.lastPathComponent
                }
                else if (self.selected == selectedFile.mapobject)
                {
                    self.mapObject.text = tmpURL.lastPathComponent
                }
                else if (self.selected == selectedFile.QR)
                {
//self.qr.text = tmpURL.lastPathComponent
                }
                            // then remove the spinner view controller
                self.child.willMove(toParent: nil)
                self.child.view.removeFromSuperview()
                self.child.removeFromParent()
            }
            }.resume()
    }
 }






