//
//  LoginViewController.swift
//  Time'em
//
//  Created by Krishna Mac Mini 2 on 10/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import FMDB


class LoginViewController: UIViewController, UITextFieldDelegate,UIScrollViewDelegate {

    // MARK: Outlets
    @IBOutlet var imageLogo: UIImageView!
    @IBOutlet var txtUserID: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var imageUserID: UIImageView!
    @IBOutlet var imagePassword: UIImageView!
    @IBOutlet var seperatorUserID: UILabel!
    @IBOutlet var sepratorPassword: UILabel!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    
    var statusPasswordField:Bool = false
    var webData:NSMutableData!
    var currentUser: User!
    let notificationKey = "com.time-em.loginResponse"
    var scrollView: UIScrollView!
    
    
    
    // MARK: defaults methods
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserID.delegate = self
        txtPassword.delegate = self
        self.navigationController?.navigationBarHidden = true
        btnLogin.layer.cornerRadius = 4
        

        
        //--
    }
    
   
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if Reachability.DeviceType.IS_IPHONE_5 {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
            
        }

        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.navigationBarHidden = true
        print("\(NSUserDefaults.standardUserDefaults().valueForKey("userLoggedIn"))")
        
        if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil {
    if (NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") != nil){
                delay(0.001){
                self.performSegueWithIdentifier("login_passcode", sender: self)
                            }
        }
            
      }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buttons
    @IBAction func btnLogin(sender: AnyObject) {
        self.login()
        txtUserID.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    @IBAction func btnForgotPassword(sender: AnyObject) {

        self.performSegueWithIdentifier("resetPassword", sender: self)
//        let resetPinAndPasswordView = resetPinAndPassword()
//        self.navigationController?.pushViewController(resetPinAndPasswordView, animated: true)
    }

    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    
    
    // MARK: textfield delegates
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
//        if textField == txtUserID {
//            txtUserID.becomeFirstResponder()
//        }else if textField == txtPassword{
//            txtPassword.becomeFirstResponder()
//        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        if textField == txtUserID {
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
//        }
//        if textField == txtPassword {
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardDidShowNotification, object: nil)
//        }
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
//        
//        if textField == txtUserID {
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidHideNotification, object: nil)
//        }
//        if textField == txtPassword {
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardDidShowNotification, object: nil)
//        }

        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        if textField == txtUserID{
            statusPasswordField = true
            txtPassword.becomeFirstResponder()
        }else if textField == txtPassword{
            self.login()
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: functions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtUserID.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    func login() {
        let userIDStr: String = txtUserID.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let passwordStr: String = txtPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        var message:String = ""
        if userIDStr.isEmpty {
            message = "Please enter Username"
            let alert = UIAlertController(title: "Time'em", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }else if passwordStr.isEmpty{
            message = "Please enter password"
            let alert = UIAlertController(title: "Time'em", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.displayResponse), name: notificationKey, object: nil)
    
        let loginUser = ApiRequest()
//        let status:Bool = loginUser.loginApi(userIDStr, password: passwordStr)
        loginUser.loginApi(userIDStr, password: passwordStr,view: self.view)
        
        
      
 
    }
    
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)

        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:notificationKey, object:nil)

        var alert :UIAlertController!
        if status.lowercaseString == "success"{
         alert = UIAlertController(title: "Time'em", message: "Login Successfull", preferredStyle: UIAlertControllerStyle.Alert)
            self.performSegueWithIdentifier("companyView", sender: self)
        
        }else{
         alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "companyView"{
            let companyView = segue.destinationViewController as! ChooseCompanyViewController
            companyView.fromView = "fromLogin"
        }else if segue.identifier == "resetPassword"{
            let resetView = segue.destinationViewController as! resetPinAndPassword
            resetView.resetType = "Password"
        }
    }
    func getCurrentUser() {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL!.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
            let rs = try database.executeQuery("select * from userdata", values: nil)
            while rs.next() {
//                let x = rs.stringForColumn("userId")
                let y = rs.dataForColumn("userData")
                let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(y) as! NSMutableDictionary
                print(userDict)
                self.currentUser =  User(dict: userDict)
                
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }

//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
//        let newVerticalPosition: Float = Float(-keyboardSize.height)
//        self.moveFrameToVerticalPosition(newVerticalPosition, forDuration: 0.3)
//        }
//    }
//    func keyboardWillHide(notification: NSNotification) {
//        //    CGFloat  kNavBarHeight =  self.navigationController.navigationBar.frame.size.height;
//        let kNavBarHeight: CGFloat = 0
//        self.moveFrameToVerticalPosition(Float(kNavBarHeight), forDuration: 0.3)
//    }
//    func moveFrameToVerticalPosition(position: Float, forDuration duration: Float) {
//        var frame: CGRect = self.view.frame
//        frame.origin.y = CGFloat( -50)
//        UIView.animateWithDuration(0.3, animations: {() -> Void in
//            self.view.frame = frame
//        })
//    }
    
    func keyboardWillShow(notification: NSNotification) {
        if statusPasswordField {
            statusPasswordField = false
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
        
              self.view.frame.origin.y -= (keyboardSize.height/2)-20
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if statusPasswordField {
            
        }else{
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height/2) - 20
            }
            else {
                
            }
        }
        }
    }

}
