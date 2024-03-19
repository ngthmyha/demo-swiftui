//
//  DrawCatView.swift
//  Animation01
//
//  Created by MacMini4 on 15/03/2024.
//

import SwiftUI

struct DrawCatView: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            // đi từ phần đuôi
            path.move(to: CGPoint(x: rect.midX - 20, y: 250))
            path.addQuadCurve(to: CGPoint(x: rect.midX - 100, y: 140), control: CGPoint(x: rect.midX - 110, y: 250))
            path.addQuadCurve(to: CGPoint(x: rect.midX - 85, y: 140), control: CGPoint(x: rect.midX - 93, y: 130))
            path.addQuadCurve(to: CGPoint(x: rect.midX - 85, y: 180), control: CGPoint(x: rect.midX - 86, y: 180))
            path.addQuadCurve(to: CGPoint(x: rect.midX - 50, y: 226), control: CGPoint(x: rect.midX - 74, y: 230))
            // vẽ thẳng lên trên cổ
            path.addCurve(to: CGPoint(x: rect.midX, y: 80),
                          control1: CGPoint(x: rect.midX - 60, y: 160),
                          control2: CGPoint(x: rect.midX + 10, y: 95))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: 50), control: CGPoint(x: rect.midX - 10, y: 65))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: 20), control: CGPoint(x: rect.midX + 2, y: 30))
            path.move(to: CGPoint(x: rect.midX, y: 20))
            path.addQuadCurve(to: CGPoint(x: rect.midX + 27, y: 40), control: CGPoint(x: rect.midX + 15, y: 24))
            path.move(to: CGPoint(x: rect.midX + 24, y: 30))
            path.addQuadCurve(to: CGPoint(x: rect.midX + 29, y: 24), control: CGPoint(x: rect.midX + 25, y: 30))
            path.addQuadCurve(to: CGPoint(x: rect.midX + 42, y: 39), control: CGPoint(x: rect.midX + 37, y: 30))

            path.addRoundedRect(in: CGRect(x: rect.midX + 35, y: 59, width: 4, height: 8), cornerSize: CGSize(width: 4, height: 8))
            path.move(to: CGPoint(x: rect.midX + 30, y: 40))
            path.addCurve(to: CGPoint(x: rect.midX + 65, y: 70),
                          control1: CGPoint(x: rect.midX + 60, y: 44),
                          control2: CGPoint(x: rect.midX + 51, y: 66))
            path.move(to: CGPoint(x: rect.midX + 65, y: 80))
            path.addQuadCurve(to: CGPoint(x: rect.midX + 30, y: 100), control: CGPoint(x: rect.midX + 65, y: 95))
            path.addQuadCurve(to: CGPoint(x: rect.midX + 45, y: 250), control: CGPoint(x: rect.midX + 50, y: 200))
            path.move(to: CGPoint(x: rect.midX + 24, y: 200))
            path.addQuadCurve(to: CGPoint(x: rect.midX + 28, y: 250), control: CGPoint(x: rect.midX + 25, y: 210))
            path.move(to: CGPoint(x: rect.midX, y: 160))
            path.addQuadCurve(to: CGPoint(x: rect.midX + 10, y: 250), control: CGPoint(x: rect.midX - 10, y: 190))
        }
    }
}

#Preview {
    DrawCatView()
}
