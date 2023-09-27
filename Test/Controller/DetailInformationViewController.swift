//
//  DetailInformationViewController.swift
//  Test
//
//  Created by Admin on 13.09.23.
//

import UIKit

class DetailInformationViewController: UIViewController {
    
    static let identifier = "DetailInformationViewController"
    
    let detailedSettingsView = DetailInformationView()
    var initData: InitData
    
    init(_ initData: InitData) {
        self.initData = initData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailedSettingsView
    }
}

extension  DetailInformationViewController {
    struct InitData {
        // тут она
        var someData: JessicaJonesSeries?
    }
}
