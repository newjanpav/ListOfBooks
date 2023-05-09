//
//  BookData.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 25.04.23.
//

import Foundation


struct BookObject: Decodable {
    let docs: [Doc]
}


struct Doc : Decodable {
    let title: String?
    let cover_i: Int?
    let first_publish_year: Int?
    let ratings_average: Double?
   
}






