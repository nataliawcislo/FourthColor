//
//  HueTestView.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 19/10/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct RadarChartData {
    let pairs: [(UIColor, Int)]
    let max: Int
}

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
        ],
        [
            UIColor(named: "b1")!,
            UIColor(named: "b2")!,
            UIColor(named: "b3")!,
            UIColor(named: "b4")!,
            UIColor(named: "b5")!,
            UIColor(named: "b6")!,
            UIColor(named: "b7")!,
            UIColor(named: "b8")!,
            UIColor(named: "b9")!,
            UIColor(named: "b10")!
        ],
        [
            UIColor(named: "p1")!,
            UIColor(named: "p2")!,
            UIColor(named: "p3")!,
            UIColor(named: "p4")!,
            UIColor(named: "p5")!,
            UIColor(named: "p6")!,
            UIColor(named: "p7")!,
            UIColor(named: "p8")!,
            UIColor(named: "p9")!,
            UIColor(named: "p10")!
        ]
    ]
    
    var body: some View {
        HueTestSwipeView(pages: self.pages)
    }
}

struct HueTestSwipeView: View {
    let pages: [[UIColor]]
    let leadingPages = 1
    let trailingPages = 1
    
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false
    @State private var scores: [[Int]]
    @State private var swipeBlocked: Bool = false
    
    init(pages: [[UIColor]]) {
        self.pages = pages
        _scores = State(initialValue: pages.map { Array(repeating: 0, count: $0.count - 2) })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    HueTestResultsTutorialView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    ForEach(Array(self.pages.enumerated()), id: \.element) { i, pageColorList in
                        HueTestTestPageView(colorList: pageColorList, setScores: {
                            scores[i] = $0
                        })
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    HueTestResultsPageView(radarChartData: RadarChartData(pairs: Array(zip(pages.joined(), scores.map { [0] + $0 + [0] }.joined())), max: scores.map { $0.count - 1 }.max()!), swipeBlocked: $swipeBlocked)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .content
            .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        if !swipeBlocked {
                            self.isUserSwiping = true
                            self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                        }
                    })
                    .onEnded({ value in
                        if !swipeBlocked {
                            if value.predictedEndTranslation.width < geometry.size.width / 2, self.index < self.pages.count + leadingPages + trailingPages - 1 {
                                self.index += 1
                            }
                            if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                                self.index -= 1
                            }
                        }
                        withAnimation {
                            self.isUserSwiping = false
                        }
                    })
            )
        }
    }
}

struct HueTestTestPageView: View {
    struct Block: Hashable {
        let originalIndex: Int
        let color: UIColor
    }
    
    private static let BLOCK_SIZE: CGFloat = 10
    private var anchors: (UIColor, UIColor)
    private let setScores: ([Int]) -> Void
    @State private var blocks: [Block] = []
    @State private var selectedBlock: Int? = nil
    
    init(colorList: [UIColor], setScores: @escaping ([Int]) -> Void) {
        self.setScores = setScores
        self.anchors = (colorList.first!, colorList.last!)
        let movableBlocks = colorList[1..<colorList.count - 1].enumerated().map { (index: Int, color: UIColor) -> Block in
            Block(originalIndex: index, color: color)
        }
        _blocks = State(initialValue: movableBlocks.shuffled())
    }
    
    private func calculateScores() {
        let scores: [Int] = self.blocks.enumerated().map { (current: (Int, Block)) -> Int in
            let (index, block) = current
            return abs(index - block.originalIndex)
        }
        self.setScores(scores)
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
                                    self.calculateScores()
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
            self.calculateScores()
        }
    }
}

struct HueTestResultsTutorialView: View {
    var body: some View {
        Text("Tutorial")
    }
}

struct HueTestResultsPageView: View {
    let radarChartData: RadarChartData
    @Binding var swipeBlocked: Bool
    
    init(radarChartData: RadarChartData, swipeBlocked: Binding<Bool>) {
        self.radarChartData = radarChartData
        _swipeBlocked = swipeBlocked
    }
    
    var body: some View {
        if !swipeBlocked {
            Button("Finish") {
                swipeBlocked = true
            }
        } else {
            RadarChart(data: radarChartData)
        }
    }
}

final class RadarChart : UIViewControllerRepresentable, ObservableObject {
    @State var controller: RadarChartViewController? = nil
    
    let data: RadarChartData
    
    init(data: RadarChartData) {
        self.data = data
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<RadarChart>) -> UIViewController {
        let controller = RadarChartViewController(data: self.data)
        DispatchQueue.main.async {
            self.controller = controller
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: RadarChart.UIViewControllerType, context: UIViewControllerRepresentableContext<RadarChart>) {
    }
}

class RadarChartViewController : UIViewController {
    var canvas: RadarChartView!
    
    init(data: RadarChartData) {
        super.init(nibName: nil, bundle: nil)
        canvas = RadarChartView(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.backgroundColor = .clear
        
        view.addSubview(canvas)
        NSLayoutConstraint.activate([
            canvas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvas.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            canvas.widthAnchor.constraint(equalTo: view.widthAnchor),
            canvas.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

class RadarChartView : UIView {
    var data: RadarChartData!
    
    convenience init(data: RadarChartData) {
        self.init(frame: CGRect.zero)
        self.data = data
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func pointOnCircle(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        return CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }
    
    static func lerp(min: CGFloat, max: CGFloat, i: CGFloat) -> CGFloat {
        return min + (max - min) * i
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let pairs = data.pairs
        let center: CGPoint = CGPoint(x: 0.5, y: 0.5)
        let squareSize: CGFloat = min(rect.width, rect.height)
        let DOT_RADIUS: CGFloat = 0.03
        let CENTER_RADIUS: CGFloat = 0.2
        let MAX_RADIUS = 1/2 - DOT_RADIUS
        
        // MARK: Grid
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(0.5)
        for i in 0...data.max + 1 {
            let radius = RadarChartView.lerp(
                min: CENTER_RADIUS,
                max: MAX_RADIUS,
                i: CGFloat(i) / CGFloat(data.max + 1)
            )
            context.addArc(
                center: center * squareSize,
                radius: radius * squareSize,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            )
            context.strokePath()
        }
        for i in 0..<pairs.count {
            let maxPoint = RadarChartView.pointOnCircle(
                center: center,
                angle: CGFloat(i) / CGFloat(pairs.count) * 2 * CGFloat.pi - 3/4 * CGFloat.pi,
                radius: MAX_RADIUS
            )
            let minPoint = RadarChartView.pointOnCircle(
                center: center,
                angle: CGFloat(i) / CGFloat(pairs.count) * 2 * CGFloat.pi - 3/4 * CGFloat.pi,
                radius: CENTER_RADIUS
            )
            context.move(to: minPoint * squareSize)
            context.addLine(to: maxPoint * squareSize)
            context.strokePath()
        }
        
        // MARK: Graph
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(2)
        context.move(to: RadarChartView.pointOnCircle(
            center: center,
            angle: -3/4 * CGFloat.pi,
            radius: RadarChartView.lerp(
                min: CENTER_RADIUS,
                max: MAX_RADIUS,
                i: CGFloat(pairs[0].1) / CGFloat(data.max + 1)
            )
        ) * squareSize)
        for i in 1...pairs.count {
            let (_, lastScore) = pairs[i - 1]
            let (_, score) = pairs[i % pairs.count]
            
            let radius = RadarChartView.lerp(
                min: CENTER_RADIUS,
                max: MAX_RADIUS,
                i: CGFloat(score) / CGFloat(data.max + 1)
            )
            
            if score == lastScore {
                // move clockwise
                context.addArc(
                    center: center * squareSize,
                    radius: radius * squareSize,
                    startAngle: CGFloat(i - 1) / CGFloat(pairs.count) * 2 * CGFloat.pi - 3/4 * CGFloat.pi,
                    endAngle: CGFloat(i) / CGFloat(pairs.count) * 2 * CGFloat.pi - 3/4 * CGFloat.pi,
                    clockwise: false
                )
            } else {
                // move up/down
                let point = RadarChartView.pointOnCircle(
                    center: center,
                    angle: CGFloat(i) / CGFloat(pairs.count) * 2 * CGFloat.pi - 3/4 * CGFloat.pi,
                    radius: radius
                )
                context.addLine(to: point * squareSize)
            }
        }
        context.strokePath()
        
        // MARK: Color dots
        for (i, pair) in pairs.enumerated() {
            let (color, _) = pair
            let point = RadarChartView.pointOnCircle(
                center: center,
                angle: CGFloat(i) / CGFloat(pairs.count) * 2 * CGFloat.pi - 3/4 * CGFloat.pi,
                radius: 1/2 - DOT_RADIUS
            )
            context.setFillColor(color.cgColor)
            context.addArc(
                center: point * squareSize,
                radius: DOT_RADIUS * squareSize,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            )
            context.fillPath()
        }
    }
}

struct HueTestView_Previews: PreviewProvider {
    static var previews: some View {
        HueTestView()
    }
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}
