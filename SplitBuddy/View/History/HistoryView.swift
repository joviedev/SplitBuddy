//
//  HistoryView.swift
//  SplitBuddy
//
//  Created by Jovie on 20/9/2024.
//

import SwiftUI
import SwiftData

/**
 A view that displays the history of bills, showing either an equal split or a per-item split view for each bill.
 
 This view fetches historical bill data from the `modelContext` and displays it in a list. If no bill history is available,
 a placeholder message is shown. Bills are categorized based on the method of splitting (either equally or per item),
 and the corresponding views (`HistoryEqualItemView` and `HistoryPerItemView`) are used to display them.
 */

struct HistoryView: View {
    
    /// Accesses the environment's model context to fetch and manage the bill data.
    @Environment(\.modelContext) private var modelContext
    
    /// A state variable that holds the fetched list of bills.
    @State var datas: [BillModel] = []
    
  
    var body: some View {
        NavigationStack {
            VStack(content: {
            // Displays a message if the bill history is empty.
            if datas.count == 0 {
                Text("No History")
            } else {
            // Displays the list of bills. Depending on whether the method of splitting, either equally or per item, the corresponding view is used.
                List {
                    ForEach(0..<datas.count, id: \.self) { index in
                        if datas[index].isEqually {
                            HistoryEqualItemView(billModel: datas[index])
                        } else {
                            HistoryPerItemView(billModel: datas[index])
                        }
                    }
                }
            }
            })
            // Sets the navigation title of the view to "History" and displays it inline in the navigation bar.
            .navigationTitle(Text("History"))
            .navigationBarTitleDisplayMode(.inline)
        }
        // Fetches the data by executing `queryData()` when the view appears.
        .onAppear(perform: {
            queryData()
        })
        
    }
    
    /**
         Fetches the historical bill data from the model context.
         
         This function uses a `FetchDescriptor` to retrieve the bills from the model context,
         sorting them by date in reverse order. The results are stored in the `datas` state variable.
         If there is an error during fetching, it is logged to the console.
         */
    
    func queryData() {
        let descriptor = FetchDescriptor<BillModel>(sortBy: [SortDescriptor(\BillModel.date, order: .reverse)])
        do {
            let results = try modelContext.fetch(descriptor)
            
            self.datas = results
         
        } catch  {
            print(error.localizedDescription)
            
        }
    }
}

#Preview {
    /// Provides a preview of the `HistoryView` using an in-memory model container for testing.
    HistoryView()
        .modelContainer(for: BillModel.self,inMemory: true)

}
