//
//  GrantAccessViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class GrantAccessViewController: UIViewController {

    var isPushNotification : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSLog("isPushNotification = \(isPushNotification)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doGrant(_ sender: UIButton) {
    }
    
    @IBAction func doReject(_ sender: UIButton) {
    }
}
