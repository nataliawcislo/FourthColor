//
//  MenuCard.swift
//  fourColor
//
//  Created by Natalia Wcisło on 12/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct MenuCardView: View {
    @State private var showInfo = false
    @State private var activeInfoDefect: Defect? = nil
    @State private var color = Color.yellow
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(defects, id: \.id) { defect in
                ZStack{
                    NavigationLink(destination: RecognizeView(defect: defect)){
                        RoundedRectangle(cornerRadius: 20)
                            .padding(.horizontal, -5.0)
                            .foregroundColor(Color("ColorCard"))
                            .frame(height: 200.0)
                            .shadow(color: Color(.black), radius: 1).opacity(1)
                            .overlay(Text(defect.name).fontWeight(.light).font(.custom("Helvetica Neue", size: 34)).foregroundColor(Color("ColorTextCard")))
                            .contextMenu {
                                VStack {
                                    Button(action: {
                                        withAnimation{
                                            self.showInfo.toggle()
                                            self.activeInfoDefect = defect
                                        }
                                    }){
                                        HStack{
                                            //TODO: przycisk  dodaj do ulubionych
                                            Text("Info")
                                            Image(systemName: "questionmark")
                                        }
                                        .sheet(isPresented: self.$showInfo) {
                                            Info(defect: self.activeInfoDefect!)
                                        }

                                    }
                                    
                                }
                                                                
                                
                        }.padding(2)
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
