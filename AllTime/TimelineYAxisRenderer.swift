//
//  TimelineYAxisRenderer.swift
//  TimeKeep
//
//  Created by Mi Yan on 5/18/20.
//  Copyright © 2020 Darren Key. All rights reserved.
//

import Foundation
import Charts

class TimelineYAxisRender: YAxisRenderer{
 /// Sets up the axis values. Computes the desired number of labels between the two given extremes.
    @objc open override func computeAxisValues(min: Double, max: Double)
    {
        super.computeAxisValues(min: min, max: max)

        guard let axis = self.axis else { return }

        let labelCount = axis.labelCount
        let range = max - min

        // Ensure stops contains at least n elements.
        axis.entries.removeAll(keepingCapacity: true)
        axis.entries.reserveCapacity(labelCount)
        
        let lowestHour = Int((min/60).rounded(.down))
        let highestHour = Int((max/60).rounded(.up))
        
        let rangeHour = highestHour - lowestHour

        switch range {
        case 160..<600:
            for i in 0...2 * rangeHour{
                axis.entries.append(Double(i) * 30 + Double(lowestHour * 60))
            }
        case 50..<160:
            for i in 0...4 * rangeHour{
                axis.entries.append(Double(i) * 15 + Double(lowestHour * 60))
            }
        case 15..<50:
            for i in 0...12 * rangeHour{
                axis.entries.append(Double(i) * 5 + Double(lowestHour * 60))
            }
        case 0..<15:
            for i in 0...60 * rangeHour{
                axis.entries.append(Double(i) + Double(lowestHour * 60))
            }
        default:
            for i in 0...8{
                axis.entries.append(Double(i) * 180)
            }
        }
        
    }
}
