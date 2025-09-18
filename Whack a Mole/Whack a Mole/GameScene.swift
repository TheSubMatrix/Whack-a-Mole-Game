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
    let moleUpTexture =  SKTexture(imageNamed: "mole-head")
    let moleDownTexture = SKTexture(imageNamed: "mole-hill")
    var moles = Array<Mole>()
    class Mole
    {
        init(emptyHoleTexture: SKTexture, moleTexture: SKTexture, scale: CGFloat, position: CGPoint, scene: SKScene)
        {
            self.emptyHoleTexture = emptyHoleTexture
            self.moleTexture = moleTexture
            self.sprite = SKSpriteNode(texture: emptyHoleTexture)
            self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.sprite.setScale(scale)
            self.sprite.position = position
            scene.addChild(self.sprite)
        }
        var timeSinceLastAction: TimeInterval = 0
        var enemyRoutine: SKAction?
        var sprite: SKSpriteNode
        var emptyHoleTexture: SKTexture
        var moleTexture: SKTexture
        
        func CheckInBounds(position: CGPoint) -> Bool
        {
            if self.sprite.texture != moleTexture{ return false }
            return sprite.frame.contains(position)
        }
        func ShowMole()
        {
            self.sprite.texture = moleTexture
        }
        func HideMole()
        {
            self.sprite.texture = emptyHoleTexture
        }
        func SwapState()
        {
            if self.sprite.texture != moleTexture
            {
                self.sprite.texture = moleTexture
            }
            else
            {
                self.sprite.texture = emptyHoleTexture
            }
        }
    }
    
    
    
    
    //Awake
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black
        for i in 0...2
        {
            for j in 0...2
            {
                moles.append(Mole(emptyHoleTexture: moleDownTexture, moleTexture: moleUpTexture, scale: 0.2, position: CGPoint(x:(0-(1334.0 / 2.0)) + (1334.0 / 4.0) + (Double(i) * (1334.0 / 4.0)), y: (0-(750.0 / 2.0)) + (750.0 / 4.0) + (Double(j) * (750.0 / 4.0))), scene: self))
            }
        }
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
        
        for i in moles
        {
            let time = TimeInterval.random(in: 2...100)
            if i.timeSinceLastAction > time
            {
                i.SwapState()
                i.timeSinceLastAction = 0
            }
            i.timeSinceLastAction += deltaTime
        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else{return}
        let touchLocation = touch.location(in: self)
        for i in moles
        {
            if i.CheckInBounds(position: touchLocation)
            {
                i.HideMole()
                i.timeSinceLastAction = 0
            }
        }
    }
    
}
