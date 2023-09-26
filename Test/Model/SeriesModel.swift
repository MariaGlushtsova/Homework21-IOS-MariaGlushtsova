//
//  SeriesModel.swift
//  Test
//
//  Created by Admin on 11.09.23.
//

import Foundation

struct Series: Decodable {
    let series: [JessicaJonesSeries]
}

struct JessicaJonesSeries: Decodable {
    let title: String
    let description: String
    let coverImageURL: URL?
}
