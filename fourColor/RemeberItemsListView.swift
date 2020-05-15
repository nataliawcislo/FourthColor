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
        NavigationView {
           List{
               GridView()
           }.navigationBarTitle("Donut Gallery Grid")
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
                        Image("\(number)").resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .cornerRadius(30)
                }
            }
        }
    }
}


struct Donut : Identifiable  {
    var id = UUID()
    var name: String
    var image: Int
}

let listDonut: [Donut] = [
    Donut(name: "Donut_Animal", image: 1),
    Donut(name: "Donut_Blue",  image: 2),
    Donut(name: "Donut_BluePink",  image: 3),
    Donut(name: "Donut_Cat",  image: 4),
    Donut(name: "Donut_Christmas",  image: 5),
    Donut(name: "Donut_Color",  image: 6),
    Donut(name: "Donut_Colorfull",  image: 7 ),
    Donut(name: "Donut_Dark",  image: 8)]
   
