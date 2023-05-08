//
//  ViewController.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 25.04.23.
//

import UIKit

class ViewController: UIViewController {
    
    var books: [Doc] = []
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier: "CellBook")
        tableView.dataSource = self
        tableView.delegate = self
        fetchBook()
    }
    
    
    func fetchBook() {
        
//        activityIndicator.startAnimating()
        
        let url = URL(string: "https://openlibrary.org/search.json?q=the+lord+of+the+rings")!
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let safeData = data else { return }
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(BookObject.self, from: safeData)
                self.books = object.docs
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    self.activityIndicator.stopAnimating()
                }
            } catch let error {
                
                print("Error decoding JSON data: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}





extension ViewController: UITableViewDataSource,
                          UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellBook", for: indexPath) as! TableViewCell
        let book = books[indexPath.row]
        
        if  let bookTitle = book.title , let firstPublishDate = book.first_publish_year {
            cell.title.text = bookTitle
            cell.firstPublishDate.text = "Published in \(firstPublishDate)"
        }
        if let coverEditionKey = book.cover_i {
            let imageUrl = "https://covers.openlibrary.org/b/id/" + "\(coverEditionKey)" + "-M.jpg"
            print("Loading image from URL: \(imageUrl)")
            
            if let url = URL(string: imageUrl){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    if let safeData = data {
                        let image = UIImage(data: safeData)
                        DispatchQueue.main.async {
                            cell.imageBook.image = image
                        }
                    }
                }
            }
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook  = books[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBookViewController")as! DetailBookViewController
        vc.detailBook = selectedBook
        vc.indexOfBook = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}







