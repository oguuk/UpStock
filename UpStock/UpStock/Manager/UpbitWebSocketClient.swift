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

extension UpbitWebSocketClient: WebSocketDelegate {

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
            self.send()
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            dataSubject.onNext(data)
        case .ping(_), .pong(_), .viabilityChanged(_), .reconnectSuggested(_), .cancelled:
            break
        case .error(let error):
            isConnected = false
            print("Error: \(error?.localizedDescription ?? "")")
            dataSubject.onError(error ?? NSError(domain: "", code: -1, userInfo: nil))
        }
    }
}
