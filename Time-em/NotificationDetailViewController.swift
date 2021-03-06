//
//  NotificationDetailViewController.swift
//  Time-em
//
//  Created by Br@R on 06/06/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import Foundation
class NotificationDetailViewController: UIViewController {
    
    var notificationData:NSMutableDictionary! = [:]
    @IBOutlet var dateTimeLbl: UILabel!
    @IBOutlet var TextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var notification_subject_lbl: UITextView!
    @IBOutlet var notification_messageLbl: UITextView!
    @IBOutlet var sender_name_Lbl: UILabel!
    @IBOutlet var attachmentImageView: UIImageView!
    @IBOutlet var attachmentLbl: UILabel!
    @IBOutlet var attachmentImgBackView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self .displayData()
    }
    
    func displayData() {
        
        if notificationData.valueForKey("Subject") is NSNull
        {
            notification_subject_lbl.text = ""
        }
        else{
            notification_subject_lbl.text = "\(notificationData.valueForKey("Subject")!)"
        }
        
        if notificationData.valueForKey("SenderFullName") is NSNull
        {
            sender_name_Lbl.text = ""
        }
        else{
            sender_name_Lbl.text = "\(notificationData.valueForKey("SenderFullName")!)"
        }

        
        if notificationData.valueForKey("Message") is NSNull
        {
            notification_messageLbl.text = ""
        }
        else{
            notification_messageLbl.text = "\(notificationData.valueForKey("Message")!)"
        }
        
        
        attachmentLbl.hidden = true
        attachmentImgBackView.hidden = true
        
        if notificationData.valueForKey("AttachmentFullPath") is NSNull
        {
            attachmentLbl.hidden = true
            attachmentImageView.hidden = true
        }
        else{
            attachmentImageView.layer.cornerRadius = 4
            attachmentImageView.clipsToBounds = true
            
            if notificationData.valueForKey("AttachmentFullPath") as? String != "" {
                let url = NSURL(string: "\(self.notificationData.valueForKey("AttachmentFullPath")!)")
                
                
                self.attachmentLbl.hidden = false
                self.attachmentImgBackView.hidden = false
                
                attachmentImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "cross-popup"), options: .RefreshCached)

//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//                    let data = NSData(contentsOfURL: url!)
//                    dispatch_async(dispatch_get_main_queue(), {
                        if self.attachmentImageView != nil {
//                            self.attachmentImageView.image = UIImage(data: data!)
                            self.attachmentLbl.hidden = false
                            self.attachmentImgBackView.hidden = false
                        }
//                    });
//                }
            }
        }

        
        var dateStr: String = ""
        
        if notificationData.valueForKey("createdDate") is NSNull
        {
            dateTimeLbl.text = ""
        }
        else{
            dateStr = "\(notificationData.valueForKey("createdDate")!)"
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone.localTimeZone()
            let date: NSDate = dateFormatter.dateFromString(dateStr)!
            let currentDate: NSDate = NSDate()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1String = dateFormatter.stringFromDate(date)
            let date2String = dateFormatter.stringFromDate(currentDate)
            if date1String == date2String {
                dateFormatter.dateFormat = "HH:mm"
                dateStr = dateFormatter.stringFromDate(date)
                dateTimeLbl.text = "Today,\(dateStr)"
            }
            else{
                dateStr = self.dateConversion(date) as String
                dateTimeLbl.text = dateStr as String
            }
        }
        
        let sizeThatFitsTextView1: CGSize = self.notification_messageLbl.sizeThatFits(CGSizeMake(notification_messageLbl.frame.size.width, CGFloat(MAXFLOAT)))
        TextViewHeightConstraint.constant = sizeThatFitsTextView1.height

    }
    
    @IBAction func backBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dateConversion(date : NSDate) -> NSString {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d MMM,yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let dateStr: String = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    
}