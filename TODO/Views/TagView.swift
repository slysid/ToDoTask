//
//  TagView.swift
//  TODO
//
//  Created by Bharath on 2017-09-21.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

protocol TagViewProtocolDelegate {
    
    func handleDoubleAction(tag:TagView)
}

class TagView: UIView {

    @IBOutlet weak var UITagLabel:UILabel? {
        
        didSet {
            
            if (self.UITagLabel!.text == "") {
                
                self.UITagLabel!.backgroundColor = UIColor.clear
            }
            else {
                
                self.UITagLabel!.backgroundColor = UIColor.black
            }
        }
    }
    
    public var delegate:TagViewProtocolDelegate?
    
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
        
        let doubleTap = UITapGestureRecognizer(target: tagView, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        tagView.addGestureRecognizer(doubleTap)
        
        
        return tagView
    }
    
    @objc private func doubleTapAction() {
        
        if (self.delegate != nil ) {
            
            self.delegate!.handleDoubleAction(tag: self)
        }
    }

}
