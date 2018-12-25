//
//  UserManagementViewController+TestingAccount.swift
//  ThueNha
//
//  Created by Hồng Vũ on 12/21/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import Foundation

public struct TestingAccountConfig {
    public static let kPrefillAccount = "THUENHA_TESTING_ACCOUNT"
    public static let kAccountTimNha = "TIMNHA"
    public static let kAccountChoThue = "CHOTHUE"
}

extension UserManagementViewController {
    
    func prefillTestingAccount() {
        let bundle = Bundle.main
        if let valueString = bundle.object(forInfoDictionaryKey: TestingAccountConfig.kPrefillAccount) as? String {
            if valueString == TestingAccountConfig.kAccountTimNha {
                self.mLoginPhoneNumber.text = "0987859106"
                self.mLoginPassword.text = "5493"
                self.mUserBtn.isSelected = true
                self.mHostUserBtn.isSelected = false
            } else if valueString == TestingAccountConfig.kAccountChoThue {
                self.mLoginPhoneNumber.text = "0925480717"
                self.mLoginPassword.text = "1561"
                self.mHostUserBtn.isSelected = true
                self.mUserBtn.isSelected = false
            }
        }
    }
    
}
