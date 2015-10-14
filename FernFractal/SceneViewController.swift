//
//  ViewController.swift
//  FernFractal
//
//  Created by Rodrigo Leite on 1/4/15.
//  Copyright (c) 2015 Rodrigo Leite. All rights reserved.
//

import UIKit
import SceneKit
import QuartzCore

struct Point {
    var x: Double
    var y: Double
}

class SceneViewController: UIViewController, SCNSceneRendererDelegate {

// MARK: ATTRIBUTES
    
    let scene = SCNScene()
    let spheret = SCNSphere(radius: 0.03)
    var point = Point(x: 0.0, y: 0.0)
    var baseColor = UIColor()
    
// MARK: VC METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Scene
        let scnView = self.view as! SCNView
        scnView.scene = self.scene
        scnView.allowsCameraControl = true
        //scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.blackColor()
        scnView.delegate = self;
        
        // Create Camera
        let cameraNode = makeCamera()
        self.scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 20)
        
        // create and add a light to the scene
        let lightNode = makeLight(SCNLightTypeOmni, color: UIColor.whiteColor())
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        self.scene.rootNode.addChildNode(lightNode)

        // create and add an ambient light to the scene
        let ambientLightNode = makeLight(SCNLightTypeAmbient, color: UIColor.whiteColor())
        self.scene.rootNode.addChildNode(ambientLightNode)
  
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
          
            self.fractal(10000)

        }
        
    }
 
// MARK: FERN
    
    
    func fern(){
        
        let probability = arc4random_uniform(100)
        let tempPoint = self.point
        
        
        switch probability{
        case 0 :
            self.point.x = 0.0
            self.point.y = 0.16 * tempPoint.y
            self.baseColor = UIColor(red: 0.0, green: 0.0, blue: 0.8, alpha: 1.0)
        case 1...6 :
            self.point.x = 0.2 * tempPoint.x - 0.26 * tempPoint.y
            self.point.y = 0.23 * tempPoint.x + 0.22 * tempPoint.y + 1.6
            self.baseColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
        case 7...14 :
            self.point.x = -0.15 * tempPoint.x + 0.28 * tempPoint.y
            self.point.y =  0.26 * tempPoint.x + 0.24 * tempPoint.y + 0.44
            self.baseColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case 15...99 :
            self.point.x =  0.85 * tempPoint.x + 0.04 * tempPoint.y
            self.point.y = -0.04 * tempPoint.x + 0.85 * tempPoint.y + 1.6
            self.baseColor = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0)
        default:
            print("This line will never be executed, if it happends, arc4random don't work in the right way 😰")
        }
    }
    

    func fractal( points: Int ) {
        print("fractal starting")
        for _ in 0..<points{
            fern()
            let sphereGeometry: SCNGeometry = self.spheret.copy() as! SCNGeometry
            let material = makeColorMaterial(self.baseColor)
            sphereGeometry.materials = [material]
            
            let sphereNode = SCNNode(geometry: sphereGeometry)
            let x = Float(arc4random_uniform(40)) - 20.0
            let y = Float(arc4random_uniform(40)) - 20.0
            
            let initialPosition = SCNVector3(x: x, y: y, z: 5.0)
            let lastPosition    = SCNVector3(x: Float(self.point.x), y: Float(self.point.y), z: 0.0)
            sphereNode.position = initialPosition
            sphereNode.runAction(SCNAction.moveTo(lastPosition, duration: 0.5))
            self.scene.rootNode.addChildNode(sphereNode)
        }
        
    }
  

    
// MARK: BASIC CONFIGURATION OF SCENE
    
    
    func makeCamera() -> SCNNode{
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 1500.0
        cameraNode.camera?.zNear = 1.0
        return cameraNode
    }
    
    func makeLight(type: String, color: UIColor) -> SCNNode{
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = type
        lightNode.light!.color = color
        return lightNode
    }
    
    func makeColorMaterial(color: UIColor) -> SCNMaterial{
        let material: SCNMaterial = SCNMaterial()
        material.diffuse.contents = color
        material.specular.contents = color
        return material
    }

}

