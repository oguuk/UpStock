//
//  HomeViewController.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/25.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController, UIScrollViewDelegate {

    private var homeView = HomeView()
    private let disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    private var upbitReal: UpbitWebSocketClient?
    
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegateTableView()
        binding()
    }
    
    private func binding() {
        let input = HomeViewModel.Input(
            keyboard: homeView.textField.rx.text.orEmpty.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.stocks
            .drive(homeView.tableView.rx.items) { [weak self] tableView, index, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StockListCell.identifier, for: IndexPath(row: index, section: 0)) as? StockListCell else { return UITableViewCell() }
                cell.configure(ticker: item)
                cell.configureCandleImage(ticker: item)
                if let isRising = self?.viewModel.checkPrice(item: item) {
                    if isRising { cell.highlightPrice(isRising: true) }
                    else { cell.highlightPrice(isRising: false) }
                }
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func delegateTableView() {
        homeView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var isBookamark = false
        if let cell = tableView.cellForRow(at: indexPath) as? StockListCell, let market = cell.market.text {
            isBookamark = self.viewModel.isBookmark(market: market)
        }
        let customAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            if let cell = tableView.cellForRow(at: indexPath) as? StockListCell, let market = cell.market.text {
                isBookamark = self.viewModel.isBookmark(market: market)
                if isBookamark { self.viewModel.unBookmark(market: market) }
                else { self.viewModel.bookmark(market: market) }
            }
            completionHandler(true)
        }
        
        customAction.image = UIImage(systemName: "star.fill")?.withTintColor( isBookamark ? .yellow : .white, renderingMode: .alwaysOriginal)
        customAction.backgroundColor = .darkGray
        
        return UISwipeActionsConfiguration(actions: [customAction])
    }
}
