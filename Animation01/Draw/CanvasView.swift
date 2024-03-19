//
//  CanvasView.swift
//  Animation01
//
//  Created by MacMini4 on 15/03/2024.
//

import SwiftUI
import SpriteKit

struct CanvasView: View {
    @State var selectedIndex: Int = -1
    @State var offset: [CGFloat] = [63, 260]
    @State var scale: CGFloat = 1
    @State var offsetY: CGFloat = -130
    @State var color: Color = .green
    @State var animate = false
    @State var rotation: Double = 0
    @State private var isSpinning = false
    @State private var isLaunch = true
    var colors: [Color] = [.red, .green, .blue]

    var body: some View {
        ZStack {
            canvaView
        }
    }

    private var canvaView: some View {
        if #available(iOS 15.0, *) {
            return VStack {
                ZStack {
                    TimelineView(.animation(minimumInterval: 6, paused: false)) { time in
                        Canvas { context, size in
                            context.addFilter(.alphaThreshold(min: 0.3, color: Color(
                                red: 0.5,
                                green: 0.7,
                                blue: 1
                            )))
                            context.addFilter(.blur(radius: 15))
                            
                            context.drawLayer { layer in
                                for id in 0...200 {
                                    if let resolvedSymbol = layer.resolveSymbol(id: id) {
                                        layer.draw(resolvedSymbol, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                    }
                                }
                            }
                        } symbols: {
                            ForEach(0...200, id: \.self) { id in
                                let offsetV = animate ? CGSize(width: .random(in: -240...240), height: .random(in: -500...500)) : .zero
                                Circle()
                                    .fill(Color(
                                        red: .random(in: 0.5...1),
                                        green: .random(in: 0.7...1),
                                        blue: .random(in: 0.6...1)
                                    ))
                                    .frame(width: 30, height: 30)
                                    .offset(offsetV)
                                    .animation(.easeInOut(duration: 20), value: offsetV)
                                    .tag(id)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .task {
                        animate = true
                    }
                }
                .onAppear {
                    isSpinning.toggle()
                }
            }
        } else {
            return Text("")
        }
    }

    private func cirleLine(index: Int) -> some View {
        ZStack {
            Circle() // MARK: Nine. 0.8 delay
                .stroke(lineWidth: 5)
                .foregroundColor(Color(
                    red: 1 - Double(index) * 0.04,
                    green: 1 - Double(index) * 0.04,
                    blue: 1 - Double(index) * 0.01
                ))
            ForEach(0 ..< 4) {
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundColor(Color(
                        red: 0.9,
                        green: 0.4,
                        blue: 0.05
                    ))
                    .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                    .offset(y: CGFloat(15 * index * (-1)))
                    .rotationEffect(.degrees(Double($0) * -90))
                    .rotationEffect(.degrees(isSpinning ? 0 : -180))
                    .frame(width: CGFloat(index / 2 * 3), height: CGFloat(index + 3))
                    .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(Double(index) * 0.1), value: isSpinning)
            }
        }
        .frame(width: CGFloat(30 * index), height: CGFloat(30 * index))
        .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
        .offset(y: CGFloat(index * 40))
    }
}



// MARK: - Preview

#Preview {
    CanvasView()
}
