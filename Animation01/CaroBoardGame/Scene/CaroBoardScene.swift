//
//  CaroBoardScene.swift
//  Animation01
//
//  Created by MacMini4 on 26/03/2024.
//

import SpriteKit

class CaroBoardScene: SKScene {
    
    let gridSize: Int = 8
    var tileSize: CGFloat = 40.0
    var tiles: [[SKShapeNode]] = []
    var focusedNode: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        tileSize = size.width / 8
        setupBoard()
    }
    
    func setupBoard() {
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                let texture = SKTexture(imageNamed: "square")
                let block = SKSpriteNode(texture: texture, size: .init(width: tileSize, height: tileSize))
                block.position.x = block.frame.width/2 + tileSize*CGFloat(j)
                block.position.y = block.frame.height/2 + tileSize*CGFloat(i)
                block.zPosition = 1
                addChild(block)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)

        for case let block as SKSpriteNode in self.nodes(at: touchLocation) {
            block.setScale(1.2)
        }
    }
}
