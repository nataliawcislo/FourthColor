//
//  Info.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 16/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct Info: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        VStack{
            
            VStack{
                ZStack{
                    Image("Deuteranomaly").resizable().frame(height: 180)
            
                
                    Button(action: {
                        // Navigate to the previous screen
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    }).offset(x:-165,y:-35)
                }
                ZStack{
                    Text("Deuteranomaly")
                        .fontWeight(.light)
                        .foregroundColor(Color(.black))
                        .padding(.all, 15.0)
                        .cornerRadius(20)
                        .font(.custom("Helvetica Neue", size: 30))
                }
                .padding(.vertical, 3)
                VStack{
                    Text("zdxfgchvjbknl")
                    
                }.padding(.horizontal)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info()
    }
}
