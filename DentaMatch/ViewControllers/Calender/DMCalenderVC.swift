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
        self.title = "Calender"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 311))
        self.calendar?.dataSource = self;
        self.calendar?.delegate = self;
        self.calendar?.allowsMultipleSelection = false
        self.calendar?.swipeToChooseGesture.isEnabled = false
        self.calendar?.appearance.headerMinimumDissolvedAlpha = 0
        self.calendar?.appearance.caseOptions = .headerUsesUpperCase
        self.calendar?.pagingEnabled = true
        self.calendar?.placeholderType = .none
        
        self.calendar?.appearance.todayColor = UIColor.blue
        
        self.calendar?.appearance.headerTitleFont = UIFont.fontRegular(fontSize: 12)
        self.calendar?.appearance.titleFont = UIFont.fontRegular(fontSize: 16)
        self.calendar?.appearance.weekdayFont = UIFont.fontRegular(fontSize: 16)
        
        self.calendar?.appearance.adjustsFontSizeToFitContentSize = true
        self.calendar?.appearance.adjustTitleIfNecessary()
//                calenderView.appearance.preferredTitleFont = UIFont.fontRegular(fontSize: 16)
        
        self.calendar?.appearance.headerTitleColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1)
        self.calendar?.appearance.weekdayTextColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 0.5)
        self.calendar?.appearance.titleDefaultColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1)
        self.calendar?.appearance.selectionColor = UIColor(red: 15.0/255.0, green: 24.0/255.0, blue: 62.0/255.0, alpha: 1)

//        self.calendar?.appearance.borderRadius = 0.0
        self.calendar?.appearance.eventOffset = CGPoint(x: 0, y: -10)
        
        self.view.addSubview(self.calendar!)

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
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.clear
//    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        return UIColor.clear
    }

    @IBAction func setAvailablityButtonClicked(_ sender: Any) {
        let termsVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        termsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(termsVC, animated: true)
    }

}
