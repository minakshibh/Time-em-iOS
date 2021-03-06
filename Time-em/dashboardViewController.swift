//30 45 68
//  dashboardViewController.swift
//  Time-em
//
//  Created by Krishna Mac Mini 2 on 13/05/16.
//  Copyright © 2016 Krishna_Mac_2. All rights reserved.
//

import UIKit
import KGModal
import FMDB
import MBProgressHUD

class dashboardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var btnMyTasks: UIButton!
    @IBOutlet var widgetBackgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet var manageButtonottomSpace: NSLayoutConstraint!
    @IBOutlet var btnNotificationSecond: UIButton!
    @IBOutlet var btnMyTeam: UIButton!
    @IBOutlet var btnNotifications: UIButton!
    @IBOutlet var btnSetting: UIButton!
    @IBOutlet var viewStartWorking: UIView!
    @IBOutlet var btnCrossPOPUP: UIButton!
    @IBOutlet var btnSignInOutPOPUP: UIButton!
    @IBOutlet var btnSignInOut2: UIButton!
    @IBOutlet var lblpopupBackground: UILabel!
     @IBOutlet var imageViewLogoPopup: UIImageView!
    
     @IBOutlet var lblStartWorking: UILabel!
    @IBOutlet var lblStartWorkingOnTasks: UILabel!
    
    @IBOutlet var btnBackgroundPopUP: UIButton!
    var val:Int = 0
    var count:Int = 0
    var currentUser: User!
    var boxView:UIView!
    @IBOutlet var btnUserInfo: UIButton!
     @IBOutlet var btnSync: UIButton!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var sideView: UIView!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnScanBarcode: UIButton!
    @IBOutlet var imageSyncMenu: UIImageView!
    @IBOutlet var imageWorkunderConst: UIImageView!
    @IBOutlet var imagePersonMenu: UIImageView!
    var fromPassCodeView:String!
    @IBOutlet var lblNameSlideMenu: UILabel!
    var pageMenu : CAPSPageMenu?
    var lblBackground:UILabel!
    var selectedWidgets:NSMutableArray = []
    @IBOutlet var widgetCollectionView: UICollectionView!
    @IBOutlet var widgetBackground: UIView!
    var counterForWidget:Int = 0
    
    
    private let reuseIdentifier = "WidgetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideView.hidden = true
        
        lblStartWorking.text = "Hello \(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_FullName")!)"
        if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0" {
            lblStartWorkingOnTasks.text = "You are currently Signed Out. Please click Sign In to go Online."
          
        }else{
            
          
            lblStartWorkingOnTasks.text = "You are currently Signed In. Please click Sign Out to go offline."
        }

        
//        self.fetchUserTaskGraphDataFromAPI()
//        self.fetchUserTaskGraphDataFromDatabase()

         lblBackground = UILabel(frame: CGRectMake(0, self.view.bounds.height-btnMyTasks.frame.size.height, self.view.bounds.width, btnMyTasks.frame.size.height))
        lblBackground.backgroundColor = UIColor(red: 30.0/255.0, green: 45.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        self.view.addSubview(lblBackground)
        self.view.bringSubviewToFront(btnMyTasks)
        self.view.bringSubviewToFront(btnMyTeam)
        self.view.bringSubviewToFront(btnNotifications)
        self.view.bringSubviewToFront(btnSetting)
        self.view.bringSubviewToFront(btnNotificationSecond)
        self.view.bringSubviewToFront(self.sideView)
        self.view.bringSubviewToFront(btnMenu)
        
      ///////-->> fetch all data on dashboard
        let assignedTasks = ApiRequest()
        let currentUserId = NSUserDefaults.standardUserDefaults() .objectForKey("currentUser_id")
        
        self.fetchUserTaskGraphDataFromAPI()
        self.fetchUserSignedGraphDataFromAPI()
        //get notificaiton api
            //        self.fetchNotificationList()
        assignedTasks.getAllNotificationsInStart(currentUserId as! String)
        
        // get team details
//        self.fetchTeamList()
        NSUserDefaults.standardUserDefaults().setObject("true", forKey:"exicuteOnlyOnce")
        assignedTasks.getTeamOfflineAtStart(currentUserId as! String)
       
        // gett assigned tasks
//        assignedTasks.GetAssignedTaskIList(currentUserId as! String, view: self.view)
        assignedTasks.getAssignedTaskListOfflineATStart(currentUserId as! String
            )
        
        assignedTasks.GetNotificationType()
//        self.getActiveUserList()
        assignedTasks.getUserlistingforSendingNotiOffline(currentUserId as! String)
        NSUserDefaults.standardUserDefaults().setObject("false", forKey:"isEditingOrAdding")
        //get all tasks apis
//        assignedTasks.getUserTask(currentUserId as! String, createdDate: "",TimeStamp: "", view: self.view)
        assignedTasks.fetchAllTaskAtOnce(currentUserId as! String, createdDate: "")
//        assignedTasks.GetUserWorksiteListActivity("2,8049,7,10", view: self.view)
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

        
        if fromPassCodeView != "yes" {
            
            
            if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil {
            if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0" {
                
                self.viewStartWorking.alpha = 0
                self.viewStartWorking.hidden = false
                 self.btnSignInOutPOPUP.setTitle("Sign In", forState: .Normal)
                self.btnSignInOut2.setTitle("Sign In", forState: .Normal)

                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.viewStartWorking.alpha = 1
                    }, completion: nil)
                
                }else{
                self.viewStartWorking.alpha = 0
                self.viewStartWorking.hidden = false
                self.btnSignInOutPOPUP.setTitle("Sign Out", forState: .Normal)
                self.btnSignInOut2.setTitle("Sign Out", forState: .Normal)

                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.viewStartWorking.alpha = 1
                    }, completion: nil)
                }
            }
        }else{
            self.viewStartWorking.hidden = true
        }
       
//        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(dashboardViewController.showMenuFunction), userInfo: nil, repeats: false)
        lblpopupBackground.layer.cornerRadius = 8
        btnSignInOutPOPUP.layer.cornerRadius = 4
        lblpopupBackground.layer.masksToBounds = true
        btnSignInOutPOPUP.layer.masksToBounds = true

        registerUserDevice()
        
        btnNotificationSecond.hidden = true
        
        
        //---
         boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.whiteColor()
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        if Reachability.DeviceType.IS_IPHONE_6 ||  Reachability.DeviceType.IS_IPHONE_6P {
           boxView.frame = CGRectMake(boxView.frame.origin.x, boxView.frame.origin.y-60, boxView.frame.size.width, boxView.frame.size.height)
        }
        
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.grayColor()
        textLabel.text = "Loading Graph"
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
        self.view.bringSubviewToFront(viewStartWorking)
        self.view.bringSubviewToFront(self.sideView)
        self.view.bringSubviewToFront(btnMenu)

        
       
    }
    
    func implementGraphViews(){
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 : UserGraphViewController = UserGraphViewController(nibName: "UserGraphViewController", bundle: nil)
        controller1.title = "User Graph"
        controllerArray.append(controller1)
        
        let controller2 : UserLoginGraphViewController = UserLoginGraphViewController(nibName: "UserLoginGraphViewController", bundle: nil)
        controller2.title = "User Login Graph"
        controllerArray.append(controller2)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor(red: 60.0/255.0, green: 177.0/255.0, blue: 203.0/255.0, alpha: 1.0)),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 15.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(self.view.frame.size.width/2 - 40),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, btnSignInOut2.frame.size.height + btnSignInOut2.frame.origin.y, self.view.frame.width, 270), pageMenuOptions: parameters)
    
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMoveToParentViewController(self)
        self.view.sendSubviewToBack(pageMenu!.view)
//        self.view.bringSubviewToFront( self.sideView)
        
//
    }
    
    
    func showMenuFunction() {
        
        self.menuSlideBack()
        sideView.hidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        btnSetting.backgroundColor = UIColor.clearColor()
//        btnNotificationSecond.backgroundColor = UIColor.clearColor()
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnMyTasks.backgroundColor = UIColor.clearColor()
        
        
        menuSlideBack()
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//        setNotificationButton()

    }
    func checkActiveInacive() {
        if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") != nil {
            print(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)
        if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0"  {
        self.btnUserInfo.setImage(UIImage(named: "user_inactive"), forState: .Normal)
         imagePersonMenu.image = UIImage(named: "user_inactive")
        
        }else{
            self.btnUserInfo.setImage(UIImage(named: "user_active"), forState: .Normal)
            imagePersonMenu.image = UIImage(named: "user_active")
            
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchUserTaskGraphDataFromAPI()
        self.fetchUserSignedGraphDataFromAPI()
//        self.fetchUserTaskGraphDataFromDatabase()
//        self.fetchUserSignedGraphDataFromDatabase()
        print(selectedWidgets)
        if NSUserDefaults.standardUserDefaults().valueForKey("selectedWidgets") != nil {
            let data:NSData = NSUserDefaults.standardUserDefaults().valueForKey("selectedWidgets") as! NSData
            
            selectedWidgets = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSMutableArray
      
            widgetCollectionView.reloadData()
        }

        let currentUserName = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_FullName")  as? String
        lblNameSlideMenu.text = currentUserName!
        self.checkActiveInacive()
        refreshButtonTitleImage()
        
        print(sideView.frame)
        if sideView.frame.origin.x == 0 {
            self.menuSlideBack()
        }
        
//        let usertype = "\(NSUserDefaults.standardUserDefaults().valueForKey("UserTypeId")!)"
//        print(usertype)
//        if "\(usertype)" == "4" {
//            btnMyTeam.hidden = true
//            btnNotifications.hidden = true
//            self.btnNotificationSecond.hidden = false
////            delay(0.001) {
//                print(self.btnMyTeam.frame)
//
//            self.btnMyTeam.frame = CGRectMake(self.btnMyTeam.frame.origin.x,self.btnMyTeam.frame.origin.y, 0, self.btnMyTeam.frame.size.height)
//            self.btnNotifications.frame = CGRectMake(self.view.frame.size.width/2-self.btnNotifications.frame.size.width/2,self.btnNotifications.frame.origin.y, self.btnNotifications.frame.size.width, self.btnNotifications.frame.size.height)
//            print(self.btnMyTeam.frame)
//            }
//
//        }
        refreshsyncImage()
       
        
        let usertype = NSUserDefaults.standardUserDefaults().valueForKey("UserTypeId")!
        if "\(usertype)" == "4" {
            btnMyTeam.hidden = true
            self.btnNotifications.hidden = true
        }
        
    }
    // &&&&&
    
    let kImageTopOffset: CGFloat = -15
    let kTextBottomOffset: CGFloat = -25
    
     func centerButtonImageTopAndTextBottom(button: UIButton, frame buttonFrame: CGRect, text textString: String, textColor: UIColor, font textFont: UIFont, image: UIImage, forState buttonState: UIControlState) {
        button.frame = buttonFrame
        button.setTitleColor((textColor ), forState:.Normal)
        button.setTitle(String(textString), forState: .Normal)
        button.titleLabel!.font = (textFont )
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -image.size.width, -25, 0.0)
        button.setImage((image ), forState: .Normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(-15, 0.0, 0.0, -button.titleLabel!.bounds.size.width)
    }
    
    
    
    func refreshsyncImage (){
        if NSUserDefaults.standardUserDefaults().valueForKey("sync") != nil {
            let syncStr = "\(NSUserDefaults.standardUserDefaults().valueForKey("sync")!)"
            if syncStr == "yes" {
                imageSyncMenu.image = UIImage(named: "sync- red")
            }else{
                imageSyncMenu.image = UIImage(named: "sync - green")
                
            }
        }else{
            NSUserDefaults.standardUserDefaults().setObject("no", forKey: "sync")
            imageSyncMenu.image = UIImage(named: "sync - green")
        }
    }
    
    func iphone5UiAdjustments() {
//        imageWorkunderConst.frame = CGRectMake(imageWorkunderConst.frame.origin.x, imageWorkunderConst.frame.origin.y, imageWorkunderConst.frame.size.width, imageWorkunderConst.frame.size.height+10)
        imageViewLogoPopup.frame = CGRectMake(imageViewLogoPopup.frame.origin.x, imageViewLogoPopup.frame.origin.y-30, imageViewLogoPopup.frame.size.width, imageViewLogoPopup.frame.size.height)
        lblStartWorking.frame = CGRectMake(self.lblpopupBackground.frame.origin.x, lblpopupBackground.frame.origin.y + imageViewLogoPopup.frame.height+20,self.lblpopupBackground.frame.size.width,30)
         lblStartWorking.font = UIFont(name: lblStartWorking.font.fontName, size: 14)
//        lblStartWorking.font = lblStartWorking.font.fontWithSize(14)
        lblStartWorkingOnTasks.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblStartWorkingOnTasks.numberOfLines = 2
        lblStartWorkingOnTasks.font = UIFont(name: lblStartWorkingOnTasks.font.fontName, size: 14)
        lblStartWorkingOnTasks.frame = CGRectMake(self.lblpopupBackground.frame.origin.x+3, lblStartWorking.frame.origin.y + lblStartWorking.frame.height - 12, lblpopupBackground.frame.size.width - 6,60)
        lblStartWorkingOnTasks.numberOfLines = 2
        btnSignInOutPOPUP.frame = CGRectMake(btnSignInOutPOPUP.frame.origin.x, btnSignInOutPOPUP.frame.origin.y, btnSignInOutPOPUP.frame.size.width, btnSignInOutPOPUP.frame.size.height)
        lblpopupBackground.frame = CGRectMake(lblpopupBackground.frame.origin.x, lblpopupBackground.frame.origin.y, lblpopupBackground.frame.size.width, lblpopupBackground.frame.size.height-20)
    
        if Reachability.DeviceType.IS_IPHONE_4_OR_LESS {
            imageViewLogoPopup.frame = CGRectMake(imageViewLogoPopup.frame.origin.x, imageViewLogoPopup.frame.origin.y-60, imageViewLogoPopup.frame.size.width, imageViewLogoPopup.frame.size.height)
            lblStartWorking.frame = CGRectMake(lblStartWorking.frame.origin.x, lblStartWorking.frame.origin.y-70, lblStartWorking.frame.size.width, lblStartWorking.frame.size.height)
            lblStartWorkingOnTasks.frame = CGRectMake(lblStartWorkingOnTasks.frame.origin.x, lblStartWorkingOnTasks.frame.origin.y-70, lblStartWorkingOnTasks.frame.size.width, lblStartWorkingOnTasks.frame.size.height+18)
            lblStartWorkingOnTasks.numberOfLines = 2
            btnSignInOutPOPUP.frame = CGRectMake(btnSignInOutPOPUP.frame.origin.x, btnSignInOutPOPUP.frame.origin.y-40, btnSignInOutPOPUP.frame.size.width, btnSignInOutPOPUP.frame.size.height)
            lblpopupBackground.frame = CGRectMake(lblpopupBackground.frame.origin.x, lblpopupBackground.frame.origin.y-30, lblpopupBackground.frame.size.width, lblpopupBackground.frame.size.height-30)
            btnCrossPOPUP.frame = CGRectMake(btnCrossPOPUP.frame.origin.x, btnCrossPOPUP.frame.origin.y-30, btnCrossPOPUP.frame.size.width, btnCrossPOPUP.frame.size.height) 
        }
        
        
        
       if Reachability.DeviceType.IS_IPHONE_6 ||  Reachability.DeviceType.IS_IPHONE_6P{
        
           // btnSignInOutPOPUP.frame = CGRectMake(btnSignInOutPOPUP.frame.origin.x, btnSignInOutPOPUP.frame.origin.y+10, btnSignInOutPOPUP.frame.size.width, btnSignInOutPOPUP.frame.size.height)
        
             btnSignInOutPOPUP.frame = CGRectMake(btnSignInOutPOPUP.frame.origin.x, lblStartWorkingOnTasks.frame.origin.y+lblStartWorkingOnTasks.frame.size.height+50, btnSignInOutPOPUP.frame.size.width, btnSignInOutPOPUP.frame.size.height)
        
        lblStartWorking.frame = CGRectMake(self.lblpopupBackground.frame.origin.x, lblpopupBackground.frame.origin.y + imageViewLogoPopup.frame.height+50,self.lblpopupBackground.frame.size.width,30)
        lblStartWorking.font = UIFont(name: lblStartWorking.font.fontName, size: 16)
        //        lblStartWorking.font = lblStartWorking.font.fontWithSize(14)
        lblStartWorkingOnTasks.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblStartWorkingOnTasks.numberOfLines = 2
        lblStartWorkingOnTasks.font = UIFont(name: lblStartWorkingOnTasks.font.fontName, size: 16)
        lblStartWorkingOnTasks.frame = CGRectMake(self.lblpopupBackground.frame.origin.x + 5, lblStartWorking.frame.origin.y + lblStartWorking.frame.height , lblpopupBackground.frame.size.width - 10,60)
        lblStartWorkingOnTasks.numberOfLines = 2
        
        
        }
    }
     func layoutSubviews() {
        
        
    }
   override func viewDidAppear(animated: Bool) {
    
    if count == 0 {
    
   
        count += 1
    let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 9.0)!
    centerButtonImageTopAndTextBottom(btnMyTasks, frame: btnMyTasks.frame, text: "My Tasks", textColor: UIColor.whiteColor(), font: myFont, image: UIImage(named: "task")!, forState: .Normal)
    
    centerButtonImageTopAndTextBottom(btnMyTeam, frame: btnMyTeam.frame, text: "My Team", textColor: UIColor.whiteColor(), font: myFont, image: UIImage(named: "group_icon")!, forState: .Normal)
    
    centerButtonImageTopAndTextBottom(btnNotifications, frame: btnNotifications.frame, text: "Notifications", textColor: UIColor.whiteColor(), font: myFont, image: UIImage(named: "notification_Dashboard")!, forState: .Normal)
    
    centerButtonImageTopAndTextBottom(btnSetting, frame: btnSetting.frame, text: "Settings", textColor: UIColor.whiteColor(), font: myFont, image: UIImage(named: "setting")!, forState: .Normal)
        
        lblBackground.frame = CGRectMake(0, self.view.bounds.height-btnMyTasks.frame.size.height, self.view.bounds.width, btnMyTasks.frame.size.height)
        
        
    }
    
//    let usertype = NSUserDefaults.standardUserDefaults().valueForKey("UserTypeId")!
//    if "\(usertype)" == "4" {
//    NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(dashboardViewController.setNotificationButton), userInfo: nil, repeats: true)
//    }
    setNotificationButton()
    
        if val == 0 {
            val += 1
            if Reachability.DeviceType.IS_IPHONE_5 || Reachability.DeviceType.IS_IPHONE_6 || Reachability.DeviceType.IS_IPHONE_6P || Reachability.DeviceType.IS_IPHONE_4_OR_LESS{
                iphone5UiAdjustments()
            }
        }

    let value = "\(NSUserDefaults.standardUserDefaults().valueForKey("forGraph")!)"

    if value == "yes" {
        
    }else{
       self.implementGraphViews()
    }
    
    if Reachability.DeviceType.IS_IPHONE_5 {
//        widgetBackground.frame = CGRectMake(widgetBackground.frame.origin.x, widgetBackground.frame.origin.y+60, widgetBackground.frame.size.width, widgetBackground.frame.size.height-80)
        
        if counterForWidget == 0 {
        widgetBackgroundHeightConstraint.constant = widgetBackground.frame.size.height - 40
            counterForWidget=1
        }
    }else if Reachability.DeviceType.IS_IPHONE_4_OR_LESS{
        if counterForWidget == 0 {
            widgetBackgroundHeightConstraint.constant = widgetBackground.frame.size.height - 110
            counterForWidget=1
            
            manageButtonottomSpace.constant = manageButtonottomSpace.constant-10
        }
    }
    
    
    }
    
    
    
    func setNotificationButton () {
        let myFont: UIFont = UIFont(name: "HelveticaNeue", size: 9.0)!

        delay(0.001) {
            self.btnNotificationSecond.frame =  CGRectMake(self.view.frame.size.width/2-self.btnNotifications.frame.size.width/2, self.btnNotifications.frame.origin.y, self.btnNotifications.frame.size.width, self.btnNotifications.frame.size.height)
        }
        centerButtonImageTopAndTextBottom(btnNotificationSecond, frame: btnNotificationSecond.frame, text: "Notifications", textColor: UIColor.whiteColor(), font: myFont, image: UIImage(named: "notification_Dashboard")!, forState: .Normal)
        
        let usertype = NSUserDefaults.standardUserDefaults().valueForKey("UserTypeId")!
//        print(usertype)
        if "\(usertype)" == "4" {
            btnMyTeam.hidden = true
            
            self.btnNotifications.hidden = true
           
           self.btnNotificationSecond.hidden = false
            
        }
    }
    
    func registerUserDevice () {
        print( NSUserDefaults.standardUserDefaults().valueForKey("tokenString"))
        var uuidStr:String = ""
        if NSUserDefaults.standardUserDefaults().valueForKey("tokenString") != nil {
         uuidStr =  "\(NSUserDefaults.standardUserDefaults().valueForKey("tokenString")!)"
        }
        print(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id"))
        let currentUserId:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id")!)"
        let api = ApiRequest()
        api.registerUserDevice(currentUserId, DeviceUId: uuidStr, DeviceOS: "IOS")
    }
    
    func fetchUserTaskGraphDataFromAPI () {
        let currentUserId:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id")!)"
        let api = ApiRequest()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.displayGraphResponse), name: "com.time-em.getUserTaskGraphData", object: nil)
        api.fetchUserTaskGraphDataFromAPI(currentUserId ,view: self.view)
    }
//    func fetchUserTaskGraphDataFromDatabase() {
//        let databaseFetch = databaseFile()
//        let userTaskGraphDataArray : NSMutableArray = databaseFetch.getUserTaskGraphData()
//        print("\(userTaskGraphDataArray)")
//    }

    func displayGraphResponse() {
//        self.fetchUserTaskGraphDataFromDatabase()
        NSUserDefaults.standardUserDefaults().setObject("no", forKey:"forGraph")
         boxView.hidden = true
        self.implementGraphViews()

        let userGraph = UserGraphViewController()
        userGraph.viewWillAppear(true)
    }
    
    func displayUserSignedGraphResponse() {
        
        let userGraph = UserLoginGraphViewController()
        userGraph.viewWillAppear(true)
        //        self.fetchUserSignedGraphDataFromDatabase()
    }
//    func changepage (){
//        var currentIndex = pageMenu!.currentPageIndex
//        
//                if currentIndex == 0 {
//                    pageMenu!.moveToPage(currentIndex + 1)
//        }else if currentIndex == 1 {
//            pageMenu!.moveToPage(currentIndex - 1)
//        }
//    }
    func fetchUserSignedGraphDataFromAPI () {
        let currentUserId:String = "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id")!)"
        let api = ApiRequest()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.displayUserSignedGraphResponse), name: "com.time-em.getUserSignedGraphData", object: nil)
        api.fetchUserSignedGraphDataFromAPI(currentUserId ,view: self.view)
    }
//    func fetchUserSignedGraphDataFromDatabase() {
//        let databaseFetch = databaseFile()
//        let userSignedGraphDataArray : NSMutableArray = databaseFetch.getUserSignedGraphData()
//        print("\(userSignedGraphDataArray)")
//    }
    

    
    
    func refreshButtonTitleImage() {
        if NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn") != nil {
        if "\(NSUserDefaults.standardUserDefaults().valueForKey("currentUser_IsSignIn")!)" == "0" {
            self.btnSignInOutPOPUP.setTitle("SIGN IN", forState: .Normal)
            self.btnSignInOut2.setTitle("SIGN IN", forState: .Normal)
        }else{
            self.btnSignInOutPOPUP.setTitle("SIGN OUT", forState: .Normal)
            self.btnSignInOut2.setTitle("SIGN OUT", forState: .Normal)
        }
        }
    }
    
    @IBAction func btnSync(sender: AnyObject) {
        self.menuSlideBack()
        let database = databaseFile()
        var dataArray:NSMutableArray = []
        dataArray =  database.getDataFromSync()
//        print(dataArray)
        if dataArray.count == 0 {
            var alert :UIAlertController!
            alert = UIAlertController(title: "Time'em", message: "No offline data available to sync.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
           return
        }
        
        
        
        let addyaToSynkData:NSMutableArray = []
        let addyaToSynkNotification:NSMutableArray = []
        let uniqueDict:NSMutableDictionary = [:]
        for dictDATA in dataArray {
            
                    if dictDATA.valueForKey("AddUpdateNewTask") != nil {
                        let dict:NSMutableDictionary = [:]
                        let userArr:NSArray = (dictDATA.valueForKey("AddUpdateNewTask") as? NSArray)!
                        dict.setObject(userArr[9], forKey: "Id")
                        dict.setObject(userArr[8], forKey: "CreatedDate")
                        dict.setObject(userArr[7], forKey: "Comments")
                        dict.setObject(userArr[4], forKey: "UserId")
                        dict.setObject(userArr[3], forKey: "TaskId")
                        dict.setObject(userArr[2], forKey: "ActivityId")
                        dict.setObject(userArr[6], forKey: "TimeSpent")
                        dict.setObject(userArr[12], forKey: "CompanyId")
                        
                        if "\(userArr[3])" == "0" {
                        dict.setObject(userArr[5], forKey: "TaskName")
                        }
                        
                        if "\(userArr[9])" == "0"{
                            dict.setValue("add", forKey: "Operation")
                        }else{
                            dict.setValue("update", forKey: "Operation")
                        }
                        
                        var uniqueNo:String = ""
                        
                        
                        if "\(userArr[10])" == "1" {
                            let videoData:NSData = userArr[1] as! NSData
                            let count = videoData.length / sizeof(UInt8)
                            if count > 0{
                                uniqueNo = "video_\(userArr[11])"
                                dict.setObject("\(uniqueNo)", forKey: "UniqueNumber")
                                let localArr:NSMutableArray = []
                                localArr.addObject("video")
                                localArr.addObject(videoData)
                                uniqueDict.setObject(localArr, forKey: uniqueNo)
                            }
                        }else{
                            let imageData:NSData = userArr[0] as! NSData
                            let count = imageData.length / sizeof(UInt8)
                            if count > 0{
                                uniqueNo = "img_\(userArr[11])"
                                dict.setObject("\(uniqueNo)", forKey: "UniqueNumber")
                                let localArr:NSMutableArray = []
                                localArr.addObject("image")
                                localArr.addObject(imageData)
                                uniqueDict.setObject(localArr, forKey: uniqueNo)
                            }else{
                                dict.setObject("\(userArr[11])", forKey: "UniqueNumber")
                            }
                            
                        }
                        addyaToSynkData.addObject(dict)
                    }
                    if dictDATA.valueForKey("deleteTasks") != nil{
                        let dict:NSMutableDictionary = [:]
                        let userArr:NSArray = (dictDATA.valueForKey("deleteTasks") as? NSArray)!
                        dict.setObject(userArr[0], forKey: "Id")
                        dict.setValue("delete", forKey: "Operation")
                        addyaToSynkData.addObject(dict)
                    }
            if dictDATA.valueForKey("sendNotification") != nil{
                let dict:NSMutableDictionary = [:]
                let userArr:NSArray = (dictDATA.valueForKey("sendNotification") as? NSArray)!
                dict.setObject(userArr[1], forKey: "UserId")
                dict.setObject(userArr[2], forKey: "Subject")
                dict.setObject(userArr[3], forKey: "Message")
                dict.setObject(userArr[4], forKey: "NotificationTypeId")
                dict.setObject(userArr[5], forKey: "NotifyTo")
                dict.setObject(userArr[6], forKey: "CompanyId")
                
                if "\(userArr[0])".characters.count != 0{
                var uniqueNo:String = ""
                let imageData:NSData = userArr[0] as! NSData
                let count = imageData.length / sizeof(UInt8)
                if count > 0{
                    uniqueNo = "img_\(currentTimeMillis())"
                    dict.setObject("\(uniqueNo)", forKey: "UniqueNumber")
                    let localArr:NSMutableArray = []
                    localArr.addObject("image")
                    localArr.addObject(imageData)
                    uniqueDict.setObject(localArr, forKey: uniqueNo)
                }else{
                    dict.setObject("\(currentTimeMillis)", forKey: "UniqueNumber")
                    }
                addyaToSynkNotification.addObject(dict)
                }
            }

            
        }
        print(addyaToSynkData)
        print(addyaToSynkNotification)
        if addyaToSynkData.count > 0 || addyaToSynkNotification.count > 0{
            let api = ApiRequest()
            let data = NSData()
//            api.addUpdateTaskSynk(addyaToSynkData,type:"",uniqueno:"", data:data ,view: self.view)
            let notiricationkey = "com.time-em.sendSyncDataToServer"
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dashboardViewController.sendSyncDataToServerResponse), name: notiricationkey, object: nil)

            api.sendSyncDataToServer(addyaToSynkData,NotificationData:addyaToSynkNotification,imagesDataDict:uniqueDict,view:self.view)
        }
        
//        if uniqueDict.count > 0 {
//            let api = ApiRequest()
//            let array:NSMutableArray = []
//            for (key, value) in uniqueDict {
//                let arr:NSArray = (value as? NSArray)!
//                let data:NSData = (arr[1] as? NSData)!
//                api.addUpdateTaskSynk(array,type:"\(arr[0])",uniqueno:"\(key)", data:data ,view: self.view)
//            }
//            
//        }
        
            
        
            
       
    }
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    @IBAction func btnNotificationSecond(sender: AnyObject) {
        self.performSegueWithIdentifier("notification", sender: self)
        
//        btnNotificationSecond.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnMyTasks.backgroundColor = UIColor.clearColor()
        btnSetting.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func btnMyTasks(sender: AnyObject) {
        btnMyTasks.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnSetting.backgroundColor = UIColor.clearColor()
  
    }
    
     @IBAction func btnBackgroundPopUP(sender: AnyObject) {
        viewStartWorking.alpha = 1
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.viewStartWorking.alpha = 0
            
            }, completion: {(finished: Bool) -> Void in
                self.viewStartWorking.hidden = true
        })
        
    }
    
    @IBAction func btnMyTeam(sender: AnyObject) {
        btnMyTeam.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTasks.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnSetting.backgroundColor = UIColor.clearColor()
    }
    @IBAction func btnNotifications(sender: AnyObject) {
        self.performSegueWithIdentifier("notification", sender: self)

        btnNotifications.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnMyTasks.backgroundColor = UIColor.clearColor()
        btnSetting.backgroundColor = UIColor.clearColor()
    }
    @IBAction func btnSetting(sender: AnyObject) {
         self.performSegueWithIdentifier("setting", sender: self)
        btnSetting.backgroundColor = UIColor(red: 35/255, green: 51/255, blue: 86/255, alpha: 1)
        btnMyTeam.backgroundColor = UIColor.clearColor()
        btnNotifications.backgroundColor = UIColor.clearColor()
        btnMyTasks.backgroundColor = UIColor.clearColor()
    }
    @IBAction func btnCrossPOPUP(sender: AnyObject) {
        viewStartWorking.alpha = 1
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.viewStartWorking.alpha = 0
            
            }, completion: {(finished: Bool) -> Void in
                self.viewStartWorking.hidden = true
        })
    }

    @IBAction func btnUserInfo(sender: AnyObject) {
    }
    @IBAction func btnSignInOutPOPUP(sender: AnyObject) {
        let buttontitle:String = (btnSignInOutPOPUP.titleLabel!.text)!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dashboardViewController.displayResponse), name: "com.time-em.signInOutResponse", object: nil)
        
      let ActivityId =  NSUserDefaults.standardUserDefaults().valueForKey("currentUser_ActivityId") as! String
    let userId = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as! String
     let loginid = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_LoginId") as! String
        
        
        
        if buttontitle.lowercaseString == "sign in" {
            main{
            let api = ApiRequest()
            api.signInUser(userId, LoginId: loginid, view: self.view)
            }

        }else{
            main{

            let api = ApiRequest()
            
            api.signOutUser(userId, LoginId: loginid, ActivityId: ActivityId, view: self.view)

            }
        }
        
        
    }
    @IBAction func btnScanBarcode(sender: AnyObject) {
        let barcodeView: UIViewController? = self.storyboard?.instantiateViewControllerWithIdentifier("barcode")
        self.presentViewController(barcodeView!, animated: true, completion: nil)

    }
    @IBAction func btnLogout(sender: AnyObject) {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Time-em.sqlite")
        
        let database = FMDatabase(path: fileURL!.path)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        do {
        try database.executeUpdate("DELETE FROM tasksData", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
         do {
        try database.executeUpdate("DELETE FROM userdata", values: nil )
         } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM teamData", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM notificationtype", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM geofensingGraphList", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM notificationActiveUserList", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM notificationsTable", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM sync", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM assignedTaskList", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM UserSignedList", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        do {
            try database.executeUpdate("DELETE FROM TasksList", values: nil )
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        database.close()
        
        
    NSUserDefaults.standardUserDefaults().removeObjectForKey("UserTypeId")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("userLoggedIn")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_id")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("sync")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_IsSignIn")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_ActivityId")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_LoginId")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_FullName")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("activeUserListTimeStamp")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("taskTimeStamp")

    NSUserDefaults.standardUserDefaults().removeObjectForKey("notificationsTimeStamp")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("teamTimeStamp")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_Email")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_PhoneNumber")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("forGraph")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("selectedWidgets")
    NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_LoginCode")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_Pin")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_UserType")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("companyData")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("currentUser_company")
   
        
////        self.navigationController?.popToRootViewControllerAnimated(true)
//        self.dismissViewControllerAnimated(true, completion: nil)
        let loginVC: UIViewController? = self.storyboard?.instantiateViewControllerWithIdentifier("loginView")
        self.navigationController?.pushViewController(loginVC!, animated: true)
//        self.presentViewController(loginVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func backgroundButtonOnSlider(sender: AnyObject) {
        self.menuSlideBack()
    }
    func menuSlideBack() {
        UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseIn, animations: {() -> Void in
            var frame: CGRect = self.sideView.frame
            frame.origin.y = self.sideView.frame.origin.y
            frame.origin.x = self.view.frame.origin.x - self.sideView.frame.size.width
            self.sideView.frame = frame
            }, completion: {(finished: Bool) -> Void in
                NSLog("Completed")
        })
    }
    @IBAction func btnMenu(sender: AnyObject) {
        
        if sideView.frame.origin.x == 0 {
            self.menuSlideBack()
        }
        else {
            UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseOut, animations: {() -> Void in
                self.sideView.hidden = false
                var frame: CGRect = self.sideView.frame
                frame.origin.y = self.sideView.frame.origin.y
                frame.origin.x = 0
                self.sideView.frame = frame
//                var btnmenu_frame: CGRect = self.btnMenu.frame
//                btnmenu_frame.origin.x = self.btnMenu.frame.origin.x + self.sideView.frame.size.width
//                self.btnMenu.frame = btnmenu_frame
                }, completion: {(finished: Bool) -> Void in
                    NSLog("Completed")
                    
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myTasksSegue"{
            let mytasks = myTasksViewController()
            mytasks.viewCalledFrom = "myTasks"
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
    func displayResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)


//        var alert :UIAlertController!
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.signInOutResponse", object:nil)

//            alert = UIAlertController(title: "Time'em", message: status, preferredStyle: UIAlertControllerStyle.Alert)
     //   self.view.makeToast("\(status)")
       // self.view.makeToast("\(status)", duration:2, position:.center)
         self.view.makeToast("\(status)", duration: 2, position: .Center)
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
        
        viewStartWorking.alpha = 1
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.viewStartWorking.alpha = 0
            
            }, completion: {(finished: Bool) -> Void in
                self.viewStartWorking.hidden = true
        })
        self.checkActiveInacive()
        refreshButtonTitleImage()
        refreshsyncImage()
    }
    
    func sendSyncDataToServerResponse(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo!
        let status: String = (userInfo["response"] as! String)
        
        
        //        var alert :UIAlertController!
        NSNotificationCenter.defaultCenter().removeObserver(self, name:"com.time-em.sendSyncDataToServer", object:nil)
        refreshsyncImage()
        
    }
    // MARK: - Container View Controller
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }

    // MARK: - Collection view
    
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedWidgets.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! widgetsCell
        //2
        
        if selectedWidgets[indexPath.row] as! String == "0" {
            cell.widgetLabel.backgroundColor = UIColor(red: 99/255.0, green: 192/255.0, blue: 112/255.0, alpha: 1.0)
        }
        else if selectedWidgets[indexPath.row] as! String == "1"{
            cell.widgetLabel.backgroundColor = UIColor(red: 184/255.0, green: 63/255.0, blue: 58/255.0, alpha: 1.0)
        }else if selectedWidgets[indexPath.row] as! String == "2"{
            cell.widgetLabel.backgroundColor = UIColor(red: 81/255.0, green: 179/255.0, blue: 206/255.0, alpha: 1.0)
        }
        //3
        cell.widgetLabel.text = "Label \(selectedWidgets[indexPath.row])"
        cell.widgetLabel?.textAlignment = NSTextAlignment.Center
        return cell
    }
    
   
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Time'em", message: "Label \(selectedWidgets[indexPath.row]) selected.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    func fetchNotificationList() {
        
        let userid = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        
        let timestm:String!
        if NSUserDefaults.standardUserDefaults().valueForKey("notificationsTimeStamp") != nil {
            timestm = NSUserDefaults.standardUserDefaults().valueForKey("notificationsTimeStamp") as? String
        }else{
            timestm = ""
        }
        let api = ApiRequest()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.displayResponse), name: "com.time-em.getNotificationListByLoginCode", object: nil)
        api.getNotifications(userid!, timeStamp: timestm)
    }
    func fetchTeamList() {
        let logedInUserId =   NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        let timestm:String!
        if NSUserDefaults.standardUserDefaults().valueForKey("teamTimeStamp") != nil {
            timestm = NSUserDefaults.standardUserDefaults().valueForKey("teamTimeStamp") as? String
        }else{
            timestm = ""
        }
        let api = ApiRequest()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTeamViewController.displayResponse), name: "com.time-em.getTeamResponse", object: nil)
        api.getTeamDetail(logedInUserId!, TimeStamp:timestm, view: self.view)
    }
    func getActiveUserList(){
        // Do any additional setup after loading the view.
        let api = ApiRequest()
        
        
        let userIdStr = NSUserDefaults.standardUserDefaults().valueForKey("currentUser_id") as? String
        let TimeStamp:String!
        if NSUserDefaults.standardUserDefaults().objectForKey("activeUserListTimeStamp") != nil {
            TimeStamp = NSUserDefaults.standardUserDefaults().objectForKey("activeUserListTimeStamp") as? String
        }else{
            TimeStamp = ""
        }
        api.getActiveUserList(userIdStr!,timeStamp:TimeStamp,view:self.view)
    }
}
