//
//  newbrightonMuralsParser.swift
//  New Brighton Murals
//
//  Created by Uxanaa Shashitharen on 26/11/2022.
//

import Foundation


struct newbrightonMuralsParser: Decodable {
    let newbrightonMurals: [Mural]

    enum CodingKeys: String, CodingKey {
        case newbrightonMurals = "newbrighton_murals"
    }
}
