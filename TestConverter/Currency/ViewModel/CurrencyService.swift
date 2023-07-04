//
//  CurrencyService.swift
//  TestConverter
//
//  Created by Nikita Velichko on 04/07/23.
//

import Foundation

class CurrencyService {
    static let shared = CurrencyService()
    
    private init() {}
    
    func convert(amount: Double, from fromCurrency: String, to toCurrency: String, completion: @escaping (Result<Double, Error>) -> Void) {
        let apiKey = "96d8ec3195799d2f4b95a812a0dadbe5"
        let url = URL(string: "https://api.exchangeratesapi.io/v1/convert?access_key=\(apiKey)&from=\(fromCurrency)&to=\(toCurrency)&amount=\(amount)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                if let conversionResult = try? JSONDecoder().decode(ConversionResult.self, from: data) {
                    completion(.success(conversionResult.result))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка при конвертации валют"])))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка при конвертации валют"])))
            }
        }.resume()
    }
}
