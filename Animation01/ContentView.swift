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

    @State var colors: [Color] = [.blue, .green, .orange, .red, .gray, .pink, .yellow]
    var colors2: [Color] = [.blue, .green, .orange, .red, .gray, .pink, .yellow]
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
                                itemButton(color: color, title: "item \(color)", destination: StoryView())
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
                                if color == colors[1] {
                                    itemButton(color: color, title: "item \(color)", height: 70, destination: CardView())
                                        .onDrag({
                                            self.selectedColor = color
                                            return NSItemProvider()
                                        })
                                        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: color, list: $colors, draggedItem: $selectedColor))
                                } else {
                                    itemButton(color: color, title: "item \(color)", height: 70, destination: CanvasView())
                                        .onDrag({
                                            self.selectedColor = color
                                            return NSItemProvider()
                                        })
                                        .onDrop(of: [.text], delegate: DropViewDelegate(destinationItem: color, list: $colors, draggedItem: $selectedColor))
                                }
                                    
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
    private func itemButton<Destination: View>(color: Color,title: String, height: CGFloat = 100, destination: Destination) -> some View {
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
        .animation(.default, value: rotation)
        .rotationEffect(rotation)
        .gesture(RotationGesture()
            .onChanged { value in
                self.rotation = value
                self.color = .orange
            })
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
