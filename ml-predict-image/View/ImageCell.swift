//
//  ImageCell.swift
//  ml-predict-image
//
//  Created by Viktor Yamchinov on 14/06/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(_ image: UIImage) {
        imageView.image = image
    }
}
