//
//  CameraView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 12/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI
import AVFoundation
import UIKit
import FINNBottomSheet
import CoreData

struct RecognizeView: View {
  //  @ObservedObject var camera = CameraView()
    @Environment(\.presentationMode) var presentationMode
    
    let defect: Defect
      
    var body: some View {

        CameraView(defect: defect)
               // .navigationBarTitle("")
               // .navigationBarHidden(true)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
               // .statusBar(hidden: true)
      //  .edgesIgnoringSafeArea(.top)
               .navigationBarBackButtonHidden(true)
               .navigationBarItems(leading:
                   Button(action: {
                       // Navigate to the previous screen
                       self.presentationMode.wrappedValue.dismiss()
                   }, label: {
                       Image(systemName: "chevron.left.circle.fill")
                           .font(.largeTitle)
                        .foregroundColor(Color(.systemBlue))
                   })
               )
        
//            Text("test")
//                .offset(CGSize(width: camera.getPoint()?.x ?? 0, height: camera.getPoint()?.y ?? 0))
  
    }
}


struct RecogniseView_Previews: PreviewProvider {
    static var previews: some View {
        RecognizeView(defect: defects[0])
    }
}


final class CameraView : UIViewControllerRepresentable, ObservableObject {
    @State var controller: CameraViewController? = nil
    
    let defect: Defect
    
    init(defect: Defect) {
        self.defect = defect
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let controller = CameraViewController(filename: defect.filename)
        DispatchQueue.main.async {
            self.controller = controller
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType, context: UIViewControllerRepresentableContext<CameraView>) {
        
    }
    
    func getPoint() -> CGPoint? {
//        print(controller?.pickerPosition)
        return controller?.pickerPosition
    }
}





let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height

class CameraViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    init(filename: String) {
        self.colors = ColorSet.new(fromFilename: filename)!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var colors: ColorSet
    
    let captureSession = AVCaptureSession()
    
    var backFacingCamera: AVCaptureDevice?
    
    var currentDevice: AVCaptureDevice?
// obraz z ekranu
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = AVCaptureVideoOrientation.portrait
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        guard let baseAddr = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else {
            return
        }
        let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bimapInfo: CGBitmapInfo = [
            .byteOrder32Little,
            CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]
        
        guard let content = CGContext(data: baseAddr, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bimapInfo.rawValue) else {
            return
        }
        
        guard let cgImage = content.makeImage() else {
            return
        }
        
        DispatchQueue.main.async {
            self.previewLayer.contents = cgImage
            self.currentPhoto = UIImage(cgImage: cgImage)
            self.updatePickersColor()
        }
    }
    
    let previewLayer = CALayer()
    let pickerLayer = CAShapeLayer()
    var bottomSheetView: BottomSheetView? = nil
    let colorView = UIView()
    let colorLayer = CAShapeLayer()
    let labelLayer = CATextLayer()
    let descriptionLayer = CATextLayer()
    
    let flashLayer = CAShapeLayer()
    
    func setupUI() {
        previewLayer.position = view.center
        previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        pickerLayer.position = view.center
        pickerLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        pickerLayer.strokeColor = UIColor.black.cgColor
        pickerLayer.lineWidth = 3.0
        pickerLayer.frame = view.frame
        view.layer.addSublayer(pickerLayer)
        
//        labelBackgroundLayer.position = view.center
//        labelBackgroundLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
//        labelBackgroundLayer.fillColor = UIColor.black.cgColor
//        labelBackgroundLayer.frame = view.frame
//        let rect = CGRect(x: 0, y: HEIGHT - 50, width: WIDTH, height: 50)
//        labelBackgroundLayer.path = UIBezierPath(rect: rect).cgPath
//        view.layer.addSublayer(labelBackgroundLayer)
        
        colorLayer.position = view.center
        colorLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        colorLayer.frame = view.frame
        colorLayer.path = UIBezierPath(arcCenter: CGPoint(x: 25.0, y: 15.0), radius: CGFloat(15), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        
        labelLayer.position = view.center
        labelLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        labelLayer.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        labelLayer.fontSize = 26
        labelLayer.foregroundColor = UIColor.white.cgColor
        labelLayer.frame = CGRect(x: 50 + 5, y: 0, width: WIDTH - 50, height: 50)
        
        descriptionLayer.position = view.center
        descriptionLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        descriptionLayer.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        descriptionLayer.fontSize = 18
        descriptionLayer.foregroundColor = UIColor.white.cgColor
        descriptionLayer.frame = CGRect(x: 10, y: 50, width: WIDTH - 10, height: HEIGHT)
        descriptionLayer.isWrapped = true
        
        colorView.backgroundColor = .black
        
        colorView.layer.addSublayer(colorLayer)
        colorView.layer.addSublayer(labelLayer)
        colorView.layer.addSublayer(descriptionLayer)
        
        bottomSheetView = BottomSheetView(
            contentView: colorView,
            contentHeights: [50, HEIGHT]
        )

        bottomSheetView!.present(in: self.view, targetIndex: 0, animated: false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        flashLayer.position = view.center
        flashLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        flashLayer.fillColor = UIColor.black.cgColor
        flashLayer.frame = view.frame
        let rect = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        flashLayer.path = UIBezierPath(rect: rect).cgPath
        flashLayer.opacity = 0
        view.layer.addSublayer(flashLayer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)
            self.pickerPosition = position
            updatePickersPosition()
            updatePickersColor()
        }
    }
//zdj robienie zapisywanie
    @objc func doubleTapped() {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        flashLayer.add(animation, forKey: "fade")
        
        let name = self.currentColorName!
        let imageData: Data = self.currentPhoto!.pngData()!
        let description: String = self.currentColorDescription!
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.currentColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let sred = Int64(red * 255.0)
        let sgreen = Int64(green * 255.0)
        let sblue = Int64(blue * 255.0)
        let salpha = Int64(alpha * 255.0)
        print("\(salpha) \(sred) \(green) \(sblue)")
        let rgb: Int64 = (salpha << 24) + (sred << 16) + (sgreen << 8) + sblue
        
        let photoConnection = PhotoConnection()
        photoConnection.insertPhoto(name: name, image: imageData, color: rgb, description: description)
    }
    
    private func updatePickersPosition() {
        self.pickerLayer.path = UIBezierPath(arcCenter: self.pickerPosition!, radius: CGFloat(20), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
    }
    
    private func updatePickersColor() {
        let color = self.previewLayer.pickColor(at: self.pickerPosition!)
        self.pickerLayer.fillColor = color?.cgColor
        if bottomSheetView!.currentTargetOffsetIndex == 0 {
            let recognizedColor = self.colors.getNearest(from: color!)
            self.colorLayer.fillColor = recognizedColor?.color.cgColor
            self.labelLayer.string = recognizedColor?.name
            self.descriptionLayer.string = recognizedColor?.description
            self.currentColor = recognizedColor?.color
            self.currentColorName = recognizedColor?.name
            self.currentColorDescription = recognizedColor?.description
            print(recognizedColor!.name)
            self.uttered = false
        }
        if bottomSheetView!.currentTargetOffsetIndex == 1 && !self.uttered {
            let utterance = AVSpeechUtterance(string: self.currentColorName!)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.4
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
            self.uttered = true
        }
        print(bottomSheetView!.currentTargetOffsetIndex)
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCamera()
        updatePickersPosition()
    }
    
    let queue = DispatchQueue(label: "com.camera.video.queue")
    
    var pickerPosition: CGPoint? = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
    
    var currentPhoto: UIImage? = nil
    var currentColor: UIColor? = nil
    var currentColorName: String? = nil
    var currentColorDescription: String? = nil
    var uttered: Bool = false
    
    func loadCamera() {
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        self.backFacingCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        self.currentDevice = self.backFacingCamera
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA)] as? [String : Any]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            if self.captureSession.canAddOutput(videoOutput) {
                self.captureSession.addOutput(videoOutput)
            }
            self.captureSession.addInput(captureDeviceInput)
        } catch {
            print(error)
            return
        }
        
        self.captureSession.startRunning()
    }
}


struct DetectorView: View {
    @State public var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    var body: some View {
        
        HStack{
            Circle()
                .overlay(Circle().stroke(Color.black, lineWidth: 5))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .offset(x: self.currentPosition.width, y: self.currentPosition.height)
                .gesture(DragGesture()
                    .onChanged { value in
                        self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                }
                .onEnded { value in
                    self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                    print(self.newPosition.width)
                    self.newPosition = self.currentPosition
                    }
                    //TODO: Gest dla kola, przenieś sie tam gdzie klikne
                    //.gesture(TapGesture().onEnded {_ in self.didTap.toggle() }
            )
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.gray)
                .frame( width: 120.0, height: 70.0)
                .overlay(Text("Kolor").font(.custom("Helvetica Neue", size: 40)).foregroundColor(.black))
                .offset(x: self.currentPosition.width - 10, y: self.currentPosition.height - 60)
            
        }
        
    }
}

//pobiera konkretny piksel z ekranu
public extension CALayer {
    func pickColor(at position: CGPoint) -> UIColor? {
        
        var pixel = [UInt8](repeatElement(0, count: 4))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        context.translateBy(x: -position.x, y: -position.y)
        
        render(in: context)
        
        return UIColor(red: CGFloat(pixel[0]) / 255.0,
                       green: CGFloat(pixel[1]) / 255.0,
                       blue: CGFloat(pixel[2]) / 255.0,
                       alpha: CGFloat(pixel[3]) / 255.0)
    }
}

//extension CGImage {
//    func getPixelColor(pos: CGPoint) -> UIColor {
//
//        let pixelData = self.dataProvider!.data
//        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//
//        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
//
//        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
//        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
//        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
//        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
//
//        return UIColor(red: r, green: g, blue: b, alpha: a)
//    }
//}

//public extension CGColor {
//    func nearestName(from colorList: []) -> String? {
//        return "test"
//    }
//
//    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
//        let components = self.components
//        let r = components![0]
//        let g = components![1]
//        let b = components![2]
//        return (r, g, b)
//    }
//
//    func 
//}
