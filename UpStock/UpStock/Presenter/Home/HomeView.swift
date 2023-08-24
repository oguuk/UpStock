//
//  HomeView.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/26.
//

import UIKit

final class HomeView: UIView {
    
    private enum Constant {
        static let padding: CGFloat = 10
        static let textFieldHeight: CGFloat = 30
    }
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = Constant.textFieldHeight / 2
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOffset = CGSize(width: 0, height: 2)
        tf.layer.shadowRadius = 4
        tf.layer.shadowOpacity = 0.25

        let vacantView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
        tf.leftView = vacantView
        tf.leftViewMode = .always
        tf.rightView = vacantView
        tf.rightViewMode = .always

        return tf
    }()

    
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.register(StockListCell.self, forCellWithReuseIdentifier: Constant.stockListCellID)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        [textField, collectionView]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constant.padding),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.padding),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.padding),
            textField.heightAnchor.constraint(equalToConstant: Constant.textFieldHeight),
            
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constant.padding),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
