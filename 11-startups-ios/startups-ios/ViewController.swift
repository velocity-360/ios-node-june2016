//
//  ViewController.swift
//  startups-ios
//
//  Created by Dan Kwon on 7/25/16.
//  Copyright © 2016 Velocity360. All rights reserved.


import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var startupsTable: UITableView!
    var startupsList = Array<Startup>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCtr = NSNotificationCenter.defaultCenter()
        notificationCtr.addObserver(
            self,
            selector: #selector(ViewController.imageDownloadNotifcation),
            name: "ImageDownloaded",
            object: nil
        )
        
        
        let url = "https://ff-startups.herokuapp.com/api/startup"
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                print("\(json)")
                
                if let results = json["results"] as? Array<Dictionary<String, AnyObject>>{
                    
                    for startupInfo in results {
                        let startup = Startup()
                         startup.populate(startupInfo)
                        self.startupsList.append(startup)
                    }
                    
                    self.startupsTable.reloadData()
                }
            }
        }
    }
    
    func imageDownloadNotifcation(){
        self.startupsTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.startupsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let startup = self.startupsList[indexPath.row]
        let cellId = "cellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
            cell.textLabel?.text = startup.name
            cell.detailTextLabel?.text = startup.city
            if (startup.imageData != nil){
                cell.imageView?.image = startup.imageData
                return cell
            }
            
            startup.fetchImage()
            return cell
        }

        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = startup.name
        cell.detailTextLabel?.text = startup.city
        if (startup.imageData != nil){
            cell.imageView?.image = startup.imageData
            return cell
        }
        
        startup.fetchImage()
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let startupVc = StartupViewController()
        startupVc.startup = self.startupsList[indexPath.row]
        self.navigationController?.pushViewController(startupVc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

