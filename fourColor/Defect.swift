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
    let color: Color
}

let defects: [Defect] = [
    Defect( name: "Deuteranomaly", color: Color("Color1")),
    Defect(name: "Protanomaly", color: Color( "Color2")),
    Defect(name: "Protanopia", color: Color("Color3")),
    Defect(name:"Deuteranopia" , color: Color("Color4")),
    Defect( name: "Tritanopia", color: Color("Color5")),
    Defect( name: "Tritanomaly", color: Color("Color6")),
    Defect(name: "Acromatopia", color: Color("Color10")),
]
