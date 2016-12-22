//
//  ViewController.swift
//  KNN
//
//  Created by Italus Rodrigues do Prado on 21/12/16.
//  Copyright © 2016 GAMEPiD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var arrayWithFlowersString = [[String]]()
    var flowerNumbers = [Int]()
    
    var arrayFlowers = [Flower]()
    var flowersToTest = [Flower]()
    
    let knextNeig = 4
    var test = 0
    var hits = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let textFromFile = self.readFromFile(withFile: "iris")
        splitValues(withText: textFromFile)
        
        for _ in 0...9{
            self.hits.append(0)
            self.flowerNumbers = [Int]()
            self.arrayFlowers = [Flower]()
            self.flowersToTest = [Flower]()
            setupFlowers(withArrayString: arrayWithFlowersString)
            self.chooseFlowersToTest(withQuantity: 30)
            self.compareFlowersTest()
            test += 1
            //print("Acertou \(Double(self.hits[index])/30*100)% dos testes")
        }
        //print("Média geral = \(Double(self.hits.reduce(0, +))/300*100)%")
        self.mediaAndStandardDeviation()
    }
    
    // Media and Standard Deviation of the tests
    func mediaAndStandardDeviation(){
        var media: CGFloat = 0
        var deviation: CGFloat = 0
        var preVariation = [CGFloat]()
        
        // Media
        for number in hits {
            media += CGFloat(number)
        }
        media = media/CGFloat(self.hits.count)
        print("Media: \(media)")
        
        // Standard Deviation
        for number in self.hits{
            preVariation.append(CGFloat(number)-media)
            preVariation[preVariation.count-1] *= preVariation.last!
        }
        var variation: CGFloat = preVariation.reduce(0, +)
        variation = variation/media
        deviation = sqrt(variation)
        print("Desvio padrão = \(deviation)")
    }
    
    // Generate arrayFlower with the data
    func setupFlowers(withArrayString array: [[String]]){
        for arrayComponent in array{
            let flower = Flower(withName: arrayComponent[4], andSepalLength: Double(arrayComponent[0])!, andSepalWidth: Double(arrayComponent[1])!, andPetalLength: Double(arrayComponent[2])!, andPetalWidth: Double(arrayComponent[3])!)
            self.arrayFlowers.append(flower)
        }
    }
    
    // Choose the 30 random flowers to test
    func chooseFlowersToTest(withQuantity quantity: Int){
        var result:[Int] = []
        var insert = 0
        while insert < quantity {
            let value = Int(arc4random_uniform(150))
            if !result.contains(value){
                result.append(value)
                insert += 1
            }
        }
        result = result.sorted()
        self.flowerNumbers = result
        for index in 0...quantity-1{
            self.flowersToTest.append(arrayFlowers[result[index]])
        }
    }
    
    // Compare the 30 flowers choosen with the other 120 to set type
    func compareFlowersTest() {
        for flower in 0...flowerNumbers.count-1{
            let iris = self.flowersToTest[flower]
            self.hits[test] += iris.setNextFlowers(withNextQuantity: knextNeig, andFlowersArray: self.arrayFlowers, andFlowersTest: self.flowerNumbers)
        }
    }
    
    /// Funcs to open .txt archive
    
    // Open file with data
    func readFromFile(withFile fileName: String) -> String{
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        var text: String
        do {
            text = try String(contentsOfFile: path!)
            //print(text)
        } catch {
            text = "error"
            print(text)
        }
        return text
    }
    
    // Generate array with the flowers
    func splitValues(withText text: String){
        var array = text.components(separatedBy: "\n")
        var arrayFinished = [[String]]()
        for index in 0...array.count-1{
            let minorText = array[index]
            arrayFinished.append(minorText.components(separatedBy: ","))
        }
        arrayFinished.removeLast()
        self.arrayWithFlowersString = arrayFinished
    }
}

