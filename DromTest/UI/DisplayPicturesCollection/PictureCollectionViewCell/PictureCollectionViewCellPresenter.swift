//
//  PictureCollectionViewCellPresenter.swift
//  DromTest
//
//  Created by v.sklyarov on 29.10.2025.
//

import UIKit

final class PictureCollectionViewCellPresenter {
    
    // MARK: - Properties
    
    let id: String
    var image: UIImage? {
        didSet {
            if let image {
                cell?.updateImage(image)
            }
        }
    }
    weak var cell: PictureCollectionViewCell?
    
    // MARK: - Init
    
    init(id: String) {
        self.id = id
    }
    
}
