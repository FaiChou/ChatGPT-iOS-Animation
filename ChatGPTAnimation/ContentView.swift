//
//  ContentView.swift
//  ChatGPTAnimation
//
//  Created by 周辉 on 2023/6/27.
//

import SwiftUI

extension Color {
    static let color1 = Color("color1")
    static let color2 = Color("color2")
    static let color3 = Color("color3")
    static let color4 = Color("color4")
}

struct ChatGPTAnimationModel: Identifiable {
    var id: UUID = .init()
    var text: String
    var textColor: Color
    var circleColor: Color
    var bgColor: Color
    var circleOffset: CGFloat = 0
    var textOffset: CGFloat = 0
}

// Samples
var samples: [ChatGPTAnimationModel] = [
    .init(text: "Guidoooo📱", textColor: .color4, circleColor: .color4, bgColor: .color1),
    .init(text: "Sark Sark🏊‍♂️", textColor: .color1, circleColor: .color1, bgColor: .color2),
    .init(text: "Juner~~~⚡️", textColor: .color2, circleColor: .color2, bgColor: .color3),
    .init(text: "星空🌌", textColor: .color3, circleColor: .color3, bgColor: .color4),
    .init(text: "猛哥猛哥猛哥👙", textColor: .color4, circleColor: .color4, bgColor: .color1),
]

struct ContentView: View {
    @State private var active: ChatGPTAnimationModel?
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                if let active {
                    Rectangle()
                        .fill(active.bgColor)
                        .overlay {
                            Circle()
                                .fill(active.circleColor)
                                .frame(width: 38, height: 38)
                                .background(alignment: .leading) {
                                    Capsule()
                                        .fill(active.bgColor)
                                        .frame(width: size.width)
                                }
                                .background(alignment: .leading) {
                                    Text(active.text)
                                        .font(.largeTitle)
                                        .foregroundStyle(active.textColor)
                                        .frame(width: textSize(active.text))
                                        .offset(x: 10)
                                        .offset(x: active.textOffset)
                                }
                                .offset(x: -active.circleOffset)
                        }
                }
            }
            .ignoresSafeArea()
        }
        .task {
            if active == nil {
                active = samples.first
                let seconds = UInt64(1_000_000_000 * 5)
                try? await Task.sleep(nanoseconds: seconds)
                animate(0)
            }
        }
    }
    func animate(_ index: Int, _ loop: Bool = true) {
        if samples.indices.contains(index + 1) {
            active?.text = samples[index].text
            active?.textColor = samples[index].textColor
            
            withAnimation(.easeIn(duration: 1)) {
                active?.textOffset = -(textSize(samples[index].text) + 20)
                active?.circleOffset = -(textSize(samples[index].text) + 20) / 2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeIn(duration: 0.8)) {
                    active?.textOffset = 0
                    active?.circleOffset = 0
                    active?.circleColor = samples[index+1].circleColor
                    active?.bgColor = samples[index+1].bgColor
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    animate(index+1, loop)
                }
            }
        } else {
            if loop {
                animate(0, loop)
            }
        }
    }
    func textSize(_ text: String) -> CGFloat {
        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
