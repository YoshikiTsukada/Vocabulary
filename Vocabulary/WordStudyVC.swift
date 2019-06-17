//
//  WordStudyVC.swift
//  Vocabulary
//
//  Created by 塚田良輝 on 2019/06/13.
//  Copyright © 2019 塚田良輝. All rights reserved.
//

import Foundation
import UIKit

class WordStudyVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        if let view = UINib(nibName: "WordStudyVC", bundle: nil).instantiate(withOwner: self
            , options: nil).first as? UIView {
            self.view = view
        }
    }
}
