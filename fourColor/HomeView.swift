//
//  HomeView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 02/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    @State private var verticalOffset: CGFloat = 0.0
    @State private var gestureOffset: CGFloat = 0.0
    @State private var itemCount: Int = 200
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    MenuCardView()
                }.padding(.top, 20.0)
                VStack{
                    Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color("arrow"))
//             Button("To top!") {
//                    withAnimation {
//                        self.verticalOffset = 0.0
//                    }
//                }
                .padding(.bottom, 30.0)
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
