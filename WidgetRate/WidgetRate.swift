//
//  WidgetRate.swift
//  WidgetRate
//
//  Created by Jovie on 11/10/2024.
//

import WidgetKit
import SwiftUI

/**
 A widget bundle that displays live exchange rates for a given base currency.

 `WidgetRate` fetches exchange rates from an API and displays the conversion rate from AUD to USD in a widget format. The widget updates every 2 hours and uses a timeline to ensure periodic refreshes. It supports medium and large widget sizes.

 - Structures:
   - `Provider`: A timeline provider responsible for fetching and updating exchange rates.
   - `SimpleEntry`: Represents a single timeline entry containing the exchange rate data.
   - `WidgetRateEntryView`: The view that displays the exchange rate information.
   - `WidgetRate`: The main widget structure responsible for configuring and displaying the widget.

 - Example:
 ```swift
 WidgetRate()
 */

struct Provider: TimelineProvider {
    //1
    /**
     Provides a placeholder entry used in the widget’s preview.

     - Parameter context: The widget’s context.
     - Returns: A `SimpleEntry` containing placeholder data for the widget.
     */
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),rateMsg: "wait...")
    }

   //2
    /**
     Provides a snapshot entry for the widget, typically used for previews or when the widget is being shown in the widget gallery.
     
     - Parameter context: The widget’s context.
     - Parameter completion: The closure that is called with the snapshot entry.
     */
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(date: Date(),rateMsg: "wait...")
        completion(entry)
    }

    //3
    /**
     Generates a timeline of entries for the widget by fetching exchange rates.
     
     The widget updates every 2 hours and retrieves live exchange rate data from the API.
     
     - Parameter context: The widget’s context.
     - Parameter completion: The closure that is called with the timeline of entries.
     */
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getExchangeRates { result in
            var msg = ""
            switch result {
            case .success(let json):
                print("Exchange Rate Data: \(json)")
                guard let result = json["result"] as? String else
                    {
                    return
                }
                if result != "success" {
                    msg = (json["error-type"] as? String) ?? "unknown-code"
                    return
                }
           
                if let conversion_rates = json["conversion_rates"] as? [String:Double],
                   let value = conversion_rates["USD"] {
                    
                    msg = String(format: "1AUD = %.2lfUSD", value)
                } else {
                    msg =  "unknown-code"
                }
                
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                msg = error.localizedDescription
            }
            
            // show 2 hours changes
           let entries = [SimpleEntry(date: Date(), rateMsg: msg)]
            let expireDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()
            let timeline = Timeline(entries: entries, policy: .after(expireDate))
            completion(timeline)
        }
//        let entries = [SimpleEntry(date: Date(), rateMsg: "1AUD = 0.67USD")]
//         let expireDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date()
//         let timeline = Timeline(entries: entries, policy: .after(expireDate))
//         completion(timeline)
    }
}

/** A structure representing a single timeline entry for the widget.
SimpleEntry contains the date and the exchange rate message to be displayed in the widget. 
 */
struct SimpleEntry: TimelineEntry {
    let date: Date
    let rateMsg: String
    
}

/** A view that displays the widget's exchange rate data.

WidgetRateEntryView displays the current exchange rate for AUD to USD along with the last update time. It fetches the exchange rate data using the Provider.
 */
struct WidgetRateEntryView : View {
    var entry: Provider.Entry
    @ObservedObject var rateVM = RateViewModel()
    var body: some View {
        VStack {
            HStack {
                Text("Last:")
                Text(entry.date, style: .time)
            }
            .padding(5)
            Text(entry.rateMsg)
                .foregroundStyle(Color.green).padding(0)

//            Link(destination: URL(string: "")!) {
//                Text("To Add Bill")
//            }
        }
        .padding(10)
        .background(Color.white)
    }
}

/** The main widget configuration for displaying exchange rate information.

WidgetRate defines the configuration for the widget, including supported sizes and the main view (WidgetRateEntryView). The widget updates every 2 hours and is available in medium and large sizes.
 */
struct WidgetRate: Widget {
    let kind: String = "WidgetRate"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetRateEntryView(entry: entry)
                    .containerBackground(.white, for: .widget)
                    //.containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetRateEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .supportedFamilies([.systemMedium,.systemLarge])
        .description("This is an example widget.")
    }
}


/** A view model that holds the current exchange rate and allows for observation and updates.

RateViewModel is used to store and observe the current exchange rate in real-time within the widget.
 */
class RateViewModel: ObservableObject {
    @Published var rate = 0.0
    
    init(rate: Double = 0.0) {
        self.rate = rate
        
    }
    
}


#Preview(as: .systemSmall) {
    WidgetRate()
} timeline: {
    SimpleEntry(date: .now, rateMsg: "wait...")
    SimpleEntry(date: .now, rateMsg: "wait...")
}


/** Fetches exchange rate data from an external API.

getExchangeRates makes an API call to fetch the latest exchange rate data for the specified base currency (default is "AUD").

Parameters:

baseCurrency: The base currency to fetch exchange rates for (default is "AUD").
completion: A closure that handles the result of the API call, containing either the fetched JSON data or an error.
 */

func getExchangeRates(for baseCurrency: String = "AUD", completion: @escaping (Result<[String: Any], Error>) -> Void) {
    let apiKey = "817ad6381a4974576547cc76"
    let urlString = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(baseCurrency)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
            completion(.failure(noDataError))
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(json))
            }
        } catch let jsonError {
            completion(.failure(jsonError))
        }
    }
    
    task.resume()
}
