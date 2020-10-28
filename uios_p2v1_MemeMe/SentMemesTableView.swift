//
//  SentMemesTableViewController.swift
//  uios_p2v1_MemeMe
//
//  Created by Naci Kalyoncu on 27.10.20.
//

import UIKit
import Foundation

// MARK: - UITableViewController
class SentMemesTableView: UITableViewController  {

    // MARK: Properties

    // Storyboard has been set up with this String.
    let cellReuseIdentifier = "SendMemeCell"
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Outlets

    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidMemesChanged(_:)), name: .didMemesChanged, object: nil)
        
    }

    @objc func onDidMemesChanged(_ notification: Notification)
    {
        tableView!.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // we have only one section
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // nomber of rows for the table in section 1
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)!
        
        // get meme object
        let meme =  memes[(indexPath as NSIndexPath).row]
        // set view components with meme object values
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            cell.textLabel?.text = meme.topText
            detailTextLabel.text = meme.bottomText
        } else {
            cell.textLabel?.text = meme.topText + " .. " + meme.bottomText
        }
        cell.imageView?.image = meme.memedImage

        // return cell object for the table view
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Navigate to selected row . It is one sent meme, which should be displayed in MemeDetailView
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailView") as! MemeDetailView
        detailController.meme  =  memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    // LeadingSwipe: delete a meme from sent items
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action,view,competion) in
            // Add it to the memes array in the Application Delegate
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: (indexPath as NSIndexPath).row)
            competion(true)
            NotificationCenter.default.post(name: .didMemesChanged, object: nil)  // notify that memes did change
        }
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: "trash", withConfiguration: configuration)
        action.image = image
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }

    
}
