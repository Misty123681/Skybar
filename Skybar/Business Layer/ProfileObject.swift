//
//  ProfileObject.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/17/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
extension Encodable {
    func toDictionary() -> [String:String] {
        let mirrored_object = Mirror(reflecting: self)
        var result = [String:String]()
        
        for (index, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label{
                let subMirror = Mirror(reflecting: attr.value)
                if let style = subMirror.displayStyle{
                    switch style{
                    case .optional:
                        if subMirror.children.count == 0 {
                            continue
                        }
                    default: break
                    }
                }
                
                print("Attr \(index): \(property_name) = \(attr.value)")
                let str = "\(unwrap(any: attr.value))"
                if !str.isEmpty{
                    result[property_name] = str
                }
            }
        }
        return result
    }
    
    func unwrap(any:Any) -> Any {
        
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return NSNull() }
        let (_, some) = mi.children.first!
        return some
        
    }
}

class ProfileObject: Codable {
    var id, firstName: String
    var middleName: String?
    var lastName, email, mobile: String
    var dob:String?
    var phone: String?
    var address: String?
    var addressLocationMap: String?
    var isMale: Bool
    var socialFacebook, socialInstagram, socialLinkedin, whyShouldBeStar: String?
    var aspUserID: String?
    var userTypeID: Int
    var typeName, benefits: String?
    var userApprovalStatusID: Int
    var categoryID: String
    var categoryName, parentCategoryID, parentCategoryName: String?
    var userLevelTypeID: Int
    var level, dateCreated: String
    var suspended: Bool
    var starMembershipSeed, points, discountPercentage: Int
    //var userSupportDocumentList: [UserSupportDocumentList]
    var isFirstTimeAdd: String?
    var acceptTerms, enablePushNotifications, skyKeyActivated: Bool
    var profileImage, password, roleID, roleName: String?
    var dateVisited: String?
    var numberOfVisits: Int?
    var profileImageName, userStaffComments, fullName, userRatingValue: String?
    var phoneCode:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case dob = "DOB"
        case email = "Email"
        case mobile = "Mobile"
        case phone = "Phone"
        case address = "Address"
        case addressLocationMap = "AddressLocationMap"
        case isMale = "IsMale"
        case socialFacebook = "Social_Facebook"
        case socialInstagram = "Social_Instagram"
        case socialLinkedin = "Social_Linkedin"
        case whyShouldBeStar = "WhyShouldBeStar"
        case aspUserID = "ASP_User_ID"
        case userTypeID = "UserTypeID"
        case typeName = "TypeName"
        case benefits = "Benefits"
        case userApprovalStatusID = "UserApprovalStatus_ID"
        case categoryID = "Category_ID"
        case categoryName = "CategoryName"
        case parentCategoryID = "ParentCategoryID"
        case parentCategoryName = "ParentCategoryName"
        case userLevelTypeID = "UserLevelType_ID"
        case level = "Level"
        case dateCreated = "DateCreated"
        case suspended = "Suspended"
        case starMembershipSeed = "StarMembershipSeed"
        case points = "Points"
        case discountPercentage = "DiscountPercentage"
        //case userSupportDocumentList = "UserSupportDocumentList"
        case isFirstTimeAdd = "IsFirstTimeAdd"
        case acceptTerms = "AcceptTerms"
        case enablePushNotifications = "EnablePushNotifications"
        case skyKeyActivated = "SkyKeyActivated"
        case profileImage
        case password = "Password"
        case roleID = "RoleID"
        case roleName = "RoleName"
        case dateVisited = "DateVisited"
        case numberOfVisits = "NumberOfVisits"
        case profileImageName = "ProfileImageName"
        case userStaffComments = "UserStaffComments"
        case fullName = "FullName"
        case userRatingValue = "UserRatingValue"
        case phoneCode = "PhoneCode"
    }
}

typealias Privileges = [Privilege]

struct Privilege: Codable {
    let id, title, description: String
    let benefitTypeID: Int
    let dateCreated: String
    let benefitImageName: String?
    let uploadedImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case description = "Description"
        case benefitTypeID = "BenefitType_ID"
        case dateCreated = "DateCreated"
        case benefitImageName = "BenefitImageName"
        case uploadedImage = "UploadedImage"
    }
}


//////////////////////////////////////////////////////////
typealias PhoneCodes = [PhoneCode]

struct PhoneCode: Codable {
    let countryID: Int?
    let name, abbreviation, phoneCode: String?
    let citizenShipNaming: String?
    
    enum CodingKeys: String, CodingKey {
        case countryID = "Country_Id"
        case name = "Name"
        case abbreviation = "Abbreviation"
        case phoneCode = "Phone_Code"
        case citizenShipNaming = "CitizenShip_Naming"
    }
}
