//
//  DelegateColors.swift
//  MultipeerConnectivityExample
//
//  Created by Renato Lopes on 04/10/18.
//  Copyright © 2018 Renato Lopes. All rights reserved.
//

import Foundation

protocol DelegateColors {
    
    func connectedDevicesChanged(manager : ServiceColors, connectedDevices: [String])
    func colorChanged(manager : ServiceColors, colorString: String)
    
}
