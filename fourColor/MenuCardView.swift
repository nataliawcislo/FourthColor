//
//  MenuCard.swift
//  fourColor
//
//  Created by Natalia Wcisło on 12/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct MenuCard: View {
    var body: some View {
        VStack{
               ForEach(defects, id: \.id) { number in
                   ZStack{
                       NavigationLink(destination: RecognizeView()){
                          RoundedRectangle(cornerRadius: 20)
                           .foregroundColor(number.color)
                           .frame(width: 380, height: 180)
                           .shadow(color: Color("Color7"), radius: 3).opacity(1)
                           .overlay(Text(number.name).font(.custom("Helvetica Neue", size: 40)).foregroundColor(.white))
                           .contextMenu{
                               VStack{
                                   Button(action: {}){
                                       HStack{
                                           Text("Make First")
                                           Image(systemName: "star")
                                       }
                                   }
                               }
                           }
                       }
                   }.padding(2)
                }
          }.padding()
       }
}

struct MenuCard_Previews: PreviewProvider {
    static var previews: some View {
        MenuCard()
    }
}
