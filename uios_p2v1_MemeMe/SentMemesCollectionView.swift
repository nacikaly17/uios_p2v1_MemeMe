//
//  SentMemesCollectionViewController.swift
//  uios_p2v1_MemeMe
//
//  Created by Naci Kalyoncu on 27.10.20.
//
import Foundation
import UIKit

class SentMemesCollectionView: UICollectionViewController {

    // MARK: Properties
    // AppDelegate contains shared memory "memes"
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 0.5
        let dimensionWidth = (self.view.frame.size.width - (1 * space)) / 0.5
        let dimensionHeight = (self.view.frame.size.height - (2 * space)) / 1.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidMemesChanged(_:)), name: .didMemesChanged, object: nil)
        
    }

    @objc func onDidMemesChanged(_ notification: Notification)
    {
        collectionView!.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        
        // get meme object
        let meme =  memes[(indexPath as NSIndexPath).row]
        // set view components with meme object values
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailView") as! MemeDetailView
        detailController.meme  =  memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}
