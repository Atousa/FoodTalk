//
//  FavoriteListCell.swift
//  FoodTalk
//
//  Created by Atousa Duprat on 4/23/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

import UIKit

class FavoriteListCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameOfResturant: UILabel!
    
    @IBOutlet weak var myRatingImage: UIImageView!
    
    @IBOutlet weak var adressTextView: UITextView!
    
    @IBOutlet private weak var notesTableView: UITableView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    /*
    func setNoteTableViewDataSourceDelegate
        <D: protocol<UITableViewDataSource, UITableViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
        
        notesTableView.delegate = dataSourceDelegate
        notesTableView.dataSource = dataSourceDelegate
        notesTableView.tag = row
        notesTableView.reloadData()
    }
    */
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNotesTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNotesTableView()
    }
    
    func setupNotesTableView()
    {
        notesTableView.delegate = self
        notesTableView.dataSource = self
        self.addSubview(notesTableView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        notesTableView.frame = CGRectMake(0.2, 0.3, self.bounds.size.width-5, self.bounds.size.height-5)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("NotesCell")
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "NotesCell")
        }
        cell?.textLabel?.text = "Row " + String(indexPath.row)
        return cell!
    }
}
