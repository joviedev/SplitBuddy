//
//  ExchangeRatesTools.swift
//  SplitBuddy
//
//  Created by Jovie on 10/10/2024.
//

import Foundation

/**
 A utility class for fetching exchange rate data from the ExchangeRate API.

 This class provides methods to fetch the latest exchange rates for a given base currency. It uses a singleton pattern to ensure only one instance is shared across the app.
 */

let AllRateList = ["AUD","USD","GHS","SHP","TJS","DZD","MYR","MMK","NOK","TTD","GYD","LYD","SSP","TOP","AOA","GNF","SGD","PGK","KWD","BHD","TVD","MZN","BRL","GGP","ALL","XDR","XAF","UGX","ETB","ERN","HNL","SOS","RSD","LRD","HRK","CHF","SRD","UYU","KZT","JPY","HKD","EUR","LBP","TZS","JMD","JEP","CVE","UAH","GEL","XCD","OMR","ZAR","KMF","MVR","PAB","GMD","MKD","FOK","SDG","TND","HTG","DOP","AWG","LAK","PHP","RON","NGN","QAR","BGN","STN","BSD","CNY","BMD","NIO","AED","CDF","GTQ","MUR","IDR","RUB","IRR","THB","NPR","BZD","INR","KHR","KGS","ZMW","TWD","TMT","ARS","HUF","CAD","GBP","DKK","VES","FJD","AMD","BOB","COP","AZN","VND","MAD","SCR","ISK","SLL","ZWL","BAM","SLE","KYD","YER","BND","FKP","GIP","EGP","SAR","SYP","MRU","ILS","PLN","MNT","CZK","UZS","BIF","CUP","KRW","MXN","KID","IQD","SEK","PKR","USD","NZD","MOP","BBD","MGA","CLP","KES","MDL","LKR","TRY","BDT","RWF","IMP","WST","ANG","BTN","CRC","SBD","JOD","SZL","MWK","PYG","PEN","VUV","DJF","AFN","LSL","NAD","XPF","BWP","XOF","BYN"]

class ExchangeRatesTools {
    static let shared = ExchangeRatesTools()
    
    /// Private initializer to ensure only a single instance is used.
    init() {
        
        /**
         Fetches the latest exchange rates for the given base currency from the ExchangeRate API.

         This method makes an asynchronous network call to fetch the latest exchange rates. It returns the data in the completion handler, which provides either a dictionary of exchange rates or an error.

         - Parameters:
           - baseCurrency: The base currency for which exchange rates are required. Default is "USD".
           - completion: A closure that gets called with the result, either a success containing the exchange rate data or an error.
             - `Result<[String: Any], Error>`: The result type where a success returns a dictionary of exchange rates and a failure returns an error.

         - Important: Ensure you have network access when calling this function. The API key used here must be valid.

         */
    }
    
    func getExchangeRates(for baseCurrency: String = "USD", completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let apiKey = "817ad6381a4974576547cc76"// Replace this with a valid API key
        let urlString = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(baseCurrency)"
        // Validate the URL string
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a data task to fetch the exchange rates
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if data is received
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(noDataError))
                return
            }
            
            // Parse the received JSON data
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        
        // Start the network task
        task.resume()
    }

    // Example usage:
    
//    getExchangeRates(for: "USD") { result in
//        switch result {
//        case .success(let json):
//            print("Exchange Rate Data: \(json)")
//        case .failure(let error):
//            print("Error: \(error.localizedDescription)")
//        }
//    }
    
    
    
}
