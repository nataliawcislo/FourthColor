//
//  PuzzleView.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 26/08/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct HueLine: View {
    struct Block: Hashable {
        let originalIndex: Int
        let color: UIColor
    }
    
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
                .frame(width: 80, height: 80)
                .padding(.all, -3.0)
            ForEach(Array(blocks.enumerated()), id: \.element) { index, block in
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(block.color))
                        .frame(width: 80, height: 80)
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
                .frame(width: 80, height: 80)
                .padding(.all, -3.0)
        }.onAppear {
            self.score = self.calculateScore()
        }
    }
}

struct HueLine_Previews: PreviewProvider {
    static var previews: some View {
        HueLine(colorList: [
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
        ], isFinished: Binding.constant(false), score: Binding.constant(0))
    }
}


                   
                    
                    
