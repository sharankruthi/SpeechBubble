//
//  SpeechBubbleView.swift
//  SpeechBubbleSample
//
//  Created by Sharanya on 8/24/15.
//  Copyright (c) 2015 Sharanya. All rights reserved.
//

import UIKit

enum PartToBeMoved
{
    case Arc
    case PrimaryTail
    case SecondaryTail
}


class SpeechBubbleView: UIView
{
    // MARK: Properties
    // MARK: Draw Rect Methods
    
    var arcsArray = [BubbleModel]()
    
    let shadow:UIColor = UIColor.blackColor().colorWithAlphaComponent(0.80)
    let shadowOffset = CGSizeMake(2.0, 2.0)
    let shadowBlurRadius: CGFloat = 5
    let π = CGFloat(M_PI)
    var partToBeMoved:PartToBeMoved?
    

    var currentSpeechBubble:BubbleModel?
    
    // MARK:
    // MARK: Draw Rect Methods
    
    override func drawRect(rect: CGRect) {
        
        for bubbleModel in arcsArray
        {
            drawSingleBubble(bubbleModel)
        }
    }
    
    func drawSingleBubble(currentSpeechBubbleModel:BubbleModel)
    {
        // Add arc when drawn without transformation will result in circular path. When transformed will be elliptical path.
        
        var scaleTransformationMatrix:CGAffineTransform = CGAffineTransformMakeScale(currentSpeechBubbleModel.scalePoint.x,currentSpeechBubbleModel.scalePoint.y);
        
        let context = UIGraphicsGetCurrentContext()
        
        var speechBubblePath = CGPathCreateMutable()
        
        let startArcAngle = getStartAngle(currentSpeechBubbleModel)
        
        var endArcAngle = startArcAngle + ((11 * π) / 6)
        
        if(!currentSpeechBubbleModel.isBubbleSingleTailed)
        {
            endArcAngle = startArcAngle + ((5 * π) / 3)
        }
        
        if(endArcAngle > (2 * π))
        {
            endArcAngle -= (2 * π)
        }
        
        CGPathAddArc(speechBubblePath, &scaleTransformationMatrix, currentSpeechBubbleModel.arcCentrePoint.x, currentSpeechBubbleModel.arcCentrePoint.y, currentSpeechBubbleModel.arcRadius, startArcAngle, endArcAngle, false)
        
        currentSpeechBubbleModel.arcPath = CGPathCreateMutableCopy(speechBubblePath)
        
        CGContextSetShadowWithColor(context,
            shadowOffset,
            shadowBlurRadius,
            shadow.CGColor)
        
        CGPathAddLineToPoint(speechBubblePath, nil, currentSpeechBubbleModel.primaryTailEndingPoint.x, currentSpeechBubbleModel.primaryTailEndingPoint.y)
        
        if(!currentSpeechBubbleModel.isBubbleSingleTailed)
        {
            CGPathAddArc(speechBubblePath, &scaleTransformationMatrix, currentSpeechBubbleModel.arcCentrePoint.x, currentSpeechBubbleModel.arcCentrePoint.y, currentSpeechBubbleModel.arcRadius,startArcAngle + ((5 * π) / 4) , startArcAngle + ((11 * π) / 6), false)
            
            CGPathAddLineToPoint(speechBubblePath, nil, currentSpeechBubbleModel.secondaryTailEndingPoint.x, currentSpeechBubbleModel.secondaryTailEndingPoint.y)
        }
        CGContextAddPath(context, speechBubblePath)
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        
        CGContextFillPath(context)
        
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        
       (currentSpeechBubbleModel.bubbleText).drawInRect(CGRectMake((currentSpeechBubbleModel.arcCentrePoint.x * currentSpeechBubbleModel.scalePoint.x)-15, (currentSpeechBubbleModel.arcCentrePoint.y * currentSpeechBubbleModel.scalePoint.y)-15, currentSpeechBubbleModel.scaledXRadius(), currentSpeechBubbleModel.scaledYRadius()), withAttributes: nil)
        
    }
    
    // MARK:
    // MARK: Touches Events
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        var pointTouched:CGPoint = CGPoint()
        if let touch = touches.first as? UITouch
        {
             pointTouched = touch.locationInView(self)
            
            for bubbleModel in arcsArray
            {
                if(CGPathContainsPoint(bubbleModel.arcPath, nil, pointTouched, false))
                {
                    partToBeMoved = .Arc
                    currentSpeechBubble = bubbleModel
                }
                else if(CGRectContainsPoint(CGRectMake(bubbleModel.primaryTailEndingPoint.x-20, bubbleModel.primaryTailEndingPoint.y-20, 40, 40), pointTouched))
                {
                    partToBeMoved = .PrimaryTail
                    currentSpeechBubble = bubbleModel
                }
                else if(CGRectContainsPoint(CGRectMake(bubbleModel.secondaryTailEndingPoint.x-20, bubbleModel.secondaryTailEndingPoint.y-20, 40, 40), pointTouched))
                {
                    partToBeMoved = .SecondaryTail
                    currentSpeechBubble = bubbleModel
                }
            }
            
            
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        var pointTouched:CGPoint = CGPoint()
        if let touch = touches.first as? UITouch
        {
            pointTouched = touch.locationInView(self)

            if(currentSpeechBubble != nil)
            {
                if(partToBeMoved == .Arc)
                {
                    let xCoordinate:CGFloat = pointTouched.x/currentSpeechBubble!.scalePoint.x
                    
                    if(isxCoordinateInsideFrameForArc(currentSpeechBubble!, withXcoordinate: pointTouched.x) && isyCoordinateInsideFrameForArc(currentSpeechBubble!, yCoordinate: pointTouched.y))
                    {
                        currentSpeechBubble!.arcCentrePoint = CGPointMake(xCoordinate, pointTouched.y)
                        setNeedsDisplay()
                    }
                }
                else if(partToBeMoved == .PrimaryTail)
                {
                    if(isxCoordinateInsideFrameForTail(pointTouched.x) && isyCoordinateInsideFrameForTail(pointTouched.y))
                    {
                        currentSpeechBubble!.primaryTailEndingPoint = pointTouched
                        setNeedsDisplay()
                    }
                }
                else if(partToBeMoved == .SecondaryTail)
                {
                    if(isxCoordinateInsideFrameForTail(pointTouched.x) && isyCoordinateInsideFrameForTail(pointTouched.y))
                    {
                        currentSpeechBubble!.secondaryTailEndingPoint = pointTouched
                        setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        var pointTouched:CGPoint = CGPoint()
        if let touch = touches.first as? UITouch
        {
            pointTouched = touch.locationInView(self)
            
            if(currentSpeechBubble != nil)
            {
                currentSpeechBubble = nil
            }
        }
    }
    
    // MARK: 
    // MARK: Helper methods
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor( red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                        blue:  CGFloat(rgbValue & 0x0000FF) / 255.0,
                        alpha: CGFloat(1.0)
        )
    }
    
    func isxCoordinateInsideFrameForArc(bubbleModel:BubbleModel, withXcoordinate xCoordinate: CGFloat) -> Bool
    {
        return ((xCoordinate + bubbleModel.scaledXRadius()) < self.frame.size.width) &&
                ((xCoordinate - bubbleModel.scaledXRadius()) > 0)
    }
    
    func isyCoordinateInsideFrameForArc(bubbleModel:BubbleModel, yCoordinate: CGFloat) -> Bool
    {
        return ((yCoordinate + bubbleModel.scaledYRadius()) < self.frame.size.height) &&
            ((yCoordinate - bubbleModel.scaledYRadius()) > 0)
    }
    
    func isxCoordinateInsideFrameForTail(xCoordinate: CGFloat) -> Bool
    {
        return (xCoordinate < self.frame.size.width) && (xCoordinate > 0)
    }
    
    func isyCoordinateInsideFrameForTail(yCoordinate: CGFloat) -> Bool
    {
        return (yCoordinate < self.frame.size.height) && (yCoordinate > 0)
    }
    
    func getStartAngle(speechBubble:BubbleModel) -> CGFloat
    {
        var startAngle:CGFloat = π / 2
        if(speechBubble.arcCentrePoint.x == speechBubble.primaryTailEndingPoint.x)
        {
            if(speechBubble.arcCentrePoint.y < speechBubble.primaryTailEndingPoint.y)
            {
                startAngle = (23 * π) / 36
            }
            else if(speechBubble.arcCentrePoint.y > speechBubble.primaryTailEndingPoint.y)
            {
                startAngle = (19 * π) / 12
            }
        }
        else
        {
            if(speechBubble.arcCentrePoint.y > speechBubble.primaryTailEndingPoint.y)
            {
                startAngle = (5 * π)/3
            }
            else if(speechBubble.arcCentrePoint.y < speechBubble.primaryTailEndingPoint.y)
            {
                startAngle = π / 2
            }
            else // Equal:
            {
                if(speechBubble.arcCentrePoint.x < speechBubble.primaryTailEndingPoint.x)
                {
                    startAngle = π / 12
                }
                else
                {
                    startAngle = (13 * π) / 12
                }
            }
        }
        return startAngle
    }
    
    // MARK:
    // MARK: Speech bubble related methods
    
    func createNewBubble(tailType:TailType)
    {
        var speechBubbleModel:BubbleModel = BubbleModel()
        let xCoordinate = (speechBubbleModel.arcCentrePoint.x)/speechBubbleModel.scalePoint.x
        let yCoordinate = (speechBubbleModel.arcCentrePoint.y)/speechBubbleModel.scalePoint.y
        speechBubbleModel.arcCentrePoint = CGPointMake(xCoordinate, yCoordinate)

        let incrementXComponent = 10 * speechBubbleModel.scalePoint.x
        let incrementYComponent = 10 * speechBubbleModel.scalePoint.y

        let unModifiedSpeechBubbleModel:BubbleModel = speechBubbleModel.copy() as! BubbleModel
        
        if(!arcsArray.isEmpty)
        {
            var index:CGFloat = 2
            for bubbleModel in arcsArray
            {
                if(bubbleModel.arcCentrePoint == speechBubbleModel.arcCentrePoint)
                {
                    let modifiedXCoordinate = (unModifiedSpeechBubbleModel.arcCentrePoint.x + (incrementXComponent * index))
                    let modifiedYCoordinate = (unModifiedSpeechBubbleModel.arcCentrePoint.y + (incrementYComponent * index))

                    if(modifiedXCoordinate+bubbleModel.scaledXRadius() < (self.frame.size.width))
                    {
                        speechBubbleModel.arcCentrePoint = CGPointMake(modifiedXCoordinate/speechBubbleModel.scalePoint.x, yCoordinate)
                    }
                    else if(modifiedYCoordinate+bubbleModel.scaledYRadius() < self.frame.size.height)
                    {
                        speechBubbleModel.arcCentrePoint = CGPointMake(xCoordinate, modifiedYCoordinate)
                    }
                }
                index++
            }
        }
        
        
        if(tailType == .DoubleType)
        {
            speechBubbleModel.isBubbleSingleTailed = false
        }
        arcsArray.append(speechBubbleModel)
        
        setNeedsDisplay()
    }
    
    func clearAllBubbles()
    {
        arcsArray.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    // MARK:

    
}