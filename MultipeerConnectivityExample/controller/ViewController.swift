//
//  ViewController.swift
//  MultipeerConnectivityExample
//
//  Created by Renato Lopes on 03/10/18.
//  Copyright © 2018 Renato Lopes. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DelegateColors {
    enum ColorImage {
        case red
        case yellow
        case green
    }
    

//ImageView que vai mudar de acordo com o click no button
    @IBOutlet weak var imageViewColors: UIImageView!
// Objeto ServiceColors, responsavel por cuidar da conexao entre os dispositivos
    let serviceColors = ServiceColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceColors.colorDelegate = self
    }
    
    
    @IBAction func changeToRed(_ sender: UIButton){
        self.changeImageView(color: .red)
        serviceColors.sendColor(withName: "Red")
    }
    
    @IBAction func changeToYellow(_ sender: UIButton) {
        self.changeImageView(color: .yellow)

        serviceColors.sendColor(withName: "Yellow")
    }
    @IBAction func changeToGreen(_ sender: UIButton) {
        self.changeImageView(color: .green)

        serviceColors.sendColor(withName: "Green")
    }
    
    
    func connectedDevicesChanged(manager: ServiceColors, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print(connectedDevices)
        }
    }
    
    func colorChanged(manager: ServiceColors, colorString: String) {
        OperationQueue.main.addOperation {
            switch colorString {
            case "Red":
                self.changeImageView(color: .red)
            case "Yellow":
                self.changeImageView(color: .yellow)
            case "Green":
                self.changeImageView(color: .green)

            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
    
    func changeImageView(color: ColorImage){
        switch color {
        case .red:
            imageViewColors.image = #imageLiteral(resourceName: "red-mode")
        case .yellow:
            imageViewColors.image = #imageLiteral(resourceName: "yellow-mode")
        case .green:
            imageViewColors.image = #imageLiteral(resourceName: "green-mode")

        }
        
    }
    
}

