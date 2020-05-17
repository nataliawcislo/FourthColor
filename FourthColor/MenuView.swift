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
                    .font(.system(size: 42, weight: .light)).padding(.top, 25)
                Text("Forth Color")
                    .font(.custom("Helvetica Neue", size: 14)).padding(.vertical, 10)
            }
            
            Divider().background(Color("ColorText"))
            
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "house")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(Color("ColorText"))
                    
                    Text("Home")
                        .font(.custom("Helvetica Neue", size: 18)).foregroundColor(Color("ColorText"))
                }.padding(.top, 30)
                
                HStack{
                    // NavigationLink(destination: RemeberItemsListView()){
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(Color("ColorText"))
                    Text("Recognise")
                        .font(.custom("Helvetica Neue", size: 18))
                        .foregroundColor(Color("ColorText"))
                }.padding(.top, 30)
                
                HStack{
                    NavigationLink(destination: SavedGridView()) {
                        HStack{
                            Image(systemName: "heart")
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(Color("ColorText"))
                            Text("The best")
                                .font(.custom("Helvetica Neue", size: 18))
                                .foregroundColor(Color("ColorText"))
                        }.navigationBarTitle("Grid")
                    }.padding(.top, 30)
                }
                
                HStack{
                    Image(systemName: "book")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(Color("ColorText"))
                    
                    Text("Info")
                        .font(.custom("Helvetica Neue", size: 18))
                        .foregroundColor(Color("ColorText"))
                }.padding(.top, 30)
                    
                Spacer()
                HStack{
                    Image(systemName: "gear")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(Color("ColorText"))
                    Text("Setting")
                        .font(.custom("Helvetica Neue", size: 18))
                        .foregroundColor(Color("ColorText"))
                    Spacer()
                    
                }
            }.padding(.leading, 20.0)
            
        }.padding(.vertical, 60.0)
            .background(Color("Color"))
            .edgesIgnoringSafeArea(.all)
        
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
