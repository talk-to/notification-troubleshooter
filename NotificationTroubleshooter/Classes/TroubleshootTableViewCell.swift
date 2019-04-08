//
//  TroubleshootTableViewCell.swift
//  flockmail
//
//  Created by aditya.gh on 2/7/19.
//  Copyright © 2019 RIVA FZC. All rights reserved.
//

import UIKit

class TroubleshootTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet weak var imageSuccess: UIImageView!
  @IBOutlet weak var imageFailure: UIImageView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    resetCell()
  }
  
  override func prepareForReuse() {
    resetCell()
  }
  
  func resetCell () {
    imageSuccess?.image = nil
    imageFailure?.image = nil
    spinner.isHidden = true
  }
  
  func configure(text: String, imageSuccess: UIImage?, imageFailure: UIImage?, hideSpinnerStatus: Bool) {
    self.messageLabel.text = text
    self.imageSuccess.image = imageSuccess
    self.imageFailure.image = imageFailure
    self.spinner.isHidden = hideSpinnerStatus
    self.spinner.startAnimating()
  }
}
