//
//  UpbitWebSocketClient.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/28.
//
import Foundation
import RxSwift
import Starscream

final class UpbitWebSocketClient {
    
    enum Constant {
        static let webSocketURL = "wss://api.upbit.com/websocket/v1"
    }
    
    var request: String
    var socket: WebSocket
    var isConnected = false
    let dataSubject = PublishSubject<Data>()

    init(request: String) {
        self.request = request
        var request = URLRequest(url: URL(string: Constant.webSocketURL)!)
        request.timeoutInterval = 1
        self.socket = WebSocket(request: request)
        self.socket.delegate = self
    }

    func start() {
        self.socket.connect()
    }

    func stop() {
        self.socket.disconnect()
    }

    func send() {
        self.socket.write(string: self.request)
    }
}
