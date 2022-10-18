//
//  UserPersistentService.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 14/10/22.
//

import UIKit

struct UserPersistentService {
    private let stateKey = "state"
    private let nameKey = "name"
    private let professionKey = "profession"
    private let imageKey = "image"
    
    var userState: Bool {
        get {
            return UserDefaults.standard.bool(forKey: stateKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: stateKey)
        }
    }
    
    var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    
    var profession: String {
        get {
            return UserDefaults.standard.string(forKey: professionKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: professionKey)
        }
    }
    
    var image: UIImage {
        get {
            let data = UserDefaults.standard.data(forKey: imageKey) ?? Data()
            let decoded = try? PropertyListDecoder().decode(Data.self, from: data)
            return UIImage(data: decoded ?? Data()) ?? UIImage()
        }
        set {
            let data = newValue.jpegData(compressionQuality: 0.5)
            let encoded = try? PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: imageKey)
        }
    }
    
    func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
