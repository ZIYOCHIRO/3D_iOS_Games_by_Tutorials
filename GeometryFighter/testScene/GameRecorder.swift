//
//  GameRecorder.swift
//  testScene
//
//  Created by ruixinyi on 2020/1/14.
//  Copyright © 2020 ruixinyi. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

public enum GameStateType {
    case playing
    case tapToPlay
    case gameOver
}

class GameRecorder {
    var score: Int
    var highScore: Int
    var lastScore: Int
    var lives: Int
    var state: GameStateType = GameStateType.tapToPlay
    
    var hudNode: SCNNode!
    var labelNode: SKLabelNode!
    
    static let sharedInstance = GameRecorder()
    
    var sounds: [String: SCNAudioSource] = [:]
    
    fileprivate init() {
        score = 0
        lastScore = 0
        highScore = 0
        lives = 3
        score = UserDefaults.standard.integer(forKey: "lastScore")
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        initHUD()
    }
    
    func initHUD() {
        let skScene = SKScene(size: CGSize(width: 500, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.fontSize = 40
        labelNode.position.y = 50
        labelNode.position.x = 250
        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 5, height: 1)
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        
        hudNode = SCNNode(geometry: plane)
        hudNode.name = "HUD"
        hudNode.rotation = SCNVector4(1, 0, 0, 3.14159265)
        
        loadSounds()
    }
    
    func updateHUD() {
        let scoreFormatted = String(score)
        let highScoreFormatted = String(highScore)
        labelNode.text = "❤️\(lives) 😎\(highScoreFormatted) 💥\(scoreFormatted)"
        
    }
    
    func loadSounds() {
        for sound in ["ExplodeBad", "ExplodeGood", "GameOver", "SpawnBad", "SpawnGood"] {
            loadSound(sound, fileNamed: "\(sound).wav")
        }
    }
    
    func loadSound(_ name: String, fileNamed: String) {
        guard let sound = SCNAudioSource(fileNamed: fileNamed) else {
            print("Failed to load sound: \(fileNamed)")
            return
        }
        sound.load()
        sounds[name] = sound
    }
    
    func playSound(_ node: SCNNode, name: String) {
        let sound = sounds[name]
        node.runAction(SCNAction.playAudio(sound!, waitForCompletion: false))
    }
    
    func saveState() {
        lastScore = score
        highScore = max(score, highScore)
        UserDefaults.standard.set(lastScore, forKey: "lastScore")
        UserDefaults.standard.set(highScore, forKey: "highScore")
        UserDefaults.standard.synchronize()
    }
    
    func reSet() {
        score = 0
        lives = 3
    }
    
    func getScoreString(_ length: Int) -> String {
        return String("\(length)")
    }
    
    func shakeNode(_ node: SCNNode) {
        let left = SCNAction.move(by: SCNVector3(-0.2, 0.0, 0.0), duration: 0.05)
        let right = SCNAction.move(by: SCNVector3(0.2, 0.0, 0.0), duration: 0.05)
        let up = SCNAction.move(by: SCNVector3(0.0, 0.0, 0.2), duration: 0.05)
        let down = SCNAction.move(by: SCNVector3(0.0, 0.0, -0.2), duration: 0.05)
        
        node.runAction(SCNAction.sequence([
            left, up, down, right, left, right, down, up, right, down, left, up,
            left, up, down, right, left, right, down, up, right, down, left, up]))
    }
    
}
