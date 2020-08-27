//
//  HueResultsView.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 27/08/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import SwiftUI

struct HueResultsView: View {
    let answer: String = "0"
    let result: String = "0"
    var body: some View {
        HStack{
            Text("Correct answer")
            Spacer()
            Text(answer)
        }.padding()
    }
}

struct ResultsHueView_Previews: PreviewProvider {
    static var previews: some View {
        HueResultsView()
    }
}
