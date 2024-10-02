

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


struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.Auth.accessKey,
                                 secretKey: Constants.Auth.secretKey,
                                 redirectURI: Constants.Auth.redirectURI,
                                 accessScope: Constants.Auth.accessScope,
                                 authURLString: Constants.Token.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.Auth.defaultBaseURL!)
        }
}
