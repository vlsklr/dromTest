//
//  DisplayPicturesCollectionInteractor.swift
//  DromTest
//
//  Created by v.sklyarov on 29.10.2025.
//

import UIKit

protocol DisplayPicturesCollectionPresenterToInteractorProtocol: AnyObject {
    func generateModels() -> [PictureCollectionViewCellPresenter]
    func loadImage(for modelId: String)
}

// Решил сделать кэширование на период сессии, как хранение модельки(entity) в интеракторе, если бы хотел сделать постоянное хранение,
// то сохранял бы саму картинку в файлы, ссылку на картинку хранил бы модели, а модели бы хранил в CoreData

final class DisplayPicturesCollectionInteractor {
    
    // MARK: - Properties
    
    private var pictureItems: [PictureItem] = [
        PictureItem(id: UUID().uuidString,
                    url: "https://s12.auto.drom.ru/photo/v2/IOI0K_KwIeDLMVigAW-NxaHMHmfnik44X3i5Qo7aMaS8jQyCdyppDGbhxEtfNYuHzwE8XC01bLtCkgV-/gen1200.jpg"),
        PictureItem(id: UUID().uuidString,
                    url: "https://s12.auto.drom.ru/photo/v2/EeUi2PDk7_YRO-vBLn3w1BSDk5QxnFLoUTxG23dxVwq9mSGNak0OMBu7IZs60zgNEk6swSiuYO_1EtzQ/gen1200.jpg"),
        PictureItem(id: UUID().uuidString,
                    url: "https://s12.auto.drom.ru/photo/v2/D-9wQ7_vJjW6xIjcbaeNExAamEpIAAmd1ht9LnFOliBxveZR9boi56PTKnsJ5gn3-2nU9zZNQV3FOhPz/gen1200.jpg"),
        PictureItem(id: UUID().uuidString,
                    url: "https://s11.auto.drom.ru/photo/v2/cg8dJZDMeSR3k0JZN8ohsM3QYbeZVFsiE-W_2_N_4uOrEWlr6tmr24YumiDGs45WrFNTwPr-1cAiluDo/gen1200.jpg"),
        PictureItem(id: UUID().uuidString,
                    url: "https://s11.auto.drom.ru/photo/v2/kZoATB2ooxahBEJ2XSleA-i7IOKZobr_nN-ncWixpDyKC8XY1sDy_2e9_81PtaDWcIQGjagcdbwShxMW/gen1200.jpg"),
        PictureItem(id: UUID().uuidString,
                    url: "https://s12.auto.drom.ru/photo/v2/nNuvqUzbAiUeCXS4GHS8Yqz-sue_ZVf3zm5VPwG64P7_BNYEkrOITU31g-8mdtqX_jhBBXn8sktrf15k/gen1200.jpg")
    ]
    private let fetchingImageService: FetchImageServiceProtocol
    weak var presenter: DisplayPicturesCollectionInteractorToPresenterProtocol?
    
    // MARK: - Init
    
    init(fetchingImageService: FetchImageServiceProtocol) {
        self.fetchingImageService = fetchingImageService
    }
}

// MARK: - DisplayPicturesCollectionPresenterToInteractorProtocol

extension DisplayPicturesCollectionInteractor: DisplayPicturesCollectionPresenterToInteractorProtocol {
    
    func generateModels() -> [PictureCollectionViewCellPresenter] {
        let modelsToShow = pictureItems.map { PictureCollectionViewCellPresenter(id: $0.id) }
        return modelsToShow
    }
    
    func loadImage(for modelId: String) {
        guard let itemIndex = pictureItems.firstIndex(where: { $0.id == modelId }) else { return }
        fetchingImageService.fetchImage(from: pictureItems[itemIndex].url) { [weak self] result in
            guard let index = self?.pictureItems.firstIndex(where: { $0.id == self?.pictureItems[itemIndex].id ?? "" }) else { return }
            if case .success(let imageData) = result {
                self?.pictureItems[index].imageData = imageData
            }
            
            guard let imageData = self?.pictureItems[index].imageData,
                  let image = UIImage(data: imageData) else {
                DispatchQueue.main.async {
                    self?.presenter?.notifyFetchedError(id: self?.pictureItems[index].id ?? "")
                }
                return
            }
            DispatchQueue.main.async {
                self?.presenter?.notifyFetchedSuccess(id: self?.pictureItems[index].id ?? "", image: image)
            }
        }
    }
    
}
