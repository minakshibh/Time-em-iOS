//
//  TaskDetailViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 20/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import AVKit
import SDWebImage

//cross-popup
class TaskDetailViewController: UIViewController ,UIScrollViewDelegate{

    var err: NSError? = nil
    var taskData:NSMutableDictionary! = [:]
    @IBOutlet var TextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var TextHeadingHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewVideo: UIImageView!
    @IBOutlet var btnPlayVideo: UIButton!
    @IBOutlet var lblTaskDate: UILabel!
    @IBOutlet var viewimageBackground: UIView!
    @IBOutlet var txtComments: UITextView!
    @IBOutlet var lblHourWorked: UILabel!
    @IBOutlet var txtTaskDescription: UITextView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    var videoStatus:Bool = false
    var videoData:NSData!
    @IBOutlet var lblAttachment: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        viewimageBackground.layer.cornerRadius = 4
        viewimageBackground.clipsToBounds = true

//        print(taskData)

    txtComments.scrollEnabled = false
        
    txtTaskDescription.text = taskData.valueForKey("TaskName") as? String
    txtComments.text = taskData.valueForKey("Comments") as? String
     lblHourWorked.text = "\(roundToPlaces(Double("\(taskData.valueForKey("TimeSpent")!)")!, places: 2))"
//    lblHourWorked.text = taskData.valueForKey("TimeSpent")!  as? String
    print(taskData.valueForKey("CreatedDate")!)
        
        if taskData.valueForKey("TaskName") != nil {
        
        var dateStr = "\(taskData.valueForKey("CreatedDate")!)".componentsSeparatedByString(" ")[0]
        let dateArr = dateStr.componentsSeparatedByString("/") as? NSArray
            if dateStr.componentsSeparatedByString(" ").count == 1 {
               dateStr = "\(dateArr![2])-\(dateArr![1])-\(dateArr![0])T00:00:00"
            }else{
        dateStr = "\(dateArr![2])-\(dateArr![1])-\(dateArr![0])T\("\(taskData.valueForKey("CreatedDate")!)".componentsSeparatedByString(" ")[1])"
            }
        
                        let dateFormatter: NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        
                        let date: NSDate = dateFormatter.dateFromString(dateStr)!
                        // create date from string
                        // change to a readable time format and change to local time zone
                        dateFormatter.dateFormat = "EEE MMM d, yyyy"
        
                        dateFormatter.timeZone = NSTimeZone.localTimeZone()
                        let timestamp: String = dateFormatter.stringFromDate(date)
        lblTaskDate.text = "\(timestamp)"
        }else {
             lblTaskDate.text = "\(taskData.valueForKey("CreatedDate")!)"
        }
        
        
        
        
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(0, 2000)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentOffset = CGPoint(x: 450, y: 2000)
    }
    override func viewWillAppear(animated: Bool) {
        // image or video processing
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
        if self.taskData.valueForKey("AttachmentImageFile") != nil {
            self.lblAttachment.hidden = false
            if self.taskData.valueForKey("AttachmentImageFile") as? String != "" {
                
                if "\(self.taskData.valueForKey("isoffline")!)" == "true" {
                    let database = databaseFile()
                    let dataArr:NSMutableArray!
                    dataArr = database.getImageForUrl("\(self.taskData.valueForKey("AttachmentImageFile")!)",imageORvideo:"AttachmentImageFile")
                    
                    if dataArr.count > 0 {
                        if "\(dataArr[0])".characters.count != 0 {
                            let data1:NSData = dataArr[0] as! NSData
                            let count = data1.length / sizeof(UInt8)
                            if count > 0 {
                                delay(0.001){
                                    let data:NSData = dataArr[0] as! NSData
                                    let userImageData:NSData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSData
                                    self.lblAttachment.hidden = false
                                    self.imageView.image = UIImage(data: userImageData)
                                }
                                return
                            }
                        }
                    }
                    
                }
             imageView.sd_setImageWithURL(NSURL(string: "\(self.taskData.valueForKey("AttachmentImageFile")!)"), placeholderImage: UIImage(named: "cross-popup"), options: .RefreshCached)
            self.lblAttachment.hidden = false
            }else{
                self.imageView.hidden = true
                self.lblAttachment.hidden = true
            }
            
        }else{
            self.imageView.hidden = true
            self.lblAttachment.hidden = true
            
        }
        //            dispatch_async(dispatch_get_main_queue(), {
        //
        //
        //            });
        //        }
        
        
        
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        if self.taskData.valueForKey("AttachmentVideoFile") != nil {
            self.lblAttachment.hidden = false
            if self.taskData.valueForKey("AttachmentVideoFile") as? String != "" {
                self.lblAttachment.hidden = false
                // check and get image from databse
                let database = databaseFile()
                let dataArr:NSMutableArray!
                dataArr = database.getImageForUrl("\(self.taskData.valueForKey("AttachmentVideoFile")!)",imageORvideo:"AttachmentVideoFile")
                if dataArr.count > 0 {
                    if "\(dataArr[0])".characters.count != 0 {
                        let data1:NSData = dataArr[0] as! NSData
                        let count = data1.length / sizeof(UInt8)
                        if count > 0 {
                            
                            let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentVideoFile")!)")
                            
                            generateThumbnail(url!)
                            
                            let data:NSData = dataArr[0] as! NSData
                            let userVideoData:NSData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSData
                            self.videoData = userVideoData
                            self.lblAttachment.hidden = false
                            return
                        }
                    }else{
                        let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentVideoFile")!)")
                        generateThumbnail(url!)
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        delay(0.001){
                            let data = NSData(contentsOfURL: url!)
//                            dispatch_async(dispatch_get_main_queue(), {
                        
                            if Reachability.isConnectedToNetwork() == true {
                                print("Internet connection OK")
                            
                                //----
                                let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                                let database = databaseFile()
                                database.addImageToTask("\(self.taskData.valueForKey("AttachmentVideoFile")!)", AttachmentImageData: encodedData,imageORvideo:"AttachmentVideoFile")
                                self.videoData = data!
//                            });
                    }
//                        }
                        }
                    }
                }
                
                
                
                //                downloadVideo  and save to databse
                let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentVideoFile")!)")
                self.generateThumbnail(url!)
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                    let data = NSData(contentsOfURL: url!)
//                    dispatch_async(dispatch_get_main_queue(), {
                delay(0.001){
                        //----
                    if Reachability.isConnectedToNetwork() == true {
                        print("Internet connection OK")
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                        let database1 = databaseFile()
                        database1.addImageToTask("\(self.taskData.valueForKey("AttachmentVideoFile")!)", AttachmentImageData: encodedData,imageORvideo:"AttachmentVideoFile")
                        self.videoData = data!
                    }
                }
//                    });
//                }
                
            }else{
                if self.lblAttachment.hidden {
                    self.lblAttachment.hidden = true
                }else{
                
                }
                
                if imageView.hidden || imageViewVideo.hidden{
                    self.lblAttachment.hidden = true
                }else{
                   self.lblAttachment.hidden = false
                }
                
            }
        }else{
            self.lblAttachment.hidden = true
            
        }
//                    dispatch_async(dispatch_get_main_queue(), {
        //
        //                
//                    });
//                }
        
        
    }
    
    func downloadImage() {
        let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentImageFile")!)")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!)
            
            if Reachability.isConnectedToNetwork() == true {
                print("Internet connection OK")
                
            dispatch_async(dispatch_get_main_queue(), {
                if self.imageView != nil && data != nil {
                    self.imageView.image = UIImage(data: data!)
                }
                if data != nil {
                    let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                    let database = databaseFile()
                    database.addImageToTask("\(self.taskData.valueForKey("AttachmentImageFile")!)", AttachmentImageData: encodedData, imageORvideo:"AttachmentImageFile")
                    print("image download complete")
                }
            });
        }
        }
    
    }
    func downloadVideo() {
        let url = NSURL(string: "\(self.taskData.valueForKey("AttachmentVideoFile")!)")
        self.generateThumbnail(url!)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let data = NSData(contentsOfURL: url!)
            dispatch_async(dispatch_get_main_queue(), {
                
                //----
                if Reachability.isConnectedToNetwork() == true {
                    print("Internet connection OK")
                let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data!)
                let database = databaseFile()
                database.addImageToTask("\(self.taskData.valueForKey("AttachmentVideoFile")!)", AttachmentImageData: encodedData,imageORvideo:"AttachmentVideoFile")
                self.videoData = data!
                }
            });
        }
        
    }
    func generateThumbnail (url:NSURL) {
        do {
            viewimageBackground.hidden = false
            let asset = AVURLAsset(URL: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            let uiImage = UIImage(CGImage: cgImage)
            viewimageBackground.hidden = false
            self.imageViewVideo.image = uiImage
            
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
    }
    
    func playVideo(data:NSData) {
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let temppath:String = documentDirectory.stringByAppendingString("/video.mp4")
        videoStatus = data.writeToFile(temppath, atomically: true)
        
        if videoStatus {
            let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: temppath)))
            let playerItem = AVPlayerItem(asset:videoAsset)
            
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            presentViewController(playerViewController, animated:true){
                playerViewController.player!.play()
            }

        }
    }
    
    @IBAction func btnPlayVideo(sender: AnyObject) {
        if videoData != nil {
           playVideo(videoData) 
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        
        if videoStatus {
            let filemanager = NSFileManager.defaultManager()
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .   UserDomainMask, true)[0] as String
            let temppath:String = documentDirectory.stringByAppendingString("/video.mp4")
            do{
                try filemanager.removeItemAtPath(temppath)
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if Reachability.DeviceType.IS_IPHONE_5 {
        scrollView.contentSize = CGSizeMake(320, 700)
        }
        
        let sizeThatFitsTextView: CGSize = self.txtComments.sizeThatFits(CGSizeMake(txtComments.frame.size.width, CGFloat(MAXFLOAT)))
        TextViewHeightConstraint.constant = sizeThatFitsTextView.height
        
        
        let sizeThatFitsTextView1: CGSize = self.txtTaskDescription.sizeThatFits(CGSizeMake(txtTaskDescription.frame.size.width, CGFloat(MAXFLOAT)))
        TextHeadingHeightConstraint.constant = sizeThatFitsTextView1.height

        
        

        
    }
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }

}
