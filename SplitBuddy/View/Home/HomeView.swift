//
//  HomeView.swift
//  SplitBuddy
//
//  Created by Jovie on 27/8/2024.
//

import SwiftUI
import SwiftData

/**
 The main home view of the application, displaying recent activity and quick navigation items.

 `HomeView` provides users with a summary of the most recent bill (if available) and offers navigation to other parts of the app such as creating a new bill, exchange rate conversion, and history. It uses `NavigationStack` and `ScrollView` for navigation and content display, and dynamically updates based on the current app state.

 - Properties:
   - modelContext: The SwiftData context used to fetch and manage `BillModel` data.
   - lastBill: The most recent bill, fetched from persistent storage.
   - tabIndex: A binding to the tab index used to control navigation between different tabs.
   - dataList: An array of `HomeModel` objects representing different home screen actions.
   - showAlert: A boolean used to control the display of the removal alert.
 
 - Example:
 ```swift
 HomeView(tabIndex: .constant(0))
    .modelContainer(for: BillModel.self, inMemory: true)
 */

struct HomeView: View {
    /// The data model context used for managing and fetching BillModel data.
    @Environment(\.modelContext) private var modelContext
    
    /// The most recent bill, fetched from the persistent data storage. Defaults to nil.
    @State var lastBill: BillModel?
    
    /// A binding to the current tab index, used for navigating between different app sections.
    @Binding var tabIndex: Int
    
    /// A list of HomeModel items representing different home screen actions, such as creating a bill or viewing exchange rates.
    @State var dataList = [HomeModel]()
    
    /// A boolean controlling the display of the removal confirmation alert.
    @State var showAlert = false
    var body: some View {
        NavigationStack {
            ScrollView {
                // Conditionally display the last bill or a placeholder message if no recent activity exists.
                if lastBill != nil {
                    lastView
                } else {
                    Text("No Recent Activity")
                        .font(.title)
                        .foregroundStyle(Color.gray)
                        .frame(height: 200)
                    
                }
                
                // Display four home action items if they exist in the dataList.
                if dataList.count == 4 {
                    // Navigation link to create a new bill.
                    NavigationLink(destination: InsertTitleView()) {
                        HomeItemView(homeModel: dataList[0])
                    }
                    
                    //2
                    // Navigation to the group tab on tap.
                    HomeItemView(homeModel: dataList[1])
                    .onTapGesture {
                        tabIndex = 1
                    }
                    
                    // Navigation link to the Exchange Rate page.
                    NavigationLink(destination: ExchangeRateMoreView()) {
                        HomeItemView(homeModel: dataList[2])
                    }
                   
                    // Navigation to the exchange rate tab on tap.
                    HomeItemView(homeModel: dataList[3])
                        .onTapGesture {
                            tabIndex = 2
                        }
                }

            }
            
            .navigationTitle(Text("Home"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                queryData()// Fetch the most recent bill data when the view appears.
            })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Tip"), message: Text("Are you sure remove it?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Sure"), action: {
                    removeLast()
                }))
                
            })
          
            
        }
        .task {
            var dataListTemp = [HomeModel]()
            let model1 = HomeModel(icon: "plus.app", title: "Create Bill", value: "Add your bill manualy")
            let model2 = HomeModel(icon: "arrow.left.arrow.right", title: "Rate Conversion", value: "Help you convert accurately")
            let model3 = HomeModel(icon: "dollarsign.circle", title: "Exchange Rates", value: "Can be paid in different currencies")
            let model4 = HomeModel(icon: "clock", title: "History", value: "To history")
            dataListTemp.append(model1)
            dataListTemp.append(model2)
            dataListTemp.append(model3)
            dataListTemp.append(model4)
            dataList = dataListTemp
        }
        
    }
    
    /** A view that displays the details of the most recent bill.

    This view provides details such as the total amount, the method of splitting the bill (equally or by item), and the people involved. It also includes options to view more details or remove the last bill.

    Returns: A VStack containing information about the last bill. */
    
    var lastView : some View {
        
        var totalAmount = 0.0
        let lastBill = lastBill!
        if lastBill.isEqually {
            totalAmount = lastBill.foods.reduce(0, {$0 + $1.price})
        } else {
            totalAmount = lastBill.peoples.reduce(0, {$0 + $1.price})
        }
        return VStack(alignment: .leading, spacing: 10, content: {
            Text("Last Activity")
                .font(.title)
                .frame(height: 40)
            Spacer().frame(height: 10)
            Text(lastBill.name)
            Text("Total Amount:$\(String(format: "%.2lf", totalAmount))")
            Text("Share Method: \(lastBill.isEqually ? "Equally" : "Pay By Item")")
            Text("People Involved: \(lastBill.peoples.count)")
            HStack(content: {
                CustomLayoutView(){
                    ForEach(0..<lastBill.peoples.count, id: \.self) { index in
                        Image(lastBill.peoples[index].icon)
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                            .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                .stroke(.white, lineWidth: 2))
                    }
                    
                }
                
                Spacer().layoutPriority(1000)
            })
            .frame(height: 50)
            
            HStack(content: {
                Spacer()
                Button(action: {
                    print("details")// Placeholder action for the details button.
                }, label: {
                    Text("Details")
                })
                .padding(.trailing, 10)
                Button(action: {
                    showAlert.toggle()// Toggle the alert for bill removal.
                }, label: {
                    Text("Remove")
                })
                .padding(.trailing, 20)
                .padding(.leading, 10)
            })
            .fontWeight(.medium)
            .foregroundStyle(Color.init(red: 82/255.0, green: 85/255.0, blue: 80/255.0))
        })
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(20)
        .font(Font.system(size: 18, weight: .regular))
        .background(themeColor12)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 12, height: 12)))
    }
    
    /** Fetches the most recent bill from the persistent data store.

    This method queries the data model for the most recent bill based on the date and assigns it to lastBill. If no bill is found, lastBill is set to nil. */
    
    func queryData() {
        let descriptor = FetchDescriptor<BillModel>(sortBy: [SortDescriptor(\BillModel.date, order: .reverse)])
        do {
            let results = try modelContext.fetch(descriptor)
            if let result = results.first {
                lastBill = result
            } else {
                lastBill = nil
            }
        } catch  {
            print(error.localizedDescription)
            
        }
    }
    
    /** Removes the most recent bill from the persistent data store.

    This method deletes the bill stored in lastBill and then fetches the updated data. */
    
    func removeLast()  {
        
        if lastBill != nil {
            modelContext.delete(lastBill!)
        }
        queryData()
        
    }
}

#Preview {
    HomeView(tabIndex: .constant(0))
        .modelContainer(for:BillModel.self,inMemory: true)
}

