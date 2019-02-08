//
//  ViewController.swift
//  hermes
//
//  Created by Nishant Jha on 12/14/2018
//  Copyright © 2018 Nishant Jha. All rights reserved.
//

import JTAppleCalendar
import FirebaseAuth
import FirebaseDatabase

class CalendarViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Used to launch assesment
    var notificationPayload: [String: AnyObject]?
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showTodayButton: UIBarButtonItem!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    var remoteAssesments: [String: Assesment] = [:]
    var currentExercise: Exercise?
    var remoteExercises: [String: Exercise] = [:]
    
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
    
    //Mark: Firebase config
   
    
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
        //Set Navbar root
        self.navigationController?.setViewControllers([self], animated: true)
        self.initNavBar()
        setupViewNibs()
        showTodayButton.target = self
        showTodayButton.action = #selector(showTodayWithAnimate)
        showToday(animate: false)
        
        let gesturer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        calendarView.addGestureRecognizer(gesturer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.refreshCalendar(self)
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
        title = "\(currentMonthSymbol) \(year)"
    }
    
    func initNavBar() {
        let assesmentButton = UIBarButtonItem(title: "Assesments", style: .plain, target: self, action: #selector(showPendingAssesments))
        if getPendingAssesments().count > 0 {
            navigationItem.rightBarButtonItem = assesmentButton
        }
    }
    
    func getPendingAssesments() -> [Assesment] {
        var pendingAssesments: [Assesment] = []
        for assesment in self.remoteAssesments.values {
            if assesment.dateCompleted == nil {
                pendingAssesments.append(assesment)
            }
        }
        return pendingAssesments.sorted(by: { $0.dateAssigned.compare($1.dateAssigned) == .orderedAscending })
    }
    
    @objc func showPendingAssesments() {
        performSegue(withIdentifier: "assesmentPopover", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToExercise" {
            let destinationVC = segue.destination as! ExerciseViewController
            destinationVC.delegate = self
            destinationVC.exercise = currentExercise
        }
        if segue.identifier == "assesmentPopover" {
            let destinationVC = segue.destination as! AssesmentTableViewController
            destinationVC.assesments = getPendingAssesments()
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        appDelegate.logout()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
}

//Mark: Firebase
extension CalendarViewController {

    //MARK: User Data
    func getCurrentUser() -> User? {
        guard let user = appDelegate.auth!.currentUser else {
            return nil
        }
        return user
    }
    
    //Mark: Exercises
    
    func getRemoteExercises() {
        let userDocument = appDelegate.getUserDocument()
        if (userDocument != nil) {
            userDocument!.child("exerciseData").observeSingleEvent(of: .value, with: { (firebaseExerciseData) in
                for child in firebaseExerciseData.children {
                    let exerciseDatumSnapshot = child as! DataSnapshot
                    var exerciseDatum = exerciseDatumSnapshot.value as! [String: AnyObject]
                    exerciseDatum["key"] = exerciseDatumSnapshot.key as AnyObject
                    let eid = exerciseDatum["eid"] as! String
                    //Grab exercise and merge in user exerciseDatum
                    let exerciseDocument = self.appDelegate.getExerciseDocument()
                    if (exerciseDocument != nil) {
                        exerciseDocument!.child(eid).observeSingleEvent(of: .value, with: { (exerciseSnapshot) in
                            var exerciseDict = exerciseSnapshot.value as! [String: AnyObject]
                            exerciseDict.merge(dict:exerciseDatum)
                            let exercise = self.parseDictToExercise(exerciseDict: exerciseDict)
                            if exercise != nil {
                                self.remoteExercises[exercise!.key] = exercise!
                            }
                        })
                    }
                }
            })
        }
    }
    
    func parseDictToExercise(exerciseDict: [String: AnyObject]) -> Exercise? {
        guard let key = exerciseDict["key"] as? String,
            let title = exerciseDict["title"] as? String,
            let instructions = exerciseDict["instructions"] as? String,
            let completed = exerciseDict["completed"] as? Bool,
            let primaryVideoUrl = exerciseDict["primaryVideoUrl"] as? String,
            let sets = exerciseDict["sets"] as? Int,
            let reps = exerciseDict["reps"] as? Int,
            let equipment = exerciseDict["equipment"] as? String,
            let startDateTimeString = exerciseDict["startDateTime"] as? String,
            let endDateTimeString = exerciseDict["endDateTime"] as? String
            else {
                print("Failed to parse dict to exercise", exerciseDict)
                return nil
        }
        
        guard let startDateTime =  appDelegate.firebaseDateFormatter.date(from: startDateTimeString),
            let endDateTime =  appDelegate.firebaseDateFormatter.date(from: endDateTimeString)
            else {
                print("Failed to parse string to date", startDateTimeString, endDateTimeString, self.appDelegate.firebaseDateFormatString)
                return nil
        }
        
        let secondaryMultimediaFilenames =  exerciseDict["secondaryMultimediaFilenames"] as? [String] ?? []
        
        return Exercise(key: key, title: title, instructions: instructions, startDateTime: startDateTime, endDateTime: endDateTime, completed: completed, primaryVideoUrl: primaryVideoUrl, secondaryMultimediaFilenames: secondaryMultimediaFilenames, sets: sets, reps: reps, equipment: equipment)
    }
    
    //MARK: Assesments
    func getRemoteAssesments() {
        let userDocument = appDelegate.getUserDocument()
        if (userDocument != nil) {
            userDocument!.child("assesmentData").observeSingleEvent(of: .value, with: { (firebaseAssesmentData) in
                for child in firebaseAssesmentData.children {
                    let assesmentSnapshot = child as! DataSnapshot
                    var assesmentDatum = assesmentSnapshot.value as! [String: AnyObject]
                    assesmentDatum["key"] = assesmentSnapshot.key as AnyObject
                    let aid = assesmentDatum["aid"] as! String
                    let assesmentDocument = self.appDelegate.getAssesmentDocument()
                    if (assesmentDocument != nil) {
                        assesmentDocument!.child(aid).observeSingleEvent(of: .value, with: { (assesmentSnapshot) in
                            var assesmentDict = assesmentSnapshot.value as! [String: AnyObject]
                            assesmentDict.merge(dict:assesmentDatum)
                            let assesment = self.parseDictToAssesment(assesmentDict: assesmentDict)
                            if assesment != nil {
                                self.remoteAssesments[assesment!.key!] = assesment!
                            }
                        })
                    }
                }
            })
        } else {
            print("Failed to get assignments")
        }
    }
    
    //TODO: Fails to parse completed assesments, not critical
    func parseDictToAssesment(assesmentDict: [String: AnyObject]) -> Assesment? {
        guard let key = assesmentDict["key"] as? String,
            let title = assesmentDict["title"] as? String,
            let painSites = assesmentDict["painSites"] as? [String],
            let questions = assesmentDict["questions"] as? [String],
            let dateAssignedString = assesmentDict["dateAssigned"] as? String
            else {
                print("Failed to parse Dict to assesment", assesmentDict)
                return nil
        }
        
        let painScore = 0
        
        var painSiteDict: [String: Bool] = [:]
        for (_, site) in painSites.enumerated() {
            painSiteDict[site] = false
        }
        
        var questionsDict: [String: Bool] = [:]
        for (_, question) in questions.enumerated() {
            questionsDict[question] = false
        }
        
        guard let dateAssigned = appDelegate.firebaseDateFormatter.date(from: dateAssignedString)
            else {
                print("Failed to parse dateAssigned string", dateAssignedString, self.appDelegate.firebaseDateFormatString)
                return nil
        }
        //dateCompleted is allowed to be nil
        let dateCompleted: Date? = nil
        //But if it isn't, must be valid date
        let dateCompletedString = assesmentDict["dateCompleted"] as? String
        if dateCompletedString != nil {
            guard let dateCompleted =  appDelegate.firebaseDateFormatter.date(from: dateCompletedString!)
                else {
                    print("Failed to parse dateCompleted", dateCompletedString!, self.appDelegate.firebaseDateFormatString)
                    return nil
            }
            return Assesment(key: key, title: title, painScore: painScore, painSites: painSiteDict, questions: questionsDict, dateAssigned: dateAssigned, dateCompleted: dateCompleted)
        }
        return Assesment(key: key, title: title, painScore: painScore, painSites: painSiteDict, questions: questionsDict, dateAssigned: dateAssigned, dateCompleted: dateCompleted)
    }
    
    //Refresh Button
    @IBAction func refreshCalendar(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Refreshing...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .background).async {
            self.getRemoteAssesments()
            self.getRemoteExercises()
            sleep(1)
            DispatchQueue.main.async {
                self.getExercise()
                self.initNavBar()
                self.calendarView.visibleDates { [unowned self] (visibleDates: DateSegmentInfo) in
                    self.setupViewsOfCalendar(from: visibleDates)
                }
                self.adjustCalendarViewHeight()
                self.dismiss(animated: true, completion: nil)
            }
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

// MARK: Prepare dataSource
extension CalendarViewController {
    func getExercise() {
        if let startDate = calendarView.visibleDates().monthDates.first?.date  {
            let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)
            getExercise(fromDate: startDate, toDate: endDate!)
        }
    }
    
    func getExercise(fromDate: Date, toDate: Date) {
        exerciseGroup = self.remoteExercises.values.group{self.formatter.string(from: $0.startDateTime)}
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
        
        let relevantExercises = exerciseGroup?[formatter.string(from: cellState.date)]
        if relevantExercises != nil {
            myCustomCell.eventView.isHidden = false
            
            var numCompleted = 0
            var count = 0
            for exercise in relevantExercises! {
                if Calendar.current.isDate(cellState.date, inSameDayAs:exercise.startDateTime) {
                    count += 1
                    if exercise.completed {
                        numCompleted += 1
                    }
                }
            }
            if numCompleted == 0 && count > 0 {
                myCustomCell.eventView.backgroundColor = UIColor(red:218, green:41, blue:28)
            }
            else if numCompleted == count {
                myCustomCell.eventView.backgroundColor = UIColor(red: 61, green: 149, blue: 37)
            } else {
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

//Popover on iPhone
extension CalendarViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
