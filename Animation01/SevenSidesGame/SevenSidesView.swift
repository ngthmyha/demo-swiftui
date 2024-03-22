//
//  SevenSidesView.swift
//  Animation01
//
//  Created by MacMini4 on 25/03/2024.
//

import SwiftUI
import SpriteKit

struct SevenSidesView: View {
    var scene: SKScene {
        let scene = SevenSidesScene()
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    SevenSidesView()
}
