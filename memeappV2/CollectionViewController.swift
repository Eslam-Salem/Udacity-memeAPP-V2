//
//  CollectionViewController.swift
//  memeappV2
//
//  Created by Eslam  on 3/2/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController{
    
    @IBOutlet weak var flowLayout :UICollectionViewFlowLayout!
    var memes: [Meme]! {
        didSet {
            collectionView.reloadData()
        }
    }
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! memeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // Set the name and image
        let cellTextLabel = meme.topText?.appending("..".appending(meme.bottomText!))
        cell.memeLabel.text = cellTextLabel
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let memee = self.memes[(indexPath as NSIndexPath).row]
        detailController.memeImage = memee.memedImage!
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @IBAction func addMeme( _ sender: Any ){
        
        let addmeme = self.storyboard!.instantiateViewController(withIdentifier: "AddMemeViewController") as! AddMemeViewController
        self.navigationController!.present(addmeme, animated: true, completion: nil)
    }
    
}
