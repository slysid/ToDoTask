//
//  DetailController.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

protocol DetailControllerDelegate {
    
    func refreshData(decision:Bool)
}

class DetailController: UIViewController, UITextViewDelegate, UITextFieldDelegate, TagViewProtocolDelegate {

    @IBOutlet weak var UIToDoTitle:UITextField?
    @IBOutlet weak var UIToDoDescription:UITextView?
    @IBOutlet weak var UICloseButton:UIButton?
    @IBOutlet weak var UITagsStack:UIStackView?
    @IBOutlet weak var UICreationDate:UILabel?
    @IBOutlet weak var UIEditButtonsStack:UIStackView?
    @IBOutlet weak var UIKeyboard:UIButton?
    @IBOutlet weak var UITagTextField:UITextField?
    @IBOutlet weak var UITagAddButton:UIButton?
    
    public var delegate:DetailControllerDelegate?
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
    private var addButton = CustomButton.initButtonWithData(title: "ADD")
    private var tags:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UIToDoDescription!.delegate = self
        self.UIToDoTitle!.delegate = self
        self.tags = self.itemData!.tags
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name:Notification.Name.UIKeyboardDidShow , object: nil)
        
        self.UIToDoTitle!.text = self.itemData!.name
        self.UIToDoDescription!.text = self.itemData!.description
        self.UICreationDate!.text = self.itemData!.creationdate.components(separatedBy: "T")[0]
        
        self.viewMode()
        self.showTags()
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
    
    @IBAction private func addTagAction() {
        
        if (self.tags.count < MAXTAGS) {
            
            let tag = self.UITagTextField!.text!
            self.tags.append(tag)
            self.UITagTextField!.text = ""
            self.showTags()
        }
        else {
            
            self.UITagTextField!.text = ""
        }
    }
    
    // PRIVATE METHODS
    
    private func viewMode() {
        
        self.showEditButton()
        
        self.UIToDoDescription!.isEditable = false
        self.UIToDoTitle!.isEnabled = false
        self.editButton.button?.setTitle("EDIT", for: UIControlState.normal)
        self.UITagTextField!.isHidden = true
        self.UITagAddButton!.isHidden = self.UITagTextField!.isHidden
    }
    
    private func editMode() {
        
        self.UIToDoDescription!.isEditable = true
        self.UIToDoTitle!.isEnabled = true
        self.editButton.button?.setTitle("COMMIT", for: UIControlState.normal)
        self.UIToDoDescription!.becomeFirstResponder()
        self.UITagTextField!.isHidden = false
        self.UITagAddButton!.isHidden = self.UITagTextField!.isHidden
        
    }
    
    @objc private func handleKeyboard() {
        
        self.UIKeyboard!.isHidden = false
    }
    
    private func removeButtonStackViews() {
        
        for v in self.UIEditButtonsStack!.subviews {
            
            self.UIEditButtonsStack!.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
    }
    
    private func showTags() {
        
        for v in self.UITagsStack!.subviews {
            self.UITagsStack!.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        
        for _ in 0..<MAXTAGS {
            
            let tagLabel = TagView.initWithTagData(text:"")
            tagLabel.delegate = self
            self.UITagsStack!.addArrangedSubview(tagLabel)
        }
        
        for (index, tag) in self.tags.enumerated() {
            let tagView = self.UITagsStack!.arrangedSubviews[index] as! TagView
            tagView.UITagLabel!.text = tag
            tagView.UITagLabel!.backgroundColor = UIColor.black
        }
        
        /*if (tags.count < MAXTAGS) {
            while tags.count < MAXTAGS {
                tags.append("")
            }
        }
        
        for tag in tags {
            
            let tagLabel = TagView.initWithTagData(text: tag)
            tagLabel.delegate = self
            self.UITagsStack!.addArrangedSubview(tagLabel)
        }*/
    }
    
    private func showEditButton() {
        
        self.removeButtonStackViews()
        self.UIEditButtonsStack!.addArrangedSubview(self.editButton)
        
        self.editButton.buttonAction = { (button) in
            
            self.editAction(sender:button)
        }
    }
    
    private func showAddButton() {
        
        self.removeButtonStackViews()
        self.UIEditButtonsStack!.addArrangedSubview(self.addButton)
        
        self.addButton.buttonAction = { (button) in
            
            self.addAction(sender:button)
        }
    }
    
    private func editAction(sender:CustomButton) {
        
        if (self.mode == .view) {
            
            self.mode = .edit
        }
        else if (self.mode == .edit) {
            
            self.mode = .view
            self.formSaveData()
        }
    }
    
    private func addAction(sender:CustomButton) {
        
        self.mode = .add
    }
    
    private func formSaveData() {
        
        var editedItem = Item()
        
        editedItem.id = self.itemData!.id
        editedItem.name = self.UIToDoTitle!.text!
        editedItem.description = self.UIToDoDescription!.text
        editedItem.creationdate = self.itemData!.creationdate
        editedItem.completed = self.itemData!.completed
        editedItem.completiondate = self.itemData!.completiondate
        editedItem.tags = self.formTagsArray()
        editedItem.trashed = self.itemData!.trashed
        
        if (editedItem != self.itemData!) {
            
            FileHandlingManager.sharedInstance.editItem(item: editedItem)
            if (self.delegate != nil) {
                
                self.delegate!.refreshData(decision: true)
            }
        }
    }
    
    private func formTagsArray() -> [String] {
        
        var result:[String] = []
        
        for v in self.UITagsStack!.arrangedSubviews {
            let text = (v as! TagView).UITagLabel!.text
            if (text != "") {
                result.append(text!)
            }
         }
        return result
    }
    
    
    // KEYBOARD DELEGATE METHODS
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    // TAGVIEW DELEGATE METHODS
    
    func handleDoubleAction(tag: TagView) {
        
        if (self.mode == .edit) {
            
            let index = self.tags.index(of: tag.UITagLabel!.text!)
            self.tags.remove(at: index!)
            self.showTags()
        }
    }

}
