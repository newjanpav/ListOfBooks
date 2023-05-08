//
//  BookData.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 25.04.23.
//

import Foundation
import UIKit



//struct Book: Decodable {
//    let book: [BookObject]
//}


struct BookObject: Decodable {
    let docs: [Doc]
}

struct Doc : Decodable {
    let title: String?
    let author_name: [String]?
    let cover_i: Int?
    let first_publish_year: Int?
    let ratings_average: Double?
    let subject_key: [String]?
}






