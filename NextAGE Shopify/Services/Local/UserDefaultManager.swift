//
//  UserDefaultManager.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/3/24.
//

import Foundation
class UserDefaultManager {
    static let shared = UserDefaultManager()
    private let pref = UserDefaults.standard
    var continueAsAGuest: Bool = false
    var isLogin: Bool = false
    var darkModeEnabled: Bool = false
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var customerID: Int = 0
    var wishlistID: Int = 0
    var shoppingCartID: Int = 0
    var currency: String = ""
    
    private init(){
        getStoredData()
    }
    
    func getStoredData(){
        self.continueAsAGuest = getSharedBool(forKey: "guest")
        self.isLogin  = getSharedBool(forKey: "isLogin")
        self.darkModeEnabled  = getSharedBool(forKey: "darkMode")
        self.name = getSharedString(forKey: "name")
        self.email = getSharedString(forKey: "email")
        self.password = getSharedString(forKey: "password")
        self.customerID = getSharedInt(forKey: "userID")
        self.wishlistID = getSharedInt(forKey: "wishlistID")
        self.shoppingCartID = getSharedInt(forKey: "shoppingCartID")
        self.currency = getSharedString(forKey: "currency")
        if self.currency == "" {
            self.currency = "USD"
        }
    }
    func storeData(){
        setSharedValue("guest", value: continueAsAGuest)
        setSharedValue("isLogin", value: isLogin)
        setSharedValue("darkMode",value: darkModeEnabled)
        setSharedValue("name", value: name)
        setSharedValue("email", value: email)
        setSharedValue("password", value: password)
        setSharedValue("userID", value: customerID)
        setSharedValue("wishlistID", value: wishlistID)
        setSharedValue("shoppingCartID", value: shoppingCartID)
        setSharedValue("currency", value: currency)
    }
    func logout(){
        removeValue(forKey: "guest")
        removeValue(forKey: "isLogin")
        removeValue(forKey: "darkMode")
        removeValue(forKey: "name")
        removeValue(forKey: "email")
        removeValue(forKey: "password")
        removeValue(forKey: "userID")
        removeValue(forKey: "wishlistID")
        removeValue(forKey: "shoppingCartID")
        removeValue(forKey: "currency")
    }
    
    private func setSharedValue(_ key: String, value: Any) {
        self.pref.set(value, forKey: key)
    }
    private func getSharedValue(forKey key: String) -> Any? {
        return self.pref.object(forKey: key)
    }
    private func getSharedString(forKey key: String) -> String {
        return self.pref.object(forKey: key) as? String ?? ""
    }
    
    private func getSharedInt(forKey key: String) -> Int {
        return self.pref.object(forKey: key) as? Int ?? 0
    }
    
    private func getSharedBool(forKey key: String) -> Bool {
        return self.pref.object(forKey: key) as? Bool ?? false
    }
    
    private func removeValue(forKey key: String) {
        self.pref.removeObject(forKey: key)
    }
    private func clearCache() {
        let domain = Bundle.main.bundleIdentifier ?? ""
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
