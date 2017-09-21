//
//  DetailController.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

class DetailController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var UIToDoTitle:UITextField?
    @IBOutlet weak var UIToDoDescription:UITextView?
    @IBOutlet weak var UICloseButton:UIButton?
    @IBOutlet weak var UITagsStack:UIStackView?
    @IBOutlet weak var UICreationDate:UILabel?
    @IBOutlet weak var UIEditButtonsStack:UIStackView?
    @IBOutlet weak var UIKeyboard:UIButton?
    
    public var itemData:Item?
    public var mode:ControllerMode = .view {
        
        didSet {
            
            switch self.mode {
            case .view:
                self.viewMode()
            case .edit:
                self.editMode()
            default:()
            }
        }
    }
    
    private var editButton = CustomButton.initButtonWithData(title: "EDIT")
    private var cancelButton = CustomButton.initButtonWithData(title: "CANCEL")
    private var completeButton = CustomButton.initButtonWithData(title: "COMPLETE")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UIToDoDescription!.delegate = self
        self.UIToDoTitle!.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name:Notification.Name.UIKeyboardDidShow , object: nil)
        
        self.UIToDoTitle!.text = self.itemData!.name
        self.UIToDoDescription!.text = self.itemData!.description
        self.UICreationDate!.text = self.itemData!.creationdate.components(separatedBy: "T")[0]
        
        self.viewMode()
        self.showTags()
        self.showCustomButtons()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBACTION METHODS
    
    @IBAction private func closeTapped() {
        
        self.dismiss(animated: true) {
            
            
        }
    }
    
    
    @IBAction private func keyboardTapped() {
        
        for v in (self.view.subviews) {
            
            v.resignFirstResponder()
        }
        
        self.UIKeyboard!.isHidden = true
    }
    
    // PRIVATE METHODS
    
    private func viewMode() {
        
        self.UIToDoDescription!.isEditable = false
        self.UIToDoTitle!.isEnabled = false
        self.editButton.button?.setTitle("EDIT", for: UIControlState.normal)
    }
    
    private func editMode() {
        
        self.UIToDoDescription!.isEditable = true
        self.UIToDoTitle!.isEnabled = true
        self.editButton.button?.setTitle("COMMIT", for: UIControlState.normal)
        self.UIToDoDescription!.becomeFirstResponder()
    }
    
    @objc private func handleKeyboard() {
        
        self.UIKeyboard!.isHidden = false
    }
    
    private func showTags() {
        
        var tags = itemData!.tags
        if (tags.count < MAXTAGS) {
            while tags.count < MAXTAGS {
                tags.append("")
            }
        }
        
        for tag in tags {
            
            let tagLabel = TagView.initWithTagData(text: tag)
            self.UITagsStack!.addArrangedSubview(tagLabel)
        }
    }
    
    private func showCustomButtons() {
        
        self.UIEditButtonsStack!.addArrangedSubview(self.editButton)
        self.UIEditButtonsStack!.addArrangedSubview(self.completeButton)
        self.UIEditButtonsStack!.addArrangedSubview(self.cancelButton)
        
        self.editButton.buttonAction = { (button) in
            
            self.editAction(sender:button)
        }
        
        self.cancelButton.buttonAction = { (button) in
            
            self.cancelAction(sender:button)
        }
        
        self.completeButton.buttonAction = { (button) in
            
            self.completeAction(sender:button)
        }
    }
    
    private func editAction(sender:CustomButton) {
        
        if (self.mode == .view) {
            
            self.mode = .edit
        }
        else if (self.mode == .edit) {
            
            self.mode = .view
        }
    }
    
    private func cancelAction(sender:CustomButton) {
        
        print("Cancel Tapped")
    }
    
    private func completeAction(sender:CustomButton) {
        
        print("Completion Tapped")
    }
    
    // KEYBOARD DELEGATE METHODS
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    

}
