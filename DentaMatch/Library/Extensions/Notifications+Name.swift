//
//  Notifications+Name.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let updateProfileScreen = Notification.Name("updateProfileScreen")
    static let deleteFetchController = Notification.Name("deleteFetchController")
    static let refreshChat = Notification.Name("refreshChat")
    static let refreshBlockList = Notification.Name("refreshBlockList")
    static let refreshUnblockList = Notification.Name("refreshUnBlockList")

    static let refreshMessageList = Notification.Name("refreshMessageList")
    static let chatRedirect = Notification.Name("chatRedirect")
    static let hideMessagePlaceholder = Notification.Name("hideMessagePlaceholder")

    static let pushRedirectNotificationForground = Notification.Name("pushRedirectNoyificationForground")
    static let pushRedirectNotificationBacground = Notification.Name("pushRedirectNoyificationBackground")
    static let pushRedirectNotificationForProfile = Notification.Name("pushRedirectNoyificationForProfile")
    static let pushRedirectNotificationAllForground = Notification.Name("pushRedirectNoyification")
    static let pushRedirectNotificationAllBackGround = Notification.Name("pushRedirectNoyificationBackGround")
    static let pushRedirectNotificationForChat = Notification.Name("pushRedirectNoyificationForChat")
    static let pushRedirectNotificationForChatBackGround = Notification.Name("pushRedirectNoyificationForChatBackGround")
    static let decreaseBadgeCount = Notification.Name("decreaseBadgeCount")
    static let fetchBadgeCount = Notification.Name("fetchBadgeCount")
    static let updateBadgeCount = Notification.Name("updateBadgeCount")
    static let refreshSavedJobs = Notification.Name("RefreshSavedJob")
    static let refreshInterviewingJobs = Notification.Name("RefreshInterviewingJob")
    static let refreshAppliedJobs = Notification.Name("RefreshAppliedJob")
    static let jobSavedUnsaved = Notification.Name("JobSavedUnsaved")
}
