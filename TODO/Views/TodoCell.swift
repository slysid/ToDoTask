//
//  TodoCell.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

protocol TodoCellProtocolDelegate {
    
    func singleTapAction(cell:TodoCell)
    func doubleTapAction(cell:TodoCell)
    
}

class TodoCell: UITableViewCell {

    @IBOutlet weak var bgLabel:UIImageView?
    @IBOutlet weak var todoTitle:UILabel?
    @IBOutlet weak var todoDescription:UILabel?
    @IBOutlet weak var completion:UIButton?
    @IBOutlet weak var UICompletionDate:UILabel?
    
    public var delegate:TodoCellProtocolDelegate?
    public var cellCompletionAction:(TodoCell) -> Void = { _ in }
    public var completionStatus:Bool? {
        
        didSet {
            var imageName = "target.png"
            self.bgLabel!.isHidden = false
            self.UICompletionDate!.isHidden = true
            
            if (self.completionStatus == true) {
                
                imageName = "completed.png"
                self.bgLabel!.isHidden = true
                self.UICompletionDate!.isHidden = false
            }
            
            self.UICompletionDate!.text = Date().iso8601
            self.completion!.setBackgroundImage(UIImage(named:imageName), for: UIControlState.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(single))
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(double))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction private func completionTapped() {
        
        self.cellCompletionAction(self)
        
    }
    
    @objc public func single() {
        
        if (self.delegate != nil) {
            
            self.delegate?.singleTapAction(cell: self)
        }
    }
    
    @objc public func double() {
        
        if (self.delegate != nil) {
            
            self.delegate!.doubleTapAction(cell: self)
        }
    }
    
}
