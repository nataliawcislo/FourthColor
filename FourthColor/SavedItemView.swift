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
    
    let imageName: String
    func shareButton(){
          isShare.toggle()
          let image = UIImage(named: imageName)
          let av = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
          
          UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
      }

      @State private var isShare = false
      
    var body: some View {
        ScrollView(){
            
            VStack{
                ZStack{
                    Image(imageName).resizable().scaledToFit().contextMenu {
                        Button(action: {
                            UIImageWriteToSavedPhotosAlbum(UIImage(named: self.imageName)!, nil, nil, nil)
                            
                        }){
                            HStack{
                                
                                Text("Save")
                                Image(systemName: "arrow.down")
                            }
                            
                        }
                    }
                    HStack{
                        Button(action: {
                            // Navigate to the previous screen
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        })
                        Spacer()
                        
                        ZStack{
                            Button(action: shareButton ){
                            Image(systemName: "square.and.arrow.up").scaleEffect(1.4)
                                .frame(width: 40, height: 40).offset(y:-2)
                                .foregroundColor(.black)
                            }
                        }.background(Color(.white)).cornerRadius(500)
                        
                        
                    }.padding(.horizontal, 20.0).offset(y:-60)
                }
                HStack{
                    ZStack{
                        
                        Text("Color")
                            .fontWeight(.light)
                            .foregroundColor(Color(.black))
                            .padding(.all, 15.0)
                            .cornerRadius(20)
                            .font(.custom("Helvetica Neue", size: 30))
                    }
                    Spacer()
                    ZStack{
                        Circle().foregroundColor(Color(.purple))
                            .frame(width: 32.0, height: 32.0)
                    }
                }.padding(.horizontal, 20.0)
                
                VStack{
                    Text("let alone used to indicate that something  far less likely or suitable than something  already mentioned: he was incapable of leading a bowling team,  alone a country. someone or something be stop interfering with someone or something:  him be—he knows what he wants.someone down gently")
                    
                }.padding(.horizontal)
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
}
struct SavedItemView_Previews: PreviewProvider {
    static var previews: some View {
        SavedItemView(imageName: "1")
    }
}



