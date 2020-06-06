//
//  InfoView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 03/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//



import SwiftUI

struct SavedItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let photo: Photo
    
    func shareButton() {
        isShare.toggle()
        let image = UIImage(data: photo.image!)
        let av = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func image() -> UIImage {
        return UIImage(data: photo.image!)!
    }
    
    func UIColorFromRGB(rgbValue: Int64) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x000000FF) / 255.0,
            alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
        )
    }
    
    @State private var isShare = false
    
    var body: some View {
        ScrollView(){
            
            VStack{
               
                ZStack{

                    Image(uiImage: image()).resizable().scaledToFit().contextMenu {
                        Button(action: {
                            UIImageWriteToSavedPhotosAlbum(self.image(), nil, nil, nil)
                            
                        }){
                            HStack{
                                
                                Text("Save")
                                Image(systemName: "arrow.down")
                            }
                        }
                        Button(action: shareButton
                        ){
                            HStack{
                                Text("Share")
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
//                    HStack{
//                        //                        Button(action: {
//                        //                            // Navigate to the previous screen
//                        //                            self.presentationMode.wrappedValue.dismiss()
//                        //                        }, label: {
//                        //                            Image(systemName: "chevron.left.circle.fill")
//                        //                                .font(.largeTitle)
//                        //                                .foregroundColor(.white)
//                        //                        })
//                        Spacer()
//                        
//                        ZStack{
//                            Button(action: shareButton ){
//                                Image(systemName: "square.and.arrow.up").scaleEffect(1.4)
//                                    .frame(width: 40, height: 40).offset(y:-2)
//                                    .foregroundColor(.black)
//                            }
//                        }.background(Color(.white)).cornerRadius(500)
//                        
//                        
//                    }.padding(.horizontal, 20.0).offset(y:-130)
                }
                HStack{
                    ZStack{
                        
                        Text(photo.name!).foregroundColor(Color("ColorText"))
                            .fontWeight(.light)
                            
                            .padding(.all, 15.0)
                            .cornerRadius(20)
                            .font(.custom("Helvetica Neue", size: 30))
                    }
                    Spacer()
                    ZStack{
                        Circle().foregroundColor(Color(UIColorFromRGB(rgbValue: photo.color)))
                            .frame(width: 32.0, height: 32.0)
                    }
                }.padding(.horizontal, 20.0)
                
                VStack{
                    Text(photo.color_description!)
                        .foregroundColor(Color("ColorText"))
                    
                }.padding(.horizontal).padding(.bottom, 20)
            }
        }    //  .navigationBarTitle(photo.name!)
            
            
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
            .edgesIgnoringSafeArea(.all)
    }
    
}
