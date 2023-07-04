//
//  CurrencyViewModel.swift
//  TestConverter
//
//  Created by Nikita Velichko on 04/07/23.
//

import Foundation

class CurrencyViewModel: ObservableObject {
    @Published var amount = ""
    @Published var fromCurrency = "USD"
    @Published var toCurrency = "EUR"
    @Published var convertedAmount: Double?
    @Published var error: String?
    @Published var favoritePairs = [String]()
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "RUB"]
    
    func convert() {
        guard let amount = Double(amount) else {
            error = "Недопустимая сумма"
            return
        }
        
        CurrencyService.shared.convert(amount: amount, from: fromCurrency, to: toCurrency) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let convertedAmount):
                    self.convertedAmount = convertedAmount
                    self.error = nil
                case .failure(let error):
                    self.error = error.localizedDescription
                    self.convertedAmount = nil
                }
            }
        }
    }
    
    func addPair() {
        let pair = fromCurrency + "/" + toCurrency
        if !favoritePairs.contains(pair) {
            favoritePairs.append(pair)
        }
    }
    
    func selectPair(_ pair: String) {
        let currencies = pair.split(separator: "/")
        fromCurrency = String(currencies[0])
        toCurrency = String(currencies[1])
    }
}
