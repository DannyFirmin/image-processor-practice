//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

var myRGBA = RGBAImage(image: image)!

//var totalRed = 0
//var totalGreen = 0
//var totalBlue = 0
//
//for y in 0..<myRGBA.height{
//    for x in 0..<myRGBA.width{
//        let index = y * myRGBA.width + x
//        var pixel = myRGBA.pixels[index]
//        totalRed += Int(pixel.red)
//        totalGreen += Int (pixel.green)
//        totalBlue += Int (pixel.blue)
//    }
//}
//let count = myRGBA.width * myRGBA.height
let avgRed = 119 //totalRed/count
let avgGreen = 98 //totalGreen/count
let avgBlue = 83 //totalBlue/count

class Filter{
    var filter:((Pixel,Int)->Pixel)
    var intensity: Int = 0
    init(filter:((Pixel,Int)->Pixel),intensity:Int){
        self.filter = filter
        self.intensity = intensity
    }
}


func goBlue (var pixel:Pixel, intensity:Int)->Pixel{
    let blueDiff = Int (pixel.blue) - avgRed
    if (blueDiff>0)
    {
        pixel.blue = UInt8(max(0,min(255,avgBlue + blueDiff*intensity)))
    }
    return pixel
}
let moreBlue = Filter(filter:goBlue,intensity: 5)


func goGreen (var pixel:Pixel, intensity:Int)->Pixel{
    let greenDiff = Int (pixel.green) - avgGreen
    if (greenDiff>0)
    {
        pixel.green = UInt8(max(0,min(255,avgBlue + greenDiff*intensity)))
    }
    return pixel
}
let moreGreen = Filter(filter:goGreen,intensity: 5)

func noRed (var pixel:Pixel, intensity:Int)->Pixel{
    let redDiff = Int (pixel.red) - avgRed
    if (redDiff>0)
    {
        pixel.red = UInt8(max(0,min(255,avgRed + redDiff/intensity)))
    }
    return pixel
}
let lessRed = Filter(filter:noRed,intensity: 5)

func changeTransperency(var pixel:Pixel, intensity:Int)->Pixel{
    pixel.alpha = UInt8(max(min(255,intensity),0))
    return pixel}

let changeTransFilter = Filter(filter:changeTransperency, intensity: 180)

class ImageProcessor{
    var filtersList:[Filter]=[]
    func addFilter(filter:String){
        filtersList.append(filtersDictionary[filter]!)
    }
    
    
    var filtersDictionary:[String:Filter]=[
        "moreBlue":moreBlue,
        "moreGreen":moreGreen,
        "lessRed":lessRed,
        "changeTransFilter":changeTransFilter
    ]
    func applyFilter(image:UIImage)->UIImage {
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y * myRGBA.width + x
                for filter in filtersList{
                    let pixel = myRGBA.pixels[index]
                    myRGBA.pixels[index] = filter.filter(pixel, filter.intensity)
                    
                    
                }
            }
        }
        return myRGBA.toUIImage()!
    }
}

var myProcessor:ImageProcessor = ImageProcessor()
myProcessor.addFilter("moreBlue")
myProcessor.addFilter("moreGreen")
myProcessor.addFilter("lessRed")
myProcessor.addFilter("changeTransFilter")
myProcessor.applyFilter(image)

