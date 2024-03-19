//
//  CardView.swift
//  Animation
//
//  Created by MacMini4 on 14/03/2024.
//

import SwiftUI
import Combine
import SpriteKit

struct CardView: View {
    @GestureState var dragState = DragState.inactive
    @State var offsetY: CGFloat = -130
    @State var color: Color = Color(red: 0.5, green: 0.7, blue: 1)
    @State var rotation: Double = 0
    @State var trimTo: Double = 0.01
    @State var rolation: Double = 0

    var body: some View {
        let dragGester = DragGesture()
            .updating($dragState) { (value, state, transaction) in
                state = .dragging(translation: value.translation)
            }
        return ZStack {
            Rectangle()
                .fill(Color(red: 68 / 255, green: 41 / 255, blue: 182 / 255))
            .frame(height: 230)
            .cornerRadius(10)
            .padding(16)
            .rotation3DEffect(Angle(degrees: dragState.isActive ? 0 : 60), axis: (x: 10.0, y: 10.0, z: 10.0))
            .blendMode(.hardLight)
            .padding(dragState.isActive ?  32 : 64)
            .padding(.bottom, dragState.isActive ? 32 : 64)
            .animation(.spring, value: dragState.isActive)
            ZStack {
                Rectangle()
                    .fill(Color(red: 68 / 255, green: 41 / 255, blue: 182 / 255))
                animationLoading1
            }
            .frame(height: 230)
            .cornerRadius(10)
            .padding(16)
            .rotation3DEffect(Angle(degrees: dragState.isActive ? 0 : 30), axis: (x: 10.0, y: 10.0, z: 10.0))
            .blendMode(.hardLight)
            .padding(dragState.isActive ?  16 : 32)
            .padding(.bottom, dragState.isActive ? 0 : 32)
            .animation(.spring, value: dragState.isActive)
            ZStack {
                Rectangle()
                    .fill(Color.black)
                pointChange
            }
            .frame(height: 230)
            .cornerRadius(10)
            .padding(16)
            .offset(
                x: dragState.translation.width,
                y: dragState.translation.height - 120
            )
            .rotationEffect(Angle(degrees: Double(dragState.translation.width / 10)))
            .shadow(radius: dragState.isActive ? 8 : 0)
            .gesture(dragGester)
            .animation(.spring, value: dragState.isActive)
            ZStack {
                Rectangle()
                    .fill(Color.black)
                animationLoading2
            }
            .frame(height: 230)
            .cornerRadius(10)
            .padding(16)
            .offset(
                x: dragState.translation.width,
                y: dragState.translation.height + 120
            )
            .rotationEffect(Angle(degrees: -Double(dragState.translation.width / 10)))
            .shadow(radius: dragState.isActive ? 8 : 0)
            .gesture(dragGester)
            .animation(.spring, value: dragState.isActive)
        }
        .frame(alignment: .top)
        .background(.clear)
        .ignoresSafeArea()
    }

    private var pointChange: some View {
        ZStack {
            ZStack {
                ForEach(0..<20, id: \.self) { i in
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 20, height: 20)
                        .offset(y: offsetY)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5 * Double(i)), value: offsetY)
                        .rotationEffect(.degrees((360 / 20) * Double(i)))
                }
                ForEach(0..<20, id: \.self) { i in
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 5, height: 5)
                        .offset(y: offsetY + 60)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.5 * Double(i)), value: offsetY)
                        .rotationEffect(.degrees((360 / 20) * Double(i)))
                }
            }
            .rotationEffect(.degrees(rotation))
            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: false), value: rotation)
        }
        .onAppear {
            offsetY += 30
            rotation = 360
        }
    }

    private var animationLoading1: some View {
        ZStack {
            ForEach(0..<200, id: \.self) { i in
                Circle()
                    .foregroundColor(color)
                    .animation(.linear(duration: 3).repeatForever(autoreverses: true), value: color)
                    .frame(width: 15, height: 15)
                    .offset(y: -(200 / Double(100) * Double(i)))
                    .rotationEffect(.degrees(4000 / Double(200) * Double(i)))
                    .rotationEffect(.degrees(rotation))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: rotation)
                    .scaleEffect(Double(i) / 100)
            }
        }
        .onAppear {
            color = .pink
            rotation = -360
        }
    }

    private var animationLoading2: some View {
        ZStack {
            ForEach(0...5, id: \.self) { i in
                ZStack {
                    ForEach(0...6, id: \.self) { index in
                        Circle()
                            .trim(from: 0, to: trimTo)
                            .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: trimTo)
                            .rotationEffect(.degrees(rolation))
                            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: rolation)
                            .rotationEffect(.degrees((-72 / 6) * Double(index)))
                            .frame(width: (200 + 15 * 6) / 6 * Double(index), height: (200 + 15 * 6) / 6 * Double(index))
                    }
                }
                .rotationEffect(.degrees(72 * Double(i)))
            }
        }
        .onAppear {
            trimTo = 0.281
            rolation = 360
        }
    }
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
}

#Preview {
    CardView()
}
