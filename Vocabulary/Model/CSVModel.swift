//
//  CSVModel.swift
//  Vocabulary
//
//  Created by 塚田良輝 on 2019/06/14.
//  Copyright © 2019 塚田良輝. All rights reserved.
//

import Foundation

class CSVModel {
    let kind = 0
    var csvString = ""

    func getWords(_ kind: Int) -> [[String]] {
        var words: [[String]] = []
        do {
            csvString = try NSString(contentsOf: create(kind)! as URL, encoding: String.Encoding.utf8.rawValue) as String
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        csvString.enumerateLines { (line, stop) -> () in
            words.append(line.components(separatedBy: ","))
        }
        return words
    }
    
    func create(_ kind: Int) -> NSURL? {
        let urlString = "https://giz-vocabulary.s3-ap-northeast-1.amazonaws.com/kikutan_\(String(kind)).csv"
        return NSURL(string: urlString)
    }
}
