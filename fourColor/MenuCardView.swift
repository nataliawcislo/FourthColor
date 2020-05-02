//
//  MenuCard.swift
//  fourColor
//
//  Created by Natalia Wcisło on 12/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct MenuCardView: View {
    var body: some View {
        VStack(alignment: .leading){
               ForEach(defects, id: \.id) { number in
                   ZStack{
                       NavigationLink(destination: RecognizeView()){
                        RoundedRectangle(cornerRadius: 20)
                                .padding(.horizontal, -5.0)
                           .foregroundColor(Color(.black))
                                .frame(height: 180.0)
                           .shadow(color: Color("Color7"), radius: 3).opacity(1)
                           .overlay(Text(number.name).font(.custom("Helvetica Neue", size: 36)).foregroundColor(.white))
                           .contextMenu{
                               VStack{
                                   Button(action: {}){
                                       HStack{
//                                         TODO: przycisk  dodaj do ulubionych
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

struct MenuCardView_Previews: PreviewProvider {
    static var previews: some View {
        MenuCardView()
    }
}
