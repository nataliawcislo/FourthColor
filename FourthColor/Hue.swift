//
//  Hue.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 26/08/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct HueView: View {
    var body: some View {
        HStack{
            PuzzleView()
//            Spacer()
//            Puzzle()
        }.padding(.horizontal, 30)
    }
}

struct Hue_Previews: PreviewProvider {
    static var previews: some View {
        HueView()
    }
}
