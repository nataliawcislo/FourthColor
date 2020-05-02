//
//  StartMenuView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 29/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack{
            VStack{
               Image(systemName: "eye")
                .font(.system(size: 42, weight: .light))
                Text("Forth Color")
                .font(.custom("Helvetica Neue", size: 14))
            }.padding(.vertical, 5)
            Divider().background(Color.black)
            
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "house")
                        .font(.system(size: 20, weight: .light))

                    Text("Home")
                        .font(.custom("Helvetica Neue", size: 18))
                }.padding(.top, 30)
                
                HStack{
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .light))
                    Text("Recognise").font(.custom("Helvetica Neue", size: 18))
                }.padding(.top, 30)
                
                HStack{
                    Image(systemName: "heart")
                    .font(.system(size: 20, weight: .light))
                   Text("The best").font(.custom("Helvetica Neue", size: 18))
               }.padding(.top, 30)
                
                HStack{
                    Image(systemName: "book")
                     .font(.system(size: 20, weight: .light))

                    Text("Info").font(.custom("Helvetica Neue", size: 18))
                }.padding(.top, 30)
                
                Spacer()
                HStack{
                    Image(systemName: "gear")
                        .font(.system(size: 20, weight: .light))
                    Text("Setting").font(.custom("Helvetica Neue", size: 18))
                    Spacer()
                }.padding(.bottom, 30.0)
                
            }.padding(.leading, 20.0)
        }.padding(.top, 40.0)
        .background(Color("Color"))
        
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
