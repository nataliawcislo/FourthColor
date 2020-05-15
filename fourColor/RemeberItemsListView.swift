//
//  RemeberItemsListView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 04/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct RemeberItemsListView: View {
    //let lista = ["", "", "", ""]
    var body: some View {
        ScrollView{
//            Text("Gallery")
//                .fontWeight(.light).font(.custom("Helvetica Neue", size: 40))
//                .padding(.top, 20.0)
           VStack{
               GridView()
           }.padding(.horizontal, 10.0)
        }
    }
}

struct RemeberItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        RemeberItemsListView()
    }
}


struct GridView: View {
    let col = 2
    var body: some View {
        var grid: [[Int]] = []
        _ = (1...listDonut.count).publisher
            .collect(col)
            .collect()
            .sink(receiveValue: { grid = $0 })
        return ForEach(0..<grid.count, id: \.self) { collect in
            HStack {
                ForEach(grid[collect], id: \.self) { number in
                    ZStack {
                        Image("\(number)").resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .cornerRadius(30)
                        NavigationLink(destination: RebemberItemView(image: Image("\(number)"))) {
                            Rectangle().hidden()
                        }
                    }
                }
            }
        }
    }
}


struct Donut : Identifiable  {
    var id = UUID()
    var color: String
    var image: Int
}

let listDonut: [Donut] = [
    Donut(color: "Donut_Animal", image: 1),
    Donut(color: "Donut_Blue",  image: 2),
    Donut(color: "Donut_BluePink",  image: 3),
    Donut(color: "Donut_Cat",  image: 4),
    Donut(color: "Donut_Christmas",  image: 5),
    Donut(color: "Donut_Color",  image: 6),
    Donut(color: "Donut_Colorfull",  image: 7 ),
    Donut(color: "Donut_Dark",  image: 8)]
   
