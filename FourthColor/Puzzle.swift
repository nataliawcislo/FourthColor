//
//  Puzzle.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 26/08/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct PuzzleView: View {
    
    var body: some View {
        VStack(){
            ForEach(mycolors, id: \.id) { item in
                ZStack{
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(Color(item.name)).frame(width: 80, height: 80)
                        .shadow(color: Color(item.name), radius: 1).opacity(1)
                        .foregroundColor(Color(item.name))
                }.padding(.all, -3.0)
            }
        }
    }
}

struct Puzzle_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView()
    }
}


                   
                    
                    
