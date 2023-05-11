//
//  DataServices.swift
//  CryptoTracker
//
//  Created by Emre ÖZKÖK on 1.05.2023.
//

import Foundation
import Combine

class CoinDataService{
    
    @Published var allCoins: [CoinModel] = []
    private var coinSubscription: AnyCancellable?
    
    init(){
        downloadData()
    }
    
    private func downloadData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=350&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: decoder)
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: {[weak self] decodedCoins in
                guard let self = self else {return}
                self.allCoins = decodedCoins
                self.coinSubscription?.cancel()
            })
    }
}
