//
//  GameScene.swift
//  Whack a Mole
//
//  Created by Colin Whiteford on 9/17/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    let zombieScale = 0.6
    var zombieVelocity: CGPoint = CGPoint.zero
    var zombieSpeed: CGFloat = 480
    
    func spawnEnemy()
    {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.setScale(zombieScale)
        enemy.position = CGPoint(x: size.width / 2 + enemy.size.width/2, y:0)
        addChild(enemy)
        let actionMove = SKAction.moveTo(x: -size.width/2 - enemy.size.width/2, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([actionMove, actionRemove])
        enemy.run(enemySequence)
    }
    
    
    //Awake
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        zombie.position = CGPoint(x: -size.width / 4, y: -size.height / 4)
        zombie.setScale(zombieScale)
        addChild(zombie)
        let wait = SKAction.wait(forDuration: 2.0)
        let spawnEnemyAction = SKAction.run {
            [weak self] in self?.spawnEnemy()
        }
        let spawnEnemySequence = SKAction.sequence([spawnEnemyAction, wait])
        let keepRespawningEnemy = SKAction.repeatForever(spawnEnemySequence)
        run(keepRespawningEnemy)
    
    }
    //Update
    override func update(_ currentTime: TimeInterval)
    {
        if lastUpdateTime > 0
        {
            deltaTime = currentTime - lastUpdateTime
        }
        else
        {
            deltaTime = 0
        }
        lastUpdateTime = currentTime
        Move(sprite: zombie, velocity: zombieVelocity)
    }
    func DetermineVelocity(location: CGPoint)
    {
        let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
        let length = sqrt(offset.x * offset.x + offset.y * offset.y)
        if length > 0
        {
            let direction = CGPoint(x: offset.x / length, y: offset.y / length)
            zombieVelocity = CGPoint(x: direction.x * zombieSpeed, y: direction.y * zombieSpeed)
        }
    }
    func Move( sprite: SKSpriteNode, velocity: CGPoint)
    {
        let amountToMove = CGPoint(x: velocity.x * deltaTime, y: velocity.y * deltaTime)
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else{return}
        let touchLocation = touch.location(in: self)
        DetermineVelocity(location: touchLocation)
    }
    //Move Finger
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else{return}
        let touchLocation = touch.location(in: self)
        DetermineVelocity(location: touchLocation)
    }
}
