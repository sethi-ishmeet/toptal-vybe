//
//  ContentView.swift
//  vybe
//
//  Created by Ishmeet Singh Sethi on 2022-02-09.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var items: [ItemType] = [.video, .text, .video, .video, .video, .text, .text]
    @State var players: [Int: AVPlayer] = [
        0: AVPlayer(url:  Bundle.main.url(forResource: "sample", withExtension: "mov")!),
        2: AVPlayer(url:  Bundle.main.url(forResource: "sample", withExtension: "mov")!),
        3: AVPlayer(url:  Bundle.main.url(forResource: "sample", withExtension: "mov")!),
        4: AVPlayer(url:  Bundle.main.url(forResource: "sample", withExtension: "mov")!)
    ]
    @State private var onScreenVideos = Set<Int>()
    
    var body: some View {
        GeometryReader { geometry in
            List(0...6, id: \.self) { index in
                VStack(alignment: .center) {
                    switch items[index] {
                    case .video:
                        VideoPlayer(player: players[index])
                            .onAppear {
                                onScreenVideos.insert(index)
                            }
                            .onDisappear {
                                onScreenVideos.remove(index)
                                players[index]?.seek(to: CMTime.zero)
                                players[index]?.pause()
                            }
                    case .text:
                        Text("Hello, world!")
                            .padding()
                    }
                }
                .frame(height: geometry.size.height / 3)
            }
            .onChange(of: onScreenVideos) { newValue in
                players.forEach { (key: Int, value: AVPlayer) in
                    value.pause()
                }
                
                if let first = newValue.sorted().first {
                    players[first]?.play()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum ItemType {
    case text
    case video
}
