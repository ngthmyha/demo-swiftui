//
//  SevenSidesScene.swift
//  Animation01
//
//  Created by MacMini4 on 25/03/2024.
//

import SwiftUI
import SpriteKit

class SevenSidesScene: SKScene {
    var wheelBase = SKShapeNode()
    var ballPosition = CGPoint.zero
    var sidePositions = [CGPoint]()
    let spinWheel = SKAction.rotate(byAngle: -CGFloat(GLKMathDegreesToRadians(360/6)),
                                    duration: 0.5)

    override func didMove(to view: SKView) {
        backgroundColor = .black

        wheelBase = SKShapeNode(rectOf: .init(width: size.width * 0.8,
                                              height: size.width * 0.8))
        wheelBase.position = .init(x: size.width / 2, y: size.height / 2)
        wheelBase.strokeColor = .clear
        self.addChild(wheelBase)

        prepWheel()
        ball()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wheelBase.run(spinWheel)
    }

    func prepWheel() {
        for i in 0...5 {
            let trapezoidPath = UIBezierPath()
            trapezoidPath.move(to: CGPoint(x: -(size.width * 0.8) / 4, y: 0))
            trapezoidPath.addLine(to: CGPoint(x: (size.width * 0.8) / 4, y: 0))
            trapezoidPath.addLine(to: CGPoint(x: (size.width * 0.8 - 60) / 4, y: 25))
            trapezoidPath.addLine(to: CGPoint(x: -(size.width * 0.8 - 60) / 4, y: 25))
            trapezoidPath.close()
            let side = SKShapeNode(path: trapezoidPath.cgPath)
            let color = UIColor(ContentView.ColorType.allCases[i].color)
            side.fillColor = color
            side.strokeColor = color
            side.position = convert(CGPoint(x: size.width / 2,
                                            y: size.height * 0.3),
                                    to: wheelBase)
            side.zRotation = -wheelBase.zRotation
            wheelBase.addChild(side)
            wheelBase.zRotation += CGFloat(GLKMathDegreesToRadians(360/6))
        }

        for item in wheelBase.children {
            sidePositions.append(convert(item.position, from: wheelBase))
        }
    }

    func ball() {
        let color = UIColor(ContentView.ColorType.allCases[Int.random(in: 0...5)].color)
        let ball = SKShapeNode(circleOfRadius: 25)
        ball.position = .init(x: size.width / 2, y: size.height / 2)
        ball.zPosition = 10
        ball.fillColor = color
        ball.strokeColor = color
        self.addChild(ball)

        ballPosition = sidePositions[Int.random(in: 0...5)]
        let moveToSide = SKAction.move(to: ballPosition, duration: 2)
        let sequence = SKAction.sequence([moveToSide])
        ball.run(sequence)
    }
}
