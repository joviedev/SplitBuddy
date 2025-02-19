//
//  CustomLayoutView.swift
//  SplitBuddy
//
//  Created by Jovie on 30/8/2024.
//

import SwiftUI
/**
 A custom layout view that arranges its subviews in a horizontal layout with specified positions.

 `CustomLayoutView` is a custom layout using SwiftUI's `Layout` protocol. The layout positions subviews horizontally at a fixed distance from one another, starting from the middle of the container's width. It calculates the size and placement of each subview using the `sizeThatFits` and `placeSubviews` methods.

 - Functions:
   - `sizeThatFits`: Determines the size that fits the provided proposal for the subviews.
   - `placeSubviews`: Places each subview within the bounds of the layout container at specific coordinates.
 
 - Example:
 ```swift
 CustomLayoutView {
     ForEach(0..<5) { index in
         Text("Item \(index)")
     }
 }
*/

struct CustomLayoutView: Layout {
    
    /**
     Determines the size that fits the provided proposal for the subviews.
     
     - Parameters:
       - proposal: The proposed size for the layout's subviews.
       - subviews: The subviews to be laid out within the container.
       - cache: A placeholder for cached layout information (not used in this example).
     
     - Returns: A `CGSize` representing the size that fits the subviews based on the provided proposal.
     */
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    /**
     Places each subview within the layout container.

     The subviews are placed horizontally at a fixed distance of 30 units apart, starting from the middle of the container's width. The `placeSubviews` method adjusts the x and y coordinates to position the subviews within the layout's bounds.

     - Parameters:
       - bounds: The bounds of the layout container where the subviews will be placed.
       - proposal: The proposed size for the layout.
       - subviews: The subviews to be placed within the container.
       - cache: A placeholder for cached layout information (not used in this example).
     */
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for (index, subview) in subviews.enumerated() {
            // Calculate the initial position of the subview based on the index and space them 30 units apart.
            var point = CGPoint(x: 30 * index, y: 0)
                //.applying(CGAffineTransform(rotationAngle: 4))
            // Offset the x-coordinate by the mid-point of the container's width.
            point.x += bounds.midX
            // Set the y-coordinate to the minimum y-value of the bounds.
            point.y += bounds.minY
            // Print the calculated point (for debugging purposes).
            print(point)
            // Place the subview at the calculated position.
            subview.place(at: point, proposal: .unspecified)
         
        }
    }
    
}
