//
//  PayPerItemView.swift
//  SplitBuddy
//
//  Created by Jovie on 20/9/2024.
//

import SwiftUI

/**
 A view that handles assigning payers for a list of food items in a bill.

 `PayPerItemView` allows users to add people to a bill and assign them to specific food items. It provides a step-by-step flow for selecting people, assigning them food items, and calculating the total price including tax. The view navigates to the result page after all food items are assigned to someone.

 - Properties:
   - `title`: The title of the bill being created.
   - `foodsList`: The list of food items to be split among the people.
   - `peopleList`: A list of people who will share the bill.
   - `tax`: A `Double` representing the tax percentage applied to the bill.
   - `showNext`: A state variable to control the navigation to the next step (results).
   - `showAddView`: A state variable that controls whether the view for adding a person is shown.
   - `showAlert`: A state variable to display validation alerts.
   - `selectedPeopleIndex`: The index of the currently selected person in `peopleList`.
   - `totalPrice`: The total amount to be paid, including tax.

 - Example:
 ```swift
 PayPerItemView(title: "Dinner", foodsList: [Food(name: "Steak", price: 20)], tax: 10.0)
 */

struct PayPerItemView: View {
    /// The title of the bill being created.
    let title : String
    /// A list of food items that need to be assigned to people.
    var foodsList: [Food] = []
    
    /// A list of people who will be assigned to the food items.
    @State var peopleList: [People] = []
    /// Access the environment's dismiss action for navigating back.
    @Environment(\.dismiss) var dismiss
    /// A state variable that controls navigation to the result view.
    @State var showNext = false
    /// A state variable that controls whether the "Add People" sheet is shown.
    @State var showAddView = false
    /// The default icon for the newly added person.
    @State var headIcon = "head1"
    /// The name of the person being added.
    @State var peopleName = ""
    /// A state variable that controls the display of alerts for validation.
    @State var showAlert = false
    /// The text to be displayed in the alert.
    @State var alertText = ""
    /// The index of the currently selected person.
    @State var selectedPeopleIndex:  NSInteger = -1
    /// The total amount for the bill, including tax.
    @State var totalPrice: Double = 0
    /// The tax percentage applied to the total price.
    var tax: Double
    
    /** Initializes the view with a title, a list of food items, and the tax percentage.
    The total price is calculated based on the sum of the food items and the tax.

    Parameters:
    title: The title of the bill.
    foodsList: The list of food items to be split.
    tax: The tax percentage applied to the total price.
    */
    
    init(title: String, foodsList: [Food],tax:Double) {
        self.title = title
        self.tax = tax
        let price = foodsList.reduce(0, {$0+$1.price})
        var temp = foodsList
        temp.append(Food(name: "Tax", price: price * tax/100.0))
        _totalPrice = State(initialValue: price  * (tax/100.0+1))
        print("totalPrice:\(totalPrice)")
        self.foodsList = temp
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            // Progress bar to indicate step 4 of 5 in the bill creation process.
            ProgressView(value: 4/5.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(themeColor1)
            
            // Step title.
            Text("Step \(4): Assign Payer")
                .font(.title)
            // Section for displaying the selected people and adding more.
            HStack {
                Text("People Selected")
                Spacer()
                Button(action: {
                    showAddView.toggle()
                }, label: {
                    Text("Add more")
                })
            }
            // A scrollable horizontal list of people, where each person can be selected.
            ScrollView(.horizontal) {
                
                HStack(content: {
                    
                    ForEach(0..<peopleList.count, id: \.self) { index in
                        VStack(content: {
                            Image(peopleList[index].icon)
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                            Text(peopleList[index].name)
                                .fontWeight(peopleList[index].selected ? .bold : .regular)
                                .foregroundStyle(peopleList[index].selected ? Color.black : Color.gray)
                            
                        }).frame(minWidth: 30, maxWidth: 100)
                            .onTapGesture {
                                for (i, _) in peopleList.enumerated() {
                                    peopleList[i].selected = false
                                }
                                peopleList[index].selected = true
                                selectedPeopleIndex = index
                            }
                    }
                }).frame(height: 60)
                    .padding()
            }
            
            // Display the selected person's items if a person is selected.
            if self.selectedPeopleIndex >= 0 {
                ScrollView {
                    HStack(content: {
                        Text("Selected item(s)")
                        Spacer()
                    })
                    VStack(content: {
                        ForEach(0..<peopleList[selectedPeopleIndex].foods.count, id: \.self) { index in
                            PayPerFoodView(food: peopleList[selectedPeopleIndex].foods[index])
                                // Toggle the 'selected' state of the food item when it is tapped.
                                // If the item is currently selected, it will become unselected, and vice versa.
                                .onTapGesture {
                                    peopleList[selectedPeopleIndex].foods[index].selected = !peopleList[selectedPeopleIndex].foods[index].selected
                                    
                        
                                }
                        }
                    })
                    .padding(15)
                    .padding(.bottom, 100)
                    .background(themeColor12)
                    
                    
                }
            }
            
            
            
            Spacer()
            Divider().frame(height: 4)
                .background(themeColor1)
            HStack(content: {
                // Display the total price.
                Text("Total")
                Spacer()
                Text(String(format: "%.2lf", totalPrice)).padding()
            })
            Spacer().frame(height: 30)
            BottomView
        })
        .padding(15)
        .navigationTitle(Text("Creat Bill"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
        })
        .onChange(of: self.peopleList.count, { oldValue, newValue in
            for (i, _) in peopleList.enumerated() {
                peopleList[i].selected = false
            }
            selectedPeopleIndex = self.peopleList.count - 1
            self.peopleList[selectedPeopleIndex].foods = self.foodsList
            self.peopleList[selectedPeopleIndex].selected = true
            
            peopleName = ""
            
            
        })
        .navigationDestination(isPresented: $showNext, destination: {
            PayPerResultView(title: title,peopleList: peopleList, totalPrice: totalPrice)
        })
        .sheet(isPresented: $showAddView, content: {
            AddPeopleView(peopleList: $peopleList) { imageName, name in
                var model = People(name: name, price: 0, icon: imageName)
                if peopleList.isEmpty {
                    model.selected = true
                }
                peopleList.append(model)
            }
            
        })
        
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text( alertText))
        })
        
    }
    /// The bottom view with "Back" and "Next" buttons.
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
            Button(action: {
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
    
    
    /** Validates the input and proceeds to the next step of the process.
    This function checks if there are any people added to the bill and if each food item is assigned to someone. If the checks pass, the view navigates to the result screen. 
    */
    func nextStep() {
        if self.peopleList.isEmpty {
            showAlert.toggle()
            alertText = "Please add people"
            return
        }
        
        for (_, food ) in self.foodsList.enumerated() {
            var isHad = false
            for(_, people) in self.peopleList.enumerated() {
                if  people.foods.contains(where: {$0.id == food.id && $0.selected == true}) {
                    isHad = true
                    break
                }
            }
            if isHad == false {
                showAlert.toggle()
                alertText = "Every product must be paid for by someone"
                return
            }
            
            
        }
        showNext.toggle()
    }
    
    
}

#Preview {
    NavigationStack {
        PayPerItemView(title: "cole",foodsList: [Food(name: "beef adsd ", price: 12.00),Food(name: "beef", price: 12.00)],tax: 20)
    }
    
}

/** A view that displays a food item with a selection indicator and price.

PayPerFoodView shows a food item in the form of a row with a checkbox (selected or unselected) and the food's name and price.

Properties:

food: A Food object representing the food item to be displayed.
*/
struct PayPerFoodView : View {
    //var index: NSInteger
    /// The food item to display.
    var food: Food
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 10, content: {
            // Display a checkmark based on whether the food is selected.
            if food.selected {
                Image(systemName: "checkmark.circle.fill" )
                    .foregroundStyle( Color.green)
            } else {
                Image(systemName:"checkmark.circle")
                    .foregroundStyle( Color.gray)
            }
            // Display the food's name.
            Text(food.name)
            Spacer()
            // Display the food's price.
            Text(String(format: "%.2lf", food.price))
        })
        .background(Color.clear)
        .padding(5)
        
        
        
    }
}
