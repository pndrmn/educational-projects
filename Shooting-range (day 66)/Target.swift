//
//  Target.swift
//  Project11
//
//  Created by Roman Gorodilov on 12.06.2021.
//

import UIKit
import SpriteKit

class Target: SKNode {
    
    var targetArraySmall = ["duck_outline_target_white.png", "duck_outline_target_brown.png"]
    
    var targetArrayBig = ["target_colored_outline.png", "target_red1_outline.png"]
    
    var goodArray = ["duck_outline_brown.png", "duck_outline_white.png", "duck_outline_yellow.png", ]
    
    var isHit = false
    
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        
        if Int.random(in: 0...1) == 0 {
            charNode = SKSpriteNode(imageNamed: goodArray.randomElement()!)
            charNode.name = "good"
            charNode.zPosition = 0.43
            addChild(charNode)
        } else if Int.random(in: 0...1) == 0 {
            charNode = SKSpriteNode(imageNamed: targetArraySmall.randomElement()!)
            charNode.name = "targetSmall"
            charNode.zPosition = 0.43
            addChild(charNode)
        } else {
            charNode = SKSpriteNode(imageNamed: targetArrayBig.randomElement()!)
            charNode.name = "targetBig"
            charNode.zPosition = 0.43
            addChild(charNode)
        }
        
            charNode.run(SKAction.moveBy(x: 1200, y: 0, duration: 2))
    }
    
    func configureRightToLeft(at position: CGPoint) {
        self.position = position

        if Int.random(in: 0...1) == 0 {
            charNode = SKSpriteNode(imageNamed: goodArray.randomElement()!)
            charNode.name = "good"
            charNode.zPosition = 0.43
            addChild(charNode)
        } else if Int.random(in: 0...1) == 0 {
            charNode = SKSpriteNode(imageNamed: targetArraySmall.randomElement()!)
            charNode.name = "targetSmall"
            charNode.zPosition = 0.43
            addChild(charNode)
        } else {
            charNode = SKSpriteNode(imageNamed: targetArrayBig.randomElement()!)
            charNode.name = "targetBig"
            charNode.zPosition = 0.43
            addChild(charNode)
        }
        
            charNode.run(SKAction.moveBy(x: -1200, y: 0, duration: 4))
    }
}
