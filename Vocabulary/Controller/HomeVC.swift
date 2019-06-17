//
//  HomeVC.swift
//  Vocabulary
//
//  Created by 塚田良輝 on 2019/06/14.
//  Copyright © 2019 塚田良輝. All rights reserved.
//

import Foundation
import UIKit

//enum Kikutan : Int, CaseIterable {
//    case a = 600
//    case b = 800
//    case c = 990
//}

class HomeVC : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let kikutan = [600, 800, 990]
    var wordNum = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    var kind: Int?
    var navPage = 1
    let word = 20
    var words: [[String]] = []
    var csvModel: CSVModel?
    var navTitle: String?
    
    var toLastSection: Int?
    var begin: Int?
    var end: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HomeVCTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeVCTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        modelInit()
        getWords()
        setNavItem()
    }
    
    override func loadView() {
        if let view = UINib(nibName: "HomeVC", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        switch navPage {
        case 1:
            words = []
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (navPage, segue.identifier, segue.destination) {
        case let (1, "showHomeVC", vc as HomeVC):
            vc.navTitle = navTitle
            vc.navPage = navPage+1
            vc.kind = kind
            vc.csvModel = csvModel
            vc.words = words
        case let (2, "showHomeVC", vc as HomeVC):
            vc.navTitle = navTitle
            vc.navPage = navPage+1
            vc.kind = kind
            vc.csvModel = csvModel
            vc.toLastSection = toLastSection
            vc.words = words
        case let (3, "showWordStudyVC", vc as WordStudyVC):
            vc.navTitle = navTitle
            var words: [[String]] = []
            for i in begin!-1...end!-1 {
                words.append(self.words[i])
            }
            vc.words = words
        default:
            return
        }
    }
    
    func modelInit() {
        if let _ = csvModel { return }
        csvModel = CSVModel()
    }
    
    func getWords() {
        guard let _ = csvModel else { return }
        guard let _ = kind else { return }
        if let kind = kind {
            switch navPage {
            case 1:
                return
            case 2:
                words = csvModel?.getWords(kind) ?? []
                wordNum = words.count
            case 3:
                wordNum = words.count
            default:
                return
            }
        }
    }
    
    func setNavItem() {
        if let title = navTitle {
            navigationItem.title = title
        } else {
            navigationItem.title = "単語帳一覧"
        }
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}

extension HomeVC : UITableViewDelegate {
    // タップイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeVCTableViewCell
        switch navPage {
        case 1:
            navTitle = cell.itemLabel.text
            kind = kikutan[indexPath.row]
            performSegue(withIdentifier: "showHomeVC", sender: nil)
        case 2:
            navTitle = cell.itemLabel.text
            toLastSection = indexPath.row
            performSegue(withIdentifier: "showHomeVC", sender: nil)
        case 3:
            navTitle = cell.itemLabel.text
            begin = cell.begin
            end = cell.end
            performSegue(withIdentifier: "showWordStudyVC", sender: nil)
        default:
            return
        }
    }
}

extension HomeVC : UITableViewDataSource {
    // セルの要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch navPage {
        case 1:
            return kikutan.count
        case 2:
            let assumedDay = wordNum / 100
            if assumedDay*100 < wordNum { return assumedDay+1}
            return assumedDay
        case 3:
            var day = wordNum / 100
            if day*100 < wordNum { day = day+1 }
            if toLastSection == day-1 {
                let wordNum = self.wordNum - (day-1)*100
                let word = wordNum / 20
                if word*20 < wordNum { return word+1 }
                return word
            }
            return 5
        default:
            return 0
        }
    }
    
    // セルを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVCTableViewCell") as! HomeVCTableViewCell
        switch navPage {
        case 1:
            cell.itemLabel.text = "キクタン\(kikutan[indexPath.row])"
        case 2:
            cell.itemLabel.text = "Day\(indexPath.row + 1)"
        case 3:
            if let sec = toLastSection {
                let begin = 1 + sec*100 + indexPath.row * word
                var end = begin + 19
                if end > wordNum { end = wordNum }
                cell.begin = begin
                cell.end = end
                cell.itemLabel.text = "\(begin) - \(end)"
            }
        default:
            return cell
        }
        return cell
    }
}
