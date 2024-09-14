//
//  WhackSlot.swift
//  Project-14-whack-a-penguin
//
//  Created by Kevin Cuadros on 14/09/24.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }

}
