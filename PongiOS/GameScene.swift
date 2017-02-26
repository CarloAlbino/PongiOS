//
//  GameScene.swift
//  PongiOS
//
//  Created by Carlo Albino on 2017-02-26.
//  Copyright © 2017 Carlo Albino. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var playerPaddle = SKSpriteNode()
    var enemyPaddle = SKSpriteNode()
    var ball = SKSpriteNode()
    
    var ballPower : Int = 20
    
    var isTouching = false
    
    override func didMove(to view: SKView) {
        playerPaddle = self.childNode(withName: "playerPaddle") as! SKSpriteNode
        enemyPaddle = self.childNode(withName: "enemyPaddle") as! SKSpriteNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        ball.physicsBody?.applyImpulse(CGVector(dx: -ballPower, dy: -ballPower))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0;
        border.restitution = 1;
        
        self.physicsBody = border
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            playerPaddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
            isTouching = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            
            playerPaddle.run(SKAction.moveTo(x: location.x, duration: 0.05))
            
            isTouching = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
    }

    override func update(_ currentTime: TimeInterval) {
        enemyPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.05))
        
        if(isTouching == false)
        {
            playerPaddle.run(SKAction.moveTo(x: ball.position.x, duration: 0.05))
        }
        
        // How to detect collisions on specific objects?
        for node in (ball.physicsBody?.allContactedBodies())!
        {
            if(node.self == playerPaddle || node.self == enemyPaddle || node.self == self)
            {
                let randomDir = CGFloat(arc4random_uniform(10)) - 5
                
                let dirMagnitude : Float = sqrt(pow(Float((ball.physicsBody?.velocity.dx)!), 2) + pow(Float((ball.physicsBody?.velocity.dy)!), 2))
                let x : Float = Float((ball.physicsBody?.velocity.dx)!)
                let y : Float = Float((ball.physicsBody?.velocity.dy)!)
                
                let dir : CGVector = CGVector(dx: CGFloat((x / dirMagnitude) * Float(ballPower)), dy: CGFloat((y / dirMagnitude) * Float(ballPower)))
                
                ball.physicsBody?.applyImpulse(CGVector(dx: dir.dx + randomDir, dy: dir.dy + randomDir))
            }
        }
    }
}
