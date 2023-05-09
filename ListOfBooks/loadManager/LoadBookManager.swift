//
//  loadBookManager.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 9.05.23.
//

import Foundation


class LoadBookManager {
    
    
    
    func fetchBook(nameBook: String, completionHandler: @escaping ([Doc]?)-> Void ) {
        
        var books: [Doc] = []
    
        guard let encodedNameBook = nameBook.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "https://openlibrary.org/search.json?q=" + "\(encodedNameBook)")else{
                  print("Invalid URL or encoded name book")
                  return}
        
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let safeData = data else { return }
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(BookObject.self, from: safeData)
                books = object.docs
                DispatchQueue.main.async {
                    completionHandler(books)
                }
            }
            catch let error {
                print("Error decoding JSON data: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}
                    
                    
                    
                  
                    
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
                           
        
                    
                    
                    
                    
                    
                    
                    
             
                
                
                
                
                
                
                
                
                
                
                
                
  
