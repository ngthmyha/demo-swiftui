//
//  GameScene.swift
//  Game
//
//  Created by MacMini4 on 13/03/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var player = SKSpriteNode(imageNamed: "spaceship")
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .red
        player.size = CGSize(width: 100, height: 100)
        player.position = CGPoint(x: self.size.width / 2, y: 100)
        self.addChild(player)
        let _ = Timer.scheduledTimer(
            timeInterval: 0.2, target: self, selector: #selector(fireBullet),
            userInfo: nil, repeats: true)
        let _ = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(spawnEnemy),
            userInfo: nil, repeats: true)
    }

    @objc
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: 40, height: 40)
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height / 2)
        self.addChild(bullet)

        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }

    @objc
    func spawnEnemy() {
        let rangeX: Range<CGFloat> = .init(uncheckedBounds: (0, self.size.width))
        let startPoint = CGPoint(x: .random(in: rangeX), y: self.size.height * 1.2)
        let endPoint = CGPoint(x: .random(in: rangeX), y: -self.size.height * 0.2)
        let enemy = SKSpriteNode(imageNamed: "startup")
        enemy.size = CGSize(width: 40, height: 40)
        enemy.position = startPoint
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        enemy.zRotation = atan2(dx, dy)
        self.addChild(enemy)

        let moveStartupY = SKAction.move(to: endPoint, duration: 2.5)
        let deleteStartup = SKAction.removeFromParent()
        let startupSequence = SKAction.sequence([moveStartupY, deleteStartup])
        enemy.run(startupSequence)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            if pointOfTouch.y < player.position.y + player.size.height / 2
                && player.position.x + amountDragged - player.size.width / 2 > 0
                && player.position.x + amountDragged + player.size.width / 2 < self.size.width {
                player.position.x += amountDragged
            }
        }
    }
}

