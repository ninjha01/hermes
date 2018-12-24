//
//  ViewController.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import JTAppleCalendar
import FirebaseAuth

class CalendarViewController: UIViewController {
    
    //Used to launch assesment
    var notificationPayload: [String: AnyObject]?
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showTodayButton: UIBarButtonItem!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    var currentExercise: Exercise?
    
    var regimens: [Regimen] = []
    
    // MARK: DataSource
    var exerciseGroup : [String: [Exercise]]? {
        didSet {
            calendarView.reloadData()
            tableView.reloadData()
        }
    }
    
    var exercises: [Exercise] {
        guard let selectedDate = calendarView.selectedDates.first else {
            return []
        }
        
        guard let data = exerciseGroup?[self.formatter.string(from: selectedDate)] else {
            return []
        }
        return data
    }
    
    
    // MARK: Config
    let formatter = DateFormatter()
    let dateFormatterString = "yyyy MM dd"
    let numOfRowsInCalendar = 6
    let numOfRandomEvent = 100
    let calendarCellIdentifier = "CellView"
    let scheduleCellIdentifier = "detail"
    
    var monthFirstDate: Date?
    
    // MARK: Helpers
    var numOfRowIsSix: Bool {
        get {
            return calendarView.visibleDates().outdates.count < 7
        }
    }
    
    var currentMonthSymbol: String {
        get {
            let startDate = (calendarView.visibleDates().monthDates.first?.date)!
            let month = Calendar.current.dateComponents([.month], from: startDate).month!
            let monthString = DateFormatter().monthSymbols[month-1]
            return monthString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRegimensFromFirebase()
        self.getExercise()
        //Set Navbar root
        self.navigationController?.setViewControllers([self], animated: true)
        setupViewNibs()
        showTodayButton.target = self
        showTodayButton.action = #selector(showTodayWithAnimate)
        showToday(animate: false)
        
        let gesturer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        calendarView.addGestureRecognizer(gesturer)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer) {
        let point = gesture.location(in: calendarView)
        guard let cellStatus = calendarView.cellStatus(at: point) else {
            return
        }
        
        if calendarView.selectedDates.first != cellStatus.date {
            calendarView.deselectAllDates()
            calendarView.selectDates([cellStatus.date])
        }
    }
    
    func setupViewNibs() {
        let myNib = UINib(nibName: "CellView", bundle: Bundle.main)
        calendarView.register(myNib, forCellWithReuseIdentifier: calendarCellIdentifier)
        
        
        let myNib2 = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        tableView.register(myNib2, forCellReuseIdentifier: scheduleCellIdentifier)
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        
        let year = Calendar.current.component(.year, from: startDate)
        title = "\(year) \(currentMonthSymbol)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToExercise" {
            let destinationVC = segue.destination as! ExerciseViewController
            destinationVC.delegate = self
            destinationVC.exercise = currentExercise
        }
        if segue.identifier == "toAssesment" {
            let destinationVC = segue.destination as! AssesmentViewController
            destinationVC.parseAPSForAssesment(aps: self.notificationPayload!)
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    func getRegimensFromFirebase() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userDocument = appDelegate.ref!.child("users").child(Auth.auth().currentUser!.uid)
        debugPrint("Remote Regimens: ")
        userDocument.child("regimens").observeSingleEvent(of: .value, with: { (regimens) in
            let regimensWrapper = regimens.value as! NSArray
            let firebaseDateFormatString = "yyyy-MM-dd HH:mm"
            let firebaseDateFormatter = DateFormatter()
            firebaseDateFormatter.dateFormat = firebaseDateFormatString
            for regimenData in regimensWrapper {
                let regimenDataDict = regimenData as! [String: AnyObject]
                let exerciseDataArray = regimenDataDict["exercises"] as! [[String: AnyObject]]
                var newExerciseArray: [Exercise] = []
                for exerciseData in exerciseDataArray {
                    debugPrint(exerciseData)
                    let id = exerciseData["id"] as! String
                    let title =  exerciseData["title"] as! String
                    let instructions =  exerciseData["instructions"] as! String
                    let startDateTime =  firebaseDateFormatter.date(from: exerciseData["startDateTime"] as! String)!
                    let endDateTime =  firebaseDateFormatter.date(from: exerciseData["endDateTime"] as! String)!
                    let completed =  exerciseData["completed"] as! Bool
                    let primaryVideoFilename =  exerciseData["primaryVideoFilename"] as! String
                    let secondaryMultimediaFilenames =  exerciseData["secondaryMultimediaFilenames"] as? [String] ?? []
                    let sets =  exerciseData["sets"] as! Int
                    let reps =  exerciseData["reps"] as! Int
                    let intensity =  exerciseData["intensity"] as! String
                    let equipment =  exerciseData["equipment"] as! String
                    let newExercise = Exercise(id: id, title: title, instructions: instructions, startDateTime: startDateTime, endDateTime: endDateTime, completed: completed, primaryVideoFilename: primaryVideoFilename, secondaryMultimediaFilenames: secondaryMultimediaFilenames, sets: sets, reps: reps, intensity: intensity, equipment: equipment)
                    newExerciseArray.append(newExercise)
                }
                let id = regimenDataDict["id"] as! String
                let title = regimenDataDict["title"] as! String
                let startDateTime =  firebaseDateFormatter.date(from: regimenDataDict["startDateTime"] as! String)!
                let endDateTime =  firebaseDateFormatter.date(from: regimenDataDict["endDateTime"] as! String)!
                let newRegimen = Regimen(id: id, title: title, exercises: newExerciseArray, startDateTime: startDateTime, endDateTime: endDateTime)
                self.regimens.append(newRegimen)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

// MARK: Helpers
extension CalendarViewController {
    func select(onVisibleDates visibleDates: DateSegmentInfo) {
        guard let firstDateInMonth = visibleDates.monthDates.first?.date else
        { return }
        
        if firstDateInMonth.isThisMonth() {
            calendarView.selectDates([Date()])
        } else {
            calendarView.selectDates([firstDateInMonth])
        }
    }
}

// MARK: Button events
extension CalendarViewController {
    @objc func showTodayWithAnimate() {
        showToday(animate: true)
    }
    
    func showToday(animate:Bool) {
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: animate, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.getExercise()
            self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            }
            
            self.adjustCalendarViewHeight()
            self.calendarView.selectDates([Date()])
        }
    }
}

// MARK: Dynamic CalendarView's height
extension CalendarViewController {
    func adjustCalendarViewHeight() {
        adjustCalendarViewHeight(higher: self.numOfRowIsSix)
    }
    
    func adjustCalendarViewHeight(higher: Bool) {
        separatorViewTopConstraint.constant = higher ? 0 : -calendarView.frame.height / CGFloat(numOfRowsInCalendar)
    }
}

// MARK: Prepere dataSource
extension CalendarViewController {
    func getExercise() {
        if let startDate = calendarView.visibleDates().monthDates.first?.date  {
            let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)
            getExercise(fromDate: startDate, toDate: endDate!)
        }
    }
    
    func getExercise(fromDate: Date, toDate: Date) {
        var exercises : [Exercise] = []
        for regimen in regimens {
            for exercise in regimen.exercises {
                exercises.append(exercise)
            }
        }
        exerciseGroup = exercises.group{self.formatter.string(from: $0.startDateTime)}
    }
}


// MARK: CalendarCell's ui config
extension CalendarViewController {
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView else { return }
        
        myCustomCell.dayLabel.text = cellState.text
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        
        myCustomCell.isHidden = cellHidden
        myCustomCell.selectedView.backgroundColor = UIColor.black
        
        if Calendar.current.isDateInToday(cellState.date) {
            myCustomCell.selectedView.backgroundColor = UIColor.red
        }
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
        
        if exerciseGroup?[formatter.string(from: cellState.date)] != nil {
            myCustomCell.eventView.isHidden = false
            
            var exercises : [Exercise] = []
            for regimen in regimens {
                for exercise in regimen.exercises {
                    exercises.append(exercise)
                }
            }
            var numCompleted = 0
            var count = 0
            for exercise in exercises {
                if Calendar.current.isDate(cellState.date, inSameDayAs:exercise.startDateTime) {
                    count += 1
                    if exercise.completed {
                        numCompleted += 1
                    }
                }
            }
            if numCompleted == count {
                myCustomCell.eventView.backgroundColor = UIColor(red: 61, green: 149, blue: 37)
            }
            else if numCompleted == 0 {
                myCustomCell.eventView.backgroundColor = UIColor(red:218, green:41, blue:28)
            }
            else {
                myCustomCell.eventView.backgroundColor = UIColor(red:255, green:163, blue:0)
            }

        }
        else {
            myCustomCell.eventView.isHidden = true
        }
    }
    
    func handleCellSelection(view: CellView, cellState: CellState) {
        view.selectedView.isHidden = !cellState.isSelected
    }
    
    func handleCellTextColor(view: CellView, cellState: CellState) {
        
        //HANDLE Cell COLOR HERE: If completed Exercise, green. If not, yellow, if past due, red
        if cellState.isSelected {
            view.dayLabel.textColor = UIColor.white
        }
        else {
            view.dayLabel.textColor = UIColor.black
            if cellState.day == .sunday || cellState.day == .saturday {
                view.dayLabel.textColor = UIColor.gray
            }
        }
        
        if Calendar.current.isDateInToday(cellState.date) {
            if cellState.isSelected {
                view.dayLabel.textColor = UIColor.white
            }
            else {
                view.dayLabel.textColor = UIColor.red
            }
        }
    }
}

// MARK: JTAppleCalendarViewDataSource
extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = dateFormatterString
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2030 02 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numOfRowsInCalendar,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        return parameters
    }
}

// MARK: JTAppleCalendarViewDelegate
extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CellView
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellIdentifier, for: indexPath) as! CellView
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        if visibleDates.monthDates.first?.date == monthFirstDate {
            return
        }
        
        monthFirstDate = visibleDates.monthDates.first?.date
        
        getExercise()
        select(onVisibleDates: visibleDates)
        
        view.layoutIfNeeded()
        
        adjustCalendarViewHeight()
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        tableView.reloadData()
        tableView.contentOffset = CGPoint()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
}

// MARK: UITableViewDataSource
extension CalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellIdentifier, for: indexPath) as! ScheduleTableViewCell
        cell.selectionStyle = .none
        cell.exercise = exercises[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
}

// MARK: UITableViewDelegate
extension CalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentExercise = exercises[indexPath.row]
        performSegue(withIdentifier: "cellToExercise", sender: self)
    }
}

