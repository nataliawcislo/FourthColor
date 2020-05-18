//
//  ContentView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 08/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    
    @State var showMenu = false
    @State private var showInfo = false
    
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false){
                
                
                MenuCardView()
                
                //.padding(.top, 20.0)
                
                VStack{
                    
                    HStack{
                        
                        ZStack{
                            Button(action: {  self.showInfo.toggle()})
                            {
                                RoundedRectangle(cornerRadius: 20)
                                    .padding(.horizontal, -5.0)
                                    .foregroundColor(Color("ColorHStack"))
                                    .frame(width: 170 ,height: 170)
                                    .shadow(color: Color("ColorHStack"), radius: 1).opacity(1)
                                    .overlay(Text("Color Blindness").fontWeight(.light).font(.custom("Helvetica Neue", size: 24)).foregroundColor(Color("ColorText")).multilineTextAlignment(.center))
                            }
                            .sheet(isPresented: self.$showInfo) {
                                Information()
                            }
                        }.padding(3)
                        
                        
                        NavigationLink(destination: SavedGridView()) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .shadow(color: Color("ColorHStack"), radius: 3).opacity(1)
                                    .overlay(Text("Gallery").fontWeight(.light).font(.custom("Helvetica Neue", size: 24)).foregroundColor(Color("ColorText")).multilineTextAlignment(.center))
                                    .foregroundColor(Color("ColorHStack"))
                                    .frame(width: 170 ,height: 170)
                                
                            }.padding(3)
                            
                        }
                        
                    }.padding(.vertical, 10.0)
                    
                    VStack{
                        Button(action: {
                            //                           self.attribute.scrollToTop()
                        }){
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color("arrow"))
                        }.padding(.bottom, 30.0)
                            .padding(.top, 20.0)
                    }
                }
                
            } .navigationBarTitle(Text("Home"))
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


