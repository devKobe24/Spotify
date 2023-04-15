//
//  AuthResponse.swift
//  Spotify
//
//  Created by Minseong Kang on 2023/04/15.
//

import Foundation

struct AuthResponse: Codable {
	let access_token: String
	let expires_in: Int
	let refresh_token: String?
	let scope: String
	let token_type: String
}
