//
//  BubbleModel.swift
//  SpeechBubbleSample
//
//  Created by Sharanya on 8/27/15.
//  Copyright (c) 2015 Sharanya. All rights reserved.
//

import Foundation
import UIKit

class BubbleModel :NSObject, NSCopying
{
    var primaryTailEndingPoint:CGPoint = CGPointMake(CGFloat(200.0), CGFloat(200.0))
    var secondaryTailEndingPoint:CGPoint = CGPointMake(CGFloat(100.0), CGFloat(200.0))

    var arcCentrePoint:CGPoint = CGPointMake(CGFloat(50.0), CGFloat(50.0))
    
    var arcPath:CGMutablePathRef = CGPathCreateMutable()
    var arcRadius:CGFloat = CGFloat(30)
    var scalePoint:CGPoint = CGPointMake(1.5, 1.0)
    var bubbleText:NSString = "Hello Bubble"
    var isBubbleSingleTailed:Bool = true
    
    required override init()
    {
        
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let bubbleModelCopy = self.dynamicType()
        
        bubbleModelCopy.primaryTailEndingPoint = self.primaryTailEndingPoint
        bubbleModelCopy.secondaryTailEndingPoint = self.secondaryTailEndingPoint
        bubbleModelCopy.arcCentrePoint = self.arcCentrePoint
        bubbleModelCopy.arcPath = self.arcPath
        bubbleModelCopy.arcRadius = self.arcRadius
        bubbleModelCopy.scalePoint = self.scalePoint
        bubbleModelCopy.bubbleText = self.bubbleText
        bubbleModelCopy.isBubbleSingleTailed = self.isBubbleSingleTailed
        
        return bubbleModelCopy
    }

    func scaledXRadius() -> CGFloat
    {
        return scalePoint.x * arcRadius
    }

    func scaledYRadius() -> CGFloat
    {
        return scalePoint.y * arcRadius
    }
}