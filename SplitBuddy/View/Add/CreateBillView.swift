//
//  CreateBillView.swift
//  SplitBuddy
//
//  Created by Jovie on 28/8/2024.
//

import SwiftUI

/**
 A view where the user inputs items (foods) and tax information as part of the bill creation process.

 `CreateBillView` is the second step in creating a bill. It allows users to input multiple food items and their prices, along with a tax percentage. It displays the total calculated price and navigates to the next step for splitting the bill.

 - Properties:
   - title: A `String` representing the bill title passed from the previous step.
   - foodsList: A list of `Food` objects that represent the food items in the bill.
   - showNext: A boolean controlling navigation to the next step of the bill creation process.
   - showAlert: A boolean controlling whether to display an alert for validation errors.
   - alertText: The text to display in the alert when `showAlert` is triggered.
   - taxValue: The tax percentage input by the user.
 */

let themeColor1 : Color = Color(red: 76/255.0, green: 99/255.0, blue: 49/255.0)
let themeColor12 : Color = Color.init(red: 241/255.0, green: 255/255.0, blue: 211/255.0)

struct CreateBillView: View {
     var title : String/// The title of the bill passed from the previous step.
    @State var foodsList: [Food] = []/// A list of food items (Food) added to the bill.
    @Environment(\.dismiss) var dismiss/// Used to dismiss the view and return to the previous step.
    @State var showNext = false/// Controls navigation to the next step in the bill creation process.
    @State var showAlert = false/// Controls whether an alert should be shown for validation errors.
    @State var alertText = ""/// The text to display in the alert when there is a validation error.
    @State var taxValue = ""/// The tax percentage input by the user for the bill.
    
    var body: some View {
        // Progress view showing that the user is on step 2 of 5.
        VStack(alignment: .leading, spacing: 10, content: {
            ProgressView(value: 2/5.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(themeColor1)
            
            Text("Step \(2): Insert your items")
                .font(.title)
            
            // A scrollable list of food items added by the user.
            ScrollView {
                ForEach(0..<foodsList.count, id: \.self) { index in
                    FoodItemView(food: $foodsList[index], foodsList:$foodsList, index: index)
                }
            }
            
            // A horizontal stack for inputting the tax value.
            HStack(content: {
                Text("Tax")
                    .fontWeight(.bold)
                Spacer()
                TextField("tax", text: $taxValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                Text("%")
                    .fontWeight(.bold)
                
            }).padding(EdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 5))
            
            // A divider line to separate sections.
            Divider()
                .frame(height: 3)
                .background(themeColor1)
            
            // Displays the calculated total, including tax.
            HStack(content: {
               Text("Total")
                    .fontWeight(.bold)
               Spacer()
                Text(String(format: "%.2lf", foodsList.reduce(0, {$0+$1.price}) * ((Double(taxValue) ?? 0)/100.0 + 1)))
                    .fontWeight(.bold)
           })
            .padding(5)
           Spacer().frame(height: 10)
           BottomView// A custom view containing Back and Next buttons.
        })
        .navigationDestination(isPresented: $showNext, destination: {
            SplitMethodView(title:title,foodsList: foodsList,tax: Double(taxValue) ?? 0)
        })
        .padding(10)
        .navigationTitle(Text("Creat Bill"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Button to add a new food item to the list.
                Button(action: {
                    self.addFood()
                }, label: {
                    Text("+")
                        .font(.title)
                        .foregroundStyle(Color.black)
                })
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertText))
        })
     
    }
    
    /** A view that contains "Back" and "Next" buttons to navigate between steps.

    The "Back" button dismisses the current view, and the "Next" button navigates to the next step in the bill creation process. */
    
    var BottomView: some View {
        HStack(alignment: .center, content: {
            Spacer()
            // Button to go back to the previous step.
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
            Button(action: {
                // Button to validate inputs and navigate to the next step.
                nextStep()
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
    
    /** Adds a new Food item to the list with default values.

    This function appends an empty food item to the foodsList when the user taps the "+" button. */
    
    func addFood() {
        foodsList.append(Food(name: "", price: 0))
    }
    
    /** Validates the food items and tax value before navigating to the next step.

    This function checks if all food items have a name and a valid price. It also validates the tax value to ensure it's a positive percentage under 100. If validation passes, it navigates to the next step; otherwise, an alert is shown. */
    
    func nextStep() {
        // Validate the name and price of each food item.
        for (_,item) in foodsList.enumerated() {
            // Ensure that the list of food items is not empty.
            if item.name.isEmpty {
                showAlert.toggle()
                alertText = "Please input all input"
                return
            }
            if item.price <= 0 {
                showAlert.toggle()
                alertText = "Price is error"
                return
            }
        }
        if foodsList.count == 0 {
            showAlert.toggle()
            alertText = "Food is empty"
            return
        }
        
        // Validate the tax value.
        guard let tax = Double(taxValue),
        tax >= 0,
        tax < 100 else {
            showAlert.toggle()
            alertText = "Tax is error"
            return  }
        // Navigate to the next step if all validation passes.
        showNext.toggle()
    }
    
}

#Preview {
    NavigationStack {
        CreateBillView(title: "cole", foodsList:[Food(name: "beef", price: 12.00),Food(name: "beef", price: 12.00),Food()])
    }
    
}

