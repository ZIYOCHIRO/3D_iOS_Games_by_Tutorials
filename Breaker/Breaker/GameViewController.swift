//
//  GameViewController.swift
//  Breaker
//
//  Created by ruixinyi on 2020/1/16.
//  Copyright © 2020 ruixinyi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SceneKit

enum ColliderType: Int {
    case Ball = 0b1
    case Barrider = 0b10
    case Brick = 0b100
    case Paddle = 0b1000
}

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var game = GameHelper.sharedInstance
    var scnScene: SCNScene!
    var horizontalCameraNode: SCNNode!
    var verticalCameraNode: SCNNode!
    var ballNode: SCNNode!
    var paddleNode: SCNNode!
    var lastContactNode: SCNNode!
    var touchX: CGFloat = 0
    var paddleX: Float = 0
    var floorNode: SCNNode!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    func setupScene() {
        scnView = SCNView()
        self.view = scnView
        //scnView.allowsCameraControl = true
        scnView.delegate = self
        
        scnScene = SCNScene(named: "Game.scn")
        scnView.scene = scnScene
        scnScene.physicsWorld.contactDelegate = self
    }
    
    func setupNodes() {
        scnScene.rootNode.addChildNode(game.hudNode)
        horizontalCameraNode = scnScene.rootNode.childNode(withName: "HorizontalCamera", recursively: true)!
        verticalCameraNode = scnScene.rootNode.childNode(withName: "VerticalCamera", recursively: true)!
        ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively: true)!
        
        ballNode.physicsBody?.contactTestBitMask = ColliderType.Barrider.rawValue | ColliderType.Brick.rawValue | ColliderType.Paddle.rawValue
        
        floorNode = scnScene.rootNode.childNode(withName: "Floor", recursively: true)!
        verticalCameraNode.constraints = [SCNLookAtConstraint(target: floorNode)]
        horizontalCameraNode.constraints = [SCNLookAtConstraint(target: floorNode)]
    }
    
    func setupSounds() {
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let deviceOrientation = UIDevice.current.orientation
        switch (deviceOrientation){
        case .portrait:
            scnView.pointOfView = verticalCameraNode
        default:
            scnView.pointOfView = horizontalCameraNode
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: scnView)
            touchX = location.x
            paddleX = paddleNode.position.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: scnView)
            paddleNode.position.x = paddleX + Float((location.x - touchX) * 0.1)
            
            if paddleNode.position.x > 4.5 {
                paddleNode.position.x = 4.5
            } else if paddleNode.position.x < -4.5 {
                paddleNode.position.x = -4.5
            }
        }
        
        verticalCameraNode.position.x = paddleNode.position.x
        horizontalCameraNode.position.x = paddleNode.position.x
        
    }
}

extension GameViewController: SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    // SCNSceneRendererDelegate
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        game.updateHUD()
    }
    
    // SCNPhysicisContactDelegate
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode: SCNNode!
        
        if contact.nodeA.name == "Ball" {
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        if lastContactNode != nil && lastContactNode == contactNode {
            return
        }
        
        lastContactNode = contactNode
        
        // 1
        if contactNode.physicsBody?.categoryBitMask == ColliderType.Barrider.rawValue {
            if contactNode.name == "Bottom"{
                game.lives -= 1
                if game.lives == 0 {
                    game.saveState()
                    game.reset()
                }
            }
        }
        
        // 2
        if contactNode.physicsBody?.categoryBitMask == ColliderType.Brick.rawValue {
            game.score += 1
            contactNode.isHidden = true
            contactNode.runAction(SCNAction.wait(duration: 120)) {
                contactNode.isHidden = false
            }

        }
        
        // 3
//        if contactNode.physicsBody?.categoryBitMask == ColliderType.Paddle.rawValue {
//            if contactNode.name == "Left" {
//                ballNode.physicsBody!.velocity.xzAngle -= convertToRadius(20) }
//            if contactNode.name == "Right" {
//                ballNode.physicsBody!.velocity.xzAngle += convertToRadians(20) }
//        }
//        // 4
//        ballNode.physicsBody?.velocity.length = 5.0
        
    }
    
    func convertToRadius(_ n: CGFloat) -> CGFloat {
        return n * .pi / 180
    }
    
    
    
    
}
