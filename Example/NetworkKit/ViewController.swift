//
//  ViewController.swift
//  NetworkKit
//
//  Created by Nileshkumar Prajapati on 06/26/2023.
//  Copyright (c) 2023 Nileshkumar Prajapati. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    private lazy var host: UIHostingController = {
        return UIHostingController(rootView: ListView())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Music"
        setupHostView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    private func setupHostView() {
        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)
        host.view.frame = view.frame
    }
}
