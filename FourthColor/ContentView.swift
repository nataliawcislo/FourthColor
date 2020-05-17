//
//  ContentView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 08/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//
import SwiftUI
import SwiftDrawer

struct ContentView: View {
    
    @State var showMenu = false
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    MenuCardView()
                }//.padding(.top, 20.0)
                
                VStack{
                    ScrollView{
                        HStack{
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color(.black))
                                    .frame(width: 160, height: 160)
                                    .shadow(color: Color(.black), radius: 3).opacity(1)
                                    .overlay(Text("Color Blindness").fontWeight(.light).font(.custom("Helvetica Neue", size: 24)).foregroundColor(Color("ColorTextCard")).multilineTextAlignment(.center))
                            }.padding(1)
                            
                            NavigationLink(destination: SavedGridView()) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .shadow(color: Color(.black), radius: 3).opacity(1)
                                        .overlay(Text("Gallery").fontWeight(.light).font(.custom("Helvetica Neue", size: 24)).foregroundColor(Color("ColorTextCard")).multilineTextAlignment(.center))
                                        .foregroundColor(Color(.black))
                                        .frame(width: 160, height: 160)
                                    
                                }.padding(1)
                                
                            }
                        }
                    }.padding(.vertical, 10.0)
                    
                    
                    VStack{
                        Button(action: {
                            //                           self.attribute.scrollToTop()
                        }){
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color(.purple))
                        }.padding(.bottom, 40.0)
                    }
                }.navigationBarTitle("Home")
                
                
            }
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


