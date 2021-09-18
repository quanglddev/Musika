//
//  MediaSourcePicker.swift
//  Musika
//
//  Created by QUANG on 6/22/17.
//  Copyright © 2017 Superior Future. All rights reserved.
//

import UIKit

var customHeight: CGFloat = 0
var customWidth: CGFloat = 0 //Set in ViewDidLoad

class MediaSourcePicker: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var modelData: [String] = ["INDIVIDUAL", "PLAYLIST", "ALBUM"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modelData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return customHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)] // it says name, but a UIFont works
        let stringBoundingBox = (modelData[row] as NSString).size(attributes: fontAttributes)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
        view.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: customWidth - stringBoundingBox.width, y: 0, width: customWidth - (customWidth - stringBoundingBox.width) + 1, height: customHeight))
        label.text = modelData[row]
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        label.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
        
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NotificationCenter.default.post(name: .pickerChanged, object: self)
    }
}
