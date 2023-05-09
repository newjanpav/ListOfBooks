//
//  DetailBookViewController.swift
//  ListOfBooks
//
//  Created by Pavel Shymanski on 2.05.23.
//

import UIKit

class DetailBookViewController: UIViewController {
    
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var titleBookLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var firstPublishDateLabel: UILabel!
    
    var detailBook : Doc?
    var indexOfBook: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetailBook()
        fetchImage()
    }
    
    
    func showDetailBook(){
        DispatchQueue.main.async { [self] in
            
            guard let book = self.detailBook else {return}
            
            guard let text = book.title else{
                self.titleBookLabel.text = "No title found"
                return}
            self.titleBookLabel.text = text
            
            guard let publishDate = book.first_publish_year else {
                self.firstPublishDateLabel.text = "publish year not found"
                return}
            self.firstPublishDateLabel.text = ("\(publishDate)")
            
            guard let ratingAverage = book.ratings_average else {
                self.averageRatingLabel.text = "average rating not found"
                return}
            self.averageRatingLabel.text = "average rating: \(ratingAverage)"
        }
    }
    
    func fetchImage() {
        if let coverEditionKey = detailBook?.cover_i {
            let imageUrl = "https://covers.openlibrary.org/b/id/" + "\(coverEditionKey)" + "-M.jpg"
            
            if let url = URL(string: imageUrl){
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    if let safeData = data {
                        let image = UIImage(data: safeData)
                        DispatchQueue.main.async {
                            self.imageBook.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.imageBook.image = UIImage(named: "not-found-image.jpeg")
                        }
                    }
                }
            }
        }
        else{self.imageBook.image = UIImage(named: "not-found-image.jpeg")}
    }
}
