
//
//  ViewController.swift
//  bc
//
//  Created by Christian Andersen on 25/02/2020.
//  Copyright © 2020 Christian Andersen. All rights reserved.
//

import UIKit
import ARKit;
import SceneKit;
import SwiftyJSON;
import Foundation;
import Darwin

class ViewController: UIViewController, ARSCNViewDelegate{

    @IBOutlet weak var idxWaypoint: UILabel!
    @IBOutlet weak var poxX: UILabel!
    @IBOutlet weak var posY: UILabel!
    @IBOutlet weak var posZ: UILabel!
    @IBOutlet weak var rotX: UILabel!
    @IBOutlet weak var rotY: UILabel!
    @IBOutlet weak var rotZ: UILabel!
    @IBOutlet weak var rotW: UILabel!
    @IBOutlet weak var addBut: UIButton!
    @IBOutlet weak var scnView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration();
    
    @IBOutlet weak var goToLocation: UIButton!
    private var image_json : AugmentedImages = AugmentedImages(fromJson: "");
    private var map_obj_json : Maps = Maps(fromJson: "");
    private var waypoint_json : Waypoints = Waypoints(fromJson: "");
    
    private var map : SCNNode!
    private var camera : SCNNode!
    private var arrow : SCNNode!
    private var waypoint : SCNNode!
    private var waypointShowVase : SCNNode!

    private var route : Array<Int> = Array<Int>()

    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // AR objects
        map =  SCNNode();
        camera = SCNNode();
        arrow =  SCNNode();
        waypoint = SCNNode();
        
        waypointShowVase = SCNNode();
        
        self.scnView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin];
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
                   fatalError("Missing expected asset catalog resources.")
               }
        configuration.detectionImages = referenceImages
        self.scnView.session.run(configuration);
        self.scnView.delegate = self;

        // Load JSON files
        image_json = loadJSONFile(filename: "augmentedImages") as! AugmentedImages
        map_obj_json = loadJSONFile(filename: "map_objects") as! Maps
        waypoint_json = loadJSONFile(filename: "waypoints") as! Waypoints
        
    /*    let sceneCup = SCNScene(named: "art.scnassets/1a/cup.scn");
        waypointShowCup = (sceneCup?.rootNode.childNode(withName: "cup", recursively: false))!;
        */
        
        let sceneVase = SCNScene(named: "art.scnassets/wayObject/vase.scn");
        waypointShowVase = sceneVase?.rootNode.childNode(withName: "vase", recursively: false);
    }
    
    @IBAction func goTo(_ sender: Any) {
        var target_index = 0;

        let alert = UIAlertController(title: "Title", message: "Please Select Location", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "off Marinna Gade office", style: .default , handler:{ (UIAlertAction)in
            target_index = 0;
            self.goToLocation.setTitle("Mariannnas office", for : UIControl.State.normal);
            self.findRouteTo(index: target_index);
        }))

        alert.addAction(UIAlertAction(title: "comm Christian Office", style: .default , handler:{ (UIAlertAction)in
            target_index = 4;
            self.goToLocation.setTitle("MY OFFICE office", for : UIControl.State.normal);
            self.findRouteTo(index: target_index);
        }))

        alert.addAction(UIAlertAction(title: "fire Fittness room (LOOP)", style: .default , handler:{ (UIAlertAction)in
            target_index = 5;
            self.goToLocation.setTitle("FITTNESS ", for : UIControl.State.normal);
            self.findRouteTo(index: target_index);
        }))

        alert.addAction(UIAlertAction(title: "Entrance", style: .default, handler:{ (UIAlertAction)in
            target_index = 7;
            self.goToLocation.setTitle("ENTRANCE", for : UIControl.State.normal);
            self.findRouteTo(index: target_index);
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler:{ (UIAlertAction)in
        }))

        self.present(alert, animated: true, completion: {
           
        })
        
    }
    
    func Add3DMatterPort (augImage : AugmentedImage, QRNode : SCNNode)
    {
        let scene = SCNScene(named: "art.scnassets/1a/1a.scn");
        map = scene?.rootNode.childNode(withName: "1a", recursively: false);

        let position = SCNVector3(CGFloat((augImage.position.x as NSString).floatValue), CGFloat((augImage.position.y as NSString).floatValue), CGFloat((augImage.position.z as NSString).floatValue));
               
        let rx = ((augImage.rotation.rx as NSString).integerValue.degreesToRadians);
        let ry = ((augImage.rotation.ry as NSString).integerValue.degreesToRadians);
        let rz = ((augImage.rotation.rz as NSString).integerValue.degreesToRadians);
        let rotation = SCNVector3(CGFloat(rx), CGFloat(ry), CGFloat(rz));
        
        map?.position = position;
     //   Rotation around an axis = eulerAngles
        map?.eulerAngles = rotation;
        QRNode.addChildNode(map!);

        //Add 3d Objects
        for mapObject in self.map_obj_json.maps {
            self.Add3DToMAp(mapObject: mapObject, map3D: map!)
        }
        
        let sceneArrow = SCNScene(named: "art.scnassets/camera/arrow.dae");
        arrow = sceneArrow?.rootNode.childNode(withName: "arrow", recursively: false);
        
        self.scnView.scene.rootNode.addChildNode(camera);
        camera.addChildNode(arrow);
        
    }
    
    func Add3DToMAp (mapObject : Map, map3D : SCNNode)
    {
        let scene = SCNScene(named: "art.scnassets/mapObject/Jellyfish.dae");
        let node3DModel = scene?.rootNode.childNode(withName: "Sphere", recursively: false);

        let position = SCNVector3(CGFloat((mapObject.position.x as NSString).floatValue), CGFloat((mapObject.position.y as NSString).floatValue), CGFloat((mapObject.position.z as NSString).floatValue));
               
        let rx = ((mapObject.rotation.rx as NSString).integerValue.degreesToRadians);
        let ry = ((mapObject.rotation.ry as NSString).integerValue.degreesToRadians);
        let rz = ((mapObject.rotation.rz as NSString).integerValue.degreesToRadians);
  
        let rotation = SCNVector3(CGFloat(rx), CGFloat(ry), CGFloat(rz));

        node3DModel?.position = position;
        node3DModel?.eulerAngles = rotation;
        map3D.addChildNode(node3DModel!);

    }
    
      func Add3DWayPointsToMAp (mapObject : Map, map3D : SCNNode)
      {
          let scene = SCNScene(named: "art.scnassets/mapObject/Jellyfish.dae");
          let node3DModel = scene?.rootNode.childNode(withName: "Sphere", recursively: false);

          let position = SCNVector3(CGFloat((mapObject.position.x as NSString).floatValue), CGFloat((mapObject.position.y as NSString).floatValue), CGFloat((mapObject.position.z as NSString).floatValue));
                 
          let rx = ((mapObject.rotation.rx as NSString).integerValue.degreesToRadians);
          let ry = ((mapObject.rotation.ry as NSString).integerValue.degreesToRadians);
          let rz = ((mapObject.rotation.rz as NSString).integerValue.degreesToRadians);
    
          let rotation = SCNVector3(CGFloat(rx), CGFloat(ry), CGFloat(rz));

          node3DModel?.position = position;
          node3DModel?.eulerAngles = rotation;
          map3D.addChildNode(node3DModel!);

      }


    @IBAction func add(_ sender: Any) {
        
        let scene = SCNScene(named: "art.scnassets/1a/1a.scn");
        let node = scene?.rootNode.childNode(withName: "1a", recursively: false);

       // var transform = ARHitTestResult.;
     //   var thirdColumn = transform.Column3;
     //  node.Position = SCNVector3(thirdColumn.X, thirdColumn.Y, thirdColumn.Z);
        node?.position = SCNVector3(0,0,0);
        self.scnView.scene.rootNode.addChildNode(node!);
    }

    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let pointOfView = scnView.pointOfView else { return}
        let PointOfViewTransform = pointOfView.transform;
        let orientation = SCNVector3(-PointOfViewTransform.m31, -PointOfViewTransform.m32, -PointOfViewTransform.m33);
        let location = SCNVector3(PointOfViewTransform.m41, PointOfViewTransform.m42, PointOfViewTransform.m43);
        let currentPositionOfCamera = orientation + location;
        
        camera.position = currentPositionOfCamera;
        arrow.position = SCNVector3( 0,-0.25, -0.5);  //is a child of camera
       
        // Waypoint nav
        if(route.count > 1) {
            let first_point_pos = waypoint_json.waypoints[route[0]].position;
            let sec_point_pos = waypoint_json.waypoints[route[1]].position;
            
            if (distanceBetween(  node :camera, json1: sec_point_pos!) < distanceBetweenPoints(json1 : first_point_pos!, json2 :sec_point_pos!) || (distanceBetween(node : camera, json1 : first_point_pos!) < 1.0)) {
                route.remove(at : 0);
            }
        }
        if(route.count > 0) {
            let point_pos = waypoint_json.waypoints[route[0]].position;
             
            map.addChildNode(waypoint);
            
            //show waypoints
    //        let sceneVase = SCNScene(named: "art.scnassets/wayObject/vase.scn");
     //       waypoint = sceneVase?.rootNode.childNode(withName: "vase", recursively: false);
            waypoint = waypointShowVase;
            waypoint.position = SCNVector3(CGFloat((point_pos!.x as NSString).floatValue), CGFloat((point_pos!.y as NSString).floatValue), CGFloat((point_pos!.z as NSString).floatValue));
            waypoint.rotation = SCNVector4( 0.707, 0, 0,0.707);
            pointToNode(node : waypoint);
        }
        
        var idxW = "";
        for i in 0..<self.route.count
        {
            idxW += String(self.route[i]  ) ;
        }
     
        DispatchQueue.main.async {

            self.idxWaypoint.text = idxW;
            
            self.poxX.text = String(self.camera.position.x);
            self.posY.text = String(self.camera.position.y);
            self.posZ.text = String(self.camera.position.z);
            
            self.rotX.text = String(self.camera.rotation.x);
            self.rotY.text = String(self.camera.rotation.y);
            self.rotZ.text = String(self.camera.rotation.z);
            self.rotW.text = String(self.camera.rotation.w);
        }
              
    }
    
    
    // MARK: - ARSCNViewDelegate (Image detection results)
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
       
        _ = SCNVector3Make(imageAnchor.transform.columns.3.x,
                                           imageAnchor.transform.columns.3.y,
                                           imageAnchor.transform.columns.3.z)

     //   var plane = anchor as! ARPlaneAnchor;
    //    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
     //   plane.center.x
        
        /*POV
        guard let pointOfView = scnView.pointOfView else { return}
        let transform = pointOfView.transform;
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33);
        let location = SCNVector3(transform.m41, transform.m42, transform.m43);
        let currentlocation = location + orientation;
        camera.position = currentlocation;
 */
        //   self.scnView.scene.rootNode.addChildNode(camera);
        
        // QRAnchor
        let QRAnchor = SCNNode();
        QRAnchor.transform = SCNMatrix4(imageAnchor.transform)
 
        //Plane
        let planeAnchor = SCNNode();
        planeAnchor.position = SCNVector3(0,0,0);
        
        let box = SCNPlane();
        box.width = referenceImage.physicalSize.width;
        box.height = referenceImage.physicalSize.height;
        
      //  box.length = 0.2;
      //  box.chamferRadius = 0.2;
        box.firstMaterial?.diffuse.contents = UIColor.red;
        planeAnchor.eulerAngles.x = -.pi / 2
        planeAnchor.geometry = box;
        //nopew    QRAnchor.geometry = box;
        QRAnchor.addChildNode(planeAnchor);
        
        self.scnView.scene.rootNode.addChildNode(QRAnchor);
        
        
        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
     
            for augImage in self.image_json.augmentedImages {
                if (String(augImage.id) == imageName) {

                    self.Add3DMatterPort(augImage: augImage, QRNode: QRAnchor);
                }
            }
                        
            //       self.statusViewController.cancelAllScheduledMessages()
     //       self.statusViewController.showMessage("Detected image “\(imageName)”")
        }
 
    }

    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ])
    }
    

    func  loadJSONFile(filename : String) -> AnyObject {
        
        if let filePath = Bundle.main.path(forResource: filename, ofType: "json") {
          // let data = NSData(contentsOfFile: filePath ) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let result = JSON(data);
                    
                if (filename == "augmentedImages") {
                    return AugmentedImages(fromJson: result);
                }
                else if (filename == "map_objects") {
                    return Maps(fromJson: result);
                }
                else if (filename == "waypoints") {
                    return Waypoints(fromJson: result);
                }
            }
            catch {
                  // handle error
             }
            
            return AugmentedImages(fromJson: nil);
        }
        
       return AugmentedImages(fromJson: nil);

    }

    func findRouteTo(index : Int )   {
          // Find starting point
          var start_index = 0;
          var min_distance = Double.greatestFiniteMagnitude;

        for i in 0..<waypoint_json.waypoints.count
        {
            let waypoint_pos = waypoint_json.waypoints[i].position;
            if (distanceBetween(node: camera, json1: waypoint_pos!) < min_distance) {
                    start_index = waypoint_json.waypoints[i].index;
                    min_distance = distanceBetween(node: camera, json1: waypoint_pos!);
            }
        }
    
        var vertexes = Array<Vertex>();
          // Create waypoint map
        for i in 0..<waypoint_json.waypoints.count
        {
            vertexes.append(Vertex(id: i));
        }
        
        for i in 0..<waypoint_json.waypoints.count
        {
            let neighbor_json = waypoint_json.waypoints[i].neighbors;
            for j in 0..<neighbor_json!.count{
                let addNeighbor = vertexes[neighbor_json![j]];
                vertexes[waypoint_json.waypoints[i].index].addNeighbor(vertex: addNeighbor);
            }
        }
        
        // Find shortest path
        let start = vertexes[start_index];
        let end = vertexes[index];
        
        
        let hasPath = ViewController.bfs(start: start, end: end);
        
        if (hasPath) {
          // print path
            var predecessor: Vertex? = end;
           // predecessor = end;
            route = Array<Int>();
           repeat {
               //take input from standard IO into variable n
            route.insert(predecessor!.id, at: 0)
            predecessor = predecessor!.getPredecessor();
           } while predecessor != nil
        }
        
        
    }

    
      // z value is discarded
    func distanceBetween( node : SCNNode, json1 : Position) -> Double {
        //Vector3 node_pos = node.getLocalPosition();
        var dist = Double.greatestFiniteMagnitude;
        dist = sqrt(pow( Double(node.position.x) - (json1.x as NSString).doubleValue , 2 ) +
            pow(Double(node.position.z * -1 )  - (json1.TWO_D_Y as NSString).doubleValue * -1  , 2 ));
        return dist;
    }
      
    func distanceBetweenPoints( json1 : Position, json2 : Position) -> Double {
        var dist = Double.greatestFiniteMagnitude;
        dist = sqrt(pow((json1.x as NSString).doubleValue - (json2.x as NSString).doubleValue , 2 ) +
                    pow((json1.TWO_D_Y as NSString).doubleValue * -1  - (json2.TWO_D_Y as NSString).doubleValue * -1  , 2 ))
        return dist;
      }

    func pointToNode(node : SCNNode) {
        let currentPositionOfCamera = getLocation(node: camera) + getOrientation(node: camera);
        let currentPositionOfArrow = getLocation(node: arrow) + getOrientation(node: arrow);
        let currentPositionOfNode =   getLocation(node: node) + getOrientation(node: node);
        
        let start_vec = currentPositionOfCamera - currentPositionOfArrow;
        let end_vec = currentPositionOfCamera - currentPositionOfNode;
        
        let arrow_quat = simd_quatf(from: SIMD3<Float>(start_vec.x, start_vec.y, start_vec.z), to: SIMD3<Float>(end_vec.x, end_vec.z, end_vec.y));
        arrow.rotation = arrow_quat.toSCN();
        
    }
    
    
    
    
    
     // breadth-first search
    static func bfs( start : Vertex, end : Vertex ) -> Bool {
        let queue  =  LinkedList<Vertex>();
        queue.append(start);
        while (!queue.isEmpty) {
             
                
            let vertex = queue.first; //pollfirst = remove find first
            if (vertex != nil) {
                queue.remove(at: 0);
            }
            
            if (vertex!.isSearched) {
                continue;
            }
            if (vertex == end) {
                 return true;
            }
            else
            {
                for neighbor in vertex!.getNeighbors()!
                {
                    if (neighbor.getPredecessor() == nil && neighbor != start)
                    {
                        neighbor.setPredecessor(predecessor: vertex!);
                    }
                    queue.append(neighbor);
               }
            }
            vertex!.isSearched = true;
         }
         return false;
     }
}
func getOrientation(node : SCNNode ) -> SCNVector3
{
    return SCNVector3(-node.transform.m31, -node.transform.m32, -node.transform.m33);
}

func getLocation(node : SCNNode ) -> SCNVector3
{
    return SCNVector3(node.transform.m41, node.transform.m42, node.transform.m43);
}


func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x,left.y + right.y, left.z + right.z);
}

func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x,left.y - right.y, left.z - right.z);
}



extension Int {
    var degreesToRadians : Double {return Double(self) * .pi/180}
}
