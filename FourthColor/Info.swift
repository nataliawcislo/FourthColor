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
    
    var defect: Defect
    
    var body: some View {
        
        VStack{
            
            VStack{
                ZStack{
                    //image
                    Image(defect.image).resizable().frame(height: 180)
              
                }
                ZStack{
                    //name
                    Text(defect.name)
                        .fontWeight(.light)
                        .foregroundColor(Color(.black))
                        .padding(.all, 15.0)
                        .cornerRadius(20)
                        .font(.custom("Helvetica Neue", size: 30))
                }
                .padding(.vertical, 3)
                VStack{
                    //deskryptiom
                    Text(defect.description)
                    
                }.padding(.horizontal)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info(defect: defects[1])
    }
}
