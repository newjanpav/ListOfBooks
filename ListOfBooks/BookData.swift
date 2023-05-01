//
//  BookData.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 25.04.23.
//

import Foundation
import UIKit



struct Book: Decodable {
    let book: [BookObect]
}
//
struct BookObect: Decodable {
//    let start: Int?
//    let numFound: Int?
    let docs: [Doc]

}
//
struct Doc : Decodable {
    let title: String?
    let author_name: [String]
    let cover_i: Int?
    

}




//struct Book: Decodable {
//    let title: String
//    let author_name: [String]?
//    let cover_i: String?
//}


