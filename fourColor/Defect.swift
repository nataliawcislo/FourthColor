//
//  Defect.swift
//  fourColor
//
//  Created by Natalia Wcisło on 08/04/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.

import Foundation
import SwiftUI

struct Defect: Identifiable {
    var id = UUID()
    let name: String
}

let defects: [Defect] = [
    Defect( name: "Deuteranomaly"),
    Defect(name: "Protanomaly"),
    Defect(name: "Protanopia"),
    Defect(name:"Deuteranopia"),
    Defect( name: "Tritanopia"),
    Defect( name: "Tritanomaly"),
    Defect(name: "Acromatopia"),
]

struct Defect_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
