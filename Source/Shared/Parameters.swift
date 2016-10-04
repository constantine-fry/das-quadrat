//
//  Parameters.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

// swiftlint:disable colon
// swiftlint:disable variable_name
// swiftlint:disable variable_name_min_length

import Foundation

open class Parameter {
    // MARK: - PUBLIC
    
    // MARK: Ids
    open class var categoryId             : String { return #function }
    open class var checkinId              : String { return #function }
    open class var commentId              : String { return #function }
    open class var contentId              : String { return #function }
    open class var eventId                : String { return #function }
    open class var itemId                 : String { return #function }
    open class var offerId                : String { return #function }
    open class var pageId                 : String { return #function }
    open class var participantId          : String { return #function }
    open class var photoId                : String { return #function }
    open class var postContentId          : String { return #function }
    open class var primaryCategoryId      : String { return #function }
    open class var providerId             : String { return #function }
    open class var storeId                : String { return #function }
    open class var tipId                  : String { return #function }
    open class var userId                 : String { return #function }
    open class var venueId                : String { return #function }
    
    // MARK: - A
    open class var addCategoryIds         : String { return #function }
    open class var address                : String { return #function }
    open class var afterId                : String { return #function }
    open class var afterTimestamp         : String { return #function }
    open class var alt                    : String { return #function }
    open class var altAcc                 : String { return #function }
    
    // MARK: - B
    open class var beforeId               : String { return #function }
    open class var beforeTimestamp        : String { return #function }
    open class var broadcast              : String { return #function }
    
    // MARK: - C
    open class var city                   : String { return #function }
    open class var collaborative          : String { return #function }
    open class var comment                : String { return #function }
    open class var cost                   : String { return #function }
    open class var count1                 : String { return #function }
    open class var crossStreet            : String { return #function }
    
    // MARK: - D
    open class var day                    : String { return #function }
    open class var description            : String { return #function }
    open class var domain                 : String { return #function }
    
    // MARK: - E
    open class var email                  : String { return #function }
    open class var endAt                  : String { return #function }
    
    // MARK: - F
    open class var facebookUrl            : String { return #function }
    open class var fbid                   : String { return #function }
    open class var fields                 : String { return #function }
    open class var finePrint              : String { return #function }
    open class var friendVisits           : String { return #function }
    
    // MARK: - G
    open class var group                  : String { return #function }
    
    // MARK: - H
    open class var highWatermark          : String { return #function }
    open class var hours                  : String { return #function }
    
    // MARK: - I
    open class var ignoreDuplicates       : String { return #function }
    open class var ignoreDuplicatesKey    : String { return #function }
    open class var includeFollowing       : String { return #function }
    open class var intent                 : String { return #function }
    
    // MARK: - L
    open class var lastVenue              : String { return #function }
    open class var likes                  : String { return #function }
    open class var limit                  : String { return #function }
    open class var linkedId               : String { return #function }
    open class var ll                     : String { return #function }
    open class var llAcc                  : String { return #function }
    open class var llBounds               : String { return #function }
    
    // MARK: - T
    open class var mentions               : String { return #function }
    open class var menuUrl                : String { return #function }
    open class var message                : String { return #function }
    
    // MARK: - S
    open class var name                   : String { return #function }
    open class var ne                     : String { return #function }
    open class var near                   : String { return #function }
    open class var novelty                : String { return #function }
    
    // MARK: - O
    open class var offset                 : String { return #function }
    open class var openNow                : String { return #function }
    
    // MARK: - P
    open class var phone                  : String { return #function }
    open class var postText               : String { return #function }
    open class var price                  : String { return #function }
    open class var problem                : String { return #function }
    
    // MARK: - Q
    open class var query                  : String { return #function }
    
    // MARK: - R
    open class var radius                 : String { return #function }
    open class var removeCategoryIds      : String { return #function }
    open class var role                   : String { return #function }
    
    // MARK: - S
    open class var saved                  : String { return #function }
    open class var section                : String { return #function }
    open class var set                    : String { return #function }
    open class var shout                  : String { return #function }
    open class var signature              : String { return #function }
    open class var sort                   : String { return #function }
    open class var sortByDistance         : String { return #function }
    open class var specials               : String { return #function }
    open class var startAt                : String { return #function }
    open class var state                  : String { return #function }
    open class var status                 : String { return #function }
    open class var sw                     : String { return #function }
    
    // MARK: - T
    open class var text                   : String { return #function }
    open class var time                   : String { return #function }
    open class var twitter                : String { return #function }
    open class var twitterSource          : String { return #function }
    open class var type                   : String { return #function }
    
    // MARK: - U
    open class var url                    : String { return #function }
    
    // MARK: - V
    open class var value                  : String { return #function }
    open class var venuell                : String { return #function }
    open class var venuePhotos            : String { return #function }
    open class var visible                : String { return #function }
    
    // MARK: - Z
    open class var zip                    : String { return #function }

    // MARK: - INTERNAL
    class var client_id       : String { return "client_id" }
    class var client_secret   : String { return "client_secret" }
    class var redirect_uri    : String { return "redirect_uri" }
    class var code            : String { return "code" }
    class var grant_type      : String { return "grant_type" }
    class var oauth_token     : String { return "oauth_token" }
    class var v               : String { return "v" }
    class var locale          : String { return "locale" }
    class var response_type   : String { return "response_type" }
    class var m               : String { return "m" }
    class var requests        : String { return "requests" }
    
    class func URLQuery(_ parameters: Parameters) -> String {
        var result = String()
        for (key, value) in parameters {
            let parameters = key + "=" + value
            if result.characters.count == 0 {
                result += parameters
            } else {
                result += "&" + parameters
            }
        }
        return result
    }
    
    class func buildURL(_ baseURL: URL, parameters: Parameters, preformattedQueryString: String? = nil) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        let query = URLQuery(parameters)
        if let componentsQuery = components.query {
            components.query = componentsQuery + "&" + query
        } else {
            components.query = query
        }
        
        if let preformatted = preformattedQueryString {
            let delimiter = components.query != nil ? "&" : "?"
            return URL(string: components.url!.absoluteString + delimiter + preformatted)!
        }
        return components.url!
    }
}
