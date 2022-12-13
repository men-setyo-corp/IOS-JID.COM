//
//  detailViewSheet.swift
//  JID.COM
//
//  Created by Macbook on 29/08/22.
//

import UIKit
import SwiftUI

class DetailViewSheet: UIViewController {
    
    @IBOutlet weak var theContainer: UIView!
    
    override public func viewDidLoad() {
        let childView = UIHostingController(rootView: SetBottomSheet())
        addChild(childView)
        
    }
    
}
