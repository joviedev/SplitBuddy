//
//  SplitEquallyView.swift
//  SplitBuddy
//
//  Created by Jovie on 28/8/2024.
//

import SwiftUI

/**
 A view where users select people to split the bill equally.

 `SplitEquallyView` displays a summary of the food items in the bill and the total cost (including tax). Users can add people who will split the bill equally, and the amount owed by each person is calculated based on the number of people and the total amount. This is the fourth step in the bill creation process.

 - Properties:
   - title: A `String` representing the bill title.
   - foodsList: A list of `Food` items in the bill.
   - peopleList: A list of `People` who will split the bill.
   - tax: A `Double` representing the tax percentage applied to the bill.
   - showNext: A state variable controlling the navigation to the next step.
   - showAddView: A state variable that presents a sheet to add a new person.
   - headIcon: A `String` representing the default head icon for a person.
   - peopleName: A `String` used to store the name of the person being added.
   - showAlert: A state variable controlling the display of an alert when no people are added.
 */

struct SplitEquallyView: View {
    let title : String/// The title of the bill. let title: String
    let foodsList: [Food]/// The list of food items in the bill.
    @State var peopleList: [People] = []/// The list of people who will split the bill equally.
    @Environment(\.dismiss) var dismiss/// Used to dismiss the view and return to the previous step.
    @State var showNext = false/// Controls navigation to the next step.
    @State var showAddView = false/// Controls the display of the add person sheet.
    @State var headIcon = "head1"/// The default icon for the head of a person.
    @State var peopleName = ""/// Stores the name of the person being added.
    
    @State var showAlert = false/// Controls the display of an alert when no people are added.
    var tax: Double/// The tax percentage applied to the total bill.
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            // Progress view showing that the user is on step 4 of 5.
            ProgressView(value: 4/5.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(themeColor1)
                
            
            Text("Step \(4): Select User")
                .font(.title)
            // Summary of food items and the tax applied.
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
                    
                    // Displays the total amount including tax.
                    HStack(content: {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2lf", foodsList.reduce(0, {$0+$1.price}) * (tax/100.0 + 1)))
                            .fontWeight(.bold)
                    })
                })
                .padding(15)
                .background(themeColor12)
                
                // Section to add more people to split the bill.
                HStack(content: {
                    Text("People Paying")
                    Spacer()
                    Button(action: {
                        showAddView.toggle()
                    }, label: {
                        Text("Add more")
                    })
                })
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                // Displays the list of people added.
                ForEach(0..<peopleList.count, id: \.self) { index in
                    HStack(alignment: .center, content: {
                        Image(peopleList[index].icon)
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                        Text(peopleList[index].name)
                            .frame(minWidth: 120, alignment: .leading)
                        
                        Text(String(format: "%.2lf", peopleList[index].price))
                            .layoutPriority(1000)
                        Spacer()
                        
                        // Button to remove a person from the list.
                        Button(action: {
                            peopleList.remove(at: index)
                        }, label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 20, height: 20)
                        })
                        
                    })
                    .frame(height: 35)
                }
            }
            BottomView// A view containing Back and Next buttons.
        })
        .padding(15)
        .navigationTitle(Text("Creat Bill"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
           setPrice()// Calculate the price each person has to pay.
        })
        .navigationDestination(isPresented: $showNext, destination: {
            BillResultView(title: title, foodsList: foodsList, peopleList: peopleList,tax: tax)
        })
        .sheet(isPresented: $showAddView, content: {
            // Present the AddPeopleView to add a new person to the list.
            AddPeopleView(peopleList: $peopleList) { imageName, name in
                var model = People(name: name, price: 0, icon: imageName)
                if peopleList.isEmpty {
                    model.selected = true
                }
                peopleList.append(model)
                setPrice()
            }
            
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Please add people"))
        })
    }
    
    /** Calculates the price each person has to pay based on the total bill and the number of people.

    This method divides the total bill (including tax) by the number of people to determine how much each person should pay. */
    
    func setPrice()  {
        let count = peopleList.count
        if count == 0 {
            return
        }
        let amount = foodsList.reduce(0, {$0+$1.price}) * (tax/100.0 + 1) / Double(count)
        for (index,_) in peopleList.enumerated() {
            peopleList[index].price = amount
        }
    }
    
    /** Validates if people have been added to the list before proceeding to the next step.

    If no people are added, an alert is shown. Otherwise, the view navigates to the next step. */
    
    func nextStep() {
        if self.peopleList.isEmpty {
            showAlert.toggle()
            return
        }
        
        showNext.toggle()
    }
    
    /** A view that contains "Back" and "Next" buttons to navigate between steps.

    The "Back" button dismisses the current view and returns to the previous step, while the "Next" button proceeds to the final bill result. */
    
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
            // Button to proceed to the next step.
            Button(action: {
                self.nextStep()
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
        SplitEquallyView(title: "cole",foodsList: [Food(name: "beef adsd ", price: 12.00),Food(name: "beef", price: 12.00),Food()], peopleList: [People(name: "lucy", price: 0, icon: "head1")],tax: 20)
    }
    
}


