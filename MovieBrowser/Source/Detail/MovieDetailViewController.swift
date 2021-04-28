//
//  MovieDetailViewController.swift
//  SampleApp
//
//  Created by Struzinski, Mark on 2/26/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailOverviewTextField: UITextView!
    
    @IBOutlet weak var detailReleaseDateLabel: UILabel!
    
    var selectedImage: UIImage?
    var selectedTitle: String?
    var selectedOverview: String?
    var selectedReleaseDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.detailTitleLabel.text = selectedTitle
        self.detailOverviewTextField.text = selectedOverview
        self.detailReleaseDateLabel.text = selectedReleaseDate
        
        self.detailImageView.image = selectedImage
        
    }

}
