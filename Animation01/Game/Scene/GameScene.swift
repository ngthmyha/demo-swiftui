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
    var score: Int = 0
    var level: Int = 0
    var live: Int = 3
    var bulletNumber: Int = 1
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    let liveLabel = SKLabelNode(fontNamed: "The Bold Font")
    let startLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10 //2
        static let Enemy: UInt32 = 0b100 //4
    }

    enum GameState {
        case preGame, inGame, endGame
    }

    var currentGameState = GameState.preGame
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = .black

        setupView()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            if pointOfTouch.y < player.position.y + player.size.height / 2
                && player.position.x + amountDragged > 0
                && player.position.x + amountDragged < self.size.width {
                player.position.x += amountDragged
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == .preGame {
            currentGameState = .inGame
            self.startLabel.isHidden = true
            let move = SKAction.moveTo(y: 100, duration: 1)
            let level = SKAction.run(startNewLevel)
            let bullet = SKAction.run(startNewBullet)
            let sequence = SKAction.sequence([move, level, bullet])
            player.run(sequence)
        }
    }

    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        guard currentGameState == .inGame else { return }
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        let amountToMove = 200 * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "background", using: { bg, stop in
            bg.position.y -= amountToMove
            if bg.position.y < -self.size.height {
                bg.position.y += self.size.height * 2
            }
        })
    }
}

private extension GameScene {
    func setupView() {
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.size = self.size
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: 0,
                                          y: self.size.height * CGFloat(i))
            background.zPosition = 0
            background.name = "background"
            self.addChild(background)
        }

        player.size = CGSize(width: 100, height: 100)
        player.position = CGPoint(x: self.size.width / 2, y: 100 - self.size.height)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.collisionBitMask = PhysicsCategories.None
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: 20, y: self.size.height - 20)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)

        liveLabel.text = "Life: \(live)"
        liveLabel.fontSize = 20
        liveLabel.fontColor = .white
        liveLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        liveLabel.position = CGPoint(x: self.size.width - 100, y: self.size.height - 20)
        liveLabel.zPosition = 100
        self.addChild(liveLabel)

        startLabel.text = "TAP TO START"
        startLabel.fontSize = 40
        startLabel.fontColor = .white
        startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        startLabel.position = CGPoint(x: self.size.width / 2 - startLabel.frame.width / 2, y: self.size.height / 2)
        startLabel.zPosition = 100
        self.addChild(startLabel)
    }

    func fireBullet(_ position: CGPoint) {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.size = CGSize(width: 40, height: 40)
        bullet.position = position
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        bullet.run(bulletSequence, withKey: "bullet")
    }

    func spawnEnemy(_ duration: TimeInterval) {
        let rangeX: Range<CGFloat> = .init(uncheckedBounds: (0, self.size.width))
        let startPoint = CGPoint(x: .random(in: rangeX), y: self.size.height * 1.2)
        let endPoint = CGPoint(x: .random(in: rangeX), y: -self.size.height * 0.2)
        let enemy = SKSpriteNode(imageNamed: "startup")
        enemy.size = CGSize(width: 40, height: 40)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Bullet | PhysicsCategories.Enemy
        self.addChild(enemy)
        
        let moveStartupY = SKAction.move(to: endPoint, duration: duration)
        let deleteStartup = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let startupSequence = SKAction.sequence([moveStartupY, deleteStartup, loseALifeAction])
        enemy.run(startupSequence)

        let dx = endPoint.x - startPoint.x
        let dy = startPoint.y - endPoint.y
        enemy.zRotation = atan2(dx, dy)
    }
    
    func spawnExplosion(position: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "powder")
        explosion.size = CGSize(width: 100, height: 100)
        explosion.position = position
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
    }
    
    func startNewLevel() {
        if self.action(forKey: "spawn") != nil {
            self.removeAction(forKey: "spawn")
        }
        var speed = TimeInterval()
        if level <= 3 {
            speed = 1
        } else if level <= 6 {
            speed = 0.8
        } else {
            speed = 0.3
        }
        let spawn = SKAction.run({
            self.spawnEnemy(speed + 2)
        })
        let waitToSpawn = SKAction.wait(forDuration: speed)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawn")
    }

    func startNewBullet() {
        if self.action(forKey: "bullet") != nil {
            self.removeAction(forKey: "bullet")
        }
        var actions = [SKAction]()
        var speed = TimeInterval()
        if level <= 3 {
            speed = 0.2
            let spawn = SKAction.run({
                self.fireBullet(CGPoint(x: self.player.position.x, y: self.player.position.y + self.player.size.height / 2))
            })
            actions = [spawn]
        } else if level <= 6 {
            speed = 0.18
            let spawn = SKAction.run({
                self.fireBullet(CGPoint(x: self.player.position.x + self.player.size.height / 4, y: self.player.position.y + self.player.size.height / 2))
            })
            let spawn1 = SKAction.run({
                self.fireBullet(CGPoint(x: self.player.position.x - self.player.size.height / 4, y: self.player.position.y + self.player.size.height / 2))
            })
            actions = [spawn, spawn1]
        } else {
            speed = 0.16
            let spawn = SKAction.run({
                self.fireBullet(CGPoint(x: self.player.position.x + self.player.size.height / 4, y: self.player.position.y + self.player.size.height / 2))
            })
            let spawn1 = SKAction.run({
                self.fireBullet(CGPoint(x: self.player.position.x, y: self.player.position.y + self.player.size.height / 2))
            })
            let spawn2 = SKAction.run({
                self.fireBullet(CGPoint(x: self.player.position.x - self.player.size.height / 4, y: self.player.position.y + self.player.size.height / 2))
            })
            actions = [spawn, spawn1, spawn2]
        }
        let waitToSpawn = SKAction.wait(forDuration: speed)
        let spawnSequence = SKAction.sequence(actions + [waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "bullet")
    }

    func loseALife() {
        live -= 1
        liveLabel.text = "Life: \(live >= 0 ? live : 0)"
        if live <= 0 {
            self.removeAction(forKey: "bullet")
            let move = SKAction.run(changeView)
            let waitToMove = SKAction.wait(forDuration: 1)
            let moveSequence = SKAction.sequence([waitToMove, move])
            self.run(moveSequence, withKey: "change")
        }
    }

    func changeView() {
        self.removeAllActions()
        self.removeAllChildren()

        let label = SKLabelNode(fontNamed: "The Bold Font")
        label.text = "Game Over"
        label.fontSize = 60
        label.fontColor = .white
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        label.position = CGPoint(x: self.size.width / 2 - label.frame.width / 2, y: self.size.height / 2 - label.frame.height / 2)
        self.addChild(label)

        let reStart = SKLabelNode(fontNamed: "The Bold Font")
        reStart.text = "ReStart"
        reStart.fontSize = 40
        reStart.fontColor = .white
        reStart.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        reStart.position = CGPoint(x: self.size.width / 2 - reStart.frame.width / 2, y: self.size.height / 2 - reStart.frame.height / 2 - 100)
        self.addChild(reStart)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startGame))
        view?.addGestureRecognizer(tapGesture)
    }

    @objc 
    func startGame() {
        let scene = GameScene(size: self.size)
        scene.scaleMode = self.scaleMode
        self.view?.presentScene(scene)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        let isBodyA = contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        body1 = isBodyA ? contact.bodyA : contact.bodyB
        body2 = isBodyA ? contact.bodyB : contact.bodyA
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            if self.action(forKey: "bullet") != nil {
                spawnExplosion(position: body1.node?.position ?? .zero)
                spawnExplosion(position: body2.node?.position ?? .zero)
                body1.node?.removeFromParent()
                body2.node?.removeFromParent()
                self.removeAction(forKey: "bullet")
                let move = SKAction.run(changeView)
                let waitToMove = SKAction.wait(forDuration: 1)
                let moveSequence = SKAction.sequence([waitToMove, move])
                self.run(moveSequence, withKey: "change")
            }
        } else if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy {
            if let position = body2.node?.position, position.y > 100 {
                spawnExplosion(position: position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            score += 1
            scoreLabel.text = "Score: \(score)"
            if score % 10 == 0 {
                level = score / 10
                startNewLevel()
                startNewBullet()
            }
        }
    }
}

