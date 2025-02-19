//
//  InsertTitleView.swift
//  SplitBuddy
//
//  Created by Jovie on 20/9/2024.
//

import SwiftUI

/**
 A view that allows the user to input a title for a bill as part of a multi-step process.

 `InsertTitleView` is the first step in creating a bill, where the user provides a title. The view features a `ProgressView` to show the current progress and includes a `TextField` for input. It also includes navigation to the next view (`CreateBillView`) once the title is provided.

 - Properties:
   - title: A `String` binding to store the user's input for the bill title.
   - showNext: A boolean controlling whether to navigate to the next step after the title is input.
   - showAlert: A boolean controlling the display of an alert when the user has not provided a title.
   - alertText: The text displayed in the alert when `showAlert` is triggered.
*/

struct InsertTitleView: View {
    @State var title = ""
    
    /// Controls whether to navigate to the next step (show the next view) after the title is input.
    @State var showNext = false
   
    /// Controls the display of an alert if the title is not provided.
    @State var showAlert = false
   
    /// The text that appears in the alert when `showAlert` is triggered.
    @State var alertText = ""
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10, content: {
            
            // Shows the progress of the step as 1/5th of the overall process.
            ProgressView(value: 1/5.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(themeColor1)// Custom tint for the progress bar.
            
            // Displays the current step.
            Text("Step \(1): Insert title")
                .font(.title)
            
            // A horizontal stack containing the text field for entering the bill title.
            HStack(content: {
                Spacer().frame(width: 10)// Adds padding to the left of the text field.
                TextField("type here", text: $title) // Text field where the user types the bill title.
                    .layoutPriority(999)
            })
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))// Padding around the text field.
            .background(Color(red: 232/255.0, green: 232/255.0, blue: 232/255.0)) // Light gray background color.
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))// Rounded corners.
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))// Additional padding.
            Spacer().frame(height: 30)// Adds space between the text field and the button.
            Spacer()// Pushes the content upwards.
            
            // A horizontal stack containing the "Next" button, which navigates to the next step.
            HStack(alignment: .center, content: {
                
                Button(action: {
                    nextStep()// Trigger the next step when the button is pressed.
                }, label: {
                    Text("Next")
                        .frame(width: 150, height: 40, alignment: .center) // Size of the button.
                        .background(themeColor1)// Background color for the button.
                        .foregroundStyle(Color.white)// Text color for the button.
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))// Rounded corners.
                })
            }).frame(maxWidth: .infinity)
            .padding(.bottom, 100)// Adds padding at the bottom of the view.
        })
        .navigationDestination(isPresented: $showNext, destination: {
            CreateBillView(title: title)// Navigates to `CreateBillView` if `showNext` is true.
                
        })
        .padding(10)// Adds padding around the main content.
        .navigationTitle(Text("Creat Bill"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)// Hides the tab bar in this view.
        
        // Shows an alert if `showAlert` is triggered.
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertText))// Displays the alert text.
        })
    }
    
    /**
     Handles navigation to the next step and validation of the title field.
     
     This method checks if the title has been input. If the title is empty, it triggers an alert. If the title is valid, it navigates to the next step by setting `showNext` to true.
     */
    
    func nextStep() {
        if title.isEmpty {
            showAlert.toggle()// Show alert if the title is empty.
            alertText = "Please input title"// Update the alert message.
            return
        }
        showNext.toggle()// Navigate to the next step if the title is valid.
    }
    
}

#Preview {
    InsertTitleView()
}
