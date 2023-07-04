//
//  CurrencyView.swift
//  TestConverter
//
//  Created by Nikita Velichko on 04/07/23.
//

import SwiftUI

struct CurrencyView: View {
    
    @ObservedObject var viewModel = CurrencyViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Конвертировать")) {
                    TextField("Сумма", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Из валюты", selection: $viewModel.fromCurrency) {
                        ForEach(viewModel.currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                    
                    Picker("В валюту", selection: $viewModel.toCurrency) {
                        ForEach(viewModel.currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
                
                Section(header: Text("Результат")) {
                    if let convertedAmount = viewModel.convertedAmount {
                        Text("\(convertedAmount, specifier: "%.2f") \(viewModel.toCurrency)")
                    } else if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Button(action: viewModel.convert) {
                    Text("Конвертировать")
                }
                
                Section(header: Text("Любимые валютные пары")) {
                    ForEach(viewModel.favoritePairs, id: \.self) { pair in
                        Button(action: { viewModel.selectPair(pair) }) {
                            HStack {
                                Text(pair)
                                Spacer()
                                if viewModel.fromCurrency + "/" + viewModel.toCurrency == pair {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    
                    Button(action: viewModel.addPair) {
                        Text("Добавить текущую пару")
                    }
                }
            }
            .navigationTitle("Конвертер валют")
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
