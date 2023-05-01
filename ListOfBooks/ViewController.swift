//
//  ViewController.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 25.04.23.
//

import UIKit

class ViewController: UIViewController {
    
    var books: [Book] = []
    
    @IBOutlet weak var tableView: UITableView!
    
  

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(BookEntityCell.self, forCellReuseIdentifier: "BookCell")
        fetchBook()
    }
    
    
    
    func  fetchBook() {
        
       
        let url = URL(string: "https://openlibrary.org/search.json?q=the+lord+of+the+rings")!
                
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let safeData = data else {return}
            do{
                let decoder = JSONDecoder()
                let bookObject = try decoder.decode(BookObect.self, from: safeData)
                
                self.books = bookObject["docs"] ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error{
                debugPrint(error)
                print("Error decoding JSON data: \(error.localizedDescription)")
                
            }
        }
        dataTask.resume()
    }
}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookEntityCell
        
        let book = books[indexPath.row]
        cell.title.text = book.title
        cell.authorName.text = book.author_name?.joined(separator: ", ")
        

        if let coverEditionKey = book.cover_i {
               let imageUrl = "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-M.jpg"
               if let url = URL(string: imageUrl) {
                   cell.bookImage.load(url: url)
               }
           }
           
           return cell
       }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
        
