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

public class Parameter {
    // MARK: - PUBLIC
    
    // MARK: Ids
    public class var categoryId             : String { return #function }
    public class var checkinId              : String { return #function }
    public class var commentId              : String { return #function }
    public class var contentId              : String { return #function }
    public class var eventId                : String { return #function }
    public class var itemId                 : String { return #function }
    public class var offerId                : String { return #function }
    public class var pageId                 : String { return #function }
    public class var participantId          : String { return #function }
    public class var photoId                : String { return #function }
    public class var postContentId          : String { return #function }
    public class var primaryCategoryId      : String { return #function }
    public class var providerId             : String { return #function }
    public class var storeId                : String { return #function }
    public class var tipId                  : String { return #function }
    public class var userId                 : String { return #function }
    public class var venueId                : String { return #function }
    
    // MARK: - A
    public class var addCategoryIds         : String { return #function }
    public class var address                : String { return #function }
    public class var afterId                : String { return #function }
    public class var afterTimestamp         : String { return #function }
    public class var alt                    : String { return #function }
    public class var altAcc                 : String { return #function }
    
    // MARK: - B
    public class var beforeId               : String { return #function }
    public class var beforeTimestamp        : String { return #function }
    public class var broadcast              : String { return #function }
    
    // MARK: - C
    public class var city                   : String { return #function }
    public class var collaborative          : String { return #function }
    public class var comment                : String { return #function }
    public class var cost                   : String { return #function }
    public class var count1                 : String { return #function }
    public class var crossStreet            : String { return #function }
    
    // MARK: - D
    public class var day                    : String { return #function }
    public class var description            : String { return #function }
    public class var domain                 : String { return #function }
    
    // MARK: - E
    public class var email                  : String { return #function }
    public class var endAt                  : String { return #function }
    
    // MARK: - F
    public class var facebookUrl            : String { return #function }
    public class var fbid                   : String { return #function }
    public class var fields                 : String { return #function }
    public class var finePrint              : String { return #function }
    public class var friendVisits           : String { return #function }
    
    // MARK: - G
    public class var group                  : String { return #function }
    
    // MARK: - H
    public class var highWatermark          : String { return #function }
    public class var hours                  : String { return #function }
    
    // MARK: - I
    public class var ignoreDuplicates       : String { return #function }
    public class var ignoreDuplicatesKey    : String { return #function }
    public class var includeFollowing       : String { return #function }
    public class var intent                 : String { return #function }
    
    // MARK: - L
    public class var lastVenue              : String { return #function }
    public class var likes                  : String { return #function }
    public class var limit                  : String { return #function }
    public class var linkedId               : String { return #function }
    public class var ll                     : String { return #function }
    public class var llAcc                  : String { return #function }
    public class var llBounds               : String { return #function }
    
    // MARK: - T
    public class var mentions               : String { return #function }
    public class var menuUrl                : String { return #function }
    public class var message                : String { return #function }
    
    // MARK: - S
    public class var name                   : String { return #function }
    public class var ne                     : String { return #function }
    public class var near                   : String { return #function }
    public class var novelty                : String { return #function }
    
    // MARK: - O
    public class var offset                 : String { return #function }
    public class var openNow                : String { return #function }
    
    // MARK: - P
    public class var phone                  : String { return #function }
    public class var postText               : String { return #function }
    public class var price                  : String { return #function }
    public class var problem                : String { return #function }
    
    // MARK: - Q
    public class var query                  : String { return #function }
    
    // MARK: - R
    public class var radius                 : String { return #function }
    public class var removeCategoryIds      : String { return #function }
    public class var role                   : String { return #function }
    
    // MARK: - S
    public class var saved                  : String { return #function }
    public class var section                : String { return #function }
    public class var set                    : String { return #function }
    public class var shout                  : String { return #function }
    public class var signature              : String { return #function }
    public class var sort                   : String { return #function }
    public class var sortByDistance         : String { return #function }
    public class var specials               : String { return #function }
    public class var startAt                : String { return #function }
    public class var state                  : String { return #function }
    public class var status                 : String { return #function }
    public class var sw                     : String { return #function }
    
    // MARK: - T
    public class var text                   : String { return #function }
    public class var time                   : String { return #function }
    public class var twitter                : String { return #function }
    public class var twitterSource          : String { return #function }
    public class var type                   : String { return #function }
    
    // MARK: - U
    public class var url                    : String { return #function }
    
    // MARK: - V
    public class var value                  : String { return #function }
    public class var venuell                : String { return #function }
    public class var venuePhotos            : String { return #function }
    public class var visible                : String { return #function }
    
    // MARK: - Z
    public class var zip                    : String { return #function }

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
    
    class func URLQuery(parameters: Parameters) -> String {
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
    
    class func buildURL(baseURL: NSURL, parameters: Parameters, preformattedQueryString: String? = nil) -> NSURL {
        let components = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: false)!
        let query = URLQuery(parameters)
        if let componentsQuery = components.query {
            components.query = componentsQuery + "&" + query
        } else {
            components.query = query
        }
        
        if let preformatted = preformattedQueryString {
            let delimiter = components.query != nil ? "&" : "?"
            return NSURL(string: components.URL!.absoluteString + delimiter + preformatted)!
        }
        return components.URL!
    }
}
