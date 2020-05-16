//
//  HomeView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 02/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct HomeView: View {

 //   @State var attribute = CustomScrollAttribute()
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    MenuCardView()
                }.padding(.top, 20.0)
                VStack{
                    Button(action: {
                      //self.attribute.scrollToTop()
                    }){
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color("arrow"))
                    }.padding(.bottom, 40.0)
                }
            }
            }
        }
    }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



