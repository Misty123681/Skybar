//
//  TimelineObject.swift
//  Skybar
//
//  Created by Christopher Nassar on 10/29/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

typealias Timeline = [TimelineElement]

struct TimelineElement: Codable {
    let dateCreated: String
    let visit: Visit?
    let reservation: Reservation?
    let notification: Notification?
    let timelineItemType: Int
    
    enum CodingKeys: String, CodingKey {
        case dateCreated = "DateCreated"
        case visit = "Visit"
        case reservation = "Reservation"
        case notification = "Notification"
        case timelineItemType = "TimelineItemType"
    }
}

struct Visit: Codable {
    let firstName: String
    let middleName: String?
    let lastName: String?
    let dob: String?
    let email, mobile: String?
    let dateCreated: String?
    let userTypeID: Int?
    let address: String?
    let phone: String?
    let addressLocationMap, aspUserID: String?
    let userApprovalStatusID: Int?
    let dateVisited: String?
    let numberOfGuestsArrived: Int?
    let reservationID, visitNote, companyLocationID, visitType: String?
    let eventName: String?
    let reservationNote: String?
    let reservationStatusID: Int?
    let reservationStatus: String?
    let discountProvided, totalPaid, totalBillValue: Float?
    let dateRated: String?
    let promotion, crowd, addedValue, visitRatingValue: Float?
    let visitTypeID: Int?
    let userID, id: String?
    let reservationType: String?
    let fullName: String?
    let userLevel: String?
    let userLevelTypeID: Int
    let profileImageName: String?
    let description: String?
    let eventDate: String?
    let eventImage: String?
    let numberOfGuests, reservationTypeID: Int?
    let discount: Float?
    let visitSummary: String?
    let totalConsumption: Int?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case dob = "DOB"
        case email = "Email"
        case mobile = "Mobile"
        case dateCreated = "DateCreated"
        case userTypeID = "UserTypeID"
        case address = "Address"
        case phone = "Phone"
        case addressLocationMap = "AddressLocationMap"
        case aspUserID = "ASP_User_ID"
        case userApprovalStatusID = "UserApprovalStatus_ID"
        case dateVisited = "DateVisited"
        case numberOfGuestsArrived = "NumberOfGuests_Arrived"
        case reservationID = "Reservation_ID"
        case visitNote = "VisitNote"
        case companyLocationID = "CompanyLocation_ID"
        case visitType = "VisitType"
        case eventName = "EventName"
        case reservationNote = "Reservation_Note"
        case reservationStatusID = "ReservationStatus_ID"
        case reservationStatus = "ReservationStatus"
        case discountProvided = "DiscountProvided"
        case totalPaid = "TotalPaid"
        case totalBillValue = "TotalBillValue"
        case dateRated = "DateRated"
        case promotion = "Promotion"
        case crowd = "Crowd"
        case addedValue = "AddedValue"
        case visitRatingValue = "VisitRatingValue"
        case visitTypeID = "VisitType_ID"
        case userID = "User_ID"
        case id = "ID"
        case reservationType = "ReservationType"
        case fullName = "FullName"
        case userLevel = "UserLevel"
        case userLevelTypeID = "UserLevelType_ID"
        case profileImageName = "ProfileImageName"
        case description = "Description"
        case eventDate = "EventDate"
        case eventImage = "EventImage"
        case discount = "Discount"
        case numberOfGuests = "NumberOfGuests"
        case reservationTypeID = "ReservationType_ID"
        case visitSummary = "VisitSummary"
        case totalConsumption = "TotalConsumption"
    }
}

struct Notification: Codable {
    let id: String
    let title, content: String?
    let iconID: Int
    let published: Bool
    let datePublished: String?
    let dateCreated: String?
    let publishedByUserID, imageID, documentName, internalDocumentName: String?
    let isDeleted, isSMS: Bool
    let recipientusersList: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case content = "Content"
        case iconID = "IconID"
        case published = "Published"
        case datePublished = "DatePublished"
        case dateCreated = "DateCreated"
        case publishedByUserID = "PublishedByUser_ID"
        case imageID = "ImageID"
        case documentName = "DocumentName"
        case internalDocumentName = "InternalDocumentName"
        case isDeleted = "IsDeleted"
        case isSMS = "IsSMS"
        case recipientusersList = "RecipientusersList"
    }
}

struct Reservation: Codable {
    let id, eventID, userID: String?
    let dateRequested: String?
    let reservationTypeID, numberOfGuests: Int?
    let note, moderatedByUserID: String?
    let reservationStatusID: Int?
    let reservationStatusTypeName: String?
    let reservationTypeName: String?
    let eventName: String?
    let eventDate: String?
    let description: String?
    let eventImage: String?
    let firstName: String
    let middleName: String?
    let lastName: String?
    let userLevelTypeID, userTypeID: Int?
    let level: String?
    let profileImageName: String?
    let fullName: String?
    let userRatingValue, discount: Int?
    let dateCreated: String?
    var reservationAccessCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case eventID = "Event_ID"
        case userID = "User_ID"
        case dateRequested = "DateRequested"
        case reservationTypeID = "ReservationType_ID"
        case numberOfGuests = "NumberOfGuests"
        case note = "Note"
        case moderatedByUserID = "ModeratedBy_User_ID"
        case reservationStatusID = "ReservationStatus_ID"
        case reservationStatusTypeName = "ReservationStatusTypeName"
        case reservationTypeName = "ReservationTypeName"
        case eventName = "EventName"
        case eventDate = "EventDate"
        case description = "Description"
        case eventImage = "EventImage"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case userLevelTypeID = "UserLevelType_ID"
        case userTypeID = "UserTypeID"
        case level = "Level"
        case profileImageName = "ProfileImageName"
        case fullName = "FullName"
        case userRatingValue = "UserRatingValue"
        case discount = "Discount"
        case dateCreated = "DateCreated"
        case reservationAccessCode = "ReservationAccessCode"
    }
}

struct ReservationRules: Codable {
    let tableMaximumNumberOfPeople, tableMinimumNumberOfPeople, barMaximumNumberOfPeople, barMinimumNumberOfPeople: Int
    
    enum CodingKeys: String, CodingKey {
        case tableMaximumNumberOfPeople = "Table_MaximumNumberOfPeople"
        case tableMinimumNumberOfPeople = "Table_MinimumNumberOfPeople"
        case barMaximumNumberOfPeople = "Bar_MaximumNumberOfPeople"
        case barMinimumNumberOfPeople = "Bar_MinimumNumberOfPeople"
    }
}

typealias Guest = [GuestElement]

struct GuestElement: Codable {
    let id, userID, guestFullName: String
    let mobile: String?
    let visitDate: String?
    let enteredDate: String?
    let statusName:String?
    let statusTypeID:Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case userID = "UserID"
        case guestFullName = "GuestFullName"
        case mobile = "Mobile"
        case visitDate = "VisitDate"
        case enteredDate = "EnteredDate"
        case statusName = "StatusName"
        case statusTypeID = "StatusTypeID"
    }
}
/////////////
struct CareemLinks: Codable {
    let careemTakeMeToSkyBarURL, careemTakeMeHomeURL: String
    
    enum CodingKeys: String, CodingKey {
        case careemTakeMeToSkyBarURL = "Careem_TakeMeToSkyBarUrl"
        case careemTakeMeHomeURL = "Careem_TakeMeHomeUrl"
    }
}

struct Event: Codable {
    let booked: Bool?
    let rating: Int?
    let tickets: String?
    let id, name, description, eventDate: String?
    let dateCreated, createdByUserID: String?
    let enabled, deleted: Bool?
    let companyLocationID: String?
    let doorOpen, eventImage: String?
    let maximumNumberOfPeople: Int?
    let published: Bool?
    let eventImageFile: String?
    let createdByUserFullName: String?
    let totalNumberReservationGuests, totalNumberReservation, totalEventVisits, totalEventVisitGuests: Int?
    let reservationInfo: ReservationInfo?
    
    enum CodingKeys: String, CodingKey {
        case booked = "Booked"
        case rating = "Rating"
        case tickets = "Tickets"
        case id = "ID"
        case name = "Name"
        case description = "Description"
        case eventDate = "EventDate"
        case dateCreated = "DateCreated"
        case createdByUserID = "CreatedBy_User_ID"
        case enabled = "Enabled"
        case deleted = "Deleted"
        case companyLocationID = "CompanyLocation_ID"
        case doorOpen = "DoorOpen"
        case eventImage = "EventImage"
        case maximumNumberOfPeople = "MaximumNumberOfPeople"
        case published = "Published"
        case eventImageFile = "EventImageFile"
        case createdByUserFullName = "CreatedBy_UserFullName"
        case totalNumberReservationGuests = "TotalNumberReservationGuests"
        case totalNumberReservation = "TotalNumberReservation"
        case totalEventVisits = "TotalEventVisits"
        case totalEventVisitGuests = "TotalEventVisitGuests"
        case reservationInfo = "ReservationInfo"
    }
}

struct ReservationInfo: Codable {
    let reservationAccessCode, id, eventID, userID: String?
    let dateRequested: String?
    let reservationTypeID, numberOfGuests: Int?
    let note, moderatedByUserID: String?
    let reservationStatusID: Int?
    let reservationStatusTypeName, reservationTypeName, eventName, eventDate: String?
    let description, eventImage, firstName: String?
    let middleName: String?
    let lastName: String?
    let userLevelTypeID, userTypeID: Int?
    let level, profileImageName, fullName: String?
    let userRatingValue, discount: Int?
    let dateCreated: String?
    let thirdPartyID: Int?
    let zoneID:String?
    let budget: Float?
    
    enum CodingKeys: String, CodingKey {
        case reservationAccessCode = "ReservationAccessCode"
        case id = "ID"
        case eventID = "Event_ID"
        case userID = "User_ID"
        case dateRequested = "DateRequested"
        case reservationTypeID = "ReservationType_ID"
        case numberOfGuests = "NumberOfGuests"
        case note = "Note"
        case moderatedByUserID = "ModeratedBy_User_ID"
        case reservationStatusID = "ReservationStatus_ID"
        case reservationStatusTypeName = "ReservationStatusTypeName"
        case reservationTypeName = "ReservationTypeName"
        case eventName = "EventName"
        case eventDate = "EventDate"
        case description = "Description"
        case eventImage = "EventImage"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case userLevelTypeID = "UserLevelType_ID"
        case userTypeID = "UserTypeID"
        case level = "Level"
        case profileImageName = "ProfileImageName"
        case fullName = "FullName"
        case userRatingValue = "UserRatingValue"
        case discount = "Discount"
        case dateCreated = "DateCreated"
        case thirdPartyID = "ThirdParty_ID"
        case zoneID = "ZoneID"
        case budget = "Budget"
    }
}
//////////
typealias Zones = [Zone]

struct Zone: Codable {
    let id, zoneName, description: String?
    let dateCreated: String?
    let createdByUserID: String?
    let zoneTypeID: Int?
    let parentID, location: String?
    let zoneLocation: ZoneLocation?
    let height, width, seats: Int?
    let backgroundImageName, backgroudColorCode, zoneGeneratedImageName: String?
    let budgetFrom, budgetTo: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case zoneName = "ZoneName"
        case description = "Description"
        case dateCreated = "DateCreated"
        case createdByUserID = "CreatedByUserID"
        case zoneTypeID = "ZoneTypeID"
        case parentID = "Parent_ID"
        case location = "Location"
        case zoneLocation = "ZoneLocation"
        case height = "Height"
        case width = "Width"
        case seats = "Seats"
        case backgroundImageName = "BackgroundImageName"
        case backgroudColorCode = "BackgroudColorCode"
        case zoneGeneratedImageName = "ZoneGeneratedImageName"
        case budgetFrom = "Budget_From"
        case budgetTo = "Budget_To"
    }
}

struct ZoneLocation: Codable {
    let x, y: Int
    
    enum CodingKeys: String, CodingKey {
        case x = "X"
        case y = "Y"
    }
}
/////////
struct SkyStatus: Codable {
    let nearestEventDetails: NearestEventDetails?
    let totalReservationNotifications, totalGuestsInVenueNotifications, id: Int?
    let discount:CGFloat?
    let fromDate, toDate: String?
    let hexColor: String?
    let headingOne, headingTwo: String?
    let headingThree: String?
    let isOpen, isFullCapacity, isAtSkybar: Bool?
    let rideDisabledMsg: String?
    let currentVisitInfo: CurrentVisitInfo?
    
    enum CodingKeys: String, CodingKey {
        case nearestEventDetails = "NearestEventDetails"
        case totalReservationNotifications = "TotalReservationNotifications"
        case totalGuestsInVenueNotifications = "TotalGuestsInVenueNotifications"
        case discount = "Discount"
        case id = "ID"
        case fromDate = "FromDate"
        case toDate = "ToDate"
        case hexColor = "HexColor"
        case headingOne = "HeadingOne"
        case headingTwo = "HeadingTwo"
        case headingThree = "HeadingThree"
        case isOpen = "IsOpen"
        case isFullCapacity = "IsFullCapacity"
        case isAtSkybar = "IsAtSkybar"
        case rideDisabledMsg = "RideDisabledMsg"
        case currentVisitInfo = "CurrentVisitInfo"
    }
}

struct CurrentVisitInfo: Codable {
    let isTabClosed: Bool?
    let reservationAccessCode: String?
    let reservedEventInfo: NearestEventDetails?
    let totalDiscountValue, yourCurrentTab: Float?
    let visitID, reservedEventID, reservation: String?
    let reservationInVenue: Int?
    let todayEventName: String?
    
    enum CodingKeys: String, CodingKey {
        case isTabClosed = "IsTabClosed"
        case reservationAccessCode = "ReservationAccessCode"
        case reservedEventInfo = "ReservedEventInfo"
        case totalDiscountValue = "TotalDiscountValue"
        case yourCurrentTab = "YourCurrentTab"
        case visitID = "VisitID"
        case reservedEventID = "ReservedEventID"
        case reservation = "Reservation"
        case reservationInVenue = "ReservationInVenue"
        case todayEventName = "TodayEventName"
    }
}

struct NearestEventDetails: Codable {
    let booked: Bool?
    let rating: Int?
    let tickets: String?
    let id, name: String?
    let description: String?
    let eventDate, dateCreated, createdByUserID: String?
    let enabled, deleted: Bool?
    let companyLocationID: String?
    let doorOpen: String?
    let eventImage: String?
    let maximumNumberOfPeople: Int?
    let published: Bool?
    let eventImageFile, createdByUserFullName, totalNumberReservationGuests, totalNumberReservation: String?
    let totalEventVisits, totalEventVisitGuests, reservationInfo: String?
    
    enum CodingKeys: String, CodingKey {
        case booked = "Booked"
        case rating = "Rating"
        case tickets = "Tickets"
        case id = "ID"
        case name = "Name"
        case description = "Description"
        case eventDate = "EventDate"
        case dateCreated = "DateCreated"
        case createdByUserID = "CreatedBy_User_ID"
        case enabled = "Enabled"
        case deleted = "Deleted"
        case companyLocationID = "CompanyLocation_ID"
        case doorOpen = "DoorOpen"
        case eventImage = "EventImage"
        case maximumNumberOfPeople = "MaximumNumberOfPeople"
        case published = "Published"
        case eventImageFile = "EventImageFile"
        case createdByUserFullName = "CreatedBy_UserFullName"
        case totalNumberReservationGuests = "TotalNumberReservationGuests"
        case totalNumberReservation = "TotalNumberReservation"
        case totalEventVisits = "TotalEventVisits"
        case totalEventVisitGuests = "TotalEventVisitGuests"
        case reservationInfo = "ReservationInfo"
    }
}
