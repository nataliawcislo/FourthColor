//
//  CameraView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 12/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI
import AVFoundation

struct RecognizeView: View {
    var body: some View {
        ZStack{
            //TODO: Kamera działa, koło jescze nie zmienia swojej pozycji pod czas pracy aparatu.
            //CameraView()
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
    // Init your ViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let controller = CameraViewController()
        return controller
    }


    // Tbh no idea what to do here
    func updateUIViewController(_ uiViewController: CameraView.UIViewControllerType, context: UIViewControllerRepresentableContext<CameraView>) {

    }
}


class CameraViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCamera()
    }

    func loadCamera() {
        let avSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device : captureDevice) else { return }
        avSession.addInput(input)
        avSession.startRunning()

        let cameraPreview = AVCaptureVideoPreviewLayer(session: avSession)
        view.layer.addSublayer(cameraPreview)
        cameraPreview.frame = view.frame
    }
}


struct DetectorView: View {
    @State private var currentPosition: CGSize = .zero
    @State private var newPosition: CGSize = .zero
    
    var body: some View {
        
        HStack{
        Circle()
            .stroke(Color.white, lineWidth: 5)
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
                       .foregroundColor(.white)
                       .frame(width: 120, height: 70)
                       .overlay(Text("Kolor").font(.custom("Helvetica Neue", size: 40)).foregroundColor(.black))
                        .offset(x: self.currentPosition.width - 10, y: self.currentPosition.height - 60)
                        .gesture(DragGesture()
                            .onChanged { value in
                                self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                        }
                            .onEnded { value in
                                self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
                                print(self.newPosition.width)
                                self.newPosition = self.currentPosition
                        })
        }
            
    }
}




