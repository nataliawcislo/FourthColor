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
    var body: some View {
        ZStack{
            //TODO: Kamera działa, koło jescze nie zmienia swojej pozycji pod czas pracy aparatu.
            CameraView()
            DetectorView()
        }
    }
}


struct RecogniseView_Previews: PreviewProvider {
    static var previews: some View {
        RecognizeView()
    }
}


struct CameraView : UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let controller = CameraViewController()
//        controller.delegate
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType, context: UIViewControllerRepresentableContext<CameraView>) {

    }
}





let WIDTH = UIScreen.main.bounds.width
let HEIGHT = UIScreen.main.bounds.height

class CameraViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    
    var backFacingCamera: AVCaptureDevice?
    
    var currentDevice: AVCaptureDevice?
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
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
            let color = self.previewLayer.pickColor(at: self.center)
            self.view.backgroundColor = color // TODO: zmienic na kolor kolka
            self.lineShape.strokeColor = color?.cgColor
        }
    }
    
    let previewLayer = CALayer()
    let lineShape = CAShapeLayer()
    
    func setupUI() {
        let cameraPreview = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreview)
        cameraPreview.frame = view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCamera()
    }
    
    let queue = DispatchQueue(label: "com.camera.video.queue")
    
    var center: CGPoint = CGPoint(x: WIDTH/2, y: HEIGHT/2)
    
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
