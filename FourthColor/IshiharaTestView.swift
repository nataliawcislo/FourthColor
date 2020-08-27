//
//  IshiharaTestView.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 26/08/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct IshiharaTestView: View {
    let answer: String = "0"
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    ZStack{
                        Image("test1").resizable().scaledToFit()
                    }
                }
    
                HStack{
                    Text("Correct answer is: ").font(.custom("Helvetica Neue", size: 26)).foregroundColor(Color(.black))
                    Spacer()
                    Text(answer).font(.custom("Helvetica Neue", size: 26)).foregroundColor(Color(.black))
                }.padding(.top, 40.0).padding(.horizontal, 20)
                
            }.navigationBarTitle("What do you see?")
        }
    }
}

struct Ishihara_Previews: PreviewProvider {
    static var previews: some View {
        IshiharaTestView()
    }
}
