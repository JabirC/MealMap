//
//  HudView.swift
//  MealMap
//
//  Created by Jabir Chowdhury
//

import UIKit
class HudView: UIView {
var text = ""
  class func hud(
    inView view: UIView,
    animated: Bool
  ) -> HudView {
    let hudView = HudView(frame: view.bounds)
    hudView.isOpaque = false
    view.addSubview(hudView)
    view.isUserInteractionEnabled = false
    hudView.backgroundColor = UIColor(
      red: 0,
      green: 1,
      blue: 0,
      alpha: 0.5)
    return hudView
  }
    
    func hide() {
      superview?.isUserInteractionEnabled = true
      removeFromSuperview()
    }
}
