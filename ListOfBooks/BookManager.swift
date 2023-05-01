//
//  DataLoader.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 25.04.23.
//

import Foundation

class BookManager {
    
    var books: [Book] = []
    
    
    func  fetchBook() {
        let urlString = "https://openlibrary.org/search.json?q=the+lord+of+the+rings"
        
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let safeData = data else {return}
            do{
                let decoder = JSONDecoder()
                let bookObject = try decoder.decode([String: [Book]].self, from: safeData)
                self.books = bookObject["docs"] ?? []
                DispatchQueue.main.async {
                    
                }
            }
            catch let error{
                print("Error serialization json", error)
            }
        }
        dataTask.resume()
    }
}


    
    
    
    
    
    

