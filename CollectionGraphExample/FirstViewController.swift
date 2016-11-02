//
//  FirstViewController.swift
//  CollectionGraphExample
//
//  Created by Chris Rittersdorf on 9/23/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit
import CollectionGraph

class FirstViewController: UIViewController {

    @IBOutlet weak var graph: CollectionGraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        graph.graphData = Parser.parseExampleData(data: ExampleDataFromServer().json)

        graph.setCellProperties { (cell, graphDatum) in
            cell.backgroundColor = UIColor.lightGray
            cell.layer.cornerRadius = cell.frame.width / 2
        }

        graph.setCellSize { (graphDatum) -> (CGSize) in
            return CGSize(width: 3, height: 3)
        }

        graph.setBarViewProperties { (cell, graphDatum) in
            cell.backgroundColor = UIColor.lightGray
        }

        graph.setBarViewWidth { (graphDatum) -> (CGFloat) in
            return CGFloat(10)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
