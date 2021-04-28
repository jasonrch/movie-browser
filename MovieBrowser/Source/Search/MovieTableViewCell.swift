//
//  MovieTableViewCell.swift
//  MovieBrowser
//
//  Created by Julio Reyes on 4/28/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import Foundation
import UIKit

// Initialize the cache for the image.
let imageCache = NSCache<NSString, UIImage>()

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieScoreLabel: UILabel!
    
    weak var movieImage: UIImage!
    
    var searchResults: Result? {
        didSet {
            setPosterImageAndCache()
            setMovieScoreWithAttributedText()
            
            movieTitleLabel.text = String(searchResults?.title ?? "")
            releaseDateLabel.text = "Release Date: \(searchResults?.releaseDate ?? "N/A")"
        }
    }
    
    private func setPosterImageAndCache(){
        // Initialize the image view
        movieImage = nil
        // Cache image and initialize all variables
        // Download image from the poster path and cache the image for future use. If an image was already downloaded, it will use the image cached instead.
        if let imagePosterPath = searchResults?.posterPath {
            let imageFullURLString = imageURLforCompactSize(imagePosterPath)
            
            if let image = imageCache.object(forKey:imageFullURLString as NSString) {
                movieImage = image
                return
            }
            
            guard let requestImageURL = URL(string: imageFullURLString) else { return }
            
            URLSession.shared.dataTask(with: URLRequest(url: requestImageURL)) { (data, response, err) in
                guard let data = data, err == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    imageCache.setObject(image!, forKey: imageFullURLString as NSString)
                    self.movieImage = image
                }
                }.resume()
        }
    }
    
    private func setMovieScoreWithAttributedText(){
        let movieScoreAttributedText = NSMutableAttributedString(string: "\(searchResults?.voteAverage ?? 0)  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        movieScoreAttributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, movieScoreAttributedText.string.count))
        
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(named: "starglyph")
        starAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
        movieScoreAttributedText.append(NSAttributedString(attachment: starAttachment))
        
        movieScoreLabel.attributedText = movieScoreAttributedText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
