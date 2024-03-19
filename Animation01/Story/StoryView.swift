//
//  StoryView.swift
//  Animation01
//
//  Created by MacMini4 on 14/03/2024.
//

import SwiftUI
import Combine

struct StoryView: View {
    @ObservedObject var storyTimer: StoryTimer = StoryTimer(items: 7, interval: 3.0)

    var colors: [Color] = [.blue, .green, .orange, .red, .gray, .pink, .yellow]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundStyle(colors[Int(self.storyTimer.progress)])
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: nil, alignment: .center)
                HStack(alignment: .center, spacing: 4) {
                    ForEach(self.colors.indices, id: \.self) { x in
                        LoadingRectangle(progress: min( max( (CGFloat(self.storyTimer.progress) - CGFloat(x)), 0.0) , 1.0) )
                            .frame(width: nil, height: 2, alignment: .leading)
                    }
                }
                .padding()
            }
            .onAppear { self.storyTimer.start() }
        }
    }

    func LoadingRectangle(progress: CGFloat) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.3))
                    .cornerRadius(5)
                
                Rectangle()
                    .frame(width: geometry.size.width * progress, height: nil, alignment: .leading)
                    .foregroundColor(Color.black.opacity(0.9))
                    .cornerRadius(5)
            }
        }
    }
}

#Preview {
    StoryView()
}

class StoryTimer: ObservableObject {
    @Published var progress: Double
    private var interval: TimeInterval
    private var max: Int
    private let publisher: Timer.TimerPublisher
    private var cancellable: Cancellable?
    
    
    init(items: Int, interval: TimeInterval) {
        self.max = items
        self.progress = 0
        self.interval = interval
        self.publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    }
    
    func start() {
        self.cancellable = self.publisher.autoconnect().sink(receiveValue: {  _ in
            var newProgress = self.progress + (0.1 / self.interval)
            if Int(newProgress) >= self.max { newProgress = 0 }
            self.progress = newProgress
        })
    }
}
