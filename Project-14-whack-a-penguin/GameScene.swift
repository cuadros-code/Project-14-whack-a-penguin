//
//  GameScene.swift
//  Project-14-whack-a-penguin
//
//  Created by Kevin Cuadros on 14/09/24.
//

import SpriteKit

class GameScene: SKScene {
    
    var popupTime = 0.85
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var numRounds = 0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 385)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 15)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 46
        addChild(gameScore)
        
        // CREATE SLOTS
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        // CALL CREATE ENEMY AFTER 1 SECOND
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            
            // GET PARENT FROM PINGUIN TO KNOW IS GOOD - BAD ENEMY
            guard let whackSlot = node.parent?.parent as? WhackSlot else { return }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            
            if let smokeParticle = SKEmitterNode(fileNamed: "hitPinguin"){
                smokeParticle.position = location
                addChild(smokeParticle)
            }
            
            if node.name == "charFriend" {
                whackSlot.hit()
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
            } else if node.name == "charEnemy" {
                whackSlot.hit()
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    // CREATE SLOT WITH POSITION
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy(){
        
        numRounds += 1
        
        if numRounds > 30 {
            for slot in slots {
                slot.hide()
            }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            let gameScore = SKLabelNode(fontNamed: "Chalkduster")
            gameScore.text = "Score: \(score)"
            gameScore.position = CGPoint(x: 512, y: 310)
            gameScore.fontSize = 36
            gameScore.zPosition = 1
            addChild(gameScore)
            
            return
        }
        
        // REDUCE TIME TO MAKE SPEED GAME
        popupTime *= 0.991
        
        // SHUFFLE SLOTS
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        // SHOW RANDOM PINGUIN
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        // CALCULATE TIME TO CALL createEnemy() AGAIN
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
        
    }
    
}
