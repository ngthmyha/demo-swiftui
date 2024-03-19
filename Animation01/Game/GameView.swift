//
//  GameView.swift
//  Animation01
//
//  Created by MacMini4 on 14/03/2024.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
