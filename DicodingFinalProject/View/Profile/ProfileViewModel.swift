//
//  ProfileViewModel.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 14/10/22.
//

import UIKit

class ProfileViewModel: ObservableObject {
    
    private var userService = UserPersistentService()
    
    func getUserState() -> Bool {
        return userService.userState
    }
    
    func setUserState(_ state: Bool) {
        userService.userState = state
    }
    
    func getUserName() -> String {
        return userService.name
    }
    
    func getUserProfession() -> String {
        return userService.profession
    }
    
    func getUserImage() -> UIImage {
        return userService.image
    }
    
    func synchronize() {
        userService.synchronize()
    }
    
    func saveProfile(name: String, profession: String, image: UIImage) {
        userService.name = name
        userService.profession = profession
        userService.image = image
    }
}
