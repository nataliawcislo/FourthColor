//
//  IshiharaPlate.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 19/10/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI
import UIKit

final class IshiharaPlate : UIViewControllerRepresentable, ObservableObject {
    @State var controller: IshiharaPlateViewController? = nil
    
    let filename: String
    
    init(named filename: String) {
        self.filename = filename
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<IshiharaPlate>) -> UIViewController {
        let controller = IshiharaPlateViewController(filename: self.filename)
        DispatchQueue.main.async {
            self.controller = controller
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: IshiharaPlate.UIViewControllerType, context: UIViewControllerRepresentableContext<IshiharaPlate>) {
    }
}

struct IshiharaPlateCircle {
    public var origin: CGPoint;
    public var radius: CGFloat;
    public var color: UIColor;
}

class IshiharaPlateViewController : UIViewController {
    var canvas: IshiharaPlateView!
    
    init(filename: String) {
        super.init(nibName: nil, bundle: nil)
        canvas = IshiharaPlateView(circles: try! loadCircles(filename: filename))
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
    
    private func loadCircles(filename: String) throws -> [IshiharaPlateCircle] {
        var circles: [IshiharaPlateCircle] = []
        
        let asset = NSDataAsset(name: filename, bundle: Bundle.main)
        let data = String(decoding: asset!.data, as: UTF8.self)
        let lines: [String] = data.components(separatedBy: .newlines)
        for line in lines {
            if line != "" {
                let components = line.split(separator: ";")
                let x: Float = Float(components[0]) ?? 0
                let y: Float = Float(components[1]) ?? 0
                let radius: Float = Float(components[2]) ?? 0
                let r: Float = Float(components[3]) ?? 0
                let g: Float = Float(components[4]) ?? 0
                let b: Float = Float(components[5]) ?? 0
                circles.append(IshiharaPlateCircle(
                    origin: CGPoint(
                        x: CGFloat(x),
                        y: CGFloat(y)
                    ),
                    radius: CGFloat(radius),
                    color: UIColor(
                        red: CGFloat(r),
                        green: CGFloat(g),
                        blue: CGFloat(b),
                        alpha: 1.0
                    )
                ))
            }
        }
        
        return circles
    }
}

class IshiharaPlateView : UIView {
    var circles: [IshiharaPlateCircle]!
    
    convenience init(circles: [IshiharaPlateCircle]) {
        self.init(frame: CGRect.zero)
        self.circles = circles
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for circle in circles {
            let x = circle.origin.x * frame.width
            let y = circle.origin.y * frame.height
            context.setFillColor(circle.color.cgColor)
            context.addArc(
                center: CGPoint(x: x, y: y),
                radius: circle.radius * frame.width,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            )
            context.fillPath()
        }
    }
}

struct IshiharaPlate_Previews: PreviewProvider {
    static var previews: some View {
        IshiharaPlate(named: "8")
    }
}
