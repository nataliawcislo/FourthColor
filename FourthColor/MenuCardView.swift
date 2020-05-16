//
//  MenuCard.swift
//  fourColor
//
//  Created by Natalia Wcisło on 12/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct MenuCardView: View {
        @State private var isPresent = false
        @State private var color = Color.yellow
        
        var body: some View {
                VStack(alignment: .leading){
                        ForEach(defects, id: \.id) { number in
                                ZStack{
                                        NavigationLink(destination: RecognizeView()){
                                                RoundedRectangle(cornerRadius: 20)
                                                        .padding(.horizontal, -5.0)
                                                        .foregroundColor(Color(.black))
                                                        .frame(height: 250.0)
                                                        .shadow(color: Color(.black), radius: 3).opacity(1)
                                                        .overlay(Text(number.name).fontWeight(.light).font(.custom("Helvetica Neue", size: 34)).foregroundColor(.white))
                                                        .contextMenu{
                                                                VStack{
                                                                        Button(action: {
                                                                                                                       ZStack{
                                                                                Image(systemName: "star.fill" ).padding(.trailing, 10.0)
                                                                                        .font(.system(size: 35, weight: .light)).foregroundColor(self.color).offset(x:140, y:-50)
                                                                                }

                                                                        }){
                                                                                HStack{
                                                                                        //                                         TODO: przycisk  dodaj do ulubionych
                                                                                        Text("Make First")
                                                                                        Image(systemName: "star")
                                                                                }
                                                                        }
                                                                }
                                                                
                                                }.padding(2)
                                        }
                                        ZStack{
                                                Button(action: {
                                                        withAnimation{
                                                                self.isPresent.toggle()
                                                        }
                                                }) {
                                                        Image(systemName: "arrow.down.circle.fill")
                                                                .font(.system(size: 35, weight: .light)).foregroundColor(.purple).offset(x:140, y:65)
                                                        
                                                }
                                        }
                                }.padding()
                        }
                       
                }
        }
}

struct MenuCardView_Previews: PreviewProvider {
        static var previews: some View {
                MenuCardView()
        }
}
