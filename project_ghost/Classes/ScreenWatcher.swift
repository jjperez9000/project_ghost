//
//  ScreenWatcher.swift
//  project_wingman
//
//  Created by John Perez on 2/24/23.
//

import Vision
import AppKit

///This is dead code currently. I plan to have it work one day but this feature is actual garbage right now.
///I'm leaving it in so I have a starting point for when I try to tackle this feature again. 

//converts a box of values between 0...1 to whatever size the CGImage is
func deNormalize(boundingBox: CGRect, image: CGImage) -> CGRect {
    let startingPoint: CGPoint = CGPoint(x: boundingBox.minX * CGFloat(image.width), y: (1 - boundingBox.origin.y - boundingBox.size.height) * CGFloat(image.height))
    let newWidth = boundingBox.width * CGFloat(image.width)
    let newHeight = boundingBox.height * CGFloat(image.height)
    let newSize = CGSize(width: newWidth, height: newHeight)
    return CGRect(origin: startingPoint, size: newSize)
}

//simple function to get the distance between 2 points
func getDist(p1: CGPoint, p2: CGPoint) -> CGFloat {
    let xDist: CGFloat  = (p2.x - p1.x);
    let yDist: CGFloat = (p2.y - p1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

// class to deal with the images that this project deals with
class ScreenWatcher {
    //taks a screenshot
    private func captureScreen(windowInfo: CGRect) -> NSImage? {
        
        // Get the rect of the main screen
        guard let cgImage = CGDisplayCreateImage(CGMainDisplayID(), rect: windowInfo) else { return nil }
        
        // Create an NSImage from the CGImageRef
        let image = NSImage(cgImage: cgImage, size: NSZeroSize)
        
        return image
    }
    //struct to deal with sets of words on a screen
    struct WordLadder {
        var text: [String]
        var x_start: Double = 0
        var x_end: Double = 0
        var y: Double = 0
        var y_dist: Double = 0
        mutating func isRung(comp: ObservedText) -> Bool {
            if ((y + y_dist > comp.y  && y < comp.y)  && (
                (floor(x_start) <= floor(comp.x_start) && floor(x_end) >= floor(comp.x_start)) || // comp start in self
                (floor(x_start) <= floor(comp.x_end)   && floor(x_end) >= floor(comp.x_end))   || // comp end in self
                (floor(x_start) >= floor(comp.x_start) && floor(x_end) <= floor(comp.x_end))   || // self in comp
                (floor(x_start) <= floor(comp.x_start) && floor(x_end) >= floor(comp.x_end)))) {  // comp in self
                self.text.append(comp.text)
                self.x_start = self.x_start > comp.x_start ? comp.x_start : self.x_start
                self.x_end = self.x_end < comp.x_end ? comp.x_end : self.x_end
                self.y = comp.y
                return true
            }
            return false
        }
        init(firstString: ObservedText, screen: CGImage){
            self.text = [firstString.text]
            self.y = firstString.y
            self.y_dist = Double(screen.height) / 3 // maybe hardcode this to 50?
            self.x_start = firstString.x_start
            self.x_end = firstString.x_end
        }
    }
    //struct to deal with single strings found on screen
    //don't really need it, but vastly it simplifies the objects that we're working with
    struct ObservedText {
        var text: String
        var x_start: Double = 0
        var x_end: Double = 0
        var y: Double = 0
    }
    
    //parses a region of the screen for the most relevant text in it
    func captureText(windowInfo: CGRect, lastClick: CGPoint) -> String {
        // take a screenshot of the window we're working with
        if let image = captureScreen(windowInfo: windowInfo) {
            let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)! //need to convert to image CV works with
            var foundText: String = ""
            
            
            // Text recognition request
            let textRecognitionRequest = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                //strings we found that are relevant
                var capturedStrings: [ObservedText] = []
                //information for finding the closest string to where we clicked
                var closestText: String = ""
                var closestDist: CGFloat = CGFLOAT_MAX
                
                //parse the text that was found
                for observation in observations {
                    let observationRect: CGRect = deNormalize(boundingBox: observation.boundingBox, image: cgImage)
                    //only save text above where we clicked
                    if observationRect.origin.y < lastClick.y {
                        
                        //find the closest text to where we clicked
                        if getDist(p1: lastClick, p2: CGPoint(x: observationRect.origin.x, y: observationRect.origin.y)) < closestDist {
                            closestDist = getDist(p1: lastClick, p2: CGPoint(x: observationRect.origin.x, y: observationRect.origin.y))
                            closestText = observation.topCandidates(1).first!.string
                        }
                        
                        //add relevant text to array
                        capturedStrings.append(ObservedText(text: observation.topCandidates(1).first!.string,
                                                            x_start: observationRect.origin.x,
                                                            x_end: observationRect.origin.x + observationRect.width,
                                                            y: observationRect.origin.y))
                    }
                }
                /**
                 this is a shitty N^3 algorithm for finding word ladders
                 while we have text that is unassigned to a ladder,
                 - add the current highest (y) text to a new ladder
                 - go through all other unassigned text
                 --- if it's underneath the top rung, add it to this ladder
                 --- expand the ladder to fully contian the added rung
                 --- remove that text from the strings
                 then save ladder contianing the text closest to cursor
                 */
                capturedStrings.sort(by: {$0.y < $1.y})
                var wordladders: [WordLadder] = []
                while !capturedStrings.isEmpty {
                    //variable to save strings that need deleting since swift for loops suck dick
                    var markedForDeath: [Int] = []
                    wordladders.append(WordLadder(firstString: capturedStrings[0], screen: cgImage))
                    capturedStrings.remove(at: 0)
                    //find the strings that need to be removed
                    for capturedString in 0..<capturedStrings.count {
                        if wordladders[wordladders.endIndex-1].isRung(comp: capturedStrings[capturedString]) {
                            markedForDeath.append(capturedString)
                        }
                    }
                    //remove the strings
                    var offset = 0
                    for mark in markedForDeath {
                        capturedStrings.remove(at: mark + offset)
                        offset -= 1
                    }
                }
                for wordladder in wordladders {
                    if wordladder.text.contains(closestText) {
                        for text in wordladder.text {
                            foundText += text
                        }
                    }
                }
            }
            
            // Specify the options for the text recognition request
            textRecognitionRequest.recognitionLevel = .accurate
            textRecognitionRequest.usesLanguageCorrection = true
            
            // Create an image request handler to process the image
            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            // Perform the text recognition request on the image
            try? imageRequestHandler.perform([textRecognitionRequest])
            
            return foundText
        }
        return ""
    }
}
