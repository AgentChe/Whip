//
//  WhipsCollectionView.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class WhipsCollectionView: UICollectionView {
    private lazy var elements = [WhipsCollectionElement]()
    
    private lazy var didSelectTrigger = PublishRelay<WhipsCollectionElement>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WhipsCollectionView {
    func setup(elements: [WhipsCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<WhipsCollectionElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension WhipsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WhipsCollectionCell.self), for: indexPath) as! WhipsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WhipsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        didSelectTrigger.accept(element)
        
        if !element.needPayment {
            scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            elements.forEach { $0.marked = false }
            element.marked = true
            reloadData()
        }
    }
}

// MARK: Private
private extension WhipsCollectionView {
    func initialize() {
        register(WhipsCollectionCell.self, forCellWithReuseIdentifier: String(describing: WhipsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
