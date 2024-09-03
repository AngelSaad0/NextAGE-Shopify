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
    var islogin: Bool = false
    var darkModeEnabled: Bool = false
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    
    private init(){
        getStoredData()
    }
    
    func getStoredData(){
        self.continueAsAGuest = getSharedBool(forKey: "guest")
        self.islogin  = getSharedBool(forKey: "islogin")
        self.darkModeEnabled  = getSharedBool(forKey: "darkMode")
        self.name = getSharedString(forKey: "name")
        self.email = getSharedString(forKey: "email")
        self.password = getSharedString(forKey: "password")
    }
    func storeData(){
        setSharedValue("guest", value: continueAsAGuest)
        setSharedValue("islogin", value: islogin)
        setSharedValue("darkMode",value: darkModeEnabled)
        setSharedValue("name", value: name)
        setSharedValue("email", value: email)
        setSharedValue("password", value: password)
    }
    func logout(){
        removeValue(forKey: "guest")
        removeValue(forKey: "islogin")
        removeValue(forKey: "darkMode")
        removeValue(forKey: "name")
        removeValue(forKey: "email")
        removeValue(forKey: "password")
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
