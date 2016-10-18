//
//  Data.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/14/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

struct Data: GraphData {
    var section: Int
    var point: CGPoint
    var information: [String: CGPoint]
}

struct ExampleDataFromServer {
    let json = [
        [
            "city": "chicago",
            "population": "100"
        ],
        [
            "city": "los angeles",
            "population": "137990"
        ],
        [
            "city": "grand rapids",
            "population": "20000"
        ]
    ]
}

class Parser {

    class func parseExampleData(data: [[String: String]]) -> [Data] {

        var dataAry: [Data] = []

        for (index, item) in data.enumerated() {

            let population = CGFloat((item["population"]! as NSString).floatValue)
            let city = item["city"]!

            print(population)

            let point = CGPoint(x: CGFloat(index), y: population)

            let data = Data(section: 0, point: point, information: [city: point])

            dataAry.append(data)
        }

        return dataAry
    }

}