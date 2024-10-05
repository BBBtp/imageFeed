

import Foundation

enum Constants{
    enum Auth{
        static let accessKey = "8B93ZPFMJbrK2-Y1s3Do92AHqdJcLyPIYL82IAELL_s"
        static let secretKey = "M4o-3lsWIjBYzAx-onUkZqu4tczLATVGQmhcqTMh_VI"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let grant_type = "authorization_code"
        static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    }
    
    enum Token{
        static let tokenKey = "tokenKey"
        static let baseAuthUrl = "https://unsplash.com/oauth/token"
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    
    
}
