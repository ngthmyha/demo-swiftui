//
//  ContentView.swift
//  Animation01
//
//  Created by MacMini4 on 14/03/2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var selectedColor: Color?
    @Namespace private var nameSpace
    @State var rotation: Angle = .zero
    @State var color = Color.red
    
    @State var colors = ColorType.allCases.map(\.color)
    var colors2: [Color] = ColorType.allCases.map(\.color)
    var scene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: scene, options: [.allowsTransparency])
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(colors2, id:\.self) { color in
                                itemButton2(color: color, title: "item \(color)", destination: ColorType.allCases.first(where: { $0.color == color })?.view())
                            }
                        }
                        .padding(16)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 50)
                    .frame(maxHeight: 200)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(colors, id:\.self) { color in
                                itemButton(color: color, title: "item \(color)")
                                    .onDrag({
                                        self.selectedColor = color
                                        return NSItemProvider()
                                    })
                                    .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: color, list: $colors, draggedItem: $selectedColor))
                            }
                        }
                        .padding(16)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                .frame(height: nil)
            }
        }
    }
    
    @ViewBuilder
    private func itemButton(color: Color,title: String) -> some View {
        DragCellView(color: color, title: title, rotation: $rotation)
    }
    
    @ViewBuilder
    private func itemButton2<Destination: View>(color: Color,title: String, height: CGFloat = 100, destination: Destination) -> some View {
        NavigationLink(destination: {
            destination
        }, label: {
            ZStack {
                Rectangle()
                    .frame(width: height == 100 ? 130 : nil, height: height)
                    .foregroundStyle(color)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                Text(title)
                    .foregroundStyle(Color.white)
            }
        })
    }
}

extension ContentView {
    enum ColorType: Int, CaseIterable {
        case blue, green, orange, red, gray, pink, yellow

        var color: Color {
            switch self {
            case .blue:
                return .blue
            case .green:
                return .green
            case .orange:
                return .orange
            case .red:
                return .red
            case .gray:
                return .gray
            case .pink:
                return .pink
            case .yellow:
                return .yellow
            }
        }

        func view() -> some View {
            switch self {
            case .blue:
                return AnyView(StoryView())
            case .green:
                return AnyView(CardView())
            case .orange:
                return AnyView(CanvasView())
            case .red:
                return AnyView(SevenSidesView())
            case .yellow:
                return AnyView(CaroBoardView())
            default:
                return AnyView(GameView())
            }
        }
    }
}

struct DragCellView: View {
    @Namespace private var namespace
    @State private var show = false
    var color: Color
    var title: String
    @Binding var rotation: Angle

    var body: some View {
        ZStack {
            if !show {
                ZStack {
                    Rectangle()
                        .frame(height: 100)
                        .foregroundStyle(color)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .matchedGeometryEffect(id: "view", in: namespace)
                    Text(title)
                        .foregroundStyle(Color.white)
                        .matchedGeometryEffect(id: "title", in: namespace)
                }
            } else {
                AnotherView(namespace: namespace, title: title, color: color)
            }
        }
        .onTapGesture {
            withAnimation {
                show.toggle()
            }
        }
        .animation(.default, value: rotation)
        .rotationEffect(rotation)
        .gesture(RotationGesture()
            .onChanged { value in
                self.rotation = value
            })
    }
}

struct AnotherView: View {
    var namespace: Namespace.ID
    var title: String
    var color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 400)
                .foregroundStyle(color)
                .cornerRadius(10)
                .shadow(radius: 10)
                .matchedGeometryEffect(id: "view", in: namespace)
            Text(title)
                .foregroundStyle(Color.white)
                .matchedGeometryEffect(id: "title", in: namespace)
        }
    }
}

struct DropViewDelegate: DropDelegate {
    
    let destinationItem: Color
    @Binding var list: [Color]
    @Binding var draggedItem: Color?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if let draggedItem {
            let fromIndex = list.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = list.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.list.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
