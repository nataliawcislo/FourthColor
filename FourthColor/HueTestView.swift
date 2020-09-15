//
//  HueTestView.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 26/08/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct HueTestView: View {
    let pages: [[UIColor]] = [
        [
            UIColor(named: "r1")!,
            UIColor(named: "r2")!,
            UIColor(named: "r3")!,
            UIColor(named: "r4")!,
            UIColor(named: "r5")!,
            UIColor(named: "r6")!,
            UIColor(named: "r7")!,
            UIColor(named: "r8")!,
            UIColor(named: "r9")!,
            UIColor(named: "r10")!
        ],
        [
            UIColor(named: "g1")!,
            UIColor(named: "g2")!,
            UIColor(named: "g3")!,
            UIColor(named: "g4")!,
            UIColor(named: "g5")!,
            UIColor(named: "g6")!,
            UIColor(named: "g7")!,
            UIColor(named: "g8")!,
            UIColor(named: "g9")!,
            UIColor(named: "g10")!
        ]
    ]
    @State private var index: Int = 0
    
    var body: some View {
        HueTestSwipeView(pages: self.pages, index: self.$index)
    }
}

struct HueTestSwipeView: View {
    let pages: [[UIColor]]
    
    @Binding var index: Int
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(Array(self.pages.enumerated()), id: \.element) { i, pageColorList in
                        HueTestPageView(colorList: pageColorList, isFinished: Binding.constant(false), score: Binding.constant(0))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            .content
            .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.isUserSwiping = true
                        self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                    })
                    .onEnded({ value in
                        if value.predictedEndTranslation.width < geometry.size.width / 2, self.index < self.pages.count - 1 {
                            self.index += 1
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                            self.index -= 1
                        }
                        withAnimation {
                            self.isUserSwiping = false
                        }
                    })
            )
        }
    }
}

struct HueTestPageView: View {
    struct Block: Hashable {
        let originalIndex: Int
        let color: UIColor
    }
    
    private static let BLOCK_SIZE: CGFloat = 10
    private var anchors: (UIColor, UIColor)
    @State private var blocks: [Block] = []
    @State private var selectedBlock: Int? = nil
    @Binding private var isFinished: Bool
    @Binding private var score: Int
    
    init(colorList: [UIColor], isFinished: Binding<Bool>, score: Binding<Int>) {
        self.anchors = (colorList.first!, colorList.last!)
        let movableBlocks = colorList[1..<colorList.count - 1].enumerated().map { (index: Int, color: UIColor) -> Block in
            Block(originalIndex: index, color: color)
        }
        _blocks = State(initialValue: movableBlocks.shuffled())
        _isFinished = isFinished
        _score = score
    }
    
    private func calculateScore() -> Int {
        self.blocks.enumerated().reduce(0) { (acc: Int, current: (Int, Block)) -> Int in
            let (index, block) = current
            return acc + abs(index - block.originalIndex)
        }
    }
    
    var body: some View {
        VStack() {
            Rectangle()
                .foregroundColor(Color(self.anchors.0))
                .aspectRatio(1.0, contentMode: .fit)
                .padding(.all, -3.0)
            ForEach(Array(blocks.enumerated()), id: \.element) { index, block in
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(block.color))
                        .aspectRatio(1.0, contentMode: .fit)
                        .scaleEffect(self.selectedBlock == index ? 0.9 : 1.0)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.25)) {
                                if self.selectedBlock == nil {
                                    self.selectedBlock = index
                                } else {
                                    self.blocks.swapAt(index, self.selectedBlock!)
                                    self.selectedBlock = nil
                                    self.score = self.calculateScore()
                                }
                            }
                        }
                }.padding(.all, -3.0)
            }
            Rectangle()
                .foregroundColor(Color(self.anchors.1))
                .aspectRatio(1.0, contentMode: .fit)
                .padding(.all, -3.0)
        }
        .padding(10)
        .onAppear {
            self.score = self.calculateScore()
        }
    }
}

struct Hue_Previews: PreviewProvider {
    static var previews: some View {
        HueTestView()
    }
}
