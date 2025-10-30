//
//  DisplayPicturesCollectionPresenter.swift
//  DromTest
//
//  Created by v.sklyarov on 29.10.2025.
//

import UIKit

protocol DisplayPicturesCollectionInteractorToPresenterProtocol: AnyObject {
    func notifyFetchedSuccess(id: String, image: UIImage)
    func notifyFetchedError(id: String)
}

protocol DisplayPicturesCollectionViewToPresenterProtocol: AnyObject {
    var modelsToShow: [PictureCollectionViewCellPresenter] { get }
    
    func generateModels()
    func getImage(for id: String)
    func removeItem(at index: Int)
}

final class DisplayPicturesCollectionPresenter {
     
    // MARK: - Properties
    
    private(set) var modelsToShow: [PictureCollectionViewCellPresenter] = []
    let interactor: DisplayPicturesCollectionPresenterToInteractorProtocol
    weak var view: DisplayPicturesCollectionPresenterToViewProtocol?
    
    // MARK: - Init
    
    init(interactor: DisplayPicturesCollectionPresenterToInteractorProtocol) {
        self.interactor = interactor
    }
}

// MARK: - DisplayPicturesCollectionInteractorToPresenterProtocol

extension DisplayPicturesCollectionPresenter: DisplayPicturesCollectionInteractorToPresenterProtocol {
    
    func notifyFetchedSuccess(id: String, image: UIImage) {
        guard let index = modelsToShow.firstIndex(where: { $0.id == id }) else { return }
        
        modelsToShow[index].image = image
        view?.updateCollectionCell(at: IndexPath(row: index, section: 0))
    }
    
    func notifyFetchedError(id: String) {
        notifyFetchedSuccess(id: id, image: UIImage(resource: .cat))
    }
    
}

// MARK: - DisplayPicturesCollectionViewToPresenterProtocol

extension DisplayPicturesCollectionPresenter: DisplayPicturesCollectionViewToPresenterProtocol {
    
    func generateModels() {
        modelsToShow = interactor.generateModels()
        view?.reloadCollectionView()
    }
    
    func getImage(for id: String) {
        // Загрузка стартует, когда у презентера ячейки совсем нет картинки(запуск приложения/pull to refresh)
        guard modelsToShow.first(where: {$0.id == id })?.image == nil else { return }
        interactor.loadImage(for: id)
    }
    
    func removeItem(at index: Int) {
        modelsToShow.remove(at: index)
    }
    
}
