//
//  ViewController.swift
//  Argonautica-sky
//
//  Created by Giorgi Butbaia on 10/4/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    private static var DISTANCE: Float = 5.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene

        // Add satellites
        for (key, value) in Satellites.satellites {
            for sat in value {
                N2YOSatellite.getPosition(UInt(sat["norad"] as! Int), 44.7695, 41.6883, 0) {
                    position in
                    let x = ViewController.DISTANCE * cos(position.elevation) * cos(position.azimuth)
                    let y = ViewController.DISTANCE * sin(position.elevation)
                    let z = ViewController.DISTANCE * cos(position.elevation) * sin(position.azimuth)

                    let indicator = self.loadSatellite(key)
                    indicator.position = SCNVector3(x, y, z)
                    print("Added at \(x) \(y) \(z)")
                    self.sceneView.scene.rootNode.addChildNode(indicator)
                }
            }
        }
    }
    
    func loadSatellite(_ model: String) -> SCNNode {
        // Initialize geometry
        let scene = SCNScene(named: "\(model).dae", inDirectory: "Models.scnassets/\(model)")!
        let wrapper = SCNNode()
        for node in scene.rootNode.childNodes {
            node.geometry?.firstMaterial?.lightingModel = .constant
            node.movabilityHint = .movable
            wrapper.addChildNode(node)
        }

        let bbox = wrapper.boundingBox
        let scale = 0.2 / SCNVector3.norm(bbox.max - bbox.min)
        wrapper.position = -scale * (bbox.max + bbox.min)/2.0
        wrapper.scale = scale * SCNVector3(1, 1, 1)
        
        return wrapper
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
