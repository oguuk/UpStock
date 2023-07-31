//
//  HomeView.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/26.
//

import UIKit

final class HomeView: UIView {
    
    private enum Constant {
        static let stockListCellID = "stockListCell"
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
