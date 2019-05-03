//
//  TableViewController.swift
//  memeappV2
//
//  Created by Eslam  on 3/2/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate {
    
    /*var memes: [Meme]! {
     let object = UIApplication.shared.delegate
     let appDelegate = object as! AppDelegate
     return appDelegate.memes
     }*/
    @IBOutlet weak var tableView:UITableView!
    // each time it will call function reload data to get the new updates of memes
    var memes: [Meme]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //to get the mems before the screen appears
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100.0
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // to get the number of rown in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // to make the cell reusable
        //variable meme define the cell content
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell")
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // the cell content
        let cellTextLabel = meme.topText?.appending("..".appending(meme.bottomText!))
        cell?.textLabel?.text = cellTextLabel
        cell?.imageView?.image = meme.memedImage
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // instinatite new view controller called memedeatildeviewcontroller
        //get the meme that i selcted and sent id to the image in the detaildvc
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
