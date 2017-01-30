//
//  DMCalenderVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import FSCalendar

class DMCalenderVC: DMBaseVC,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance {
    @IBOutlet weak var viewForCalender: UIView!
    @IBOutlet weak var bookedJobsTableView: UITableView!

    var calendar:FSCalendar?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.title = Constants.ScreenTitleNames.calendar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = self.rightBarButton()

        self.calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 311))
        self.calendar?.dataSource = self;
        self.calendar?.delegate = self;
        self.calendar?.allowsMultipleSelection = false
        self.calendar?.swipeToChooseGesture.isEnabled = false
        self.calendar?.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar?.appearance.caseOptions = .headerUsesUpperCase
        self.calendar?.pagingEnabled = true
        self.calendar?.placeholderType = .none
        
        self.calendar?.appearance.todayColor = UIColor.lightGray
        self.calendar?.appearance.headerTitleFont = UIFont.fontRegular(fontSize: 12)
        self.calendar?.appearance.titleFont = UIFont.fontRegular(fontSize: 16)
        self.calendar?.appearance.weekdayFont = UIFont.fontRegular(fontSize: 16)
        self.calendar?.appearance.adjustsFontSizeToFitContentSize = true
        self.calendar?.appearance.adjustTitleIfNecessary()
        self.calendar?.appearance.headerTitleColor = Constants.Color.headerTitleColor
        self.calendar?.appearance.weekdayTextColor = Constants.Color.weekdayTextColor
        self.calendar?.appearance.titleDefaultColor = Constants.Color.headerTitleColor
        self.calendar?.appearance.selectionColor = Constants.Color.CalendarSelectionColor
        
        self.calendar?.appearance.eventOffset = CGPoint(x: 0, y: -10)
        self.viewForCalender.addSubview(self.calendar!)


    }
    
    
    func rightBarButton() -> UIBarButtonItem {
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.designFont(fontSize: 30)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setImage(UIImage(named: "plusSymbol"), for: .normal)
        customButton.addTarget(self, action: #selector(setAvailablityButtonClicked(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- Calender Methods 
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 3
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 1.0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [UIColor.brown,UIColor.red,UIColor.yellow]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.brown,UIColor.yellow,UIColor.blue]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorsFor date: Date) -> [Any]? {
        
        return [UIColor.red,UIColor.green,UIColor.blue]
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return UIColor.clear
    }

    //pluse button Action
    func setAvailablityButtonClicked(_ sender: Any) {
        let termsVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        termsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(termsVC, animated: true)
    }

}
