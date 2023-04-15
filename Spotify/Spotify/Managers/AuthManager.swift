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
		static let tokenAPI_URL = "https://accounts.spotify.com/api/token"
		static let redirectURI = "https://github.com/devKobe24/Spotify"
		static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
	}
	
	private init() {}
	
	public var signInURL: URL? {
		let base = "https://accounts.spotify.com/authorize"
		let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
		
		return URL(string: string)
	}
	
	var isSignedIn: Bool {
		return accessToken != nil
	}
	
	private var accessToken: String? {
		return UserDefaults.standard.string(forKey: "access_token")
	}
	
	private var refreshToken: String? {
		return UserDefaults.standard.string(forKey: "refresh_token")
	}
	
	private var tokenExpirationDate: Date? {
		return UserDefaults.standard.object(forKey: "expirationDate") as? Date
	}
	
	private var shouldRefreshToken: Bool {
		guard let expirationDate = tokenExpirationDate else {
			return false
		}
		let currentDate = Date()
		let fiveMinutes: TimeInterval = 300
		return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
	}
	
	public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
		// Get Token
		guard let url = URL(string: Constants.tokenAPI_URL) else { return }
		
		var components = URLComponents()
		components.queryItems = [
			URLQueryItem(name: "grant_type",
						 value: "authorization_code"),
			URLQueryItem(name: "code",
						 value: code),
			URLQueryItem(name: "redirect_uri",
						 value: Constants.redirectURI),
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/x-www-form-urlencoded",
						 forHTTPHeaderField: "Content-Type")
		request.httpBody = components.query?.data(using: .utf8)
		
		let basicToken = Constants.clientID + ":" + Constants.clientSecret
		let data = basicToken.data(using: .utf8)
		guard let base64String = data?.base64EncodedString() else {
			print("Failure to get base64")
			completion(false)
			return
		}
		
		request.setValue("Basic \(base64String)",
						 forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
			guard let data = data, error == nil else {
				completion(false)
				return
			}
			
			do {
				let result = try JSONDecoder().decode(AuthResponse.self, from: data)
				self?.cacheToken(result: result)
				completion(true)
			} catch {
				print(error.localizedDescription)
				completion(false)
			}
			
		}
		task.resume()
	}
	
	public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
//		guard shouldRefreshToken else {
//			completion(true)
//			return
//		}
		
		guard let refreshToken = self.refreshToken else {
			return
		}
		
		// Refresh the token
		guard let url = URL(string: Constants.tokenAPI_URL) else { return }
		
		var components = URLComponents()
		components.queryItems = [
			URLQueryItem(name: "grant_type",
						 value: "refresh_token"),
			URLQueryItem(name: "refresh_token",
						 value: refreshToken),
		]
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/x-www-form-urlencoded",
						 forHTTPHeaderField: "Content-Type")
		request.httpBody = components.query?.data(using: .utf8)
		
		let basicToken = Constants.clientID + ":" + Constants.clientSecret
		let data = basicToken.data(using: .utf8)
		guard let base64String = data?.base64EncodedString() else {
			print("Failure to get base64")
			completion(false)
			return
		}
		
		request.setValue("Basic \(base64String)",
						 forHTTPHeaderField: "Authorization")
		
		let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
			guard let data = data, error == nil else {
				completion(false)
				return
			}
			
			do {
				let result = try JSONDecoder().decode(AuthResponse.self, from: data)
				print("Successfully refreshed")
				self?.cacheToken(result: result)
				completion(true)
			} catch {
				print(error.localizedDescription)
				completion(false)
			}
			
		}
		task.resume()
	}
	
	public func cacheToken(result: AuthResponse) {
		UserDefaults.standard.setValue(result.access_token,
									   forKey: "access_token")
		
		if let refresh_token = result.refresh_token {
			UserDefaults.standard.setValue(result.refresh_token,
										   forKey: "refresh_token")
		}
		
		UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
									   forKey: "expirationDate")
	}
}
