import Foundation
import Charts
#if !os(OSX)
import UIKit
#endif

// The original XAxisRender can result in overlapping labels on the
// x-axis (see https://github.com/danielgindi/Charts/issues/1969 ).
// This x-axis renderer will check if labels overlap and ignore drawing
// labels that overlap the previously drawn label.
class NoOverlappingLabelsXAxisRenderer: XAxisRenderer {
    public var shouldDrawBoundingBoxes = false
    public var labelSpacing = CGFloat(4.0)
    
    // Keep track of the previous label's rect
    private var previousLabelRect: CGRect?
    
    override func renderAxisLabels(context: CGContext) {
        previousLabelRect = nil
        super.renderAxisLabels(context: context)
    }
    
    //swiftlint:disable function_parameter_count
    override func drawLabel(context: CGContext, formattedLabel: String, x: CGFloat, y: CGFloat, attributes: [NSAttributedString.Key : Any], constrainedToSize: CGSize, anchor: CGPoint, angleRadians: CGFloat) {
        guard let axis = self.axis as? XAxis else { return }

        // determine label rect
        let labelRect = CGRect(x: x - (axis.labelWidth / 2), y: y, width: axis.labelWidth, height: axis.labelHeight)
        
        // check if this label overlaps the previous label
        if let previousLabelRect = previousLabelRect, labelRect.origin.x <= previousLabelRect.origin.x + previousLabelRect.size.width + labelSpacing {
            // yes, skip drawing this label
            return
        }
        
        // remember this label's rect
        self.previousLabelRect = labelRect
        
        // draw label
        super.drawLabel(context: context, formattedLabel: formattedLabel, x: x, y: y, attributes: attributes, constrainedToSize: constrainedToSize, anchor: anchor, angleRadians: angleRadians)
        
        // draw label rect for debugging purposes
        if shouldDrawBoundingBoxes {
            #if !os(OSX)
            // draw rect
            UIGraphicsPushContext(context)
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(0.5)
            context.addRect(labelRect)
            context.drawPath(using: .stroke)
            UIGraphicsPopContext()
            
            // draw line
            UIGraphicsPushContext(context)
            context.move(to: CGPoint(x: x, y: y))
            context.addLine(to: CGPoint(x: x, y: y - 4))
            context.setLineWidth(0.5)
            context.strokePath()
            UIGraphicsPopContext()
            #endif
        }
    }
    //swiftlint:disable function_parameter_count
}
