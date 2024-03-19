//
//  BackgroundScene.swift
//  Animation
//
//  Created by MacMini4 on 14/03/2024.
//

import UIKit
import SpriteKit

class BackgroundScene: SKScene {
    let snowEmitterNode = SKEmitterNode(fileNamed: "Background.sks")

    override func didMove(to view: SKView) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        addChild(snowEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        snowEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
}
