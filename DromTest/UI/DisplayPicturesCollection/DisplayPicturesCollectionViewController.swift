//
//  DisplayPicturesCollectionViewController.swift
//  DromTest
//
//  Created by v.sklyarov on 29.10.2025.
//

import UIKit

private enum Constants {
    static let itemPadding: CGFloat = 10
    static let animationDuration: TimeInterval = 0.2
}

protocol DisplayPicturesCollectionPresenterToViewProtocol: AnyObject {
    func updateCollectionCell(at indexPath: IndexPath)
    func reloadCollectionView()
}

final class DisplayPicturesCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - Constants.itemPadding * 2,
                                 height: UIScreen.main.bounds.size.width - Constants.itemPadding * 2)
        layout.sectionInset = UIEdgeInsets(top: Constants.itemPadding, left: Constants.itemPadding, bottom: 0, right: Constants.itemPadding)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.reusableId)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    private let presenter: DisplayPicturesCollectionViewToPresenterProtocol
    
    // MARK: - Init
    
    init(presenter: DisplayPicturesCollectionViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ViewController lifecycle

extension DisplayPicturesCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter.generateModels()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - Constants.itemPadding * 2,
                                     height: UIScreen.main.bounds.size.width - Constants.itemPadding * 2)
    }
    
}

// MARK: - DisplayPicturesCollectionPresenterToViewProtocol

extension DisplayPicturesCollectionViewController: DisplayPicturesCollectionPresenterToViewProtocol {
    
    func updateCollectionCell(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
}

// MARK: - Private methods

private extension DisplayPicturesCollectionViewController {
    
    @objc
    func refresh() {
        refreshControl.beginRefreshing()
        presenter.generateModels()
        refreshControl.endRefreshing()
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
    }
    
    func setupConstraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
    
}

// MARK: - UICollectionViewDataSource

extension DisplayPicturesCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.modelsToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionViewCell.reusableId,
                                                            for: indexPath) as? PictureCollectionViewCell else {
            assertionFailure("Developer error. Cell must be created as PictureCollectionViewCell")
            return UICollectionViewCell()
        }
        let model = presenter.modelsToShow[indexPath.row]
        cell.presenter = model
        presenter.getImage(for: model.id)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PictureCollectionViewCell else { return }
        
        cell.checkAndToggleIndicator()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? PictureCollectionViewCell)?.stopActivityIndicator()
    }
    
}

// MARK: - UICollectionViewDelegate

extension DisplayPicturesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PictureCollectionViewCell, cell.presenter?.image != nil {
            UIView.animate(withDuration: Constants.animationDuration, animations: {
                cell.frame.origin.x = self.view.frame.width
                cell.layer.opacity = 0
            }, completion: { _ in
                collectionView.performBatchUpdates({
                    self.presenter.removeItem(at: indexPath.row)
                    collectionView.deleteItems(at: [indexPath])
                }, completion: nil)
            })
        }
    }
    
}
