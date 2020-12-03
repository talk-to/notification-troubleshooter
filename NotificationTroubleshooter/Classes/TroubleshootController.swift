//
//  TroubleshootController.swift
//  flockmail
//
//  Created by aditya.gh on 1/28/19.
//  Copyright © 2019 RIVA FZC. All rights reserved.
//

import UIKit
import UserNotifications

public protocol TroubleshootModelActions: class {
  func initiateSettingsCheck()
  func initiateTokenCheck()
  func initiateSyncWithServer()
  func initiateDummyNotificationsRequest()
  func readyToReceiveDummyNotification()
  func endTroubleshooting()
}

public class TroubleshootController: UIViewController, NotificationTroubleshooterDelegate {

  @IBOutlet weak var tableView: UITableView!
  private var isStepsVisible: Bool = false
  private var isTroubleshooting: Bool = false
  private var steps: [String] = ["User Settings",
                                 "Device Token from iOS",
                                 "Send token to Server End",
                                 "Request for Dummy Notification",
                                 "Waiting for Dummy Notification"]
  private var showSuccess: [Bool] = []
  private var showFailure: [Bool] = []
  private var hideSpinner: [Bool] = []
  private var actionDelegate: TroubleshootModelActions!
  private var isWaitingForSyncWithServer = false
  override public func viewDidLoad() {
    super.viewDidLoad()
  }
  @IBAction func dismissButtonClicked(_ sender: UIBarButtonItem) {
    actionDelegate.endTroubleshooting()
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func runTestButtonClicked(_ sender: UIButton) {
    sender.backgroundColor = UIColor(red: 33/255.0, green: 112/255.0, blue: 244/255.0, alpha: 0.5)
    sender.isUserInteractionEnabled = false
    isStepsVisible = true
    isTroubleshooting = true
    showSuccess = [false, false, false, false, false]
    showFailure = [false, false, false, false, false]
    hideSpinner = [true, true, true, true, true]
    if tableView.numberOfSections == 1 {
      tableView.insertSections(IndexSet.init(integer: 1), with: .fade)
    } else {
      tableView.reloadSections(IndexSet.init(integer: 1), with: .fade)
    }
    actionDelegate.initiateSettingsCheck()
  }

  public func configureController(actionDelegate: TroubleshootModelActions) {
    self.actionDelegate = actionDelegate
  }

  private func changeBackgroundColorOf(label: UILabel, toColor: UIColor) {
    label.backgroundColor = toColor
  }
  
  public func willInitiateSettingsCheck() {
    hideSpinner[0] = false
    tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
  }
  
  public func didFinishSettingsCheck(withResult: UNAuthorizationStatus) {
    hideSpinner[0] = true
    if withResult == .authorized {
      showSuccess[0] = true
      tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
      actionDelegate.initiateTokenCheck()
    } else if withResult == .notDetermined {
      showSuccess[0] = false
      showFailure[0] = true
      tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
      tableView.reloadSections(IndexSet.init(integer: 0), with: .fade)
      actionDelegate.endTroubleshooting()
    } else {
      showSuccess[0] = false
      showFailure[0] = true
      tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
      actionDelegate.endTroubleshooting()
    }
  }
  
  public func willInitiateTokenCheck() {
    hideSpinner[1] = false
    tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
  }
  
  public func didFinishTokenCheck(withResult: Bool) {
    hideSpinner[1] = true
    if withResult {
      showSuccess[1] = true
      tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
      actionDelegate.initiateSyncWithServer()
    } else {
      showSuccess[1] = false
      showFailure[1] = true
      tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
      actionDelegate.endTroubleshooting()
    }
  }
  
  public func willInitiateSyncWithServer() {
    hideSpinner[2] = false
    isWaitingForSyncWithServer = true
    tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .fade)
  }
  
  public func didFinishSyncWithServer(withResult: Bool) {
    hideSpinner[2] = true
    if withResult {
      showSuccess[2] = true
      tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .fade)
      actionDelegate.initiateDummyNotificationsRequest()
    } else {
      if isWaitingForSyncWithServer {
        showSuccess[2] = false
        showFailure[2] = true
        tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .fade)
        actionDelegate.endTroubleshooting()
      }
    }
    isWaitingForSyncWithServer = false
  }
  
  public func willInitiateDummyNotificationsRequest() {
    hideSpinner[3] = false
    tableView.reloadRows(at: [IndexPath(row: 3, section: 1)], with: .fade)
  }
  
  public func didFinishDummyNotificationsRequest(withResult: Bool) {
    hideSpinner[3] = true
    if withResult {
      showSuccess[3] = true
      tableView.reloadRows(at: [IndexPath(row: 3, section: 1)], with: .fade)
      actionDelegate.readyToReceiveDummyNotification()
    } else {
      showSuccess[3] = false
      showFailure[3] = true
      tableView.reloadRows(at: [IndexPath(row: 3, section: 1)], with: .fade)
      actionDelegate.endTroubleshooting()
    }
  }
  
  public func willReceiveDummyNotificationsRequest() {
    hideSpinner[4] = false
    tableView.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .fade)
  }
  
  public func didReceiveDummyNotificationsRequest(withResult: Bool) {
    hideSpinner[4] = true
    if withResult {
      showSuccess[4] = true
      tableView.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .fade)
    } else {
      showSuccess[4] = false
      showFailure[4] = true
      tableView.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .fade)
    }
    actionDelegate.endTroubleshooting()
  }

  public func refreshPage() {
    isTroubleshooting = false
    tableView.reloadSections(IndexSet.init(integer: 0), with: .fade)
  }
  
}

extension TroubleshootController: UITableViewDataSource, UITableViewDelegate {

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return UITableViewAutomaticDimension
    }
    return 48.0
  }

  public func numberOfSections(in tableView: UITableView) -> Int {
    if isStepsVisible {
      return 2
    } else {
      return 1
    }
  }

  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return steps.count
    }
  }

  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
      return "Troubleshoot steps"
    }
    return ""
  }

  public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if section == 1 {
      (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
      (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1.0)
    }
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 1 {
      let text = steps[indexPath.row]
      let showSuccessForCell = showSuccess[indexPath.row]
      let showFailureForCell = showFailure[indexPath.row]
      let hideSpinnerForCell = hideSpinner[indexPath.row]
      let cell = tableView.dequeueReusableCell(withIdentifier: "TroubleshootStepsCell") as! TroubleshootTableViewCell
      let imageBundlePath = Bundle(for: TroubleshootController.self).path(forResource: "NotificationTroubleshooter", ofType: "bundle")!
      cell.configure(text: text,
                     imageSuccess: (showSuccessForCell ? UIImage(named: "going-active", in: Bundle(path: imageBundlePath), compatibleWith: nil): nil),
                     imageFailure: (showFailureForCell ? UIImage(named: "troubleshoot-wrong", in: Bundle(path: imageBundlePath), compatibleWith: nil): nil),
                     hideSpinnerStatus: hideSpinnerForCell)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TroubleshootStartButtonCell") as! TroubleshootStartButtonTableViewCell
      cell.resetButton(isTroubleshooting: isTroubleshooting)
      return cell
    }
  }
  
}
