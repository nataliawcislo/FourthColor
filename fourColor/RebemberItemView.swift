//
//  InfoView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 03/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct RebemberItemView: View {
    
    var body: some View {
        ScrollView(.vertical){
            
            VStack{
                //                Image("backgraund").resizable()
                //                    .cornerRadius(40).frame(maxHeight: kHeaderHeight)
                
                ZStack{
                   
                    GeometryReader { (geometry: GeometryProxy) in
                        
                        
                        Image("3").resizable()
                            .cornerRadius(40)
                            .aspectRatio(contentMode: .fill)
                            .offset(y: geometry.frame(in: .global).minY > 0 ? -geometry.frame(in: .global).minY : 0)
                            .frame(height: geometry.frame(in: .global).minY > 0 ? 400
                                
                                + geometry.frame(in: .global).minY : 400  )
                        
                    }.frame(height: 400)
                    
                    
                }.padding(.bottom, 40.0)
                
                
                
                
                
                ZStack{
                    Circle()
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .foregroundColor(Color("Color")).frame(width: 40, height: 40)
                    
                }.offset(x:140, y:-360)
                ZStack{
                Image(systemName: "square.and.arrow.up")
                                     .font(.system(size: 25, weight: .light))
                                     .foregroundColor(Color(.black))
                }.offset(x:140, y:-400)
                ZStack{
                    Text("Color")
                        .fontWeight(.light)
                        .foregroundColor(Color(.black))
                        .padding(.all, 15.0)
                        //.background(Color(.darkGray))
                        .cornerRadius(20)
                        .font(.custom("Helvetica Neue", size: 30))
                }
                VStack{
                    Text("let alone used to indicate that something  far less likely or suitable than something  already mentioned: he was incapable of leading a bowling team,  alone a country. someone or something be stop interfering with someone or something:  him be—he knows what he wants.someone down gently")
                    
                }.padding(.horizontal)
            }
        }.edgesIgnoringSafeArea(.top)
    }
    
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        RebemberItemView()
    }
}
