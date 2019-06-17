//
//  WordStudyVC.swift
//  Vocabulary
//
//  Created by 塚田良輝 on 2019/06/14.
//  Copyright © 2019 塚田良輝. All rights reserved.
//

import Foundation
import UIKit

class WordStudyVC : UIViewController {
    @IBOutlet var enWordLabel: UILabel!
    @IBOutlet var jaWordLabel: UILabel!
    @IBOutlet var wordCountLabel: UILabel!
    @IBOutlet var startStopButton: UIButton!
    var navTitle: String?
    var words: [[String]] = []
    var enTimer = Timer()
    var jaTimer = Timer()
    var timerWorking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enWordLabel.text = ""
        jaWordLabel.text = ""
        wordCountLabel.text = "1/\(words.count)単語中"
        displayInit()
        setNavTitle()
        print(words)
        print(words.count)
    }
    
    override func loadView() {
        if let view = UINib(nibName: "WordStudyVC", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        enTimer.invalidate()
    }
    
    func displayInit() {
        let sWidth = UIScreen.main.bounds.width
        let sHeight = UIScreen.main.bounds.height
        let enWidth: CGFloat = sWidth - 20
        let enY: CGFloat = sHeight/2 - 20
        enWordLabel.frame = CGRect(x: 10, y: enY, width: enWidth, height: 50)
        jaWordLabel.frame = CGRect(x: 10, y: enY+70, width: enWidth, height: 50)
        let buttonWidth = sWidth/3
        let buttonHeight = sWidth/6
        startStopButton.frame = CGRect(x: (sWidth-buttonWidth)/2, y: sHeight/4, width: buttonWidth, height: buttonHeight)
        wordCountLabel.frame = CGRect(x: (sWidth-buttonWidth)/2, y: sHeight/4+buttonHeight+10, width: buttonWidth, height: buttonHeight/2)
        startStopButton.layer.cornerRadius = 10
        startStopButton.clipsToBounds = true
    }
    
    func setNavTitle() {
        if let title = navTitle {
            navigationItem.title = title
        }
    }
    
    @IBAction func startStopButtonTapped(_ sender: Any) {
        if !timerWorking {
            startStopButton.setTitle("Stop", for: .normal)
            timerWorking = !timerWorking
            var i = 0
            enTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
                self.enWordLabel.text = self.words[i % self.words.count][0]
                self.jaWordLabel.text = ""
                self.wordCountLabel.text = "\(i % self.words.count + 1)/\(self.words.count)単語中"
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                    self.jaWordLabel.text = self.words[(i-1) % self.words.count][1]
                })
                i += 1
            })
        } else {
            startStopButton.setTitle("Start", for: .normal)
            timerWorking = !timerWorking
            enTimer.invalidate()
        }
    }
}
