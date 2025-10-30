//
//  DisplayPicturesCollectionAssembly.swift
//  DromTest
//
//  Created by v.sklyarov on 30.10.2025.
//

import Foundation

final class DisplayPicturesCollectionAssembly {
    
    static func build() -> DisplayPicturesCollectionViewController {
        let interactor = DisplayPicturesCollectionInteractor(fetchingImageService: FetchImageService.shared)
        let presenter = DisplayPicturesCollectionPresenter(interactor: interactor)
        interactor.presenter = presenter
        let viewController = DisplayPicturesCollectionViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
    
}
