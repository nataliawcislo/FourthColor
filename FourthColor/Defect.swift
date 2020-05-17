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
    let description: String
    let image: String
    let filename: String
}

let defects: [Defect] = [
    Defect(name: "Deuteranomaly", description: "Deuteranomaly, caused by a similar shift in the green retinal receptors, is by far the most common type of color vision deficiency, mildly affecting red–green hue discrimination in 5% of European males. It is hereditary and sex-linked. In contrast to deuteranopia, the green-sensitive cones are not missing but malfunctioning.\n\nPeople with deuteranomaly are known as red-green colour blind and they generally have difficulty distinguishing between reds, greens, browns and oranges. They also commonly confuse different types of blue and purple hues.", image: "Deuteranomaly", filename: "colors_small"),
    Defect(name: "Protanomaly", description: "Protanomaly is a mild color vision defect in which an altered spectral sensitivity of red retinal receptors (closer to green receptor response) results in poor red–green hue discrimination. It is hereditary, sex-linked, and present in 1% of males. In contrast to other defects, in this case the L-cone is present but malfunctioning, whereas in protanopia the L-cone is completely missing.\n\nPeople with protanomaly are known as red-green colour blind and they generally have difficulty distinguishing between reds, greens, browns and oranges. They also commonly confuse different types of blue and purple hues.", image: "Protanomaly", filename: "colors_small"),
    Defect(name: "Protanopia", description: "Protanopia is caused by the complete absence of red retinal photoreceptors. Protans have difficulties distinguishing between blue and green colors and also between red and green colors. It is a form of dichromatism in which the subject can only perceive light wavelengths from 400 nm to 650 nm, instead of the usual 700 nm. Pure reds cannot be seen, instead appearing black; purple colors cannot be distinguished from blues; more orange-tinted reds may appear as dim yellows, and all orange–yellow–green shades of too long a wavelength to stimulate the blue receptors appear as a similar yellow hue. It is present in 1% of males.", image: "Protanopia", filename: "colors_protanopia"),
    Defect(name: "Deuteranopia", description: "Deuteranopia affects hue discrimination in a similar way to protanopia, but without the dimming effect. Again, it is found in about 1% of the male population.\n\nDeuteranopes are more likely to confuse mid-reds with mid-greens, blue-greens with grey and mid-pinks, bright greens with yellows, pale pinks with light grey, mid-reds with mid-brown, and light blues with lilac",image: "Deuteranopia", filename: "colors_small"),
    Defect(name: "Tritanopia", description: "Tritanopia is a very rare color vision disturbance in which only the red and the green cone pigments are present, with a total absence of blue retinal receptors. Blues appear greenish, yellows and oranges appear pinkish, and purple colors appear deep red. It is related to chromosome 7; thus unlike protanopia and deuteranopia, tritanopia and tritanomaly are not sex-linked traits and can be acquired rather than inherited and can be reversed in some cases.\n\nThe most common colour confusions for tritanopes are light blues with greys, dark purples with black, mid-greens with blues and oranges with reds.", image: "Tritanopia", filename: "colors_small"),
    Defect(name: "Tritanomaly", description: "Tritanomaly is a rare, hereditary color vision deficiency affecting blue–green and yellow–red/pink hue discrimination. It is related to chromosome 7.[17] In contrast to tritanopia, the S-cone is malfunctioning but not missing.\n\nWith tritanomaly, S-cones are present, but they are functionally limited. People see blues as greener and the colors yellow and red seem pink. With this type of color blindness, the intensity depends on the functionality of the S-cones.", image: "Tritanomaly", filename: "colors_small"),
    Defect(name: "Acromatopia", description: "A medical syndrome that exhibits symptoms relating to at least five conditions. The term may refer to acquired conditions such as cerebral achromatopsia, but it typically refers to an autosomal recessive congenital color vision condition, the inability to perceive color and to achieve satisfactory visual acuity at high light levels, typically exterior daylight. The syndrome is also present in an incomplete form which is more properly defined as dyschromatopsia. It is estimated to affect 1 in 30,000 live births worldwide.\n\nAside from a complete inability to see color, individuals with complete achromatopsia have a number of other ophthalmologic aberrations. Included among these optical aberrations are greatly decreased visual acuity (<0.1 or 20 in daylight, hemeralopia, nystagmus, and severe photophobia. The fundus of the eye appears completely normal.", image: "Acromatopia", filename: "colors_small"),
]
