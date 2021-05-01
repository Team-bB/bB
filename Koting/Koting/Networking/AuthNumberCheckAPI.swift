//
//  AuthNumberCheckAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/03/22.
//

import Foundation
import Alamofire

class AuthNumberCheckAPI {
    
    static let shared = AuthNumberCheckAPI()

    private init() {}
    
    func get(code: String, completion: @escaping (Result<PhoneAuth, Error>) -> (Void)) {
        
        guard let phoneNumber = UserAPI.shared.phoneNumber else { return }
        
        let url = API.shared.BASE_URL + "/auth/code?phoneNumber=\(phoneNumber)&code=\(code)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\nAuthNumberChecked Success")
                
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(PhoneAuth.self, from: result)
                    print("✅ PhoneAuth Codable Success ✅")
                    completion(.success(product))
                } catch {
                    print("❗️ PhoneAuth Codable Error")
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                completion(.failure(error))
            }
        }
    }
}
