//
//  StockListCell.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/27.
//

import UIKit

final class StockListCell: UICollectionViewCell {
    
    lazy var change: UIImageView = {
        let view = UIImageView()
        view.sizeToFit()
        return view
    }()
    
    lazy var coinName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var market: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 8, weight: .light)
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var priceFluctuation: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    lazy var tradingVolume: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 8, weight: .light)
        return label
    }()
    
    lazy var fluctuationRate: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        change.image = nil
        coinName.text = nil
        change.image = nil
    }
