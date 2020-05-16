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

struct RecognizeView: View {
//    @ObservedObject var camera = CameraView()
    
    var body: some View {
        ZStack {
            CameraView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
//            Text("test")
//                .offset(CGSize(width: camera.getPoint()?.x ?? 0, height: camera.getPoint()?.y ?? 0))
        }
    }
}


struct RecogniseView_Previews: PreviewProvider {
    static var previews: some View {
        RecognizeView()
    }
}


final class CameraView : UIViewControllerRepresentable, ObservableObject {
    @State var controller: CameraViewController? = nil
    //    @Binding var position: CGPoint
    
    //    func makeCoordinator() -> Coordinator {
    //        return Coordinator(position: $position)
    //    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let controller = CameraViewController()
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
    
    let captureSession = AVCaptureSession()
    
    var backFacingCamera: AVCaptureDevice?
    
    var currentDevice: AVCaptureDevice?
    
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
            self.updatePickersColor()
        }
    }
    
    let previewLayer = CALayer()
    let pickerLayer = CAShapeLayer()
    let labelBackgroundLayer = CAShapeLayer()
    //    let labelLayer = CATextLayer()
    
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
        
        labelBackgroundLayer.position = view.center
        labelBackgroundLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        labelBackgroundLayer.fillColor = UIColor.white.cgColor
        labelBackgroundLayer.frame = view.frame
        view.layer.addSublayer(labelBackgroundLayer)
        
        //        labelLayer.position = view.center
        //        labelLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        //        labelLayer.frame = view.frame
        //        view.layer.addSublayer(labelLayer)
        
        //        let testLayer = CALayer()
        //        testLayer.position = view.center
        //        testLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        //        testLayer.contents = UIImage(imageLiteralResourceName: "1").cgImage
        //        testLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(-.pi / 2.0)))
        //        testLayer.frame = view.frame
        //        view.layer.addSublayer(testLayer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)
            updatePickersPosition(at: position)
            updatePickersColor()
        }
    }
    
    private func updatePickersPosition(at position: CGPoint) {
        self.pickerLayer.path = UIBezierPath(arcCenter: position, radius: CGFloat(20), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        
        let rect = CGRect(x: position.x + 20, y: position.y - 20, width: 100, height: 20)
        self.labelBackgroundLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
        
        self.pickerPosition = position
    }
    
    private func updatePickersColor() {
        let color = self.previewLayer.pickColor(at: self.pickerPosition!)
        self.pickerLayer.fillColor = color?.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCamera()
        updatePickersPosition(at: CGPoint(x: WIDTH / 2, y: HEIGHT / 2))
    }
    
    let queue = DispatchQueue(label: "com.camera.video.queue")
    
    @State public var pickerPosition: CGPoint? = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
    
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
