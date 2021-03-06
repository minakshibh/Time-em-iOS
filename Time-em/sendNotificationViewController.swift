//
//  sendNotificationViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 27/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import JLToast


class sendNotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet var btnCrossImage: UIButton!
    @IBOutlet var TextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var TextPlaceHolderViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet var heightConstraintFortxtComment: NSLayoutConstraint!
     @IBOutlet var txtCommentHeightConstraint: NSLayoutConstraint!
    @IBOutlet var taskDropDown: UIButton!
    let dropDown = DropDown()
    @IBOutlet var txtSelectMessage: UITextField!
    @IBOutlet var txtComment: UITextView!
    @IBOutlet var txtSubject: UITextView!
    @IBOutlet var lblPlaceholderComments: UILabel!
    @IBOutlet var lblPlaceholderSelectrecipients: UILabel!
    @IBOutlet var lblPlaceholderSubject: UILabel!
    @IBOutlet var lblheader: UILabel!
    var notificationTypeDropdownArray:NSArray = []
    var recipientsArray:NSArray = []
    @IBOutlet var btnSelectRecipients: UIButton!
    var tableView: UITableView!
    var selectedUser:NSMutableArray = []
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var uploadedImage:UIImageView!
    @IBOutlet var btnUploadImage:UIButton!
    let imagePicker = UIImagePickerController()
     @IBOutlet var scrollView: UIScrollView!
    var NotificationTypeId:String! = " "
    var selectedRecipientsNameArr:NSMutableArray = []
    var selectedRecipientsIdArr:NSMutableArray = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSend.layer.cornerRadius = 4
        btnUploadImage.layer.cornerRadius = 4
        
        
        uploadedImage.layer.cornerRadius = 4
        uploadedImage.layer.masksToBounds = true
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sendNotificationViewController.GetNotificationTypeResponse), name: "com.time-em.NotificationTypeloginResponse", object: nil)
        
        btnSelectRecipients.setTitleColor(UIColor.blackColor(), forState: .Normal)
        uploadedImage.hidden = true
        
//        scrollView.frame = CGRectMake(0, 64, 320, 736)
//        scrollView.scrollEnabled = true
//        scrollView.delegate = self
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.contentSize = CGSizeMake(320, 736)
//        NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 200).active = true
        scrollView.backgroundColor = UIColor.clearColor()
//        if #available(iOS 9.0, *) {
//            scrollView.widthAnchor.constraintEqualToAnchor(nil, constant: 300).active = true
//        } else {
//            // Fallback on earlier versions
//        }
        imagePicker.delegate = self
    }
    
   override func viewWillAppear(animated: Bool) {
        let sizeThatFitsTextView: CGSize = self.txtComment.sizeThatFits(CGSizeMake(self.txtComment.frame.size.width, CGFloat(MAXFLOAT)))
        print(sizeThatFitsTextView.height)
//        self.TextViewHeightConstraint.constant = sizeThatFitsTextView.height
//    self.TextPlaceHolderViewHeightConstraint.constant = sizeThatFitsTextView.height-10
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        scrollView.frame = CGRectMake(0, lblheader.frame.origin.y + lblheader.frame.size.height, 320, 736)
        scrollView.scrollEnabled = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if Reachability.DeviceType.IS_IPHONE_5 {
        scrollView.contentSize = CGSizeMake(320, 650)
//        btnUploadImage.frame = CGRectMake(uploadedImage.frame.origin.x, uploadedImage.frame.origin.y, uploadedImage.frame.size.width+65, uploadedImage.frame.size.height)
        }
        scrollView.backgroundColor = UIColor.clearColor()
//        NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 300).active = true
//        if #available(iOS 9.0, *) {
//            scrollView.widthAnchor.constraintEqualToAnchor(nil, constant: 300).active = true
//        } else {
//            // Fallback on earlier versions
//        }
        
        
        tableView = UITableView(frame: CGRectMake(btnSelectRecipients.frame.origin.x, btnSelectRecipients.frame.origin.y+btnSelectRecipients.frame.size.height-3, btnSelectRecipients.frame.size.width, 220 ), style: .Plain)
        
        if Reachability.DeviceType.IS_IPHONE_5 {
           tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y+5, tableView.frame.size.width, tableView.frame.size.height-50)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "commentCellss")
        tableView.layer.cornerRadius = 4
//        tableView.backgroundColor = UIColor(red: 235/256, green: 235/256, blue: 235/256, alpha: 1)

        
        
        //        self.tableViewContact.layer.cornerRadius = 8.0
        
        
        self.scrollView.addSubview(tableView)
        tableView.allowsMultipleSelection = true
        tableView.hidden = true
        
        getDataFromDatabase()
        tableView.reloadData()

    }
    
    func setDropDown(){
        let idArr:NSMutableArray = []
        let nameArr:NSMutableArray = []
        
        for  i in notificationTypeDropdownArray {
            idArr.addObject(i.valueForKey("id")!)
            nameArr.addObject(i.valueForKey("Name")!)
        }

        
        dropDown.dataSource = nameArr.mutableCopy() as! [String]
        
        //~~ Add Value to textfield from dropdown
        dropDown.selectionAction = { [unowned self] (index, item) in
            
            
            print("Clicked at index \(index)")
            print(nameArr[index])
            print(idArr[index])
            self.txtSelectMessage.text = item
             self.txtSelectMessage.textColor = UIColor.blackColor()
            self.NotificationTypeId = "\(idArr[index])"
        }
        
//        dropDown.anchorView = txtSelectMessage
//        dropDown.bottomOffset = CGPoint(x: 0, y:txtSelectMessage.bounds.height)
//        
    }
    
    func getDataFromDatabase () {
        let database = databaseFile()
       notificationTypeDropdownArray = database.getNotificationType()
        setDropDown()
        
       recipientsArray = database.getNotificationActiveUserList()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnbackground(sender: AnyObject) {
        self.tableView.hidden = true
    }

    @IBAction func selectTaskFromDropDown(sender: AnyObject) {
        txtSubject.resignFirstResponder()
        txtComment.resignFirstResponder()
        tableView.hidden = true
            if dropDown.hidden {
                dropDown.show()
            } else {
                dropDown.hide()
            }
        
        
    }

    //~ TextView Delegates
    func textViewDidBeginEditing(textView: UITextView) {
        
        txtComment.layer.borderColor = UIColor.clearColor().CGColor
        txtSubject.layer.borderColor = UIColor.clearColor().CGColor
        
        tableView.hidden = true
        if textView == txtComment {
            lblPlaceholderComments.hidden = true
        }else if textView == txtSubject {
            lblPlaceholderSubject.hidden = true
        }
        
        
    }
    func textViewShouldEndEditing(textView: UITextView) {
        if textView == txtComment {
            if txtComment.text.characters.count == 0 {
                lblPlaceholderComments.hidden = false
            }
        }else if textView == txtSubject {
            if txtSubject.text.characters.count == 0 {
                lblPlaceholderSubject.hidden = false
            }
        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
       
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        delay(0.001){
        let sizeThatFitsTextView: CGSize = self.txtComment.sizeThatFits(CGSizeMake(self.txtComment.frame.size.width, CGFloat(MAXFLOAT)))
        print(sizeThatFitsTextView.height)
            if sizeThatFitsTextView.height > 57 {
                
            }else{
                self.TextViewHeightConstraint.constant = sizeThatFitsTextView.height
//                self.TextPlaceHolderViewHeightConstraint.constant = sizeThatFitsTextView.height
                
            }
        }
        if textView == txtSubject {
            if (text == "\n") {
                txtComment.becomeFirstResponder()
            }
        }else if textView == txtComment {
            if (text == "\n") {
                txtComment.resignFirstResponder()
            }
        }
        return true
    }
    func GetNotificationTypeResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.sendnotification", object:nil)

        getDataFromDatabase()
    }
    
    @IBAction func btnCrossImage(sender: AnyObject) {
        uploadedImage.image = nil
        uploadedImage.hidden = true
        btnCrossImage.hidden = true
    }
    
    
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnSelectRecipients(sender: AnyObject) {
        tableView.frame = CGRectMake(tableView.frame.origin.x, btnSelectRecipients.frame.origin.y+btnSelectRecipients.frame.size.height-3, tableView.frame.size.width, tableView.frame.size.height)
        
        tableView.layer.shadowOffset = CGSizeMake(0, 0)
        tableView.layer.shadowColor = UIColor.blackColor().CGColor
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 0.25
//        tableView.layer.masksToBounds = false;
//        tableView.clipsToBounds = false;

        getDataFromDatabase()
        txtComment.resignFirstResponder()
        txtSubject.resignFirstResponder()
        if tableView.hidden {
            tableView.hidden = false
            btnSelectRecipients.layer.borderColor = UIColor.clearColor().CGColor

        } else {
            tableView.hidden = true
        }
    }
    @IBAction func btnSend(sender: AnyObject) {

        
        
//        if (txtSubject.text.characters.count < 0 || txtComment.text.characters.count < 0) {
//            
//            
//            
//            
//        }
        
        tableView.hidden = true
        txtComment.resignFirstResponder()
        txtSubject.resignFirstResponder()
        
        var imageData = NSData()
        if uploadedImage.image != nil {
            imageData = UIImagePNGRepresentation(uploadedImage.image!)!
        }
        
        let UserId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id")as? String
        let subject:String!
        let comments:String!
        
//        if NotificationTypeId == " " {
//            let alert = UIAlertController(title: "Time'em", message: "Select Task type before continue.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            return
//        }
        NotificationTypeId = "0"
        
        if txtSubject.text.isEmpty {
//            let alert = UIAlertController(title: "Time'em", message: "Enter subject before continue.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
            
            txtSubject.layer.borderColor = UIColor.redColor().CGColor
            txtSubject.layer.borderWidth = 1
            txtSubject.layer.cornerRadius = 5
            subject = ""
        }else{
            subject = txtSubject.text
        }
        
        if txtComment.text.isEmpty {
//            let alert = UIAlertController(title: "Time'em", message: "Enter comments before continue.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
            
            txtComment.layer.borderColor = UIColor.redColor().CGColor
            txtComment.layer.borderWidth = 1
            txtComment.layer.cornerRadius = 5
            comments = ""
        }else{
            comments = txtComment.text
        }
        
        var ids:String!
        if selectedRecipientsIdArr.count == 0 {
//            let alert = UIAlertController(title: "Time'em", message: "Select recipients before continue.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
            
            btnSelectRecipients.layer.cornerRadius = 5
            btnSelectRecipients.layer.borderWidth = 1
            btnSelectRecipients.layer.borderColor = UIColor.redColor().CGColor
            
        }else{
            
            for j in ( 0 ..< selectedRecipientsIdArr.count) {
                if j==0 {
                    ids = "\(selectedRecipientsIdArr[0])"
                }else{
                    ids = "\(ids),\(selectedRecipientsIdArr[j])"
                }
            }
        }
        
        if !txtComment.text.isEmpty && !txtSubject.text.isEmpty &&
         selectedRecipientsIdArr.count > 0
        {
        let sendNotification = ApiRequest()
        sendNotification.sendNotification(imageData, UserId: UserId!, Subject: subject, Message: comments, NotificationTypeId: NotificationTypeId, notifyto: ids, view: self.view)
        
//    sendNotification.newSendnotificationWebservice(UserId!, Subject: subject, Message: comments, NotificationTypeId: NotificationTypeId, notifyto: ids, view: self.view)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sendNotificationViewController.sendnotificationResponse), name: "com.time-em.sendnotification", object: nil)
        }
    }
    func sendnotificationResponse(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.sendnotification", object:nil)

        if status.lowercaseString.rangeOfString("successfully") != nil {
            var alert :UIAlertController!
            alert = UIAlertController(title: "Time'em", message:"Notification sent successfully", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                main {
                    self.dismissViewControllerAnimated(true, completion: {});
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
//            delay(0.001){
            JLToast.makeText("Notification added Successfully!", duration: JLToastDelay.ShortDelay)
            
//            }
        }else{
            var alert :UIAlertController!
            alert = UIAlertController(title: "Time'em", message:"Error sending notification", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
       

    }
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipientsArray.count > 0 && recipientsArray.count < 4 {
            tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 30 * CGFloat(recipientsArray.count))
        }
            return recipientsArray.count
    }
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 30
    }

      func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCellss", forIndexPath: indexPath)
        
        
        for object in cell.contentView.subviews
        {
            object.removeFromSuperview();
        }
        let dict:NSDictionary = (recipientsArray[indexPath.row] as? NSDictionary)!
        
        cell.textLabel?.text = "\(dict.valueForKey("FullName")!)"
        let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 14.0)!
        cell.textLabel?.font = myFont
        if Reachability.DeviceType.IS_IPHONE_5 {
        let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 12.0)!
        cell.textLabel?.font = myFont
        }
//        cell.backgroundColor = UIColor(red: 235/256, green: 235/256, blue: 235/256, alpha: 1)
        cell.selectionStyle = .None
        if selectedRecipientsIdArr.containsObject("\(dict.valueForKey("userid")!)") {
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        return cell
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict:NSDictionary = (recipientsArray[indexPath.row] as? NSDictionary)!
        if selectedRecipientsIdArr.containsObject("\(dict.valueForKey("userid")!)"){
            selectedRecipientsIdArr.removeObject("\(dict.valueForKey("userid")!)")
            selectedRecipientsNameArr.removeObject("\(dict.valueForKey("FullName")!)")
            tableView.reloadData()
            
            var usernames:String! = ""
            for j in (0 ..< selectedRecipientsNameArr.count) {
                if j==0 {
                    usernames = "\(selectedRecipientsNameArr[0])"
                }else{
                    usernames = "\(usernames),\(selectedRecipientsNameArr[j])"
                }
            }
            lblPlaceholderSelectrecipients.hidden = true
            btnSelectRecipients.setTitle(usernames, forState: .Normal)
            
            return
        }
        selectedRecipientsNameArr.addObject("\(dict.valueForKey("FullName")!)")
        selectedRecipientsIdArr.addObject("\(dict.valueForKey("userid")!)")
        
        var usernames:String! = ""
        for j in (0 ..< selectedRecipientsNameArr.count) {
            if j==0 {
                usernames = "\(selectedRecipientsNameArr[0])"
            }else{
                usernames = "\(usernames),\(selectedRecipientsNameArr[j])"
            }
        }
        lblPlaceholderSelectrecipients.hidden = true
        btnSelectRecipients.setTitle(usernames, forState: .Normal)
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
     func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let dict:NSDictionary = (recipientsArray[indexPath.row] as? NSDictionary)!
        selectedRecipientsNameArr.removeObject("\(dict.valueForKey("FullName")!)")
        selectedRecipientsIdArr.removeObject("\(dict.valueForKey("userid")!)")
        var usernames:String! = ""
        for j in (0 ..< selectedRecipientsNameArr.count) {
            if j==0 {
                usernames = "\(selectedRecipientsNameArr[0])"
            }else{
                usernames = "\(usernames),\(selectedRecipientsNameArr[j])"
            }
        }
        if usernames.characters.count == 0 {
            lblPlaceholderSelectrecipients.hidden = false
        }
        btnSelectRecipients.setTitle(usernames, forState: .Normal)
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    
     @IBAction func btnUploadImage(sender: AnyObject) {
        
        txtComment.resignFirstResponder()
        txtSubject.resignFirstResponder()
    // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
    
    // 2
        let deleteAction = UIAlertAction(title: "Camera", style: .Default, handler: {
        (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .Camera
        
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .Default, handler: {
        (alert: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
        
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
    
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
        (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
    
    
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
    
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadedImage.hidden = false
            uploadedImage.contentMode = .ScaleToFill
            uploadedImage.image = pickedImage
            btnCrossImage.hidden = false
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tableView.hidden = true
    }
    
    


}
