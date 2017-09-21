//
//  CustomButton.swift
//  TODO
//
//  Created by Bharath on 2017-09-21.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

class CustomButton: UIView {
    
    @IBOutlet weak var button:UIButton?
    
    public var buttonAction:(CustomButton) -> Void = { _ in }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    class func initButtonWithData(title:String) -> CustomButton {
        
        let button = UINib(nibName: "CustomButton", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! CustomButton
        button.button!.setTitle(title, for: UIControlState.normal)
        return button
    }
    
    @IBAction private func buttonTapped() {
        
        self.buttonAction(self)
    }

}
