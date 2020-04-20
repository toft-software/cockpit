
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
    private var waypointShowArrowBlue : SCNNode!

    private var rot : Int = 0
    
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
        camera.name = "camera";
        
        arrow =  SCNNode();
        arrow.name = "arrow";
        
        waypoint = SCNNode();
        waypoint.name = "waypoint";
        
        waypointShowArrowBlue = SCNNode();
        
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
        
        let sceneVase = SCNScene(named: "art.scnassets/wayObject/ArrowB.scn");
        waypointShowArrowBlue = sceneVase?.rootNode.childNode(withName: "ArrowB", recursively: false);
        /*
        let sceneArrow = SCNScene(named: "art.scnassets/camera/arrow.dae");
        arrow = sceneArrow?.rootNode.childNode(withName: "arrow", recursively: false);
        */
        let sceneArrow = SCNScene(named: "art.scnassets/1a/cup.scn");
        arrow = sceneArrow?.rootNode.childNode(withName: "cup", recursively: false);
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
        updateQueue.async {
            let scene = SCNScene(named: "art.scnassets/1a/1a.scn");
            self.map = scene?.rootNode.childNode(withName: "1a", recursively: false);

            let position = SCNVector3(CGFloat((augImage.position.x as NSString).floatValue), CGFloat((augImage.position.y as NSString).floatValue), CGFloat((augImage.position.z as NSString).floatValue));
                   
            let rx = ((augImage.rotation.rx as NSString).integerValue.degreesToRadians);
            let ry = ((augImage.rotation.ry as NSString).integerValue.degreesToRadians);
            let rz = ((augImage.rotation.rz as NSString).integerValue.degreesToRadians);
            let rotation = SCNVector3(Float(rx), Float(ry), Float(rz));
            
            self.map?.position = position;
         //   Rotation around an axis = eulerAngles
            self.map?.eulerAngles = rotation;
            QRNode.addChildNode(self.map!);

            //Add 3d Objects
            for mapObject in self.map_obj_json.maps {
                self.Add3DMapToMAp(mapObject: mapObject, map3D: self.map!)
            }

            self.map.addChildNode(self.camera);
            self.camera.addChildNode(self.arrow);
        }
        
    }
    
    func Add3DMapToMAp (mapObject : Map, map3D : SCNNode)
    {
        updateQueue.async {
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
    }
    

    @IBAction func add(_ sender: Any) {
        
    //    let scene = SCNScene(named: "art.scnassets/1a/1a.scn");
     //   let node = scene?.rootNode.childNode(withName: "1a", recursively: false);

       // var transform = ARHitTestResult.;
     //   var thirdColumn = transform.Column3;
     //  node.Position = SCNVector3(thirdColumn.X, thirdColumn.Y, thirdColumn.Z);
     //   node?.position = SCNVector3(0,0,0);
    //    self.scnView.scene.rootNode.addChildNode(node!);
        
        arrow.position = SCNVector3( 0,0, 0);  //is a child of camera
    //    arrow.eulerAngles = SCNVector3(90,90,0)
        
       rot = 90;
        
        
        self.addBut.setTitle(String(arrow.eulerAngles.y), for: UIControl.State.normal);
        
        pointToNode(node: camera);
        if (rot > 360) {
            rot = 0;
            arrow.eulerAngles.y = 0;
        }
            
    }

    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateQueue.async {
            guard let pointOfView = self.scnView.pointOfView else { return}
            let PointOfViewTransform = pointOfView.transform;
            let orientation = SCNVector3(-PointOfViewTransform.m31, -PointOfViewTransform.m32, -PointOfViewTransform.m33);
            let location = SCNVector3(PointOfViewTransform.m41, PointOfViewTransform.m42, PointOfViewTransform.m43);
            let currentPositionOfCamera = orientation + location;
                

            self.map.enumerateChildNodes { (node, _) in
                if (node.name == "camera") {
                    node.removeFromParentNode();
                }
            }

            self.camera.transform = PointOfViewTransform;
            self.map.addChildNode(self.camera)
            
            
            // Waypoint nav
            if(self.route.count > 1) {
                let first_point_pos = self.waypoint_json.waypoints[self.route[0]].position;
                let sec_point_pos = self.waypoint_json.waypoints[self.route[1]].position;
            
                if (self.distanceBetween(  node :self.camera, json1: sec_point_pos!) < self.distanceBetweenPoints(json1 : first_point_pos!, json2 :sec_point_pos!) || (self.distanceBetween(node : self.camera, json1 : first_point_pos!) < 1.0)) {
                        self.route.remove(at : 0);
                    }
            }
            if(self.route.count > 0) {
                let point_pos = self.waypoint_json.waypoints[self.route[0]].position;
             
                self.map.addChildNode(self.waypoint);

                self.waypoint = self.waypointShowArrowBlue;
                self.waypoint.position = SCNVector3(CGFloat((point_pos!.x as NSString).floatValue), CGFloat((point_pos!.y as NSString).floatValue), CGFloat((point_pos!.z as NSString).floatValue));
              //  waypoint.rotation = SCNVector4( 0.707, 0, 0,0.707);
                self.pointToNode(node : self.waypoint);
            }
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


        // QRAnchor
        let QRAnchor = SCNNode();
        QRAnchor.transform = SCNMatrix4(imageAnchor.transform)
 
        //Plane
        let planeAnchor = SCNNode();
        planeAnchor.position = SCNVector3(0,0,0);
        
        let box = SCNPlane();
        box.width = referenceImage.physicalSize.width;
        box.height = referenceImage.physicalSize.height;
        
        box.firstMaterial?.diffuse.contents = UIColor.red;
        planeAnchor.eulerAngles.x = -.pi / 2
        planeAnchor.geometry = box;
        QRAnchor.addChildNode(planeAnchor);
        
        self.scnView.scene.rootNode.addChildNode(QRAnchor);
        
        
        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
     
            for augImage in self.image_json.augmentedImages {
                if (String(augImage.id) == imageName) {
                    self.Add3DMatterPort(augImage: augImage, QRNode: QRAnchor);
                }
            }
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
        self.map.enumerateChildNodes { (node, _) in
            if (node.name == "waypoint") {
                node.removeFromParentNode();
            }
        }
        
        
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
            pow(Double(node.position.z  )  - (json1.y as NSString).doubleValue, 2 ));
        return dist;
    }
      
    func distanceBetweenPoints( json1 : Position, json2 : Position) -> Double {
        var dist = Double.greatestFiniteMagnitude;
        dist = sqrt(pow((json1.x as NSString).doubleValue - (json2.x as NSString).doubleValue , 2 ) +
                    pow((json1.y as NSString).doubleValue  - (json2.y as NSString).doubleValue   , 2 ))
        return dist;
      }

    func pointToNode(node : SCNNode) {
  /*
        return;
        
        guard let pointOfView = scnView.pointOfView else { return}
        
        for arrownode in pointOfView.childNodes {
           // if (arrownode.name == "arrow") {
                arrownode.removeFromParentNode()
           // }
        }
 */
   /*
        self.scnView.scene.rootNode.enumerateChildNodes { (arrownode, _) in
            if (arrownode.name == "arrow") {
                arrownode.removeFromParentNode();
            }
        }
        
        arrow.position = SCNVector3( 0,0, -1);  //is a child of camera
        
        let desNode = SCNNode()
        let targetPoint = SCNVector3.positionFromTransform(node.simdTransform)
        desNode.worldPosition = targetPoint
        
        let lookAtConstraints = SCNLookAtConstraint(target: desNode)
        lookAtConstraints.isGimbalLockEnabled = true
        
        // Here's the magic
        arrow.pivot = SCNMatrix4Rotate(arrow.pivot, Float.pi, 0, 1, 1)
        
        arrow.constraints = [lookAtConstraints]
        pointOfView.addChildNode(arrow);
        
        
        
        
        */
        
     /*
        let currentPositionOfCamera = getLocation(node: camera)
        let currentPositionOfArrow = getLocation(node: arrow);
        let currentPositionOfNode =   getLocation(node: node);
        
        let start_vec = currentPositionOfCamera - currentPositionOfArrow;
        let end_vec = currentPositionOfCamera - currentPositionOfNode;
        
        node.applyTorque(startLocation: SIMD3<Float>(start_vec.x, start_vec.y, start_vec.z), endLocation: SIMD3<Float>(end_vec.x, end_vec.z, end_vec.y))
 
 */
    /*
        let rotationBy = start_vec - end_vec;
        
        //print("changed \(previousTouch) \(currentTouch)")
        let previousTouch = simd_normalize(start_vec)
        let currentTouch = simd_normalize(end_vec)
        //make sure to normalize axis to make unit quaternion
        let axis = simd_normalize(simd_cross(currentTouch, previousTouch))
        
        // sometimes dot product goes outside the the range of -1 to 1
        // keep it in the range
        let dot = max(min(1, simd_dot(currentTouch, previousTouch)), -1)
        
        let angle = acosf(dot)
        let rotation = simd_quaternion(-angle, axis)
        
        let length = rotation.length
        if !length.isNaN{
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.15
            self.simdOrientation = rotation * self.simdOrientation
            SCNTransaction.commit()
        }
        
        
        
        */
        
        self.camera.enumerateChildNodes { (arrownode, _) in
            if (arrownode.name == "cup") {
                arrownode.removeFromParentNode();
            }
        }
                
        arrow.position = SCNVector3( 0,0, 0.25);  //is a child of camera
        camera.addChildNode(arrow);
        
        let currentPositionOfCamera = getLocation(node: camera)
        let currentPositionOfArrow = getLocation(node: arrow);
        let currentPositionOfNode =   getLocation(node: node);
        
        let start_vec = currentPositionOfCamera - currentPositionOfArrow;
        let end_vec = currentPositionOfCamera - currentPositionOfNode;
        
        let rotationBy = start_vec - end_vec;
        
       
        let arrow_quat = simd_quatf(from: SIMD3<Float>(start_vec.x, start_vec.y, start_vec.z), to: SIMD3<Float>(end_vec.x, end_vec.z, end_vec.y));

        arrow.rotation = arrow_quat.toSCN();// = arrow_quat.toSCN();

  
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

extension SCNNode{
    // the Apple way
    func applyTorque(startLocation: simd_float3, endLocation: simd_float3){
        guard let physicsBody = self.physicsBody else{
            return
        }
        
        let nodeCenterWorld = self.simdConvertPosition(self.simdPosition, to: nil)
        let forceVector = endLocation - startLocation
        let leverArmVector = startLocation - nodeCenterWorld
        let rotationAxis = simd_cross(leverArmVector, forceVector)
        let magnitude = simd_length(rotationAxis)
        // torqueAxis is a unit vector
        var torqueAxis = simd_normalize(rotationAxis)
        if simd_length(torqueAxis).isNaN {
            return
        }
        
        let orientationQuaternion = self.presentation.simdOrientation
        // align torque axis with current orientation
        torqueAxis = orientationQuaternion.act(torqueAxis)
        let torque = SCNVector4(torqueAxis.x, torqueAxis.y, torqueAxis.z, magnitude)
        //print("torque \(torque)")
        physicsBody.applyTorque(torque, asImpulse: true)
    }
}

extension SCNVector3 {
    // from Apples demo APP
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
}
