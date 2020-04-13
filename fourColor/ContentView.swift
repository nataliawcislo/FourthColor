//
//  ContentView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 08/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    
    @State  var scrollUp = false
    @State private var dragged = CGRect.zero
    
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack{
                    MenuCardView()
                }
                VStack{
                    Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.pink)
                    .padding(.top)
//                  TODO: przycisk przenoszaćy na początek listy
//                   .gesture(TapGesture().onEnded {_ in self.$dragged.toggle })
                }
                }.navigationBarTitle("Defect List")
            }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


