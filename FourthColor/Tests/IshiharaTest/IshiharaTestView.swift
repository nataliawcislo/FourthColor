//
//  IshiharaTestView.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 19/10/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

enum Confusion {
    case NotConfused(clarification: String)
    case Confused(confusions: Dictionary<Deficiency, String>)
}

enum Deficiency: CustomStringConvertible {
    case RedGreen
    case Prot
    case Deuter
    
    public var description: String {
        switch self {
        case .RedGreen:
            return "Red-green deficiency"
        case .Prot:
            return "Protanopia or protanomaly"
        case .Deuter:
            return "Deuteranopia or deuteranomaly"
        }
    }
    
    static func compare(lhs: (Deficiency, String), rhs: (Deficiency, String)) -> Bool {
        if lhs.0 == .RedGreen {
            return true
        }
        if lhs.0 == .Deuter {
            return false
        }
        if rhs.0 == .Deuter {
            return true
        }
        return false
    }
}

enum IshiharaTestNumberOfLines: CustomStringConvertible, CaseIterable {
    case Zero, One, Two
    
    public var description: String {
        switch self {
        case .Zero:
            return "no lines"
        case .One:
            return "1 line"
        case .Two:
            return "2 lines"
        }
    }
}

enum IshiharaTestAnswer: CustomStringConvertible {
    case Number(value: Int)
    case Lines(numberOfLines: IshiharaTestNumberOfLines)
    
    public var description: String {
        switch self {
        case .Number(value: let value):
            return "\(value)"
        case .Lines(numberOfLines: let numberOfLines):
            return "\(numberOfLines.description)"
        }
    }
}

struct IshiharaTestPage: Hashable, Identifiable {
    let id = UUID()
    let plateFilename: String;
    let correctAnswer: IshiharaTestAnswer;
    let confusedAnswers: Confusion;
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: IshiharaTestPage, rhs: IshiharaTestPage) -> Bool {
        return lhs.id == rhs.id
    }
}

struct IshiharaTestView: View {
    let pages: [IshiharaTestPage] = [
        IshiharaTestPage(
            plateFilename: "8",
            correctAnswer: IshiharaTestAnswer.Number(value: 8),
            confusedAnswers: Confusion.Confused(confusions: [Deficiency.RedGreen: "3"])
        ),
        IshiharaTestPage(
            plateFilename: "6",
            correctAnswer: IshiharaTestAnswer.Number(value: 6),
            confusedAnswers: Confusion.Confused(confusions: [Deficiency.RedGreen: "5"])
        ),
        IshiharaTestPage(
            plateFilename: "8",
            correctAnswer: IshiharaTestAnswer.Lines(numberOfLines: .One),
            confusedAnswers: Confusion.Confused(confusions: [Deficiency.RedGreen: "5"])
        ),
        IshiharaTestPage(
            plateFilename: "8",
            correctAnswer: IshiharaTestAnswer.Lines(numberOfLines: .One),
            confusedAnswers: Confusion.Confused(confusions: [Deficiency.RedGreen: "5"])
        ),
    ]
    @State private var index: Int = 0
    
    var body: some View {
        NavigationView {
            IshiharaTestSwipeView(pages: self.pages, index: self.$index)
        }
    }
}

struct IshiharaTestSwipeView: View {
    let pages: [IshiharaTestPage]
    @State var answers: [IshiharaTestAnswer?]
    @Binding var index: Int
    let setupPagesCount = 1
    
    init(pages: [IshiharaTestPage], index: Binding<Int>) {
        self.pages = pages
        _index = index
        _answers = State(initialValue: Array(repeating: nil, count: pages.count))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    IshiharaTestCountdownPageView(nextPlate: {
                        self.index = 1
                    }, isCurrent: self.index == 0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    ForEach(Array(self.pages.enumerated()), id: \.offset) { i, page in
                        IshiharaTestTestPageView(page, nextPlate: {
                            self.index = setupPagesCount + i + 1
                        }, isCurrent: self.index == i + setupPagesCount, answer: {
                            self.answers[i] = $0
                            print("answered \(String(describing: $0)) for question \(i)")
                            print(answers)
                        }, testsRemainingString: formatTestsRemainingString(self.pages.count - i - 1))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    IshiharaTestResultsPageView(pages: pages, answers: answers)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .content
            .offset(x: CGFloat(self.index) * -geometry.size.width)
            .frame(width: geometry.size.width, alignment: .leading)
        }
    }
}

func formatTestsRemainingString(_ n: Int) -> String {
    if abs(n) == 1 {
        return "\(n) test remaining"
    } else {
        return "\(n) tests remaining"
    }
}

struct IshiharaTestTestPageView: View {
    private static let INITIAL_TIME: Int = 10
    private let answer: (IshiharaTestAnswer?) -> Void
    private let page: IshiharaTestPage
    private let nextPlate: () -> Void
    private let testsRemainingString: String
    @State private var timeRemaining: Int
    @State private var ready: Bool = false
    @State private var numberInput: String = ""
    @State private var linesPick: Int = 0
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common)
    
    init(_ page: IshiharaTestPage, nextPlate: @escaping () -> Void, isCurrent: Bool, answer: @escaping (IshiharaTestAnswer?) -> Void, testsRemainingString: String) {
        self.answer = answer
        self.page = page
        self.nextPlate = nextPlate
        self.testsRemainingString = testsRemainingString
        _timeRemaining = State(initialValue: IshiharaTestTestPageView.INITIAL_TIME)
        if isCurrent {
            let _ = self.timer.connect()
        }
    }
    
    var body: some View {
        VStack {
            if !ready {
                VStack {
                    Text("Time remaining")
                        .font(.caption)
                    Text(String(self.timeRemaining))
                        .font(.title)
                }
                IshiharaPlate(named: self.page.plateFilename)
                    .frame(width: 300, height: 300)
            }
            Form {
                if !ready {
                    Button("I'm ready") {
                        withAnimation {
                            ready = true
                        }
                    }
                } else {
                    switch self.page.correctAnswer {
                    case .Number:
                        Section(header: Text("What number did you see?")) {
                            TextField("Enter your answer", text: $numberInput, onCommit: {
                                UIApplication.shared.endEditing()
                            })
                            .keyboardType(.numberPad)
                        }
                    case .Lines:
                        Section(header: Text("How many lines did you see?")) {
                            Picker(selection: $linesPick, label: Text("Select your answer")) {
                                ForEach(0..<IshiharaTestNumberOfLines.allCases.count) { i in
                                    Text(IshiharaTestNumberOfLines.allCases[i].description)
                                }
                            }
                        }
                    }
                    Section(footer: Text(testsRemainingString)) {
                        Button("Answer") {
                            switch self.page.correctAnswer {
                            case .Number:
                                answer(Int(numberInput).map { IshiharaTestAnswer.Number(value: $0) })
                                print(Int(numberInput).map { IshiharaTestAnswer.Number(value: $0) } as Any)
                            case .Lines:
                                answer(IshiharaTestAnswer.Lines(numberOfLines: IshiharaTestNumberOfLines.allCases[linesPick]))
                                print(IshiharaTestAnswer.Lines(numberOfLines: IshiharaTestNumberOfLines.allCases[linesPick]) as Optional<IshiharaTestAnswer> as Any)
                            }
                            withAnimation {
                                nextPlate()
                                UIApplication.shared.endEditing()
                            }
                        }
                        Button("I don't know") {
                            withAnimation {
                                nextPlate()
                                UIApplication.shared.endEditing()
                            }
                        }
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer.connect().cancel()
                withAnimation {
                    ready = true
                }
            }
        }
    }
}

struct ConfusionView: View {
    let confusedAnswers: Confusion
    
    var body: some View {
        VStack {
            switch self.confusedAnswers {
            case .NotConfused(clarification: let clarification):
                Text(clarification)
            case .Confused(confusions: let confusions):
                ForEach(confusions.sorted(by: Deficiency.compare), id: \.key) { key, value in
                    Text("\(key.description): \(value.description)")
                }
            }
        }
    }
}

struct IshiharaTestResultsPageAnswerView: View {
    let plateFilename: String;
    let correctAnswer: IshiharaTestAnswer;
    let answer: IshiharaTestAnswer?;
    let confusedAnswers: Confusion;
    
    var body: some View {
        HStack {
            IshiharaPlate(named: self.plateFilename)
                .frame(width: 100, height: 100)
            Spacer()
            Text(self.answer?.description ?? "-")
            Spacer()
            Text(self.correctAnswer.description)
            Spacer()
            ConfusionView(confusedAnswers: self.confusedAnswers)
        }
    }
}

struct IshiharaTestResultsPageView: View {
    let pages: [IshiharaTestPage]
    let answers: [IshiharaTestAnswer?]
    
    var body: some View {
        List {
            ForEach(Array(zip(self.pages, self.answers).enumerated()), id: \.offset) { i, row in
                HStack {
//                    EmptyView()
                    Text(String(i))
                    IshiharaPlate(named: row.0.plateFilename)
                        .frame(width: 80, height: 80)
                    Spacer()
//                    if row.0.correctAnswer == row.1 {
//                        Text("Correct answer")
//                    } else {
//                        Text("Incorrect answer")
//                    }
//                    Spacer()
                }
            }
        }
    }
}

struct IshiharaTestCountdownPageView: View {
    private static let INITIAL_TIME: Int = 3
    private let nextPlate: () -> Void
    @State private var timeRemaining: Int
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common)
    
    init(nextPlate: @escaping () -> Void, isCurrent: Bool) {
        self.nextPlate = nextPlate
        _timeRemaining = State(initialValue: IshiharaTestCountdownPageView.INITIAL_TIME)
        if isCurrent {
            let _ = self.timer.connect()
        }
    }
    
    var body: some View {
        Text(String(self.timeRemaining))
            .font(.largeTitle) // TODO: zwieksz czcionke
            .onReceive(timer) { _ in // to wszystko musi zostać
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer.connect().cancel()
                    withAnimation {
                        nextPlate()
                    }
                }
            }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct IshiharaTestView_Previews: PreviewProvider {
    static var previews: some View {
        IshiharaTestView()
    }
}
