//
//  ViewController.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TodoCellProtocolDelegate , DetailControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    
    @IBOutlet weak var todoTable:UITableView?
    @IBOutlet weak var UIAddButton:UIButton?
    @IBOutlet weak var UITrashButton:UIButton?
    
    private var searchState:Bool = false
    private var searchController:UISearchController?
    private var dataSource:[[String:Any]] = []
    private var trashIndicator:Bool = false {
        didSet {
            if (self.trashIndicator == false) {
                self.UITrashButton!.setBackgroundImage(UIImage(named:"trash.png"), for: UIControlState.normal)
            }
            else {
                self.UITrashButton!.setBackgroundImage(UIImage(named:"document.png"), for: UIControlState.normal)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.searchController = UISearchController.init(searchResultsController: nil)
        self.searchController!.searchResultsUpdater = self
        self.searchController!.searchBar.searchBarStyle = .minimal
        self.searchController!.searchBar.tintColor = UIColor.black
        self.searchController!.searchBar.delegate = self
        self.definesPresentationContext = true
        
        self.fillInDataSource()
        
        self.todoTable!.delegate = self
        self.todoTable!.dataSource = self
        self.todoTable!.backgroundColor = UIColor.clear
        self.todoTable!.separatorStyle = .none
        self.todoTable!.isEditing = false
        self.todoTable!.tableHeaderView = self.searchController!.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBACTION METHODS
    
    @IBAction private func addButtonTapped() {
        
        let detailController = DetailController(nibName: "DetailController", bundle: Bundle.main)
        detailController.delegate = self
        self.present(detailController, animated: true) {
            
            detailController.mode = .add
        }
    }
    
    @IBAction private func trashTapped() {
        
        if (self.searchState == true) {
            
            self.trashIndicator = true
            self.searchState = false
        }
        self.trashIndicator = !self.trashIndicator
        self.fillInDataSource()
        self.todoTable!.reloadData()
    }
    
    // PRIVATE METHODS
    
    private func reloadTableData() {
        
        self.fillInDataSource()
        self.todoTable!.reloadData()
    }
    
    private func fillInDataSource() {
        
        self.dataSource = FileHandlingManager.sharedInstance.readJSONFile(name: DATAFILENAME) as! [[String:Any]]
        self.dataSource = self.dataSource.filter{($0["trashed"] as! Bool) == self.trashIndicator}
        self.dataSource = self.dataSource.reversed()
    }
    
    private func hanldeCompletionSelection(cell:TodoCell) {
        
        let indexPath = self.todoTable!.indexPath(for: cell)
        let item = self.dataSource[indexPath!.row].item()
        FileHandlingManager.sharedInstance.toggleCompletionStatus(item: item)
        cell.completionStatus = !cell.completionStatus!
        self.reloadTableData()
        
    }
    
    private func trashItem(indexpath:IndexPath) {
        
        let item = self.dataSource[indexpath.row].item()
        FileHandlingManager.sharedInstance.trashItem(item: item, trash: !self.trashIndicator)
        self.fillInDataSource()
        self.todoTable!.reloadData()
    }
    
    //TODOCELL DELEGATE METHODS
    
    func singleTapAction(cell: TodoCell) {
        
        let indexPath = self.todoTable!.indexPath(for: cell)
        let data = self.dataSource[indexPath!.row].item()
        
        let detailController = DetailController(nibName: "DetailController", bundle: Bundle.main)
        detailController.itemData = data
        detailController.delegate = self
        self.present(detailController, animated: true) {
        }
    }
    
    func doubleTapAction(cell: TodoCell) {
        
        self.todoTable!.isEditing = !self.todoTable!.isEditing
    }
    
    //DETAILCONTROLLER DELEGATE
    
    func refreshData(decision: Bool) {
        
        if (decision == true) {
            
            self.fillInDataSource()
            self.todoTable!.reloadData()
        }
    }
    
    //TABLEVIEW DELEGATE AND DATASOURCE METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            
            cell = UINib(nibName: "TodoCell", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! TodoCell
            (cell as! TodoCell).delegate = self
        }
        
        let data = self.dataSource[indexPath.row].item()
        (cell as! TodoCell).todoTitle!.text = data.name
        (cell as! TodoCell).todoDescription!.text = data.creationdate.components(separatedBy:"T")[0]
        (cell as! TodoCell).completionStatus = data.completed
        if (data.completiondate != "") {
            
            (cell as! TodoCell).UICompletionDate!.text = data.completiondate
        }
        (cell as! TodoCell).cellCompletionAction = { (selectedcell) in
            
            self.hanldeCompletionSelection(cell: selectedcell)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CELLHEIGHT
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if (tableView.isEditing == false) {
            
            return UITableViewCellEditingStyle.delete
        }
        
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        
           return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item1 = self.dataSource[sourceIndexPath.row].item()
        let item2 = self.dataSource[destinationIndexPath.row].item()
        FileHandlingManager.sharedInstance.reorderItems(item1: item1, item2: item2)
        self.fillInDataSource()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let recover = UITableViewRowAction.init(style: .normal, title: NSLocalizedString("LOC_RECOVER", comment:"")) { (action, indexpath) in
            self.trashItem(indexpath: indexpath)
        }
        
        let delete = UITableViewRowAction.init(style: .destructive, title: NSLocalizedString("LOC_DELETE", comment:"")) { (action
            , indexpath) in
           if (self.trashIndicator == false) {
                self.trashItem(indexpath: indexpath)
           }
           else {
            
                let item = self.dataSource[indexpath.row].item()
                FileHandlingManager.sharedInstance.deleteFromTrash(item: item)
                self.fillInDataSource()
                tableView.reloadData()
           }
        }
        
        if (self.trashIndicator == false) {
            return [delete]
        }
        
        return [delete, recover]
    }
    
    // SEARCH METHODS
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchController?.dismiss(animated: true, completion: {
            
        })
        self.dataSource = FileHandlingManager.sharedInstance.search(text:searchBar.text!)
        self.todoTable!.reloadData()
        self.UITrashButton!.setBackgroundImage(UIImage(named:"search.png"), for: UIControlState.normal)
        self.searchState = true
    }
}

