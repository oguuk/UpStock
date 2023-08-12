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
    
    func configureUI() {
        [change, coinName, market,
         price, priceFluctuation, tradingVolume,
         fluctuationRate].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        [coinName, market].forEach {
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5 // Adjust as needed
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            change.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            change.centerYAnchor.constraint(equalTo: centerYAnchor),
            change.widthAnchor.constraint(equalToConstant: 10),
            change.heightAnchor.constraint(equalToConstant: 20),
            
            coinName.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 4),
            coinName.leftAnchor.constraint(equalTo: change.rightAnchor, constant: 4),
            
            market.topAnchor.constraint(equalTo: centerYAnchor, constant: 4),
            market.leftAnchor.constraint(equalTo: change.rightAnchor, constant: 4),
            
            fluctuationRate.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            fluctuationRate.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            priceFluctuation.rightAnchor.constraint(equalTo: rightAnchor, constant: -65),
            priceFluctuation.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            tradingVolume.topAnchor.constraint(equalTo: centerYAnchor),
            tradingVolume.trailingAnchor.constraint(equalTo: priceFluctuation.trailingAnchor),
            
            price.centerXAnchor.constraint(equalTo: centerXAnchor),
            price.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(ticker: WebsocketTickerResponse) {
        coinName.text = CoreDataManager.default.fetch(type: KRW.self)?.filter { $0.market == ticker.code }.first?.koreanName ?? ""
        if ticker.change == "RISE" {
            change.tintColor = .green
            priceFluctuation.textColor = .green
            fluctuationRate.textColor = .green
        } else if ticker.change == "FALL" {
            change.tintColor = .systemPink
            priceFluctuation.textColor = .systemPink
            fluctuationRate.textColor = .systemPink
        } else {
            change.tintColor = .gray
            priceFluctuation.textColor = .gray
            fluctuationRate.textColor = .gray
        }
        market.text = ticker.code
        price.text = ticker.tradePrice.formattedWithSeparator
        priceFluctuation.text = ticker.changePrice.formattedWithSeparator
        tradingVolume.text = "\(ticker.accTradePrice24H.toPercentage(3))"
        fluctuationRate.text = "\(ticker.signedChangeRate.toPercentage(2, 100))%"
    }
