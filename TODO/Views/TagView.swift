//
//  TagView.swift
//  TODO
//
//  Created by Bharath on 2017-09-21.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

class TagView: UIView {

    @IBOutlet weak var UITagLabel:UILabel?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    class func initWithTagData(text:String) -> TagView {
        
        let tagView = UINib(nibName: "TagView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! TagView
        tagView.layer.cornerRadius = 10.0
        tagView.clipsToBounds = true
        tagView.UITagLabel!.text = text
        
        if (text == "") {
            tagView.UITagLabel!.backgroundColor = UIColor.clear
        }
        
        return tagView
    }

}
