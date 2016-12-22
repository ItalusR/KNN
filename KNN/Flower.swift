//
//  Flower.swift
//  KNN
//
//  Created by Italus Rodrigues do Prado on 21/12/16.
//  Copyright © 2016 GAMEPiD. All rights reserved.
//

import UIKit

class Flower: NSObject {
    
    let sepalLength: Double
    let sepalWidth: Double
    let petalLength: Double
    let petalWidth: Double
    
    public let flowerName: String?
    
    let status: [Double]
    var nextFlowerTypes = [Flower]()
    
    
//    init(withSepalLength sepalLength: Double, andSepalWidth sepalWidth: Double, andPetalLength petalLength: Double, andPetalWidth petalWidth: Double) {
//        
//        self.sepalLength = sepalLength
//        self.sepalWidth = sepalWidth
//        self.petalLength = petalLength
//        self.petalWidth = petalWidth
//        self.status = [sepalLength,sepalWidth,petalLength,petalWidth]
//        self.flowerName = ""
//    }
    
    init(withName flowerName: String, andSepalLength sepalLength: Double, andSepalWidth sepalWidth: Double, andPetalLength petalLength: Double, andPetalWidth petalWidth: Double) {
        self.sepalLength = sepalLength
        self.sepalWidth = sepalWidth
        self.petalLength = petalLength
        self.petalWidth = petalWidth
        self.flowerName = flowerName
        self.status = [sepalLength,sepalWidth,petalLength,petalWidth]
    }
    
    // Compare all 4 attributes of the flower and return the distance value
    func compareStatusFlower(withFlower secondFlower: Flower) -> Double{
        var values = [Double]()
        for index in 0..<self.status.count{
            values.append(status[index] - secondFlower.status[index])
            values[index] *= values[index]
        }
        let finalValue = sqrt(values.reduce(0, +))
        return finalValue
    }
    
    // Set the type of the flower
    func setNextFlowers(withNextQuantity nextQuantity: Int, andFlowersArray flowersArray: [Flower], andFlowersTest flowersTest: [Int]) -> Int{
        
        // Save the K nearest neighboors
        var values = [[Double]]()
        for flowerIndex in 0...flowersArray.count-1{
            if !flowersTest.contains(flowerIndex) {
                values.append([self.compareStatusFlower(withFlower: flowersArray[flowerIndex]), Double(flowerIndex)])
                values = values.sorted { ($0[0] ) < ($1[0]) }
                if values.count > nextQuantity {
                    values.removeLast()
                }
            }
        }
        
        var setosas: Double = 0
        var versicolores: Double = 0
        var virginicas: Double = 0
        
        // Create the weight to distance when K > 1 to avoid draws
        for index in 0...values.count-1{
            let flowerType = (flowersArray[Int(values[index][1])]).flowerName
            let flowerTypeString : NSString = NSString(string: flowerType!)
            if flowerTypeString.isEqual(to: "Iris-setosa"){
                setosas = setosas+1/values[index][0]
            } else if flowerTypeString.isEqual(to: "Iris-versicolor"){
                versicolores = versicolores+1/values[index][0]
            } else if flowerTypeString.isEqual(to: "Iris-virginica"){
                virginicas = virginicas+1/values[index][0]
            }
        }
        
        // Compare the type found with the real type
        var flowerType = String()
        if setosas > versicolores && setosas > virginicas{
            flowerType = "Iris-setosa"
        } else if versicolores > setosas && versicolores > virginicas {
            flowerType = "Iris-versicolor"
        } else if virginicas > setosas && virginicas > versicolores{
            flowerType = "Iris-virginica"
        }
        
        let flowerTypeString : NSString = NSString(string: flowerType)
        if flowerTypeString.isEqual(to: self.flowerName!){
            //print("Acertou Flor = uma \(flowerTypeString)")
            return 1
        } else {
            //print("Errou Flor = uma \(self.flowerName!) e não uma \(flowerTypeString)")
            return 0
        }
    }
}
