//
//  Information.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 18/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct Information: View {
       @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                   Text("Color blindness")
                    .fontWeight(.light).font(.custom("Helvetica Neue", size: 46))
                    .foregroundColor(Color("ColorCard"))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("ColorHStack")).padding(.top,30)
                }.padding(.bottom,20)
                    Text("Also called color recognition disorder, people are unable to see the differences between some or different colors, Blindness is a birth defect, genetically determined, recessively inherited in the X-linked conjugation. Because men do not pass their X chromosome to their male descendants, and then male dyed with blindness does not pass it on to his son. A woman with nearly two X chromosomes can carry the stained blindness gene without even realizing it.").fontWeight(.light).font(.custom("Helvetica Neue", size:18))
                        .foregroundColor(Color("ColorText"))
                        .padding(.horizontal)
                        .accessibility(identifier: "colorBlindnessInformation")
                VStack{
                    Image("test1").resizable().scaledToFit()
                    Image("test2").resizable().scaledToFit().padding(.vertical,5)
                    Image("test3").resizable().scaledToFit()
                }.padding(.top,20)
                
            }.padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.top)
        .navigationBarItems(leading:
            Button(action: {
                // Navigate to the previous screen
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            })
        )
    }
}

struct Information_Previews: PreviewProvider {
    static var previews: some View {
        Information()
    }
}
