//
//  CaroBoardView.swift
//  Animation01
//
//  Created by MacMini4 on 26/03/2024.
//

import SwiftUI
import SpriteKit

struct CaroBoardView: View {
    var scene: SKScene {
        let scene = CaroBoardScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    CaroBoardView()
}
