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

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var game = GameHelper.sharedInstance
    var scnScene: SCNScene!
    var horizontalCameraNode: SCNNode!
    var verticalCameraNode: SCNNode!
    var ballNode: SCNNode!

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
    }
    
    func setupNodes() {
        scnScene.rootNode.addChildNode(game.hudNode)
        horizontalCameraNode = scnScene.rootNode.childNode(withName: "HorizontalCamera", recursively: true)!
        verticalCameraNode = scnScene.rootNode.childNode(withName: "VerticalCamera", recursively: true)!
        ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively: true)!
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
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        game.updateHUD()
    }
}
