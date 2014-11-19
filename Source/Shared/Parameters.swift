//
//  Parameters.swift
//  Quadrat
//
//  Created by Constantine Fry on 12/11/14.
//  Copyright (c) 2014 Constantine Fry. All rights reserved.
//

import Foundation

public class Parameter {
    // Internal.
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
    
    // Public.
    public class var checkinId       : String { return "checkinId" }
    public class var tipId           : String { return "tipId" }
    public class var venueId         : String { return "venueId" }
    public class var pageId          : String { return "pageId" }
    
    public class var value           : String { return "value" }
    
    class func makeQuery(parameters: Parameters) -> String {
        var query = String()
        for (key,value) in parameters {
            query += key + "=" + value + "&"
        }
        query.removeAtIndex(query.endIndex.predecessor())
        return query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
}
