//
//  SplitMethodView.swift
//  SplitBuddy
//
//  Created by Jovie on 28/8/2024.
//

import SwiftUI

/**
 A view that allows the user to select a method for splitting the bill—either equally or by items.

 `SplitMethodView` presents a summary of the food items in the bill, along with the total amount (including tax). Users can choose between splitting the bill equally among participants or paying per item. The view navigates to the next step based on the selected method.

 - Properties:
   - title: A `String` representing the bill title.
   - foodsList: A list of `Food` items included in the bill, filtered to exclude items without a name or price.
   - tax: A `Double` representing the tax percentage applied to the bill.
   - checkIndex: A `State` variable controlling which split method is selected (0 for equal, 1 for per item).
   - showNext: A `State` boolean that controls the navigation to the next step.
 */

struct SplitMethodView: View {
     var title : String/// The title of the bill passed from the previous step.
    var foodsList: [Food] = []/// A list of Food items in the bill, excluding items with empty names or zero prices.
    @Environment(\.dismiss) var dismiss/// Used to dismiss the current view and return to the previous step.
    @State var showNext = false/// Controls whether to navigate to the next step in the split process.
    var tax: Double/// The tax percentage applied to the total bill.
    init(title: String, foodsList: [Food], tax:Double) {
        self.title = title
        self.foodsList = foodsList.filter({$0.name.count > 0 && $0.price > 0 })
        self.tax = tax
    }
    /// A state variable to track which split method is selected (0 for equally, 1 for per item).
    @State var checkIndex = 0
    
    // Progress view showing that the user is on step 3 of 5.
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            ProgressView(value: 3/5.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(themeColor1)
            
            Text("Step \(3): Split Method")
                .font(.title)
            
            // A scrollable section summarizing the food items and tax applied.
            ScrollView {
                
                VStack(alignment: .leading,spacing: 10 ,content: {
                    Text("Summary: Aru Melbourne")
                    // Lists the food items with their prices.
                    ForEach(0..<foodsList.count, id: \.self) { index in
                        HStack(alignment: .top, content: {
                            Text(foodsList[index].name)
                            Spacer()
                            Text(String(format: "%.2lf", foodsList[index].price))
                        })
                    }
                    
                    Spacer().frame(height: 10)
                    // Displays the tax percentage.
                    HStack(content: {
                        Text("Tax")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2lf%%", tax))
                            .fontWeight(.bold)
                    })
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                })
                .padding(15)
                .background(themeColor12)
                
                
                Divider()
                    .frame(height: 3)
                    .background(themeColor1)
                // Displays the total cost with tax applied.
                HStack(content: {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(format: "%.2lf", foodsList.reduce(0, {$0+$1.price}) * (tax/100.0 + 1)))
                        .fontWeight(.bold)
                })
                .padding(10)
                
                // Option to split the bill equally.
                HStack(content: {
                    Text("SPLIT EQUALLY")
                    Spacer()
                    //
                    Image(systemName: checkIndex == 0 ? "checkmark.circle.fill" : "checkmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundStyle(checkIndex == 0 ? Color.green : Color.gray)
                })
                .frame(height: 30)
                .padding(10)
                .background(themeColor12)
                .onTapGesture {
                    checkIndex = 0
                }
                
                // Option to pay per item.
                HStack(content: {
                    Text("PAY PER ITEMS")
                    Spacer()
                    Image(systemName: checkIndex == 1 ? "checkmark.circle.fill" : "checkmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundStyle(checkIndex == 1 ? Color.green : Color.gray)
                })
                .frame(height: 30)
                .padding(10)
                .background(themeColor12)
                .onTapGesture {
                    checkIndex = 1
                }
            }
            
            BottomView// A view containing Back and Next buttons.
            
        })
        .padding(15)
        .navigationTitle(Text("Creat Bill"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showNext, destination: {
            if checkIndex == 0 {
                SplitEquallyView(title: title,foodsList: foodsList,tax: tax)
            } else {
                PayPerItemView(title: title,foodsList: foodsList,tax: tax)
            }
        })
        
    }
    
    /** A view that contains "Back" and "Next" buttons to navigate between steps.

    The "Back" button dismisses the current view and returns to the previous step, while the "Next" button moves forward in the bill splitting process. */
    
    var BottomView: some View {
        HStack(alignment: .center, content: {
            Spacer()
            Button(action: {
                dismiss()
            }, label: {
                Text("Back")
                    .frame(width: 150, height: 40, alignment: .center)
                    .background(Color(red: 207/255.0, green: 214/255.0, blue: 200/255.0))
                    .foregroundStyle(Color.black)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            })
            
            Spacer().frame(width: 15)
            // Button to navigate to the next step.
            Button(action: {
                showNext.toggle()
            }, label: {
                Text("Next")
                    .frame(width: 150, height: 40, alignment: .center)
                    .background(themeColor1)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
            })
            Spacer()
        })
    }
}

#Preview {
    NavigationStack {
        SplitMethodView(title: "cole",foodsList: [Food(name: "beef扩大好看的哈师大哈市很大会尽快大豪科技啊合适的话喀什还是", price: 12.00),Food(name: "beef", price: 12.00),Food()],tax: 10.0)
    }
    
}
