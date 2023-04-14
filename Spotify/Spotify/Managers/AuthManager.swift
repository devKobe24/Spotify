//
//  AuthManager.swift
//  Spotify
//
//  Created by Minseong Kang on 2023/04/14.
//

import Foundation

final class AuthManager {
	static let shared = AuthManager()
	
	/*
	 구조체 언제 사용?
	 - 연관된 몇명의 값들을 모아서 하나의 데이터 타입으로 표현하고 싶을 때
	 - 다른 객체 또는 함수들으로 전달될 때 참조가 아닌 복사를 원할 때
	 - 자신을 상속할 필요가 없거나, 자신이 다른 타입을 상속 받을 필요가 없을 때.
	 */
	struct Constants {
		static let clientID = "322a807c7a454ded935c193c80dd2ce3"
		static let clientSecret = "288902becd9f423e9033555da3148a51"
	}
	
	private init() {}
	
	public var signInURL: URL? {
		let scopes = "user-read-private"
		let redirectURI = "https://github.com/devKobe24/Spotify"
		let base = "https://accounts.spotify.com/authorize"
		let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
		
		return URL(string: string)
	}
	
	var isSignedIn: Bool {
		return false
	}
	
	private var accessToken: String? {
		return nil
	}
	
	private var refreshToken: String? {
		return nil
	}
	
	private var tokenExpirationDate: Data? {
		return nil
	}
	
	private var shouldRefreshToken: Bool {
		return false
	}
	
	public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
		// Get Token
	}
	
	public func refreshAccessToken() {
		
	}
	
	public func cacheToken() {
		
	}
}
