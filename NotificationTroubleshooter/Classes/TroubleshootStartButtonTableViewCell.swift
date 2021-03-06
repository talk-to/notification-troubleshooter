//
//  TroubleshootStartButtonTableViewCell.swift
//  flockmail
//
//  Created by aditya.gh on 2/7/19.
//  Copyright © 2019 RIVA FZC. All rights reserved.
//

import UIKit

class TroubleshootStartButtonTableViewCell: UITableViewCell {

  @IBOutlet private weak var startTroubleshooting: UIButton!
  
  func resetButton(isTroubleshooting: Bool) {
    self.startTroubleshooting.setTitle(NSLocalizedString("Start troubleshooting", comment: "On clicking this button, troubleshooting starts"), for: .normal)
    self.startTroubleshooting.isUserInteractionEnabled = !isTroubleshooting
    self.startTroubleshooting.backgroundColor = UIColor(red: 33/255.0, green: 112/255.0, blue: 244/255.0, alpha: isTroubleshooting ? 0.5 : 1.0)
  }

}
