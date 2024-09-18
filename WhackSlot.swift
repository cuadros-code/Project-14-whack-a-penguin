//
//  WhackSlot.swift
//  Project-14-whack-a-penguin
//
//  Created by Kevin Cuadros on 14/09/24.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    // CONFIGURE SLOT AND ADD MASK TO HIDDEN PINGUIN
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    // MOVE PINGUIN OVER MASK TO SHOW
    func show(hideTime: Double){
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.09))
        isVisible = true
        isHit = false
        
        // RANDOM GOOD - BAD PINGUIN
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        if let particle = SKEmitterNode(fileNamed: "pinguin"){
            particle.position = charNode.position
            addChild(particle)
        }
        
        // HIDE PINGUIN AFTER TIME
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    // HIDE PINGUIN
    func hide() {
        if !isVisible { return }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    // CREATE SEQUENCE WHEN PINGUIN IS TAPPED
    func hit(){
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false
        }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
        
    }

}
