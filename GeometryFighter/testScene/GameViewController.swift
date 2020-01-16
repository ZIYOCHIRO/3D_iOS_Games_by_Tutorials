//
//  GameViewController.swift
//  testScene
//
//  Created by ruixinyi on 2020/1/13.
//  Copyright © 2020 ruixinyi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
   
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var spawnTime: TimeInterval = 0
    var game = GameRecorder.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupCamera()
        setupHUD()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = SCNView()
        self.view = scnView
        
        scnView.showsStatistics = true
        //scnView.allowsCameraControl = true // 转换镜头的位置
        scnView.autoenablesDefaultLighting = true
        
        scnView.delegate = self
        scnView.isPlaying = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnScene.background.contents = UIImage(named: "Background_Diffuse")
      
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(0, 5, 10)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        var geometry: SCNGeometry
        
        switch ShapeType.random() {
        case .Box:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        case .Capsule:
            geometry = SCNCapsule(capRadius: 0.2, height: 1.0)
        case .Cone:
            geometry = SCNCone(topRadius: 0.1, bottomRadius: 0.2, height: 1.0)
        case .Cylinder:
            geometry = SCNCylinder(radius: 0.5, height: 1.0)
        case .Pyramid:
            geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        case .Sphere:
            geometry = SCNSphere(radius: 0.5)
        case .Torus:
            geometry = SCNTorus(ringRadius: 0.3, pipeRadius: 0.2)
        case .Tube:
            geometry = SCNTube(innerRadius: 0.2, outerRadius: 0.3, height: 1.0)
        }
    
        let randColor = UIColor.random()
        geometry.materials.first?.diffuse.contents = randColor
        let geometryNode = SCNNode(geometry: geometry)
        // physical body
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        scnScene.rootNode.addChildNode(geometryNode)
        
        // apply force
        let randomX = Float.random(min: -2, max: 2)
        let randomY = Float.random(min: 10, max: 18)
        let force = SCNVector3(x: randomX, y: randomY, z: 0)
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        
        // add trail
        let trailEmitterSystem = createTrail(color: randColor, geometry: geometry)
        geometryNode.addParticleSystem(trailEmitterSystem)
        
        // naming node
        if randColor == UIColor.black {
            geometryNode.name = "BAD"
        } else {
            geometryNode.name = "GOOD"
        }
        
    }
    
    func cleanScene() {
        for node in scnScene.rootNode.childNodes {
            if node.presentation.position.y < -2 {
                node.removeFromParentNode()
            }
        }
    }
    
    func createTrail(color: UIColor, geometry:SCNGeometry) -> SCNParticleSystem{
        let trail = SCNParticleSystem(named: "Trail.scnp", inDirectory: nil)!
        trail.emitterShape = geometry
        trail.particleColor = color
        return trail
    }
    
    func setupHUD() {
        game.hudNode.position = SCNVector3(x: 0.0, y: 10.0, z: 0.0)
        scnScene.rootNode.addChildNode(game.hudNode)
    }
    
    func handleTouchFor(node: SCNNode) {
        if node.name == "GOOD" {
            game.score += 1
            createExplosion(geometry: node.geometry!, position: node.presentation.position, rotation: node.presentation.rotation)
            node.removeFromParentNode()
        } else if node.name == "BAD" {
            game.lives -= 1
             createExplosion(geometry: node.geometry!, position: node.presentation.position, rotation: node.presentation.rotation)
            node.removeFromParentNode()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: scnView)
        let hitResults = scnView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first!
            handleTouchFor(node: result.node)
        }
    }
    
    func createExplosion(geometry: SCNGeometry, position: SCNVector3, rotation: SCNVector4) {
        let explosion = SCNParticleSystem(named: "Explode.scnp", inDirectory: nil)!
        explosion.emitterShape = geometry
        explosion.birthLocation = .surface
        let rotationMatrix = SCNMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
        let translationMatrix = SCNMatrix4MakeTranslation(position.x, position.y, position.z)
        let transformMatrix = SCNMatrix4Mult(rotationMatrix, translationMatrix)
        scnScene.addParticleSystem(explosion, transform: transformMatrix)
        
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if time > spawnTime {
            spawnShape()
            spawnTime = time + TimeInterval(exactly: Float.random(min: 0.2, max: 1.5))!
        }
        cleanScene()
        game.updateHUD()
    }
}
