//
//  SelectHeadView.swift
//  SplitBuddy
//
//  Created by Jovie on 29/8/2024.
//

import SwiftUI

/**
 A view that displays a grid of selectable images.

 `SelectHeadView` presents a collection of 20 images in a grid layout, where each image is tappable. When an image is tapped, the selected image's name is passed to an optional callback function, and the view is dismissed.

 This view uses SwiftUI's `LazyVGrid` to create an adaptive grid of images, and supports dismissing the view via the `@Environment(\.dismiss)` property when an image is selected.

 - Properties:
   - `imageList`: A list of image names to display, initialized with 20 placeholder images named "a1" to "a20".
   - `columns`: Defines the layout for the grid, with adaptive items that maintain a minimum size of 70x70.
   - `selectHander`: An optional callback that returns the selected image name when a user taps on an image.
   - `dismiss`: An environment variable to dismiss the current view.

 - Example:
 ```swift
 SelectHeadView(selectHander: { imageName in
     print("Selected image: \(imageName)")
 })

 */
struct SelectHeadView: View {
    /// A list of image names to display in the grid, initialized with placeholders "a1" through "a20".
    @State var imageList = Array(1...20).map({"a" + String($0)})
    //[String]()
    /// The layout configuration for the grid of images, with adaptive items that are 70x70 in size and spaced 10 points apart.
    let columns = [GridItem(.adaptive(minimum: 70, maximum: 70),spacing: 10)]
    /// An optional handler that is called when an image is selected, passing the selected image name.
    var selectHander : ((_ imageName: String) -> ())?
    /// An environment variable used to dismiss the current view
    @Environment(\.dismiss) var dismiss
    var body: some View {
        LazyVGrid(columns: columns, content: {
            // Loop through the `imageList` array and display each image in the grid.
            ForEach(0..<imageList.count, id: \.self) { index in
                // Display the image at the current index in the list.
                Image(imageList[index])
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .center)
                // Clip the image into a rounded rectangle with corner radii of 35 (circular shape).
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 35, height: 35)))
                // Add a tap gesture to handle image selection.
                    .onTapGesture {
                        // Call the optional selection handler, passing the selected image's name.
                        selectHander?(imageList[index])
                        // Dismiss the current view after the selection is made.
                        dismiss()
                    }
            }
        })
    }
}

#Preview {
    SelectHeadView()
}
