//
//  TroubleshootModel.swift
//  flockmail
//
//  Created by aditya.gh on 1/31/19.
//  Copyright © 2019 RIVA FZC. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public protocol NotificationTroubleshooterDataSource: class {
  func willStartTroubleShooting()
  func isSettingsAuthorized(completionBlockHandler: @escaping (UNAuthorizationStatus) -> Void)
  func didReceivePushToken(completionBlockHandler: @escaping (String?, Error?) -> Void)
  func syncWithServer(using token: String, completionBlockHandler: @escaping (Bool, Int64) -> Void)
  func sendDummyNotificationRequest(aId: Int64, completionBlockHandler: @escaping (Bool) -> Void)
  func didReceiveDummyNotification(completionBlockHandler: @escaping (Bool) -> Void)
  func didEndTroubleShooting()
}

public protocol NotificationTroubleshooterDelegate: class {
//  This will be called on Main Queue
  func willInitiateSettingsCheck()
  func didFinishSettingsCheck(withResult: UNAuthorizationStatus)
  func willInitiateTokenCheck()
  func didFinishTokenCheck(withResult: Bool)
  func willInitiateSyncWithServer()
  func didFinishSyncWithServer(withResult: Bool)
  func willInitiateDummyNotificationsRequest()
  func didFinishDummyNotificationsRequest(withResult: Bool)
  func willReceiveDummyNotificationsRequest()
  func didReceiveDummyNotificationsRequest(withResult: Bool)
  func refreshPage()
}

public class TroubleshootModel: TroubleshootModelActions {

  private var notificationTimeOutInSeconds = 30.0
  private var token: String?
  private var aId: Int64?
  private var timer: Timer?
  public weak var dataSource: NotificationTroubleshooterDataSource?
  public weak var delegate: NotificationTroubleshooterDelegate?

  public init() {

  }

  public func initiateSettingsCheck() {
    dataSource?.willStartTroubleShooting()
    delegate?.willInitiateSettingsCheck()
    dataSource?.isSettingsAuthorized { [weak self] permissionSettings in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.delegate?.didFinishSettingsCheck(withResult: permissionSettings)
      }
    }
  }
  
  public func initiateTokenCheck() {
    delegate?.willInitiateTokenCheck()
    dataSource?.didReceivePushToken { [weak self] token, error in
      guard let self = self else { return }
      DispatchQueue.main.async {
        if let token = token {
          self.token = token
          self.delegate?.didFinishTokenCheck(withResult: true)
        } else if error != nil {
          self.delegate?.didFinishTokenCheck(withResult: false)
        } else {
//          logger.verbose("No device token and no error occurred.")
          self.delegate?.didFinishTokenCheck(withResult: false)
        }
      }
    }
    UIApplication.shared.registerForRemoteNotifications()
  }
  
  public func initiateSyncWithServer() {
    delegate?.willInitiateSyncWithServer()
    guard let token = self.token else { return }
    dataSource?.syncWithServer(using: token) { [weak self] status, aId in
      guard let self = self else { return }
      self.aId = aId
      DispatchQueue.main.async {
        self.delegate?.didFinishSyncWithServer(withResult: status)
      }
    }
    timer = Timer.scheduledTimer(
      withTimeInterval: TimeInterval(notificationTimeOutInSeconds),
      repeats: false,
      block: { [weak self] t in
        guard let self = self else { return }
        self.delegate?.didFinishSyncWithServer(withResult: false)
    })
  }
  
  public func initiateDummyNotificationsRequest() {
    delegate?.willInitiateDummyNotificationsRequest()
    dataSource?.sendDummyNotificationRequest(aId: aId!) { [weak self] notificationStatus in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.delegate?.didFinishDummyNotificationsRequest(withResult: notificationStatus)
      }
    }
  }
  
  public func readyToReceiveDummyNotification() {
    delegate?.willReceiveDummyNotificationsRequest()
    dataSource?.didReceiveDummyNotification { [weak self] notificationReceived in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.delegate?.didReceiveDummyNotificationsRequest(withResult: notificationReceived)
      }
    }
  }
  
  public func endTroubleshooting() {
    self.dataSource?.didEndTroubleShooting()
    self.delegate?.refreshPage()
    timer?.invalidate()
  }
  
}
