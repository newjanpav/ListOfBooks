//
//  ViewController.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 25.04.23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var serchBookTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let manager = LoadBookManager()
    var safeBooks: [Doc] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        serchBookTextField.delegate = self
        tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "CellBook")
        tableView.dataSource = self
        tableView.delegate = self
    }
}



extension ViewController :UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: Any) {
        serchBookTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        serchBookTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let book = serchBookTextField.text {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            manager.fetchBook(nameBook: book) { data in
                guard let safeData = data else {return}
                self.safeBooks = safeData
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension ViewController: UITableViewDataSource,
                          UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safeBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellBook", for: indexPath) as! TableViewCell
        let book = safeBooks[indexPath.row]
        
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
        let selectedBook  = safeBooks[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBookViewController")as! DetailBookViewController
        vc.detailBook = selectedBook
        vc.indexOfBook = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}







